Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbZFQLQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 07:16:04 -0400
Subject: [PATCH] mac80211: push rx status into skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 13:13:00 +0200
Message-Id: <1245237180.20613.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Within mac80211, we often need to copy the rx status into
skb->cb. This is wasteful, as drivers could be building it
in there to start with. This patch changes the API so that
drivers are expected to pass the RX status in skb->cb, now
accessible as IEEE80211_SKB_RXCB(skb). It also updates all
drivers to pass the rx status in there, but only by making
them memcpy() it into place before the call to the receive
function (ieee80211_rx(_irqsafe)). Each driver can now be
optimised on its own schedule.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
FWIW, I did a few spatches that looked like this:
@@
expression hw, skb, status;
@@
-ieee80211_rx_irqsafe(hw, (skb), &status);
+memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+ieee80211_rx_irqsafe(hw, skb);


 drivers/net/wireless/adm8211.c             |    3 -
 drivers/net/wireless/at76c50x-usb.c        |    3 -
 drivers/net/wireless/ath/ar9170/main.c     |    6 +-
 drivers/net/wireless/ath/ath5k/base.c      |    3 -
 drivers/net/wireless/ath/ath9k/recv.c      |   13 +++--
 drivers/net/wireless/b43/xmit.c            |    3 -
 drivers/net/wireless/b43legacy/xmit.c      |    3 -
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    3 -
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    3 -
 drivers/net/wireless/libertas_tf/main.c    |    3 -
 drivers/net/wireless/mac80211_hwsim.c      |    3 -
 drivers/net/wireless/mwl8k.c               |    3 -
 drivers/net/wireless/p54/p54common.c       |    3 -
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    3 -
 drivers/net/wireless/rtl818x/rtl8180_dev.c |    3 -
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    3 -
 drivers/net/wireless/wl12xx/rx.c           |    3 -
 drivers/net/wireless/zd1211rw/zd_mac.c     |    3 -
 drivers/staging/agnx/xmit.c                |    3 -
 drivers/staging/stlc45xx/stlc45xx.c        |    3 -
 drivers/staging/winbond/wb35rx.c           |    3 -
 include/net/mac80211.h                     |   31 ++++++------
 net/mac80211/ibss.c                        |    6 --
 net/mac80211/ieee80211_i.h                 |   10 +---
 net/mac80211/main.c                        |    5 --
 net/mac80211/mesh.c                        |    6 --
 net/mac80211/mesh.h                        |    3 -
 net/mac80211/mlme.c                        |    4 -
 net/mac80211/rx.c                          |   71 ++++++++++++-----------------
 net/mac80211/scan.c                        |    4 -
 30 files changed, 109 insertions(+), 107 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-06-17 13:12:03.000000000 +0200
@@ -397,6 +397,11 @@ static inline struct ieee80211_tx_info *
 	return (struct ieee80211_tx_info *)skb->cb;
 }
 
+static inline struct ieee80211_rx_status *IEEE80211_SKB_RXCB(struct sk_buff *skb)
+{
+	return (struct ieee80211_rx_status *)skb->cb;
+}
+
 /**
  * ieee80211_tx_info_clear_status - clear TX status
  *
@@ -478,7 +483,7 @@ enum mac80211_rx_flags {
  *
  * The low-level driver should provide this information (the subset
  * supported by hardware) to the 802.11 code with each received
- * frame.
+ * frame, in the skb's control buffer (cb).
  *
  * @mactime: value in microseconds of the 64-bit Time Synchronization Function
  * 	(TSF) timer when the first data symbol (MPDU) arrived at the hardware.
@@ -1606,9 +1611,11 @@ void ieee80211_free_hw(struct ieee80211_
  */
 void ieee80211_restart_hw(struct ieee80211_hw *hw);
 
-/* trick to avoid symbol clashes with the ieee80211 subsystem */
-void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		    struct ieee80211_rx_status *status);
+/*
+ * trick to avoid symbol clashes with the ieee80211 subsystem,
+ * use the inline below instead
+ */
+void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb);
 
 /**
  * ieee80211_rx - receive frame
@@ -1624,13 +1631,10 @@ void __ieee80211_rx(struct ieee80211_hw 
  *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
- * @status: status of this frame; the status pointer need not be valid
- *	after this function returns
  */
