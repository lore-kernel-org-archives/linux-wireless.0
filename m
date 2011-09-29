Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38280 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1I2OGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 10:06:36 -0400
Message-Id: <20110929140500.670372240@sipsolutions.net> (sfid-20110929_160640_278260_4FB6E05A)
Date: Thu, 29 Sep 2011 16:04:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 08/16] mac80211: implement uAPSD
References: <20110929140425.390322480@sipsolutions.net>
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
 include/net/mac80211.h                      |   24 ++-
 net/mac80211/rx.c                           |  102 ++++++++++++----
 net/mac80211/sta_info.c                     |  170 ++++++++++++++++++++--------
 net/mac80211/sta_info.h                     |    8 +
 net/mac80211/status.c                       |   15 ++
 net/mac80211/tx.c                           |    8 -
 9 files changed, 244 insertions(+), 89 deletions(-)

--- a/net/mac80211/rx.c	2011-09-29 16:01:14.000000000 +0200
+++ b/net/mac80211/rx.c	2011-09-29 16:03:17.000000000 +0200
@@ -1163,6 +1163,79 @@ int ieee80211_sta_ps_transition(struct i
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
+	/*
+	 * Don't do anything if the station isn't already asleep. In
+	 * the uAPSD case, the station will probably be marked asleep,
+	 * in the PS-Poll case the station must be confused ...
+	 */
+	if (!test_sta_flags(rx->sta, WLAN_STA_PS_STA))
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
+	} else if (!ieee80211_has_morefrags(hdr->frame_control) &&
+		   !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
+		   ieee80211_has_pm(hdr->frame_control) &&
+		   (ieee80211_is_data_qos(hdr->frame_control) ||
+		    ieee80211_is_qos_nullfunc(hdr->frame_control))) {
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
@@ -1473,33 +1546,6 @@ ieee80211_rx_h_defragment(struct ieee802
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
@@ -2567,9 +2613,9 @@ static void ieee80211_rx_handlers(struct
 
 		CALL_RXH(ieee80211_rx_h_decrypt)
 		CALL_RXH(ieee80211_rx_h_check_more_data)
+		CALL_RXH(ieee80211_rx_h_uapsd_and_pspoll)
 		CALL_RXH(ieee80211_rx_h_sta_process)
 		CALL_RXH(ieee80211_rx_h_defragment)
-		CALL_RXH(ieee80211_rx_h_ps_poll)
 		CALL_RXH(ieee80211_rx_h_michael_mic_verify)
 		/* must be after MMIC verify so header is counted in MPDU mic */
 #ifdef CONFIG_MAC80211_MESH
--- a/net/mac80211/sta_info.c	2011-09-29 16:03:14.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-29 16:03:17.000000000 +0200
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
@@ -1117,6 +1120,8 @@ void ieee80211_sta_ps_deliver_wakeup(str
 	struct sk_buff_head pending;
 	int filtered = 0, buffered = 0, ac;
 
+	clear_sta_flags(sta, WLAN_STA_SP);
+
 	BUILD_BUG_ON(BITS_TO_LONGS(STA_TID_NUM) > 1);
 	sta->driver_buffered_tids = 0;
 
@@ -1152,32 +1157,28 @@ void ieee80211_sta_ps_deliver_wakeup(str
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
 	int ac;
 	unsigned long driver_release_tids = 0;
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
 		unsigned long tids;
 
-		if (ignore_for_response & BIT(ac))
+		if (ignored_acs & BIT(ac))
 			continue;
 
 		tids = ieee80211_tids_for_ac(ac);
@@ -1187,14 +1188,22 @@ void ieee80211_sta_ps_deliver_poll_respo
 			if (driver_release_tids) {
 				found = true;
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
 
 			/*
@@ -1202,7 +1211,8 @@ void ieee80211_sta_ps_deliver_poll_respo
 			 * certainly there's more data if we release just a
 			 * single frame now (from a single TID).
 			 */
-			if (hweight16(driver_release_tids) > 1) {
+			if (reason == IEEE80211_FRAME_RELEASE_PSPOLL &&
+			    hweight16(driver_release_tids) > 1) {
 				more_data = true;
 				driver_release_tids =
 					BIT(ffs(driver_release_tids) - 1);
@@ -1225,38 +1235,56 @@ void ieee80211_sta_ps_deliver_poll_respo
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
+	if (!driver_release_tids) {
+		struct sk_buff_head pending;
+		struct sk_buff *skb;
+
+		skb_queue_head_init(&pending);
+
+		while ((skb = __skb_dequeue(&frames))) {
+			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+			struct ieee80211_hdr *hdr = (void *) skb->data;
 
-		/*
-		 * Tell TX path to send this frame even though the STA may
-		 * still remain is PS mode after this frame exchange.
-		 */
-		info->flags |= IEEE80211_TX_CTL_PSPOLL_RESPONSE;
+			/*
+			 * Tell TX path to send this frame even though the
+			 * STA may still remain is PS mode after this frame
+			 * exchange.
+			 */
+			info->flags |= IEEE80211_TX_CTL_POLL_RESPONSE;
 
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-		printk(KERN_DEBUG "STA %pM aid %d: PS Poll\n",
-		       sta->sta.addr, sta->sta.aid);
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
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
 	} else {
@@ -1271,8 +1299,7 @@ void ieee80211_sta_ps_deliver_poll_respo
 		 * needs to be set anyway.
 		 */
 		drv_release_buffered_frames(local, sta, driver_release_tids,
-					    1, IEEE80211_FRAME_RELEASE_PSPOLL,
-					    more_data);
+					    n_frames, reason, more_data);
 
 		/*
 		 * Note that we don't recalculate the TIM bit here as it would
@@ -1285,6 +1312,59 @@ void ieee80211_sta_ps_deliver_poll_respo
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
+	int n_frames = sta->sta.max_sp;
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
+	switch (sta->sta.max_sp) {
+	case 1:
+		n_frames = 2;
+		break;
+	case 2:
+		n_frames = 4;
+		break;
+	case 3:
+		n_frames = 6;
+		break;
+	case 0:
+		/* XXX: what is a good value? */
+		n_frames = 8;
+		break;
+	}
+
+	ieee80211_sta_ps_deliver_response(sta, n_frames, ~delivery_enabled,
+					  IEEE80211_FRAME_RELEASE_UAPSD);
+}
+
 void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 			       struct ieee80211_sta *pubsta, bool block)
 {
--- a/net/mac80211/sta_info.h	2011-09-29 16:02:04.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-09-29 16:03:17.000000000 +0200
@@ -46,6 +46,11 @@
  * @WLAN_STA_TDLS_PEER: Station is a TDLS peer.
  * @WLAN_STA_TDLS_PEER_AUTH: This TDLS peer is authorized to send direct
  *	packets. This means the link is enabled.
+ * @WLAN_STA_UAPSD: Station requested unscheduled SP while driver was
+ *	keeping station in power-save mode, reply when the driver
+ *	unblocks the station.
+ * @WLAN_STA_SP: Station is in a service period, so don't try to
+ *	reply to other uAPSD trigger frames.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -63,6 +68,8 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_PSPOLL		= 1<<13,
 	WLAN_STA_TDLS_PEER	= 1<<15,
 	WLAN_STA_TDLS_PEER_AUTH	= 1<<16,
+	WLAN_STA_UAPSD		= 1<<17,
+	WLAN_STA_SP		= 1<<18,
 };
 
 #define STA_TID_NUM 16
@@ -539,5 +546,6 @@ void ieee80211_sta_expire(struct ieee802
 
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
+void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
 
 #endif /* STA_INFO_H */
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c	2011-09-29 16:01:15.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c	2011-09-29 16:03:17.000000000 +0200
@@ -335,7 +335,7 @@ int iwl4965_tx_skb(struct iwl_priv *priv
 		sta_priv = (void *)sta->drv_priv;
 
 	if (sta_priv && sta_priv->asleep &&
-	    (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)) {
+	    (info->flags & IEEE80211_TX_CTL_POLL_RESPONSE)) {
 		/*
 		 * This sends an asynchronous command to the device,
 		 * but we can rely on it being processed before the
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2011-09-29 16:01:15.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2011-09-29 16:03:17.000000000 +0200
@@ -300,7 +300,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 		sta_priv = (void *)info->control.sta->drv_priv;
 
 	if (sta_priv && sta_priv->asleep &&
-	    (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)) {
+	    (info->flags & IEEE80211_TX_CTL_POLL_RESPONSE)) {
 		/*
 		 * This sends an asynchronous command to the device,
 		 * but we can rely on it being processed before the
--- a/drivers/net/wireless/p54/txrx.c	2011-09-29 16:01:15.000000000 +0200
+++ b/drivers/net/wireless/p54/txrx.c	2011-09-29 16:03:17.000000000 +0200
@@ -689,7 +689,7 @@ static void p54_tx_80211_header(struct p
 	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		*flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
 
-	if (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)
+	if (info->flags & IEEE80211_TX_CTL_POLL_RESPONSE)
 		*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 
 	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
--- a/include/net/mac80211.h	2011-09-29 16:03:14.000000000 +0200
+++ b/include/net/mac80211.h	2011-09-29 16:03:17.000000000 +0200
@@ -339,9 +339,9 @@ struct ieee80211_bss_conf {
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
@@ -367,6 +367,10 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_NO_CCK_RATE: This frame will be sent at non CCK rate.
  *	This flag is actually used for management frame especially for P2P
  *	frames not being sent at CCK rate in 2GHz band.
+ * @IEEE80211_TX_STATUS_EOSP: This packet marks the end of service period,
+ *	when its status is reported the service period ends. For frames in
+ *	an SP that mac80211 transmits, it is already set; for driver frames
+ *	the driver may set this flag.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -388,7 +392,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(14),
 	IEEE80211_TX_INTFL_RETRIED		= BIT(15),
 	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
-	IEEE80211_TX_CTL_PSPOLL_RESPONSE	= BIT(17),
+	IEEE80211_TX_CTL_POLL_RESPONSE		= BIT(17),
 	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
 	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(19),
 	IEEE80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
@@ -398,6 +402,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
 	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
 	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(27),
+	IEEE80211_TX_STATUS_EOSP		= BIT(28),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
@@ -411,9 +416,9 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_SEND_AFTER_DTIM | IEEE80211_TX_CTL_AMPDU |	      \
 	IEEE80211_TX_STAT_TX_FILTERED |	IEEE80211_TX_STAT_ACK |		      \
 	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
-	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_PSPOLL_RESPONSE | \
+	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_POLL_RESPONSE |   \
 	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
-	IEEE80211_TX_CTL_STBC)
+	IEEE80211_TX_CTL_STBC | IEEE80211_TX_STATUS_EOSP)
 
 /**
  * enum mac80211_rate_control_flags - per-rate flags set by the
@@ -1624,9 +1629,12 @@ enum ieee80211_tx_sync_type {
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
@@ -1954,7 +1962,9 @@ enum ieee80211_frame_release_type {
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
--- a/net/mac80211/tx.c	2011-09-29 16:02:04.000000000 +0200
+++ b/net/mac80211/tx.c	2011-09-29 16:03:17.000000000 +0200
@@ -456,7 +456,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 	staflags = get_sta_flags(sta);
 
 	if (unlikely((staflags & (WLAN_STA_PS_STA | WLAN_STA_PS_DRIVER)) &&
-		     !(info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE))) {
+		     !(info->flags & IEEE80211_TX_CTL_POLL_RESPONSE))) {
 		int ac = skb_get_queue_mapping(tx->skb);
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
@@ -497,9 +497,9 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 	}
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	else if (unlikely(staflags & WLAN_STA_PS_STA)) {
-		printk(KERN_DEBUG "%s: STA %pM in PS mode, but pspoll "
-		       "set -> send frame\n", tx->sdata->name,
-		       sta->sta.addr);
+		printk(KERN_DEBUG
+		       "%s: STA %pM in PS mode, but polling/in SP -> send frame\n",
+		       tx->sdata->name, sta->sta.addr);
 	}
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
--- a/net/mac80211/status.c	2011-09-29 16:03:13.000000000 +0200
+++ b/net/mac80211/status.c	2011-09-29 16:03:17.000000000 +0200
@@ -76,8 +76,16 @@ static void ieee80211_handle_filtered_fr
 		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
-		int tid = *ieee80211_get_qos_ctl(hdr) &
-					IEEE80211_QOS_CTL_TID_MASK;
+		u8 *p = ieee80211_get_qos_ctl(hdr);
+		int tid = *p & IEEE80211_QOS_CTL_TID_MASK;
+
+		/*
+		 * Clear EOSP if set, this could happen e.g.
+		 * if an absence period (us being a P2P GO)
+		 * shortens the SP.
+		 */
+		if (*p & IEEE80211_QOS_CTL_EOSP)
+			*p &= ~IEEE80211_QOS_CTL_EOSP;
 		ac = ieee802_1d_to_ac[tid & 7];
 	} else {
 		ac = IEEE80211_AC_BE;
@@ -276,6 +284,9 @@ void ieee80211_tx_status(struct ieee8021
 		if (memcmp(hdr->addr2, sta->sdata->vif.addr, ETH_ALEN))
 			continue;
 
+		if (info->flags & IEEE80211_TX_STATUS_EOSP)
+			clear_sta_flags(sta, WLAN_STA_SP);
+
 		acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
 		if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
 			/*


