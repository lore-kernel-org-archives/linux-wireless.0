Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59440 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab1IFU2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 16:28:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R12Fh-0004I7-MM
	for linux-wireless@vger.kernel.org; Tue, 06 Sep 2011 22:28:14 +0200
Message-Id: <20110906202725.130077360@sipsolutions.net> (sfid-20110906_222826_173953_844A1DA3)
Date: Tue, 06 Sep 2011 22:27:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 3/5] mac80211: implement uAPSD
References: <20110906201703.703254041@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add uAPSD support to mac80211. This is probably not
possible with all devices, so advertising it with
the cfg80211 flag will be left up to drivers that
want it.

Due to my previous patches it is now a fairly
straight-forward extension. Drivers need to have
accurate TX status reporting for the EOSP frame.
For drivers that buffer themselves, the provided
APIs allow releasing the right number of frames,
but then drivers need to set EOSP and more-data
themselves. This is documented in more detail in
the new code itself.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c |    2 
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    2 
 drivers/net/wireless/p54/txrx.c             |    2 
 include/net/mac80211.h                      |   22 ++-
 net/mac80211/rx.c                           |   91 +++++++++++-----
 net/mac80211/sta_info.c                     |  155 +++++++++++++++++++---------
 net/mac80211/sta_info.h                     |    8 +
 net/mac80211/status.c                       |    3 
 net/mac80211/tx.c                           |    2 
 9 files changed, 201 insertions(+), 86 deletions(-)