-static inline void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
-				struct ieee80211_rx_status *status)
+static inline void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	__ieee80211_rx(hw, skb, status);
+	__ieee80211_rx(hw, skb);
 }
 
 /**
@@ -1644,13 +1648,8 @@ static inline void ieee80211_rx(struct i
  *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
- * @status: status of this frame; the status pointer need not be valid
- *	after this function returns and is not freed by mac80211,
- *	it is recommended that it points to a stack area
- */
-void ieee80211_rx_irqsafe(struct ieee80211_hw *hw,
-			  struct sk_buff *skb,
-			  struct ieee80211_rx_status *status);
+ */
+void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb);
 
 /**
  * ieee80211_tx_status - transmit status callback
--- wireless-testing.orig/net/mac80211/ibss.c	2009-06-17 13:05:35.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-06-17 13:05:45.000000000 +0200
@@ -705,7 +705,7 @@ static void ieee80211_ibss_rx_queued_mgm
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
 
-	rx_status = (struct ieee80211_rx_status *) skb->cb;
+	rx_status = IEEE80211_SKB_RXCB(skb);
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	fc = le16_to_cpu(mgmt->frame_control);
 
@@ -836,8 +836,7 @@ void ieee80211_ibss_notify_scan_complete
 }
 
 ieee80211_rx_result
-ieee80211_ibss_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		       struct ieee80211_rx_status *rx_status)
+ieee80211_ibss_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_mgmt *mgmt;
@@ -852,7 +851,6 @@ ieee80211_ibss_rx_mgmt(struct ieee80211_
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
-		memcpy(skb->cb, rx_status, sizeof(*rx_status));
 	case IEEE80211_STYPE_PROBE_REQ:
 	case IEEE80211_STYPE_AUTH:
 		skb_queue_tail(&sdata->u.ibss.skb_queue, skb);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-06-17 13:05:35.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-06-17 13:05:45.000000000 +0200
@@ -943,8 +943,7 @@ extern const struct iw_handler_def ieee8
 /* STA code */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
 ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
-					  struct sk_buff *skb,
-					  struct ieee80211_rx_status *rx_status);
+					  struct sk_buff *skb);
 int ieee80211_sta_commit(struct ieee80211_sub_if_data *sdata);
 int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len);
 int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len);
@@ -967,8 +966,7 @@ void ieee80211_sta_restart(struct ieee80
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
 ieee80211_rx_result
-ieee80211_ibss_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		       struct ieee80211_rx_status *rx_status);
+ieee80211_ibss_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid, u8 *addr, u32 supp_rates);
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
@@ -988,9 +986,7 @@ int ieee80211_scan_results(struct ieee80
 			   char *buf, size_t len);
 void ieee80211_scan_cancel(struct ieee80211_local *local);
 ieee80211_rx_result
-ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata,
-		  struct sk_buff *skb,
-		  struct ieee80211_rx_status *rx_status);
+ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata,
 			       const char *ie, size_t len);
 
