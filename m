Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:49045 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbXB1OHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:13 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562557nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:13 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 25/28] rt2x00: rt2x00.h cleanup
Date: Wed, 28 Feb 2007 15:07:07 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.07287.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup some old code that was replaced by rt2x00lib, or isn't required
anymore.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 29a8203..f1e3624 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -1817,11 +1817,6 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw,
 	control->queue = IEEE80211_TX_QUEUE_BEACON;
 
 	/*
-	 * Set the software sequence number.
-	 */
-	rt2x00_set_sequence(skb, &rt2x00dev->interface.sequence);
-
-	/*
 	 * Update the beacon entry.
 	 */
 	memcpy(entry->data_addr, skb->data, skb->len);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index e5d032c..06562e1 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -1955,11 +1955,6 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw,
 	control->queue = IEEE80211_TX_QUEUE_BEACON;
 
 	/*
-	 * Set the software sequence number.
-	 */
-	rt2x00_set_sequence(skb, &rt2x00dev->interface.sequence);
-
-	/*
 	 * Update the beacon entry.
 	 */
 	memcpy(entry->data_addr, skb->data, skb->len);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 86846a1..20e321e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -2344,7 +2344,7 @@ static int rt2500usb_init_hw(struct rt2x00_dev *rt2x00dev)
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->max_noise = -110;
+	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
 	if (ieee80211_register_hw(rt2x00dev->hw))
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index 3bd8271..0d47a41 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -811,50 +811,8 @@ struct interface {
 	 * in monitor mode that that have been added.
 	 */
 	short monitor_count;
-
-	/*
-	 * Sequence number for software controled sequence counters.
-	 */
-	u16 sequence;
 };
 
-static inline void rt2x00_add_interface(struct interface *intf,
-	struct ieee80211_if_init_conf *conf)
-{
-	/*
-	 * We support muliple monitor mode interfaces.
-	 * All we need to do is increase the monitor_count.
-	 */
-	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
-		intf->monitor_count++;
-	} else {
-		intf->id = conf->if_id;
-		intf->type = conf->type;
-		if (conf->type == IEEE80211_IF_TYPE_AP)
-			memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
-		intf->promisc = 0;
-		intf->sequence = 0;
-	}
-}
-
-static inline void rt2x00_remove_interface(struct interface *intf,
-	struct ieee80211_if_init_conf *conf)
-{
-	/*
-	 * We support muliple monitor mode interfaces.
-	 * All we need to do is decrease the monitor_count.
-	 */
-	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
-		intf->monitor_count--;
-	} else if (intf->type == conf->type) {
-		intf->id = 0;
-		intf->type = -EINVAL;
-		memset(&intf->bssid, 0x00, ETH_ALEN);
-		intf->promisc = 0;
-		intf->sequence = 0;
-	}
-}
-
 /*
  * Scanning structure.
  * Swithing channel during scanning will be put
@@ -900,22 +858,6 @@ struct scanning {
 	struct work_struct work;
 };
 
-static inline void rt2x00_start_scan(struct scanning *scan,
-	struct ieee80211_scan_conf *conf, int state)
-{
-	init_completion(&scan->completion);
-
-	memcpy(&scan->conf, conf, sizeof(*conf));
-
-	scan->state = state;
-
-	/*
-	 * Set initial status to SCANNING_WAITING to prevent scanning
-	 * to begin while there are still TX packets queued.
-	 */
-	scan->status = SCANNING_WAITING;
-}
-
 static inline void rt2x00_signal_scan(struct scanning *scan, short status)
 {
 	scan->status = status;
@@ -923,25 +865,6 @@ static inline void rt2x00_signal_scan(struct scanning *scan, short status)
 	complete_all(&scan->completion);
 }
 
-static inline int rt2x00_wait_scan(struct scanning *scan)
-{
-	/*
-	 * Only wait for completion when the status
-	 * indicates we should. The SCANNING_READY
-	 * and SCANNING_CANCELLED are both states
-	 * which indicate complete_all has already
-	 * been called.
-	 */
-	if (scan->status == SCANNING_WAITING)
-		wait_for_completion(&scan->completion);
-
-	/*
-	 * Status field will have been updated by the handler
-	 * that has called complete_all() on our complete structure.
-	 */
-	return scan->status;
-}
-
 /*
  * rt2x00lib callback functions.
  */
