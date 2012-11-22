Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:39118 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab2KVTW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:22:26 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [PATCH 3/3] mac80211: remove mesh config macros from mesh_plink.c
Date: Wed, 21 Nov 2012 18:40:32 -0800
Message-Id: <1353552032-15600-4-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121122_202231_563928_C162B2C1)
In-Reply-To: <1353552032-15600-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353552032-15600-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use shortcut pointer instead where it is appropriate.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/mesh_plink.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 234fe75..7a47f40 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -19,12 +19,6 @@
 #define mod_plink_timer(s, t) (mod_timer(&s->plink_timer, \
 				jiffies + HZ * t / 1000))
 
-#define dot11MeshMaxRetries(s) (s->u.mesh.mshcfg.dot11MeshMaxRetries)
-#define dot11MeshRetryTimeout(s) (s->u.mesh.mshcfg.dot11MeshRetryTimeout)
-#define dot11MeshConfirmTimeout(s) (s->u.mesh.mshcfg.dot11MeshConfirmTimeout)
-#define dot11MeshHoldingTimeout(s) (s->u.mesh.mshcfg.dot11MeshHoldingTimeout)
-#define dot11MeshMaxPeerLinks(s) (s->u.mesh.mshcfg.dot11MeshMaxPeerLinks)
-
 /* We only need a valid sta if user configured a minimum rssi_threshold. */
 #define rssi_threshold_check(sta, sdata) \
 		(sdata->u.mesh.mshcfg.rssi_threshold == 0 ||\
@@ -430,6 +424,7 @@ static void mesh_plink_timer(unsigned long data)
 	struct sta_info *sta;
 	__le16 llid, plid, reason;
 	struct ieee80211_sub_if_data *sdata;
+	struct mesh_config *mshcfg;
 
 	/*
 	 * This STA is valid because sta_info_destroy() will
@@ -456,12 +451,13 @@ static void mesh_plink_timer(unsigned long data)
 	llid = sta->llid;
 	plid = sta->plid;
 	sdata = sta->sdata;
+	mshcfg = &sdata->u.mesh.mshcfg;
 
 	switch (sta->plink_state) {
 	case NL80211_PLINK_OPN_RCVD:
 	case NL80211_PLINK_OPN_SNT:
 		/* retry timer */
-		if (sta->plink_retries < dot11MeshMaxRetries(sdata)) {
+		if (sta->plink_retries < mshcfg->dot11MeshMaxRetries) {
 			u32 rand;
 			mpl_dbg(sta->sdata,
 				"Mesh plink for %pM (retry, timeout): %d %d\n",
@@ -484,7 +480,7 @@ static void mesh_plink_timer(unsigned long data)
 		if (!reason)
 			reason = cpu_to_le16(WLAN_REASON_MESH_CONFIRM_TIMEOUT);
 		sta->plink_state = NL80211_PLINK_HOLDING;
-		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
+		mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
 		spin_unlock_bh(&sta->lock);
 		mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
 				    sta->sta.addr, llid, plid, reason);
@@ -543,7 +539,7 @@ int mesh_plink_open(struct sta_info *sta)
 		return -EBUSY;
 	}
 	sta->plink_state = NL80211_PLINK_OPN_SNT;
-	mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
+	mesh_plink_timer_set(sta, sdata->u.mesh.mshcfg.dot11MeshRetryTimeout);
 	spin_unlock_bh(&sta->lock);
 	mpl_dbg(sdata,
 		"Mesh plink: starting establishment with %pM\n",
@@ -570,6 +566,7 @@ void mesh_plink_block(struct sta_info *sta)
 void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_mgmt *mgmt,
 			 size_t len, struct ieee80211_rx_status *rx_status)
 {
+	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
 	struct ieee802_11_elems elems;
 	struct sta_info *sta;
 	enum plink_event event;
@@ -777,7 +774,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			sta->plid = plid;
 			get_random_bytes(&llid, 2);
 			sta->llid = llid;
-			mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
+			mesh_plink_timer_set(sta,
+					     mshcfg->dot11MeshRetryTimeout);
 			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(sdata,
 					    WLAN_SP_MESH_PEERING_OPEN,
@@ -803,7 +801,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			sta->reason = reason;
 			sta->plink_state = NL80211_PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
-					     dot11MeshHoldingTimeout(sdata)))
+					     mshcfg->dot11MeshHoldingTimeout))
 				sta->ignore_plink_timer = true;
 
 			llid = sta->llid;
@@ -825,7 +823,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		case CNF_ACPT:
 			sta->plink_state = NL80211_PLINK_CNF_RCVD;
 			if (!mod_plink_timer(sta,
-					     dot11MeshConfirmTimeout(sdata)))
+					     mshcfg->dot11MeshConfirmTimeout))
 				sta->ignore_plink_timer = true;
 
 			spin_unlock_bh(&sta->lock);
@@ -847,7 +845,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			sta->reason = reason;
 			sta->plink_state = NL80211_PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
-					     dot11MeshHoldingTimeout(sdata)))
+					     mshcfg->dot11MeshHoldingTimeout))
 				sta->ignore_plink_timer = true;
 
 			llid = sta->llid;
@@ -888,7 +886,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			sta->reason = reason;
 			sta->plink_state = NL80211_PLINK_HOLDING;
 			if (!mod_plink_timer(sta,
-					     dot11MeshHoldingTimeout(sdata)))
+					     mshcfg->dot11MeshHoldingTimeout))
 				sta->ignore_plink_timer = true;
 
 			llid = sta->llid;
@@ -923,7 +921,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			changed |= __mesh_plink_deactivate(sta);
 			sta->plink_state = NL80211_PLINK_HOLDING;
 			llid = sta->llid;
-			mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
+			mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
 			spin_unlock_bh(&sta->lock);
 			changed |= mesh_set_ht_prot_mode(sdata);
 			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
-- 
1.7.9.5