--- wireless-testing.orig/net/mac80211/main.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-06-17 13:05:45.000000000 +0200
@@ -330,19 +330,16 @@ static void ieee80211_tasklet_handler(un
 {
 	struct ieee80211_local *local = (struct ieee80211_local *) data;
 	struct sk_buff *skb;
-	struct ieee80211_rx_status rx_status;
 	struct ieee80211_ra_tid *ra_tid;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
 		switch (skb->pkt_type) {
 		case IEEE80211_RX_MSG:
-			/* status is in skb->cb */
-			memcpy(&rx_status, skb->cb, sizeof(rx_status));
 			/* Clear skb->pkt_type in order to not confuse kernel
 			 * netstack. */
 			skb->pkt_type = 0;
-			__ieee80211_rx(local_to_hw(local), skb, &rx_status);
+			ieee80211_rx(local_to_hw(local), skb);
 			break;
 		case IEEE80211_TX_STATUS_MSG:
 			skb->pkt_type = 0;
--- wireless-testing.orig/net/mac80211/mesh.c	2009-06-17 13:05:35.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.c	2009-06-17 13:05:45.000000000 +0200
@@ -568,7 +568,7 @@ static void ieee80211_mesh_rx_queued_mgm
 
 	ifmsh = &sdata->u.mesh;
 
-	rx_status = (struct ieee80211_rx_status *) skb->cb;
+	rx_status = IEEE80211_SKB_RXCB(skb);
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
 
@@ -671,8 +671,7 @@ void ieee80211_mesh_init_sdata(struct ie
 }
 
 ieee80211_rx_result
-ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		       struct ieee80211_rx_status *rx_status)
+ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
@@ -689,7 +688,6 @@ ieee80211_mesh_rx_mgmt(struct ieee80211_
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
 	case IEEE80211_STYPE_ACTION:
-		memcpy(skb->cb, rx_status, sizeof(*rx_status));
 		skb_queue_tail(&ifmsh->skb_queue, skb);
 		queue_work(local->hw.workqueue, &ifmsh->work);
 		return RX_QUEUED;
--- wireless-testing.orig/net/mac80211/mesh.h	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.h	2009-06-17 13:05:45.000000000 +0200
@@ -208,8 +208,7 @@ void ieee80211s_init(void);
 void ieee80211s_stop(void);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
 ieee80211_rx_result
-ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		       struct ieee80211_rx_status *rx_status);
+ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 
--- wireless-testing.orig/net/mac80211/mlme.c	2009-06-17 13:05:35.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-06-17 13:05:45.000000000 +0200
@@ -2063,8 +2063,7 @@ static void ieee80211_rx_mgmt_beacon(str
 }
 
 ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
-					  struct sk_buff *skb,
-					  struct ieee80211_rx_status *rx_status)
+					  struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_mgmt *mgmt;
@@ -2080,7 +2079,6 @@ ieee80211_rx_result ieee80211_sta_rx_mgm
 	case IEEE80211_STYPE_PROBE_REQ:
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
-		memcpy(skb->cb, rx_status, sizeof(*rx_status));
 	case IEEE80211_STYPE_AUTH:
 	case IEEE80211_STYPE_ASSOC_RESP:
 	case IEEE80211_STYPE_REASSOC_RESP:
--- wireless-testing.orig/net/mac80211/rx.c	2009-06-17 13:05:35.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-06-17 13:11:44.000000000 +0200
@@ -30,7 +30,6 @@
 static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 					   struct tid_ampdu_rx *tid_agg_rx,
 					   struct sk_buff *skb,
-					   struct ieee80211_rx_status *status,
 					   u16 mpdu_seq_num,
 					   int bar_req);
 /*
@@ -59,11 +58,11 @@ static struct sk_buff *remove_monitor_in
 	return skb;
 }
 
-static inline int should_drop_frame(struct ieee80211_rx_status *status,
-				    struct sk_buff *skb,
+static inline int should_drop_frame(struct sk_buff *skb,
 				    int present_fcs_len,
 				    int radiotap_len)
 {
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
@@ -111,10 +110,10 @@ ieee80211_rx_radiotap_len(struct ieee802
 static void
 ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 				 struct sk_buff *skb,
-				 struct ieee80211_rx_status *status,
 				 struct ieee80211_rate *rate,
 				 int rtap_len)
 {
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_radiotap_header *rthdr;
 	unsigned char *pos;
 
@@ -220,9 +219,9 @@ ieee80211_add_rx_radiotap_header(struct 
  */
 static struct sk_buff *
 ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
