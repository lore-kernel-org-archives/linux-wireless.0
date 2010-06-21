Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36442 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508Ab0FUVPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 17:15:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] mac80211: avoid scheduling while atomic in mesh_rx_plink_frame
Date: Mon, 21 Jun 2010 17:14:07 -0400
Message-Id: <1277154847-6395-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1277154547-5851-1-git-send-email-linville@tuxdriver.com>
References: <1277154547-5851-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While mesh_rx_plink_frame holds sta->lock...

mesh_rx_plink_frame ->
	mesh_plink_inc_estab_count ->
		ieee80211_bss_info_change_notify

...but ieee80211_bss_info_change_notify is allowed to sleep.  A driver
taking advantage of that allowance can cause a scheduling while
atomic bug.  Similar paths exist for mesh_plink_dec_estab_count,
so work around those as well.

http://bugzilla.kernel.org/show_bug.cgi?id=16099

Also, correct a minor kerneldoc comment error (mismatched function names).

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
v2 -> move ieee80211_bss_info_change_notify call outside of
	mesh_plink_inc_estab_count to balance the API with the modifications
	to mesh_plink_dec_estab_count.

 net/mac80211/mesh_plink.c |   42 +++++++++++++++++++++++++++++++-----------
 1 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 3cd5f7b..ea13a80 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -65,7 +65,6 @@ void mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_inc(&sdata->u.mesh.mshstats.estab_plinks);
 	mesh_accept_plinks_update(sdata);
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 }
 
 static inline
@@ -73,7 +72,6 @@ void mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_dec(&sdata->u.mesh.mshstats.estab_plinks);
 	mesh_accept_plinks_update(sdata);
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 }
 
 /**
@@ -115,7 +113,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 }
 
 /**
- * mesh_plink_deactivate - deactivate mesh peer link
+ * __mesh_plink_deactivate - deactivate mesh peer link
  *
  * @sta: mesh peer link to deactivate
  *
@@ -123,18 +121,23 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
  *
  * Locking: the caller must hold sta->lock
  */
-static void __mesh_plink_deactivate(struct sta_info *sta)
+static bool __mesh_plink_deactivate(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	bool deactivated = false;
 
-	if (sta->plink_state == PLINK_ESTAB)
+	if (sta->plink_state == PLINK_ESTAB) {
 		mesh_plink_dec_estab_count(sdata);
+		deactivated = true;
+	}
 	sta->plink_state = PLINK_BLOCKED;
 	mesh_path_flush_by_nexthop(sta);
+
+	return deactivated;
 }
 
 /**
- * __mesh_plink_deactivate - deactivate mesh peer link
+ * mesh_plink_deactivate - deactivate mesh peer link
  *
  * @sta: mesh peer link to deactivate
  *
@@ -142,9 +145,15 @@ static void __mesh_plink_deactivate(struct sta_info *sta)
  */
 void mesh_plink_deactivate(struct sta_info *sta)
 {
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	bool deactivated;
+
 	spin_lock_bh(&sta->lock);
-	__mesh_plink_deactivate(sta);
+	deactivated = __mesh_plink_deactivate(sta);
 	spin_unlock_bh(&sta->lock);
+
+	if (deactivated)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 }
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
@@ -381,10 +390,16 @@ int mesh_plink_open(struct sta_info *sta)
 
 void mesh_plink_block(struct sta_info *sta)
 {
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	bool deactivated;
+
 	spin_lock_bh(&sta->lock);
-	__mesh_plink_deactivate(sta);
+	deactivated = __mesh_plink_deactivate(sta);
 	sta->plink_state = PLINK_BLOCKED;
 	spin_unlock_bh(&sta->lock);
+
+	if (deactivated)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 }
 
 
@@ -397,6 +412,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	enum plink_event event;
 	enum plink_frame_type ftype;
 	size_t baselen;
+	bool deactivated;
 	u8 ie_len;
 	u8 *baseaddr;
 	__le16 plid, llid, reason;
@@ -651,8 +667,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		case CNF_ACPT:
 			del_timer(&sta->plink_timer);
 			sta->plink_state = PLINK_ESTAB;
-			mesh_plink_inc_estab_count(sdata);
 			spin_unlock_bh(&sta->lock);
+			mesh_plink_inc_estab_count(sdata);
+			ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 			mpl_dbg("Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			break;
@@ -684,8 +701,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		case OPN_ACPT:
 			del_timer(&sta->plink_timer);
 			sta->plink_state = PLINK_ESTAB;
-			mesh_plink_inc_estab_count(sdata);
 			spin_unlock_bh(&sta->lock);
+			mesh_plink_inc_estab_count(sdata);
+			ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 			mpl_dbg("Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr, llid,
@@ -702,11 +720,13 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		case CLS_ACPT:
 			reason = cpu_to_le16(MESH_CLOSE_RCVD);
 			sta->reason = reason;
-			__mesh_plink_deactivate(sta);
+			deactivated = __mesh_plink_deactivate(sta);
 			sta->plink_state = PLINK_HOLDING;
 			llid = sta->llid;
 			mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 			spin_unlock_bh(&sta->lock);
+			if (deactivated)
+				ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid,
 					    plid, reason);
 			break;
-- 
1.7.0.1

