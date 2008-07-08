Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:11652 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYGHS1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 14:27:22 -0400
Received: by yx-out-2324.google.com with SMTP id 8so658804yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 11:27:21 -0700 (PDT)
Subject: [PATCH 1/8] mac80211: move QOS control helpers into ieee80211.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 11:00:26 -0700
Message-Id: <1215540026.476.15.camel@brick> (sfid-20080708_202726_411097_A7FE2D35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also remove the WLAN_IS_QOS_DATA inline after removing the last
two users.  This starts moving away from using rx->fc to using
the header frame_control directly.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/ieee80211.h |    2 ++
 net/mac80211/rx.c         |   28 ++++++++++++++--------------
 net/mac80211/wme.c        |    4 ++--
 net/mac80211/wme.h        |    8 --------
 4 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index aa603c3..a1630ba 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -99,6 +99,8 @@
 #define IEEE80211_MAX_SSID_LEN		32
 #define IEEE80211_MAX_MESH_ID_LEN	32
 #define IEEE80211_QOS_CTL_LEN		2
+#define IEEE80211_QOS_CTL_TID_MASK	0x000F
+#define IEEE80211_QOS_CTL_TAG1D_MASK	0x0007
 
 struct ieee80211_hdr {
 	__le16 frame_control;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6a88e8f..a3a26e5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -321,20 +321,20 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 
 static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
 {
-	u8 *data = rx->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	int tid;
 
 	/* does the frame have a qos control field? */
-	if (WLAN_FC_IS_QOS_DATA(rx->fc)) {
-		u8 *qc = data + ieee80211_get_hdrlen(rx->fc) - QOS_CONTROL_LEN;
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		/* frame has qos control */
-		tid = qc[0] & QOS_CONTROL_TID_MASK;
-		if (qc[0] & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
+		tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
+		if (*qc & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
 			rx->flags |= IEEE80211_RX_AMSDU;
 		else
 			rx->flags &= ~IEEE80211_RX_AMSDU;
 	} else {
-		if (unlikely((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)) {
+		if (unlikely(ieee80211_is_mgmt(hdr->frame_control))) {
 			/* Separate TID for management frames */
 			tid = NUM_RX_DATA_QUEUES - 1;
 		} else {
@@ -1037,19 +1037,19 @@ ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_remove_qos_control(struct ieee80211_rx_data *rx)
 {
-	u16 fc = rx->fc;
 	u8 *data = rx->skb->data;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)data;
 
-	if (!WLAN_FC_IS_QOS_DATA(fc))
+	if (!ieee80211_is_data_qos(hdr->frame_control))
 		return RX_CONTINUE;
 
 	/* remove the qos control field, update frame type and meta-data */
-	memmove(data + 2, data, ieee80211_get_hdrlen(fc) - 2);
-	hdr = (struct ieee80211_hdr *) skb_pull(rx->skb, 2);
+	memmove(data + IEEE80211_QOS_CTL_LEN, data,
+		ieee80211_hdrlen(hdr->frame_control) - IEEE80211_QOS_CTL_LEN);
+	hdr = (struct ieee80211_hdr *)skb_pull(rx->skb, IEEE80211_QOS_CTL_LEN);
 	/* change frame type to non QOS */
-	rx->fc = fc &= ~IEEE80211_STYPE_QOS_DATA;
-	hdr->frame_control = cpu_to_le16(fc);
+	rx->fc &= ~IEEE80211_STYPE_QOS_DATA;
+	hdr->frame_control &= ~cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 
 	return RX_CONTINUE;
 }
@@ -2044,7 +2044,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
 	if (!ieee80211_is_data_qos(hdr->frame_control))
 		goto end_reorder;
 
-	tid = *ieee80211_get_qos_ctl(hdr) & QOS_CONTROL_TID_MASK;
+	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 
 	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_OPERATIONAL)
 		goto end_reorder;
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index a1a53a4..5c666f7 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -154,7 +154,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 		queue = skb_get_queue_mapping(skb);
 		rcu_read_lock();
 		sta = sta_info_get(local, hdr->addr1);
-		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
+		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		if (sta) {
 			int ampdu_queue = sta->tid_to_tx_q[tid];
 			if ((ampdu_queue < QD_NUM(hw)) &&
@@ -181,7 +181,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		u8 *p = ieee80211_get_qos_ctl(hdr);
 		u8 ack_policy = 0;
-		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
+		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		if (local->wifi_wme_noack_test)
 			ack_policy |= QOS_CONTROL_ACK_POLICY_NOACK <<
 					QOS_CONTROL_ACK_POLICY_SHIFT;
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index bbdb533..1aca609 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -19,18 +19,10 @@
 #define QOS_CONTROL_ACK_POLICY_NORMAL 0
 #define QOS_CONTROL_ACK_POLICY_NOACK 1
 
-#define QOS_CONTROL_TID_MASK 0x0f
 #define QOS_CONTROL_ACK_POLICY_SHIFT 5
 
-#define QOS_CONTROL_TAG1D_MASK 0x07
-
 extern const int ieee802_1d_to_ac[8];
 
-static inline int WLAN_FC_IS_QOS_DATA(u16 fc)
-{
-	return (fc & 0x8C) == 0x88;
-}
-
 #ifdef CONFIG_MAC80211_QOS
 void ieee80211_install_qdisc(struct net_device *dev);
 int ieee80211_qdisc_installed(struct net_device *dev);
-- 
1.5.6.1.322.ge904b