-		     struct ieee80211_rx_status *status,
 		     struct ieee80211_rate *rate)
 {
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(origskb);
 	struct ieee80211_sub_if_data *sdata;
 	int needed_headroom = 0;
 	struct sk_buff *skb, *skb2;
@@ -248,8 +247,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		present_fcs_len = FCS_LEN;
 
 	if (!local->monitors) {
-		if (should_drop_frame(status, origskb, present_fcs_len,
-				      rtap_len)) {
+		if (should_drop_frame(origskb, present_fcs_len, rtap_len)) {
 			dev_kfree_skb(origskb);
 			return NULL;
 		}
@@ -257,7 +255,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		return remove_monitor_info(local, origskb, rtap_len);
 	}
 
-	if (should_drop_frame(status, origskb, present_fcs_len, rtap_len)) {
+	if (should_drop_frame(origskb, present_fcs_len, rtap_len)) {
 		/* only need to expand headroom if necessary */
 		skb = origskb;
 		origskb = NULL;
@@ -289,7 +287,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 
 	/* if necessary, prepend radiotap information */
 	if (!(status->flag & RX_FLAG_RADIOTAP))
-		ieee80211_add_rx_radiotap_header(local, skb, status, rate,
+		ieee80211_add_rx_radiotap_header(local, skb, rate,
 						 needed_headroom);
 
 	skb_reset_mac_header(skb);
@@ -421,12 +419,11 @@ ieee80211_rx_h_passive_scan(struct ieee8
 	struct sk_buff *skb = rx->skb;
 
 	if (unlikely(local->hw_scanning))
-		return ieee80211_scan_rx(rx->sdata, skb, rx->status);
+		return ieee80211_scan_rx(rx->sdata, skb);
 
 	if (unlikely(local->sw_scanning)) {
 		/* drop all the other packets during a software scan anyway */
-		if (ieee80211_scan_rx(rx->sdata, skb, rx->status)
-		    != RX_QUEUED)
+		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
 			dev_kfree_skb(skb);
 		return RX_QUEUED;
 	}
@@ -1620,7 +1617,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 		/* manage reordering buffer according to requested */
 		/* sequence number */
 		rcu_read_lock();
-		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL, NULL,
+		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL,
 						 start_seq_num, 1);
 		rcu_read_unlock();
 		return RX_DROP_UNUSABLE;
@@ -1817,13 +1814,13 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 		return RX_DROP_MONITOR;
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
-		return ieee80211_mesh_rx_mgmt(sdata, rx->skb, rx->status);
+		return ieee80211_mesh_rx_mgmt(sdata, rx->skb);
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		return ieee80211_ibss_rx_mgmt(sdata, rx->skb, rx->status);
+		return ieee80211_ibss_rx_mgmt(sdata, rx->skb);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		return ieee80211_sta_rx_mgmt(sdata, rx->skb, rx->status);
+		return ieee80211_sta_rx_mgmt(sdata, rx->skb);
 
 	return RX_DROP_MONITOR;
 }
@@ -2114,9 +2111,9 @@ static int prepare_for_handlers(struct i
  */
 static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					 struct sk_buff *skb,
-					 struct ieee80211_rx_status *status,
 					 struct ieee80211_rate *rate)
 {
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr;
@@ -2227,20 +2224,21 @@ static void ieee80211_release_reorder_fr
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *rate;
-	struct ieee80211_rx_status status;
+	struct sk_buff *skb = tid_agg_rx->reorder_buf[index];
+	struct ieee80211_rx_status *status;
 
-	if (!tid_agg_rx->reorder_buf[index])
+	if (!skb)
 		goto no_frame;
 
+	status = IEEE80211_SKB_RXCB(skb);
+
 	/* release the reordered frames to stack */
-	memcpy(&status, tid_agg_rx->reorder_buf[index]->cb, sizeof(status));
-	sband = hw->wiphy->bands[status.band];
-	if (status.flag & RX_FLAG_HT)
+	sband = hw->wiphy->bands[status->band];
+	if (status->flag & RX_FLAG_HT)
 		rate = sband->bitrates; /* TODO: HT rates */
 	else
-		rate = &sband->bitrates[status.rate_idx];
-	__ieee80211_rx_handle_packet(hw, tid_agg_rx->reorder_buf[index],
-				     &status, rate);
+		rate = &sband->bitrates[status->rate_idx];
+	__ieee80211_rx_handle_packet(hw, skb, rate);
 	tid_agg_rx->stored_mpdu_num--;
 	tid_agg_rx->reorder_buf[index] = NULL;
 
@@ -2265,7 +2263,6 @@ no_frame:
 static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 					   struct tid_ampdu_rx *tid_agg_rx,
 					   struct sk_buff *skb,
-					   struct ieee80211_rx_status *rxstatus,
 					   u16 mpdu_seq_num,
 					   int bar_req)
 {
@@ -2324,8 +2321,6 @@ static u8 ieee80211_sta_manage_reorder_b
 	/* put the frame in the reordering buffer */
 	tid_agg_rx->reorder_buf[index] = skb;
 	tid_agg_rx->reorder_time[index] = jiffies;
-	memcpy(tid_agg_rx->reorder_buf[index]->cb, rxstatus,
-	       sizeof(*rxstatus));
 	tid_agg_rx->stored_mpdu_num++;
 	/* release the buffer until next missing frame */
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn)
@@ -2374,8 +2369,7 @@ static u8 ieee80211_sta_manage_reorder_b
 }
 
 static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
-				     struct sk_buff *skb,
-				     struct ieee80211_rx_status *status)
+				     struct sk_buff *skb)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -2424,7 +2418,7 @@ static u8 ieee80211_rx_reorder_ampdu(str
 
 	/* according to mpdu sequence number deal with reordering buffer */
 	mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
-	ret = ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb, status,
+	ret = ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb,
 						mpdu_seq_num, 0);
  end_reorder:
 	return ret;
@@ -2434,12 +2428,12 @@ static u8 ieee80211_rx_reorder_ampdu(str
  * This is the receive path handler. It is called by a low level driver when an
  * 802.11 MPDU is received from the hardware.
  */
-void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		    struct ieee80211_rx_status *status)
+void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate = NULL;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
 	if (status->band < 0 ||
 	    status->band >= IEEE80211_NUM_BANDS) {
@@ -2482,7 +2476,7 @@ void __ieee80211_rx(struct ieee80211_hw 
 	 * if it was previously present.
 	 * Also, frames with less than 16 bytes are dropped.
 	 */
-	skb = ieee80211_rx_monitor(local, skb, status, rate);
+	skb = ieee80211_rx_monitor(local, skb, rate);
 	if (!skb) {
 		rcu_read_unlock();
 		return;
@@ -2500,8 +2494,8 @@ void __ieee80211_rx(struct ieee80211_hw 
 	 * frames from other than operational channel), but that should not
 	 * happen in normal networks.
 	 */
-	if (!ieee80211_rx_reorder_ampdu(local, skb, status))
-		__ieee80211_rx_handle_packet(hw, skb, status, rate);
+	if (!ieee80211_rx_reorder_ampdu(local, skb))
+		__ieee80211_rx_handle_packet(hw, skb, rate);
 
 	rcu_read_unlock();
 }
@@ -2509,16 +2503,13 @@ EXPORT_SYMBOL(__ieee80211_rx);
 
 /* This is a version of the rx handler that can be called from hard irq
  * context. Post the skb on the queue and schedule the tasklet */
-void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb,
-			  struct ieee80211_rx_status *status)
+void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
 	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
 
 	skb->dev = local->mdev;
-	/* copy status into skb->cb for use by tasklet */
-	memcpy(skb->cb, status, sizeof(*status));
 	skb->pkt_type = IEEE80211_RX_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);
--- wireless-testing.orig/net/mac80211/scan.c	2009-06-17 13:05:35.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-06-17 13:05:45.000000000 +0200
@@ -135,9 +135,9 @@ void ieee80211_rx_bss_remove(struct ieee
 }
 
 ieee80211_rx_result
-ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		  struct ieee80211_rx_status *rx_status)
+ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_bss *bss;
 	u8 *elements;