@@ -1202,27 +1125,6 @@ static void rt2x00_eeprom_write(const struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->eeprom[word] = cpu_to_le16(data);
 }
 
-static inline void rt2x00_update_tx_stats(struct rt2x00_dev *rt2x00dev,
-	struct ieee80211_tx_status *tx_status, const int status,
-	const int is_ack, const int is_rts)
-{
-	struct ieee80211_low_level_stats *stats = &rt2x00dev->low_level_stats;
-
-	if (is_ack)
-		tx_status->flags |= IEEE80211_TX_STATUS_ACK;
-	tx_status->excessive_retries = (status == TX_FAIL_RETRY);
-
-	if (!is_ack && status == TX_FAIL_RETRY)
-		stats->dot11ACKFailureCount++;
-
-	if (is_rts) {
-		if (status == TX_SUCCESS || status == TX_SUCCESS_RETRY)
-			stats->dot11RTSSuccessCount++;
-		else
-			stats->dot11RTSFailureCount++;
-	}
-}
-
 /*
  * Device specific rate value.
  * We will have to create the device specific rate value
@@ -1301,83 +1203,6 @@ static inline void device_rate_entry(struct ieee80211_rate *entry,
 	entry->min_rssi_ack_delta = 0;
 }
 
-static inline int device_signal_to_rate(struct ieee80211_hw_mode *mode,
-	u8 signal, u8 ofdm)
-{
-	unsigned int i;
-	u8 plcp;
-	u8 rate;
-
-	for (i = 0; i < mode->num_rates; i++) {
-		/*
-		 * When frame was received with an OFDM bitrate,
-		 * the signal is the PLCP value. If it was received with
-		 * a CCK bitrate the signal is the rate in 0.5kbit/s.
-		 */
-		if (!ofdm) {
-			rate = DEVICE_GET_RATE_FIELD(mode->rates[i].val, RATE);
-			if (rate == signal)
-				return mode->rates[i].val;
-		} else {
-			plcp = DEVICE_GET_RATE_FIELD(mode->rates[i].val, PLCP);
-			if (plcp == signal) {
-				/*
-				 * Check for preamble bit.
-				 */
-				if (signal & 0x08)
-					return mode->rates[i].val2;
-				return mode->rates[i].val;
-			}
-		}
-	}
-
-	return 0;
-}
-
-/*
- * Sequence number handlers.
- */
-static inline int rt2x00_require_sequence(struct ieee80211_hdr *ieee80211hdr)
-{
-	/*
-	 * Check if the packet has a header
-	 * that contains a seq_ctrl field.
-	 */
-	if (ieee80211_get_hdrlen(
-		le16_to_cpu(ieee80211hdr->frame_control)) >= IEEE80211_HEADER)
-		return 1;
-	return 0;
-}
-
-static inline void rt2x00_set_sequence(struct sk_buff *skb, u16 *seq)
-{
-	struct ieee80211_hdr *ieee80211hdr =
-		(struct ieee80211_hdr*)skb->data;
-
-	/*
-	 * Only attach the sequence number, when
-	 * the buffer requires it.
-	 */
-	if (!rt2x00_require_sequence(ieee80211hdr))
-		return;
-
-	/*
-	 * Set the sequence number for this frame,
-	 * but do not change the fragment number.
-	 */
-	ieee80211hdr->seq_ctrl |= cpu_to_le16(*seq & IEEE80211_SCTL_SEQ);
-
-	/*
-	 * Since the dscape stack sends all packets and
-	 * fragments individually, we need to check if there
-	 * will be new fragments following.
-	 * If this is the last or only fragment, the sequence
-	 * counter should be increased.
-	 */
-	if (!ieee80211_get_morefrag(ieee80211hdr))
-		*seq = (*seq + 0x10) & IEEE80211_SCTL_SEQ;
-}
-
 /*
  * Duration calculations
  * The rate variable passed is: 100kbs.
