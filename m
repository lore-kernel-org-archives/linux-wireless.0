Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:57354 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367Ab2IGL3P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 07:29:15 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCHv3 1/2] mac80211: export ieee80211_send_deauth_disassoc for usage outside of mlme.c
Date: Fri,  7 Sep 2012 13:28:52 +0200
Message-Id: <1347017333-13497-1-git-send-email-ordex@autistici.org> (sfid-20120907_132920_139181_C0A8A66F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_send_deauth_disassoc() is now defined in util.c and it is available
for usage in the rest of the mac80211 code.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---

v3:
- fix if-condition in ieee80211_send_deauth_disassoc()


 net/mac80211/ieee80211_i.h |  5 ++++
 net/mac80211/mlme.c        | 60 ++++++++--------------------------------------
 net/mac80211/util.c        | 40 +++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 50 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b95fa25..8874523 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -68,6 +68,8 @@ struct ieee80211_local;
 #define IEEE80211_DEFAULT_MAX_SP_LEN		\
 	IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL
 
+#define IEEE80211_DEAUTH_FRAME_LEN	(24 /* hdr */ + 2 /* reason */)
+
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
@@ -1458,6 +1460,9 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
 			 u8 *extra, size_t extra_len, const u8 *bssid,
 			 const u8 *da, const u8 *key, u8 key_len, u8 key_idx);
+void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
+				    const u8 *bssid, u16 stype, u16 reason,
+				    bool send_frame, u8 *frame_buf);
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8746694..0ca3413 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -88,8 +88,6 @@ MODULE_PARM_DESC(probe_wait_ms,
 #define TMR_RUNNING_TIMER	0
 #define TMR_RUNNING_CHANSW	1
 
-#define DEAUTH_DISASSOC_LEN	(24 /* hdr */ + 2 /* reason */)
-
 /*
  * All cfg80211 functions have to be called outside a locked
  * section so that they can acquire a lock themselves... This
@@ -574,46 +572,6 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	ieee80211_tx_skb(sdata, skb);
 }
 
-static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
-					   const u8 *bssid, u16 stype,
-					   u16 reason, bool send_frame,
-					   u8 *frame_buf)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt = (void *)frame_buf;
-
-	/* build frame */
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | stype);
-	mgmt->duration = 0; /* initialize only */
-	mgmt->seq_ctrl = 0; /* initialize only */
-	memcpy(mgmt->da, bssid, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
-	memcpy(mgmt->bssid, bssid, ETH_ALEN);
-	/* u.deauth.reason_code == u.disassoc.reason_code */
-	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
-
-	if (send_frame) {
-		skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-				    DEAUTH_DISASSOC_LEN);
-		if (!skb)
-			return;
-
-		skb_reserve(skb, local->hw.extra_tx_headroom);
-
-		/* copy in frame */
-		memcpy(skb_put(skb, DEAUTH_DISASSOC_LEN),
-		       mgmt, DEAUTH_DISASSOC_LEN);
-
-		if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
-			IEEE80211_SKB_CB(skb)->flags |=
-				IEEE80211_TX_INTFL_DONT_ENCRYPT;
-
-		ieee80211_tx_skb(sdata, skb);
-	}
-}
-
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata)
 {
@@ -1695,7 +1653,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
-	u8 frame_buf[DEAUTH_DISASSOC_LEN];
+	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
 	mutex_lock(&ifmgd->mtx);
 	if (!ifmgd->associated) {
@@ -1713,7 +1671,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata,
 	 * must be outside lock due to cfg80211,
 	 * but that's not a problem.
 	 */
-	cfg80211_send_deauth(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
+	cfg80211_send_deauth(sdata->dev, frame_buf, IEEE80211_DEAUTH_FRAME_LEN);
 
 	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
@@ -2645,7 +2603,7 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u8 frame_buf[DEAUTH_DISASSOC_LEN];
+	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH, reason,
 			       false, frame_buf);
@@ -2655,7 +2613,7 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 	 * must be outside lock due to cfg80211,
 	 * but that's not a problem.
 	 */
-	cfg80211_send_deauth(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
+	cfg80211_send_deauth(sdata->dev, frame_buf, IEEE80211_DEAUTH_FRAME_LEN);
 
 	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
@@ -3538,7 +3496,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 			 struct cfg80211_deauth_request *req)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u8 frame_buf[DEAUTH_DISASSOC_LEN];
+	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -3566,7 +3524,8 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 
 	mutex_unlock(&ifmgd->mtx);
 
-	__cfg80211_send_deauth(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
+	__cfg80211_send_deauth(sdata->dev, frame_buf,
+			       IEEE80211_DEAUTH_FRAME_LEN);
 
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
@@ -3580,7 +3539,7 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 bssid[ETH_ALEN];
-	u8 frame_buf[DEAUTH_DISASSOC_LEN];
+	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -3605,7 +3564,8 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 			       frame_buf);
 	mutex_unlock(&ifmgd->mtx);
 
-	__cfg80211_send_disassoc(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
+	__cfg80211_send_disassoc(sdata->dev, frame_buf,
+				 IEEE80211_DEAUTH_FRAME_LEN);
 
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ed75439..dab2ebe 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1007,6 +1007,46 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 }
 
+void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
+				    const u8 *bssid, u16 stype, u16 reason,
+				    bool send_frame, u8 *frame_buf)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt = (void *)frame_buf;
+
+	/* build frame */
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | stype);
+	mgmt->duration = 0; /* initialize only */
+	mgmt->seq_ctrl = 0; /* initialize only */
+	memcpy(mgmt->da, bssid, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
+	memcpy(mgmt->bssid, bssid, ETH_ALEN);
+	/* u.deauth.reason_code == u.disassoc.reason_code */
+	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
+
+	if (send_frame) {
+		skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+				    IEEE80211_DEAUTH_FRAME_LEN);
+		if (!skb)
+			return;
+
+		skb_reserve(skb, local->hw.extra_tx_headroom);
+
+		/* copy in frame */
+		memcpy(skb_put(skb, IEEE80211_DEAUTH_FRAME_LEN),
+		       mgmt, IEEE80211_DEAUTH_FRAME_LEN);
+
+		if (sdata->vif.type != NL80211_IFTYPE_STATION ||
+		    !(sdata->u.mgd.flags & IEEE80211_STA_MFP_ENABLED))
+			IEEE80211_SKB_CB(skb)->flags |=
+				IEEE80211_TX_INTFL_DONT_ENCRYPT;
+
+		ieee80211_tx_skb(sdata, skb);
+	}
+}
+
+
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
-- 
1.7.12