--- a/net/mac80211/rx.c	2011-09-06 21:40:08.000000000 +0200
+++ b/net/mac80211/rx.c	2011-09-06 22:05:21.000000000 +0200
@@ -1172,6 +1172,68 @@ int ieee80211_sta_ps_transition(struct i
 EXPORT_SYMBOL(ieee80211_sta_ps_transition);
 
 static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_uapsd_and_pspoll(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct ieee80211_hdr *hdr = (void *)rx->skb->data;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
+	int tid, ac;
+
+	if (!rx->sta || !(status->rx_flags & IEEE80211_RX_RA_MATCH))
+		return RX_CONTINUE;
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+		return RX_CONTINUE;
+
+	/*
+	 * The device handles station powersave, so don't do anything about
+	 * uAPSD and PS-Poll frames (the latter shouldn't even come up from
+	 * it to mac80211 since they're handled.)
+	 */
+	if (sdata->local->hw.flags & IEEE80211_HW_AP_LINK_PS)
+		return RX_CONTINUE;
+
+	if (unlikely(ieee80211_is_pspoll(hdr->frame_control))) {
+		if (!test_sta_flags(rx->sta, WLAN_STA_PS_DRIVER))
+			ieee80211_sta_ps_deliver_poll_response(rx->sta);
+		else
+			set_sta_flags(rx->sta, WLAN_STA_PSPOLL);
+
+		/* Free PS Poll skb here instead of returning RX_DROP that would
+		 * count as an dropped frame. */
+		dev_kfree_skb(rx->skb);
+
+		return RX_QUEUED;
+	} else if (ieee80211_is_data_qos(hdr->frame_control) ||
+		   ieee80211_is_qos_nullfunc(hdr->frame_control)) {
+		tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+		ac = ieee802_1d_to_ac[tid & 7];
+
+		/*
+		 * If this AC is not trigger-enabled do nothing.
+		 *
+		 * NB: This could/should check a separate bitmap of trigger-
+		 * enabled queues, but for now we only implement uAPSD w/o
+		 * TSPEC changes to the ACs, so they're always the same.
+		 */
+		if (!(rx->sta->sta.uapsd_queues & BIT(ac)))
+			return RX_CONTINUE;
+
+		/* if we are in a service period, do nothing */
+		if (test_sta_flags(rx->sta, WLAN_STA_SP))
+			return RX_CONTINUE;
+
+		if (!test_sta_flags(rx->sta, WLAN_STA_PS_DRIVER))
+			ieee80211_sta_ps_deliver_uapsd(rx->sta);
+		else
+			set_sta_flags(rx->sta, WLAN_STA_UAPSD);
+	}
+
+	return RX_CONTINUE;
+}
+
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
 	struct sta_info *sta = rx->sta;
@@ -1482,33 +1544,6 @@ ieee80211_rx_h_defragment(struct ieee802
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
-{
-	struct ieee80211_sub_if_data *sdata = rx->sdata;
-	__le16 fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
-
-	if (likely(!rx->sta || !ieee80211_is_pspoll(fc) ||
-		   !(status->rx_flags & IEEE80211_RX_RA_MATCH)))
-		return RX_CONTINUE;
-
-	if ((sdata->vif.type != NL80211_IFTYPE_AP) &&
-	    (sdata->vif.type != NL80211_IFTYPE_AP_VLAN))
-		return RX_DROP_UNUSABLE;
-
-	if (!test_sta_flags(rx->sta, WLAN_STA_PS_DRIVER))
-		ieee80211_sta_ps_deliver_poll_response(rx->sta);
-	else
-		set_sta_flags(rx->sta, WLAN_STA_PSPOLL);
-
-	/* Free PS Poll skb here instead of returning RX_DROP that would
-	 * count as an dropped frame. */
-	dev_kfree_skb(rx->skb);
-
-	return RX_QUEUED;
-}
-
-static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_remove_qos_control(struct ieee80211_rx_data *rx)
 {
 	u8 *data = rx->skb->data;
@@ -2564,9 +2599,9 @@ static void ieee80211_rx_handlers(struct
 
 		CALL_RXH(ieee80211_rx_h_decrypt)
 		CALL_RXH(ieee80211_rx_h_check_more_data)
+		CALL_RXH(ieee80211_rx_h_uapsd_and_pspoll)
 		CALL_RXH(ieee80211_rx_h_sta_process)
 		CALL_RXH(ieee80211_rx_h_defragment)
-		CALL_RXH(ieee80211_rx_h_ps_poll)
 		CALL_RXH(ieee80211_rx_h_michael_mic_verify)
 		/* must be after MMIC verify so header is counted in MPDU mic */
 		CALL_RXH(ieee80211_rx_h_remove_qos_control)
--- a/net/mac80211/sta_info.c	2011-09-06 21:40:08.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-06 22:05:29.000000000 +0200
@@ -248,6 +248,9 @@ static void sta_unblock(struct work_stru
 	else if (test_and_clear_sta_flags(sta, WLAN_STA_PSPOLL)) {
 		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
 		ieee80211_sta_ps_deliver_poll_response(sta);
+	} else if (test_and_clear_sta_flags(sta, WLAN_STA_UAPSD)) {
+		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
+		ieee80211_sta_ps_deliver_uapsd(sta);
 	} else
 		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
 }
@@ -1136,31 +1139,27 @@ void ieee80211_sta_ps_deliver_wakeup(str
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 }
 
-void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta)
+static void
+ieee80211_sta_ps_deliver_response(struct sta_info *sta,
+				  int n_frames, u8 ignored_acs,
+				  enum ieee80211_frame_release_type reason)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb = NULL;
 	bool found = false;
 	bool more_data = false;
 	int ac, driver_release_tid = -1;
-	u8 ignore_for_response = sta->sta.uapsd_queues;
+	struct sk_buff_head frames;
 
-	/*
-	 * If all ACs are delivery-enabled then we should reply
-	 * from any of them, if only some are enabled we reply
-	 * only from the non-enabled ones.
-	 */
-	if (ignore_for_response == BIT(IEEE80211_NUM_ACS) - 1)
-		ignore_for_response = 0;
+	__skb_queue_head_init(&frames);
 
 	/*
-	 * Get response frame and more data bit for it.
+	 * Get response frame(s) and more data bit for it.
 	 */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		int tid1, tid2;
 
-		if (ignore_for_response & BIT(ac))
+		if (ignored_acs & BIT(ac))
 			continue;
 
 		ieee80211_tids_for_ac(ac, &tid1, &tid2);
@@ -1173,14 +1172,22 @@ void ieee80211_sta_ps_deliver_poll_respo
 				found = true;
 				driver_release_tid = tid1;
 			} else {
-				skb = skb_dequeue(&sta->tx_filtered[ac]);
-				if (!skb) {
-					skb = skb_dequeue(&sta->ps_tx_buf[ac]);
-					if (skb)
-						local->total_ps_buffered--;
-				}
-				if (skb)
+				struct sk_buff *skb;
+
+				while (n_frames > 0) {
+					skb = skb_dequeue(&sta->tx_filtered[ac]);
+					if (!skb) {
+						skb = skb_dequeue(
+							&sta->ps_tx_buf[ac]);
+						if (skb)
+							local->total_ps_buffered--;
+					}
+					if (!skb)
+						break;
+					n_frames--;
 					found = true;
+					__skb_queue_tail(&frames, skb);
+				}
 			}
 		}
 
@@ -1218,42 +1225,58 @@ void ieee80211_sta_ps_deliver_poll_respo
 		 *	  Should we send it a null-func frame indicating we
 		 *	  have nothing buffered for it?
 		 */
-		printk(KERN_DEBUG "%s: STA %pM sent PS Poll even "
-		       "though there are no buffered frames for it\n",
-		       sdata->name, sta->sta.addr);
+		if (reason == IEEE80211_FRAME_RELEASE_PSPOLL)
+			printk(KERN_DEBUG "%s: STA %pM sent PS Poll even "
+			       "though there are no buffered frames for it\n",
+			       sdata->name, sta->sta.addr);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
 		return;
 	}
 
