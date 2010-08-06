Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50196 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761885Ab0HFSuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 14:50:05 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so2902634eya.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 11:50:05 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/7] rt2x00: Remove ieee80211_rx_status from rt2x00_dev
Date: Fri, 6 Aug 2010 20:49:27 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201008062045.05288.IvDoorn@gmail.com> <201008062047.58607.IvDoorn@gmail.com> <201008062048.28764.IvDoorn@gmail.com>
In-Reply-To: <201008062048.28764.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008062049.28417.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00 was keeping a copy of ieee80211_rx_status embedded
into the rt2x00_dev structure. For each RX frame, this structure
was copied into the skb->cb where mac80211 would handle it further.

However at the moment only the fields current band, and frequency
were updated. Whereas the band was already provided directly within
the rt2x00_dev structure. Save a memcpy action, and reduce memory
a bit, by adding a curr_freq field to rt2x00_dev, and completely
remove the ieee80211_rx_status structure from rt2x00_dev.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h       |    6 +-----
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 +---
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   16 +++++++++-------
 drivers/net/wireless/rt2x00/rt61pci.c      |    4 ++--
 drivers/net/wireless/rt2x00/rt73usb.c      |    4 ++--
 6 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 827a258..3a150d3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -494,7 +494,7 @@ static int rt2800_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxwi_w2)
 	u8 offset1;
 	u8 offset2;
 
-	if (rt2x00dev->rx_status.band == IEEE80211_BAND_2GHZ) {
+	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG, &eeprom);
 		offset0 = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG_OFFSET0);
 		offset1 = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG_OFFSET1);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index edfc2b7..8c65244 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -699,6 +699,7 @@ struct rt2x00_dev {
 	struct ieee80211_hw *hw;
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 	enum ieee80211_band curr_band;
+	int curr_freq;
 
 	/*
 	 * If enabled, the debugfs interface structures
@@ -851,11 +852,6 @@ struct rt2x00_dev {
 	struct ieee80211_low_level_stats low_level_stats;
 
 	/*
-	 * RX configuration information.
-	 */
-	struct ieee80211_rx_status rx_status;
-
-	/*
 	 * Scheduled work.
 	 * NOTE: intf_work will use ieee80211_iterate_active_interfaces()
 	 * which means it cannot be placed on the hw->workqueue
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 953dc4f..9971d5c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -209,10 +209,8 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		rt2x00link_reset_tuner(rt2x00dev, false);
 
 	rt2x00dev->curr_band = conf->channel->band;
+	rt2x00dev->curr_freq = conf->channel->center_freq;
 	rt2x00dev->tx_power = conf->power_level;
 	rt2x00dev->short_retry = conf->short_frame_max_tx_count;
 	rt2x00dev->long_retry = conf->long_frame_max_tx_count;
-
-	rt2x00dev->rx_status.band = conf->channel->band;
-	rt2x00dev->rx_status.freq = conf->channel->center_freq;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 6499cc4..e692608 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -464,7 +464,7 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 {
 	struct rxdone_entry_desc rxdesc;
 	struct sk_buff *skb;
-	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
+	struct ieee80211_rx_status *rx_status;
 	unsigned int header_length;
 	int rate_idx;
 
@@ -535,19 +535,21 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00link_update_stats(rt2x00dev, entry->skb, &rxdesc);
 	rt2x00debug_update_crypto(rt2x00dev, &rxdesc);
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_RXDONE, entry->skb);
 
+	/*
+	 * Initialize RX status information, and send frame
+	 * to mac80211.
+	 */
+	rx_status = IEEE80211_SKB_RXCB(entry->skb);
 	rx_status->mactime = rxdesc.timestamp;
+	rx_status->band = rt2x00dev->curr_band;
+	rx_status->freq = rt2x00dev->curr_freq;
 	rx_status->rate_idx = rate_idx;
 	rx_status->signal = rxdesc.rssi;
 	rx_status->flag = rxdesc.flags;
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
-	/*
-	 * Send frame to mac80211 & debugfs.
-	 * mac80211 will clean up the skb structure.
-	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_RXDONE, entry->skb);
-	memcpy(IEEE80211_SKB_RXCB(entry->skb), rx_status, sizeof(*rx_status));
 	ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index dc6f3eb..cff503f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1050,7 +1050,7 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Determine r17 bounds.
 	 */
-	if (rt2x00dev->rx_status.band == IEEE80211_BAND_5GHZ) {
+	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
 		low_bound = 0x28;
 		up_bound = 0x48;
 		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags)) {
@@ -1972,7 +1972,7 @@ static int rt61pci_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 		return 0;
 	}
 
-	if (rt2x00dev->rx_status.band == IEEE80211_BAND_5GHZ) {
+	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
 		if (lna == 3 || lna == 2)
 			offset += 10;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index aa9de18..c655296 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -929,7 +929,7 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Determine r17 bounds.
 	 */
-	if (rt2x00dev->rx_status.band == IEEE80211_BAND_5GHZ) {
+	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
 		low_bound = 0x28;
 		up_bound = 0x48;
 
@@ -1597,7 +1597,7 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 		return 0;
 	}
 
-	if (rt2x00dev->rx_status.band == IEEE80211_BAND_5GHZ) {
+	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
 		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags)) {
 			if (lna == 3 || lna == 2)
 				offset += 10;
-- 
1.7.2