--- wireless-testing.orig/drivers/net/wireless/adm8211.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/adm8211.c	2009-06-17 13:05:45.000000000 +0200
@@ -452,7 +452,8 @@ static void adm8211_interrupt_rci(struct
 			rx_status.freq = adm8211_channels[priv->channel - 1].center_freq;
 			rx_status.band = IEEE80211_BAND_2GHZ;
 
-			ieee80211_rx_irqsafe(dev, skb, &rx_status);
+			memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+			ieee80211_rx_irqsafe(dev, skb);
 		}
 
 		entry = (++priv->cur_rx) % priv->rx_ring_size;
--- wireless-testing.orig/drivers/net/wireless/at76c50x-usb.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/at76c50x-usb.c	2009-06-17 13:05:45.000000000 +0200
@@ -1568,7 +1568,8 @@ static void at76_rx_tasklet(unsigned lon
 
 	at76_dbg(DBG_MAC80211, "calling ieee80211_rx_irqsafe(): %d/%d",
 		 priv->rx_skb->len, priv->rx_skb->data_len);
-	ieee80211_rx_irqsafe(priv->hw, priv->rx_skb, &rx_status);
+	memcpy(IEEE80211_SKB_RXCB(priv->rx_skb), &rx_status, sizeof(rx_status));
+	ieee80211_rx_irqsafe(priv->hw, priv->rx_skb);
 
 	/* Use a new skb for the next receive */
 	priv->rx_skb = NULL;
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2009-06-17 13:05:45.000000000 +0200
@@ -917,8 +917,10 @@ static void ar9170_handle_mpdu(struct ar
 		ar9170_rx_phy_status(ar, phy, &status);
 
 	skb = ar9170_rx_copy_data(buf, mpdu_len);
-	if (likely(skb))
-		ieee80211_rx_irqsafe(ar->hw, skb, &status);
+	if (likely(skb)) {
+		memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+		ieee80211_rx_irqsafe(ar->hw, skb);
+	}
 }
 
 void ar9170_rx(struct ar9170 *ar, struct sk_buff *skb)
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/base.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath5k/base.c	2009-06-17 13:05:45.000000000 +0200
@@ -1893,7 +1893,8 @@ accept:
 		if (sc->opmode == NL80211_IFTYPE_ADHOC)
 			ath5k_check_ibss_tsf(sc, skb, &rxs);
 
-		__ieee80211_rx(sc->hw, skb, &rxs);
+		memcpy(IEEE80211_SKB_RXCB(skb), &rxs, sizeof(rxs));
+		ieee80211_rx(sc->hw, skb);
 
 		bf->skb = next_skb;
 		bf->skbaddr = next_skb_addr;
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2009-06-17 13:05:45.000000000 +0200
@@ -670,7 +670,8 @@ void b43_rx(struct b43_wldev *dev, struc
 		goto drop;
 	}
 
-	ieee80211_rx_irqsafe(dev->wl->hw, skb, &status);
+	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+	ieee80211_rx_irqsafe(dev->wl->hw, skb);
 
 	return;
 drop:
--- wireless-testing.orig/drivers/net/wireless/b43legacy/xmit.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/xmit.c	2009-06-17 13:05:45.000000000 +0200
@@ -591,7 +591,8 @@ void b43legacy_rx(struct b43legacy_wldev
 	}
 
 	dev->stats.last_rx = jiffies;
-	ieee80211_rx_irqsafe(dev->wl->hw, skb, &status);
+	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+	ieee80211_rx_irqsafe(dev->wl->hw, skb);
 
 	return;
 drop:
--- wireless-testing.orig/drivers/net/wireless/libertas_tf/main.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas_tf/main.c	2009-06-17 13:05:45.000000000 +0200
@@ -503,7 +503,8 @@ int lbtf_rx(struct lbtf_private *priv, s
 		skb_reserve(skb, 2);
 	}
 
-	ieee80211_rx_irqsafe(priv->hw, skb, &stats);
+	memcpy(IEEE80211_SKB_RXCB(skb), &stats, sizeof(stats));
+	ieee80211_rx_irqsafe(priv->hw, skb);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(lbtf_rx);
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-06-17 13:05:45.000000000 +0200
@@ -429,7 +429,8 @@ static bool mac80211_hwsim_tx_frame(stru
 		if (memcmp(hdr->addr1, data2->hw->wiphy->perm_addr,
 			   ETH_ALEN) == 0)
 			ack = true;
-		ieee80211_rx_irqsafe(data2->hw, nskb, &rx_status);
+		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
+		ieee80211_rx_irqsafe(data2->hw, nskb);
 	}
 	spin_unlock(&hwsim_radio_lock);
 
--- wireless-testing.orig/drivers/net/wireless/mwl8k.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mwl8k.c	2009-06-17 13:05:45.000000000 +0200
@@ -1047,7 +1047,8 @@ static int rxq_process(struct ieee80211_
 		status.flag = 0;
 		status.band = IEEE80211_BAND_2GHZ;
 		status.freq = ieee80211_channel_to_frequency(rx_desc->channel);
-		ieee80211_rx_irqsafe(hw, skb, &status);
+		memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+		ieee80211_rx_irqsafe(hw, skb);
 
 		processed++;
 	}
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/p54/p54common.c	2009-06-17 13:05:45.000000000 +0200
@@ -794,7 +794,8 @@ static int p54_rx_data(struct ieee80211_
 	skb_pull(skb, header_len);
 	skb_trim(skb, le16_to_cpu(hdr->len));
 
-	ieee80211_rx_irqsafe(dev, skb, &rx_status);
+	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+	ieee80211_rx_irqsafe(dev, skb);
 
 	queue_delayed_work(dev->workqueue, &priv->work,
 			   msecs_to_jiffies(P54_STATISTICS_UPDATE));
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180_dev.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c	2009-06-17 13:05:45.000000000 +0200
@@ -143,7 +143,8 @@ static void rtl8180_handle_rx(struct iee
 			if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 				rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 
-			ieee80211_rx_irqsafe(dev, skb, &rx_status);
+			memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+			ieee80211_rx_irqsafe(dev, skb);
 
 			skb = new_skb;
 			priv->rx_buf[priv->rx_idx] = skb;
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c	2009-06-17 13:05:45.000000000 +0200
@@ -385,7 +385,8 @@ static void rtl8187_rx_cb(struct urb *ur
 	rx_status.flag |= RX_FLAG_TSFT;
 	if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
-	ieee80211_rx_irqsafe(dev, skb, &rx_status);
+	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+	ieee80211_rx_irqsafe(dev, skb);
 
 	skb = dev_alloc_skb(RTL8187_MAX_RX);
 	if (unlikely(!skb)) {
--- wireless-testing.orig/drivers/net/wireless/wl12xx/rx.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/rx.c	2009-06-17 13:05:45.000000000 +0200
@@ -166,7 +166,8 @@ static void wl12xx_rx_body(struct wl12xx
 	wl12xx_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb, skb->len,
 		     beacon ? "beacon" : "");
 
-	ieee80211_rx(wl->hw, skb, &status);
+	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+	ieee80211_rx(wl->hw, skb);
 }
 
 static void wl12xx_rx_ack(struct wl12xx *wl)
--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2009-06-17 13:05:45.000000000 +0200
@@ -711,7 +711,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 
 	memcpy(skb_put(skb, length), buffer, length);
 
-	ieee80211_rx_irqsafe(hw, skb, &stats);
+	memcpy(IEEE80211_SKB_RXCB(skb), &stats, sizeof(stats));
+	ieee80211_rx_irqsafe(hw, skb);
 	return 0;
 }
 
--- wireless-testing.orig/drivers/staging/agnx/xmit.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/staging/agnx/xmit.c	2009-06-17 13:05:45.000000000 +0200
@@ -384,7 +384,8 @@ void handle_rx_irq(struct agnx_priv *pri
 /*			dump_ieee80211_hdr((struct ieee80211_hdr *)skb->data, "RX G"); */
 		} else
 			agnx_bug("Unknown packets type");
-		ieee80211_rx_irqsafe(priv->hw, skb, &status);
+		memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+		ieee80211_rx_irqsafe(priv->hw, skb);
 		rx_desc_reinit(priv, i);
 
 	} while (priv->rx.idx++);
--- wireless-testing.orig/drivers/staging/stlc45xx/stlc45xx.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/staging/stlc45xx/stlc45xx.c	2009-06-17 13:05:45.000000000 +0200
@@ -1429,7 +1429,8 @@ static int stlc45xx_rx_data(struct stlc4
 	stlc45xx_debug(DEBUG_RX, "rx data 0x%p %d B", skb->data, skb->len);
 	stlc45xx_dump(DEBUG_RX_CONTENT, skb->data, skb->len);
 
-	ieee80211_rx(stlc->hw, skb, &status);
+	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
+	ieee80211_rx(stlc->hw, skb);
 
 	return 0;
 }
--- wireless-testing.orig/drivers/staging/winbond/wb35rx.c	2009-06-17 13:05:36.000000000 +0200
+++ wireless-testing/drivers/staging/winbond/wb35rx.c	2009-06-17 13:05:45.000000000 +0200
@@ -40,7 +40,8 @@ static void packet_came(struct ieee80211
 	rx_status.phymode = MODE_IEEE80211B;
 */
 
-	ieee80211_rx_irqsafe(hw, skb, &rx_status);
+	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+	ieee80211_rx_irqsafe(hw, skb);
 }
 
 static void Wb35Rx_adjust(PDESCRIPTOR pRxDes)
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/recv.c	2009-06-15 21:36:55.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/recv.c	2009-06-17 13:05:45.000000000 +0200
@@ -616,13 +616,18 @@ static void ath_rx_send_to_mac80211(stru
 			if (aphy == NULL)
 				continue;
 			nskb = skb_copy(skb, GFP_ATOMIC);
-			if (nskb)
-				__ieee80211_rx(aphy->hw, nskb, rx_status);
+			if (nskb) {
+				memcpy(IEEE80211_SKB_RXCB(nskb), rx_status,
+					sizeof(*rx_status));
+				ieee80211_rx(aphy->hw, nskb);
+			}
 		}
-		__ieee80211_rx(sc->hw, skb, rx_status);
+		memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
+		ieee80211_rx(sc->hw, skb);
 	} else {
 		/* Deliver unicast frames based on receiver address */
-		__ieee80211_rx(ath_get_virt_hw(sc, hdr), skb, rx_status);
+		memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
+		ieee80211_rx(ath_get_virt_hw(sc, hdr), skb);
 	}
 }
 
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2009-06-07 21:32:32.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-3945.c	2009-06-17 13:05:45.000000000 +0200
@@ -577,7 +577,8 @@ static void iwl3945_pass_packet_to_mac80
 	if (ieee80211_is_data(hdr->frame_control))
 		priv->rxtxpackets += len;
 #endif