-	if (skb) {
-		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-		struct ieee80211_hdr *hdr =
-			(struct ieee80211_hdr *) skb->data;
-
-		/*
-		 * Tell TX path to send this frame even though the STA may
-		 * still remain is PS mode after this frame exchange.
-		 */
-		info->flags |= IEEE80211_TX_CTL_PSPOLL_RESPONSE;
-
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-		printk(KERN_DEBUG "STA %pM aid %d: PS Poll\n",
-		       sta->sta.addr, sta->sta.aid);
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+	if (driver_release_tid == -1) {
+		struct sk_buff_head pending;
+		struct sk_buff *skb;
+
+		skb_queue_head_init(&pending);
+
+		while ((skb = __skb_dequeue(&frames))) {
+			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+			struct ieee80211_hdr *hdr = (void *) skb->data;
+
+			/*
+			 * Tell TX path to send this frame even though the
+			 * STA may still remain is PS mode after this frame
+			 * exchange.
+			 */
+			info->flags |= IEEE80211_TX_CTL_POLL_RESPONSE;
+
+			/*
+			 * Use MoreData flag to indicate whether there are
+			 * more buffered frames for this STA
+			 */
+			if (!more_data)
+				hdr->frame_control &=
+					cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
+			else
+				hdr->frame_control |=
+					cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+
+			if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
+			    skb_queue_empty(&frames)) {
+				/* set EOSP for the frame */
+				u8 *p = ieee80211_get_qos_ctl(hdr);
+				*p |= IEEE80211_QOS_CTL_EOSP;
+				info->flags |= IEEE80211_TX_STATUS_EOSP |
+					       IEEE80211_TX_CTL_REQ_TX_STATUS;
+			}
 
-		/* Use MoreData flag to indicate whether there are more
-		 * buffered frames for this STA */
-		if (!more_data)
-			hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
-		else
-			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+			__skb_queue_tail(&pending, skb);
+		}
 
-		ieee80211_add_pending_skb(local, skb);
+		ieee80211_add_pending_skbs(local, &pending);
 
 		sta_info_recalc_tim(sta);
-	} else if (WARN_ON(driver_release_tid == -1)) {
-		/* err ... ??? */
 	} else {
 		/*
 		 * We need to release a frame that is buffered somewhere in the
@@ -1266,8 +1289,7 @@ void ieee80211_sta_ps_deliver_poll_respo
 		 * needs to be set anyway.
 		 */
 		drv_release_buffered_frames(local, sta, driver_release_tid,
-					    1, IEEE80211_FRAME_RELEASE_PSPOLL,
-					    more_data);
+					    n_frames, reason, more_data);
 
 		/*
 		 * Note that we don't recalculate the TIM bit here as it would
@@ -1280,6 +1302,43 @@ void ieee80211_sta_ps_deliver_poll_respo
 	}
 }
 
+void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta)
+{
+	u8 ignore_for_response = sta->sta.uapsd_queues;
+
+	/*
+	 * If all ACs are delivery-enabled then we should reply
+	 * from any of them, if only some are enabled we reply
+	 * only from the non-enabled ones.
+	 */
+	if (ignore_for_response == BIT(IEEE80211_NUM_ACS) - 1)
+		ignore_for_response = 0;
+
+	ieee80211_sta_ps_deliver_response(sta, 1, ignore_for_response,
+					  IEEE80211_FRAME_RELEASE_PSPOLL);
+}
+
+void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta)
+{
+	u8 delivery_enabled = sta->sta.uapsd_queues;
+
+	/*
+	 * If we ever grow support for TSPEC this might happen if
+	 * the TSPEC update from hostapd comes in between a trigger
+	 * frame setting WLAN_STA_UAPSD in the RX path and this
+	 * actually getting called.
+	 */
+	if (!delivery_enabled)
+		return;
+
+	/* Ohh, finally, the service period starts :-) */
+	set_sta_flags(sta, WLAN_STA_SP);
+
+	ieee80211_sta_ps_deliver_response(sta, sta->sta.max_sp,
+					  ~delivery_enabled,
+					  IEEE80211_FRAME_RELEASE_UAPSD);
+}
+
 void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 			       struct ieee80211_sta *pubsta, bool block)
 {
--- a/net/mac80211/sta_info.h	2011-09-06 21:40:08.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-09-06 22:05:21.000000000 +0200
@@ -43,6 +43,11 @@
  *	be in the queues
  * @WLAN_STA_PSPOLL: Station sent PS-poll while driver was keeping
  *	station in power-save mode, reply when the driver unblocks.
+ * @WLAN_STA_UAPSD: Station requested unscheduled SP while driver was
+ *	keeping station in power-save mode, reply when the driver
+ *	unblocks the station.
+ * @WLAN_STA_SP: Station is in a service period, so don't try to
+ *	reply to other uAPSD trigger frames.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -58,6 +63,8 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_BLOCK_BA	= 1<<11,
 	WLAN_STA_PS_DRIVER	= 1<<12,
 	WLAN_STA_PSPOLL		= 1<<13,
+	WLAN_STA_UAPSD		= 1<<14,
+	WLAN_STA_SP		= 1<<15,
 };
 
 #define STA_TID_NUM 16
