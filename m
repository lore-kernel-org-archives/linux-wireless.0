Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab1BWOGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 09:06:11 -0500
Subject: [PATCH] mac80211: rename RX_FLAG_TSFT
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 15:06:08 +0100
Message-ID: <1298469968.4122.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The flag isn't very descriptive -- the intention
is that the driver provides a TSF timestamp at
the beginning of the MPDU -- make that clearer
by renaming the flag to RX_FLAG_MACTIME_MPDU.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath5k/base.c         |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c         |    2 +-
 drivers/net/wireless/b43/xmit.c               |    2 +-
 drivers/net/wireless/b43legacy/xmit.c         |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |    2 +-
 drivers/net/wireless/p54/txrx.c               |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c    |    2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c  |    2 +-
 drivers/net/wireless/wl1251/rx.c              |    2 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c  |    5 ++++-
 include/net/mac80211.h                        |    9 +++++----
 net/mac80211/ibss.c                           |    2 +-
 net/mac80211/rx.c                             |    4 ++--
 17 files changed, 25 insertions(+), 21 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2011-02-23 12:49:34.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2011-02-23 15:03:52.000000000 +0100
@@ -599,9 +599,10 @@ ieee80211_tx_info_clear_status(struct ie
  *	the frame.
  * @RX_FLAG_FAILED_PLCP_CRC: Set this flag if the PCLP check failed on
  *	the frame.
- * @RX_FLAG_TSFT: The timestamp passed in the RX status (@mactime field)
- *	is valid. This is useful in monitor mode and necessary for beacon frames
- *	to enable IBSS merging.
+ * @RX_FLAG_MACTIME_MPDU: The timestamp passed in the RX status (@mactime
+ *	field) is valid and contains the time the first symbol of the MPDU
+ *	was received. This is useful in monitor mode and for proper IBSS
+ *	merging.
  * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
  * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
  * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
@@ -614,7 +615,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_IV_STRIPPED	= 1<<4,
 	RX_FLAG_FAILED_FCS_CRC	= 1<<5,
 	RX_FLAG_FAILED_PLCP_CRC = 1<<6,
-	RX_FLAG_TSFT		= 1<<7,
+	RX_FLAG_MACTIME_MPDU	= 1<<7,
 	RX_FLAG_SHORTPRE	= 1<<8,
 	RX_FLAG_HT		= 1<<9,
 	RX_FLAG_40MHZ		= 1<<10,
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/base.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath5k/base.c	2011-02-23 12:55:01.000000000 +0100
@@ -1361,7 +1361,7 @@ ath5k_receive_frame(struct ath5k_softc *
 	 * right now, so it's not too bad...
 	 */
 	rxs->mactime = ath5k_extend_tsf(sc->ah, rs->rs_tstamp);
-	rxs->flag |= RX_FLAG_TSFT;
+	rxs->flag |= RX_FLAG_MACTIME_MPDU;
 
 	rxs->freq = sc->curchan->center_freq;
 	rxs->band = sc->curchan->band;
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c	2011-02-23 12:55:01.000000000 +0100
@@ -600,7 +600,7 @@ static bool ath9k_rx_prepare(struct ath9
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->signal =  rxbuf->rxstatus.rs_rssi + ATH_DEFAULT_NOISE_FLOOR;
 	rx_status->antenna = rxbuf->rxstatus.rs_antenna;
-	rx_status->flag |= RX_FLAG_TSFT;
+	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
 	return true;
 
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/recv.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/recv.c	2011-02-23 12:55:01.000000000 +0100
@@ -983,7 +983,7 @@ static int ath9k_rx_skb_preprocess(struc
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
-	rx_status->flag |= RX_FLAG_TSFT;
+	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
 	return 0;
 }
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2011-02-23 12:55:01.000000000 +0100
@@ -652,7 +652,7 @@ void b43_rx(struct b43_wldev *dev, struc
 		status.mactime += mactime;
 		if (low_mactime_now <= mactime)
 			status.mactime -= 0x10000;
-		status.flag |= RX_FLAG_TSFT;
+		status.flag |= RX_FLAG_MACTIME_MPDU;
 	}
 
 	chanid = (chanstat & B43_RX_CHAN_ID) >> B43_RX_CHAN_ID_SHIFT;
--- wireless-testing.orig/drivers/net/wireless/b43legacy/xmit.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43legacy/xmit.c	2011-02-23 12:55:01.000000000 +0100
@@ -572,7 +572,7 @@ void b43legacy_rx(struct b43legacy_wldev
 		status.mactime += mactime;
 		if (low_mactime_now <= mactime)
 			status.mactime -= 0x10000;
-		status.flag |= RX_FLAG_TSFT;
+		status.flag |= RX_FLAG_MACTIME_MPDU;
 	}
 
 	chanid = (chanstat & B43legacy_RX_CHAN_ID) >>
--- wireless-testing.orig/drivers/net/wireless/iwlegacy/iwl-4965-lib.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlegacy/iwl-4965-lib.c	2011-02-23 12:55:01.000000000 +0100
@@ -639,7 +639,7 @@ void iwl4965_rx_reply_rx(struct iwl_priv
 
 	/* TSF isn't reliable. In order to allow smooth user experience,
 	 * this W/A doesn't propagate it to the mac80211 */
-	/*rx_status.flag |= RX_FLAG_TSFT;*/
+	/*rx_status.flag |= RX_FLAG_MACTIME_MPDU;*/
 
 	priv->ucode_beacon_time = le32_to_cpu(phy_res->beacon_time_stamp);
 
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-lib.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-lib.c	2011-02-23 12:55:01.000000000 +0100
@@ -1173,7 +1173,7 @@ void iwlagn_rx_reply_rx(struct iwl_priv
 
 	/* TSF isn't reliable. In order to allow smooth user experience,
 	 * this W/A doesn't propagate it to the mac80211 */
-	/*rx_status.flag |= RX_FLAG_TSFT;*/
+	/*rx_status.flag |= RX_FLAG_MACTIME_MPDU;*/
 
 	priv->ucode_beacon_time = le32_to_cpu(phy_res->beacon_time_stamp);
 
--- wireless-testing.orig/drivers/net/wireless/p54/txrx.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/p54/txrx.c	2011-02-23 12:55:01.000000000 +0100
@@ -367,7 +367,7 @@ static int p54_rx_data(struct p54_common
 	rx_status->mactime = ((u64)priv->tsf_high32) << 32 | tsf32;
 	priv->tsf_low32 = tsf32;
 
-	rx_status->flag |= RX_FLAG_TSFT;
+	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
 	if (hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 		header_len += hdr->align[0];
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180/dev.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180/dev.c	2011-02-23 12:55:01.000000000 +0100
@@ -146,7 +146,7 @@ static void rtl8180_handle_rx(struct iee
 			rx_status.freq = dev->conf.channel->center_freq;
 			rx_status.band = dev->conf.channel->band;
 			rx_status.mactime = le64_to_cpu(entry->tsft);
-			rx_status.flag |= RX_FLAG_TSFT;
+			rx_status.flag |= RX_FLAG_MACTIME_MPDU;
 			if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 				rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187/dev.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187/dev.c	2011-02-23 12:55:01.000000000 +0100
@@ -371,7 +371,7 @@ static void rtl8187_rx_cb(struct urb *ur
 	rx_status.rate_idx = rate;
 	rx_status.freq = dev->conf.channel->center_freq;
 	rx_status.band = dev->conf.channel->band;
-	rx_status.flag |= RX_FLAG_TSFT;
+	rx_status.flag |= RX_FLAG_MACTIME_MPDU;
 	if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c	2011-02-23 12:55:01.000000000 +0100
@@ -691,7 +691,7 @@ bool rtl92ce_rx_query_desc(struct ieee80
 	if (GET_RX_DESC_RXHT(pdesc))
 		rx_status->flag |= RX_FLAG_HT;
 
-	rx_status->flag |= RX_FLAG_TSFT;
+	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c	2011-02-23 12:55:01.000000000 +0100
@@ -334,7 +334,7 @@ bool rtl92cu_rx_query_desc(struct ieee80
 		rx_status->flag |= RX_FLAG_40MHZ;
 	if (GET_RX_DESC_RX_HT(pdesc))
 		rx_status->flag |= RX_FLAG_HT;
-	rx_status->flag |= RX_FLAG_TSFT;
+	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	rx_status->rate_idx = _rtl92c_rate_mapping(hw,
--- wireless-testing.orig/drivers/net/wireless/wl1251/rx.c	2011-02-23 12:54:39.000000000 +0100
+++ wireless-testing/drivers/net/wireless/wl1251/rx.c	2011-02-23 12:55:01.000000000 +0100
@@ -81,7 +81,7 @@ static void wl1251_rx_status(struct wl12
 	status->freq = ieee80211_channel_to_frequency(desc->channel,
 						      status->band);
 
-	status->flag |= RX_FLAG_TSFT;
+	status->flag |= RX_FLAG_MACTIME_MPDU;
 
 	if (desc->flags & RX_DESC_ENCRYPTION_MASK) {
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
--- wireless-testing.orig/net/mac80211/ibss.c	2011-02-23 14:43:43.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2011-02-23 15:03:53.000000000 +0100
@@ -354,7 +354,7 @@ static void ieee80211_rx_bss_info(struct
 	if (memcmp(cbss->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0)
 		goto put_bss;
 
-	if (rx_status->flag & RX_FLAG_TSFT) {
+	if (rx_status->flag & RX_FLAG_MACTIME_MPDU) {
 		/*
 		 * For correct IBSS merging we need mactime; since mactime is
 		 * defined as the time the first data symbol of the frame hits
--- wireless-testing.orig/net/mac80211/rx.c	2011-02-23 14:44:01.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2011-02-23 15:03:52.000000000 +0100
@@ -77,7 +77,7 @@ ieee80211_rx_radiotap_len(struct ieee802
 	/* always present fields */
 	len = sizeof(struct ieee80211_radiotap_header) + 9;
 
-	if (status->flag & RX_FLAG_TSFT)
+	if (status->flag & RX_FLAG_MACTIME_MPDU)
 		len += 8;
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		len += 1;
@@ -123,7 +123,7 @@ ieee80211_add_rx_radiotap_header(struct
 	/* the order of the following fields is important */
 
 	/* IEEE80211_RADIOTAP_TSFT */
-	if (status->flag & RX_FLAG_TSFT) {
+	if (status->flag & RX_FLAG_MACTIME_MPDU) {
 		put_unaligned_le64(status->mactime, pos);
 		rthdr->it_present |=
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
--- wireless-testing.orig/drivers/staging/brcm80211/sys/wlc_mac80211.c	2011-02-23 15:03:58.000000000 +0100
+++ wireless-testing/drivers/staging/brcm80211/sys/wlc_mac80211.c	2011-02-23 15:04:48.000000000 +0100
@@ -6818,11 +6818,14 @@ prep_mac80211_status(struct wlc_info *wl
 	ratespec_t rspec;
 	unsigned char *plcp;
 
+#if 0
+	/* Clearly, this is bogus -- reading the TSF now is wrong */
 	wlc_read_tsf(wlc, &tsf_l, &tsf_h);	/* mactime */
 	rx_status->mactime = tsf_h;
 	rx_status->mactime <<= 32;
 	rx_status->mactime |= tsf_l;
-	rx_status->flag |= RX_FLAG_TSFT;
+	rx_status->flag |= RX_FLAG_MACTIME_MPDU; /* clearly wrong */
+#endif
 
 	channel = WLC_CHAN_CHANNEL(rxh->RxChan);
 