-	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
+	memcpy(IEEE80211_SKB_RXCB(rxb->skb), stats, sizeof(*stats));
+	ieee80211_rx_irqsafe(priv->hw, rxb->skb);
 	rxb->skb = NULL;
 }
 
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-rx.c	2009-06-16 15:57:32.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c	2009-06-17 13:05:45.000000000 +0200
@@ -932,7 +932,8 @@ static void iwl_pass_packet_to_mac80211(
 		return;
 
 	iwl_update_rx_stats(priv, le16_to_cpu(hdr->frame_control), len);
-	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
+	memcpy(IEEE80211_SKB_RXCB(rxb->skb), stats, sizeof(*stats));
+	ieee80211_rx_irqsafe(priv->hw, rxb->skb);
 	priv->alloc_rxb_skb--;
 	rxb->skb = NULL;
 }
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2009-06-02 12:33:15.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00dev.c	2009-06-17 13:05:45.000000000 +0200
@@ -449,7 +449,8 @@ void rt2x00lib_rxdone(struct rt2x00_dev 
 	 * mac80211 will clean up the skb structure.
 	 */
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_RXDONE, entry->skb);
-	ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb, rx_status);
+	memcpy(IEEE80211_SKB_RXCB(entry->skb), rx_status, sizeof(*rx_status));
+	ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb);
 
 	/*
 	 * Replace the skb with the freshly allocated one.