@@ -528,5 +535,6 @@ void ieee80211_sta_expire(struct ieee802
 
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
+void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
 
 #endif /* STA_INFO_H */
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c	2011-09-06 21:40:08.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c	2011-09-06 21:40:09.000000000 +0200
@@ -335,7 +335,7 @@ int iwl4965_tx_skb(struct iwl_priv *priv
 		sta_priv = (void *)sta->drv_priv;
 
 	if (sta_priv && sta_priv->asleep &&
-	    (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)) {
+	    (info->flags & IEEE80211_TX_CTL_POLL_RESPONSE)) {
 		/*
 		 * This sends an asynchronous command to the device,
 		 * but we can rely on it being processed before the
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2011-09-06 21:40:08.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2011-09-06 21:40:09.000000000 +0200
@@ -300,7 +300,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 		sta_priv = (void *)info->control.sta->drv_priv;
 
 	if (sta_priv && sta_priv->asleep &&
-	    (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)) {
+	    (info->flags & IEEE80211_TX_CTL_POLL_RESPONSE)) {
 		/*
 		 * This sends an asynchronous command to the device,
 		 * but we can rely on it being processed before the
--- a/drivers/net/wireless/p54/txrx.c	2011-09-06 21:40:08.000000000 +0200
+++ b/drivers/net/wireless/p54/txrx.c	2011-09-06 21:40:09.000000000 +0200
@@ -685,7 +685,7 @@ static void p54_tx_80211_header(struct p
 	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		*flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
 
-	if (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)
+	if (info->flags & IEEE80211_TX_CTL_POLL_RESPONSE)
 		*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 
 	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
--- a/include/net/mac80211.h	2011-09-06 21:40:08.000000000 +0200
+++ b/include/net/mac80211.h	2011-09-06 22:05:21.000000000 +0200
@@ -331,9 +331,9 @@ struct ieee80211_bss_conf {
  *	used to indicate that a frame was already retried due to PS
  * @IEEE80211_TX_INTFL_DONT_ENCRYPT: completely internal to mac80211,
  *	used to indicate frame should not be encrypted
- * @IEEE80211_TX_CTL_PSPOLL_RESPONSE: (internal?)
- *	This frame is a response to a PS-poll frame and should be sent
- *	although the station is in powersave mode.
+ * @IEEE80211_TX_CTL_POLL_RESPONSE: This frame is a response to a poll
+ *	frame (PS-Poll or uAPSD) and should be sent although the station
+ *	is in powersave mode.
  * @IEEE80211_TX_CTL_MORE_FRAMES: More frames will be passed to the
  *	transmit function after the current frame, this can be used
  *	by drivers to kick the DMA queue only if unset or when the
@@ -356,6 +356,10 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_INTFL_TKIP_MIC_FAILURE: Marks this packet to be used for TKIP
  *	testing. It will be sent out with incorrect Michael MIC key to allow
  *	TKIP countermeasures to be tested.
+ * @IEEE80211_TX_STATUS_EOSP: This packet marks the end of service period,
+ *	when its status is reported the service period ends. For frames in
+ *	an SP that mac80211 transmits, it is already set; for driver frames
+ *	the driver may set this flag.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -377,7 +381,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(14),
 	IEEE80211_TX_INTFL_RETRIED		= BIT(15),
 	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
-	IEEE80211_TX_CTL_PSPOLL_RESPONSE	= BIT(17),
+	IEEE80211_TX_CTL_POLL_RESPONSE		= BIT(17),
 	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
 	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(19),
 	IEEE80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
@@ -386,6 +390,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
 	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
 	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
+	IEEE80211_TX_STATUS_EOSP		= BIT(27),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
@@ -399,7 +404,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_SEND_AFTER_DTIM | IEEE80211_TX_CTL_AMPDU |	      \
 	IEEE80211_TX_STAT_TX_FILTERED |	IEEE80211_TX_STAT_ACK |		      \
 	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
-	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_PSPOLL_RESPONSE | \
+	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_POLL_RESPONSE |   \
 	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
 	IEEE80211_TX_CTL_STBC)
 
@@ -1604,9 +1609,12 @@ enum ieee80211_tx_sync_type {
 /**
  * enum ieee80211_frame_release_type - frame release reason
  * @IEEE80211_FRAME_RELEASE_PSPOLL: frame released for PS-Poll
+ * @IEEE80211_FRAME_RELEASE_UAPSD: frame(s) released due to
+ *	frame received on trigger-enabled AC
  */
 enum ieee80211_frame_release_type {
 	IEEE80211_FRAME_RELEASE_PSPOLL,
+	IEEE80211_FRAME_RELEASE_UAPSD,
 };
 
 /**
@@ -1932,7 +1940,9 @@ enum ieee80211_frame_release_type {
  *	In the case this is used for uAPSD, the @num_frames parameter may be
  *	bigger than one, but the driver may send fewer frames (it must send
  *	at least one, however). In this case it is also responsible for
- *	setting the EOSP flag in the QoS header of the frames.
+ *	setting the EOSP flag in the QoS header of the frames. Also, when the
+ *	service period ends, the driver must set %IEEE80211_TX_STATUS_EOSP
+ *	on the last frame in the SP.
  *	This callback must be atomic.
  */
 struct ieee80211_ops {
--- a/net/mac80211/tx.c	2011-09-06 21:40:08.000000000 +0200
+++ b/net/mac80211/tx.c	2011-09-06 21:40:09.000000000 +0200
@@ -456,7 +456,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 	staflags = get_sta_flags(sta);
 
 	if (unlikely((staflags & (WLAN_STA_PS_STA | WLAN_STA_PS_DRIVER)) &&
-		     !(info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE))) {
+		     !(info->flags & IEEE80211_TX_CTL_POLL_RESPONSE))) {
 		int ac = skb_get_queue_mapping(tx->skb);
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
--- a/net/mac80211/status.c	2011-09-06 21:40:08.000000000 +0200
+++ b/net/mac80211/status.c	2011-09-06 22:05:21.000000000 +0200
@@ -234,6 +234,9 @@ void ieee80211_tx_status(struct ieee8021
 		if (memcmp(hdr->addr2, sta->sdata->vif.addr, ETH_ALEN))
 			continue;
 
+		if (info->flags & IEEE80211_TX_STATUS_EOSP)
+			clear_sta_flags(sta, WLAN_STA_SP);
+
 		acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
 		if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
 			/*


