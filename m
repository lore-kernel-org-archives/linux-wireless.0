Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:29581 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750763AbYDGEZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 00:25:55 -0400
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 1/2] mac80211: use hardware flags for signal/noise units
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz
Date: Mon, 07 Apr 2008 13:25:42 +0900
Message-ID: <20080407042541.9026.59360.stgit@localhost> (sfid-20080407_052605_291434_E6D354E8)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

trying to clean up the signal/noise mess. the previous code in mac80211 did
not have much definition of what units of signal and noise were provided and
used implicit mechanisms from the wireless extensions.

introduce hardware capability flags to let the hardware specify if it can
provide signal and noise level values and which units it can provide:

  IEEE80211_HW_SIGNAL_UNSPEC - unspecified, unknown, hw specific
  IEEE80211_HW_SIGNAL_DB     - dB difference to unspecified reference point
  IEEE80211_HW_SIGNAL_DBM    - dBm, difference to 1mW

  IEEE80211_HW_NOISE_DBM     - dBm, difference to 1mW

also clean up the confusing names which were used for signal, noise and qual
before.

if IEEE80211_HW_SIGNAL_UNSPEC or IEEE80211_HW_SIGNAL_DB is used the driver has
to provide the maximum value (max_signal) it reports in order for applications
to make sense of the signal values.

i tried my best to find out for each driver what it can provide and update it
but i'm not sure (?) for some of them and used the more conservative guess in
doubt. could driver authors please check and fix that up later or tell me the
correct units?

DRIVER          SIGNAL    MAX	NOISE   QUAL
-----------------------------------------------------------------
adm8211         unspec(?) 100   n/a     missing
at76_usb        unspec(?) (?)   unused  missing
ath5k           dBm             dBm     percent rssi
b43legacy       dBm             dBm     percent jssi(?)
b43             dBm             dBm     percent jssi(?)
iwl-3945        dBm             dBm     percent snr+more
iwl-4965        dBm             dBm     percent snr+more
p54             unspec    127   n/a     missing
rt2x00          dBm	        n/a     percent rssi+tx/rx frame success
  rt2400        dBm             n/a
  rt2500pci     dBm             n/a
  rt2500usb     dBm             n/a
  rt61pci       dBm             n/a
  rt73usb       dBm             n/a
rtl8180         unspec(?) 65    n/a     (?)
rtl8187         unspec(?) 65    (?)     noise(?)
zd1211          dB(?)     100   n/a     percent

drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/adm8211.c              |    7 ++--
 drivers/net/wireless/at76_usb.c             |    5 ++-
 drivers/net/wireless/ath5k/base.c           |   23 +++----------
 drivers/net/wireless/b43/main.c             |    8 ++---
 drivers/net/wireless/b43/xmit.c             |    5 +--
 drivers/net/wireless/b43legacy/main.c       |    7 ++--
 drivers/net/wireless/b43legacy/xmit.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   18 +++++-----
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   12 +++----
 drivers/net/wireless/iwlwifi/iwl-core.c     |   16 ++-------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 ++-------
 drivers/net/wireless/p54common.c            |    7 ++--
 drivers/net/wireless/rt2x00/rt2400pci.c     |    5 +--
 drivers/net/wireless/rt2x00/rt2500pci.c     |    6 ++-
 drivers/net/wireless/rt2x00/rt2500usb.c     |    6 ++-
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    4 +-
 drivers/net/wireless/rt2x00/rt61pci.c       |    5 +--
 drivers/net/wireless/rt2x00/rt73usb.c       |    5 +--
 drivers/net/wireless/rtl8180_dev.c          |    9 +++--
 drivers/net/wireless/rtl8187_dev.c          |   10 +++---
 drivers/net/wireless/zd1211rw/zd_mac.c      |   12 +++----
 include/net/mac80211.h                      |   47 ++++++++++++++++++++-------
 net/ieee80211/ieee80211_rx.c                |    2 +
 net/mac80211/debugfs_sta.c                  |    2 +
 net/mac80211/ieee80211.c                    |   10 +++---
 net/mac80211/ieee80211_i.h                  |    2 +
 net/mac80211/ieee80211_ioctl.c              |   28 +++++++++++-----
 net/mac80211/ieee80211_sta.c                |   12 +++----
 net/mac80211/rx.c                           |    4 +-
 net/mac80211/sta_info.h                     |    2 +
 30 files changed, 151 insertions(+), 147 deletions(-)


diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 2e257ee..f5518f8 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -446,9 +446,9 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 			struct ieee80211_rx_status rx_status = {0};
 
 			if (priv->pdev->revision < ADM8211_REV_CA)
-				rx_status.ssi = rssi;
+				rx_status.signal = rssi;
 			else
-				rx_status.ssi = 100 - rssi;
+				rx_status.signal = 100 - rssi;
 
 			rx_status.rate_idx = rate;
 
@@ -1901,9 +1901,10 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 
 	dev->extra_tx_headroom = sizeof(struct adm8211_tx_hdr);
 	/* dev->flags = IEEE80211_HW_RX_INCLUDES_FCS in promisc mode */
+	dev->flags = IEEE80211_HW_SIGNAL_UNSPEC;
 
 	dev->channel_change_time = 1000;
-	dev->max_rssi = 100;	/* FIXME: find better value */
+	dev->max_signal = 100;    /* FIXME: find better value */
 
 	dev->queues = 1; /* ADM8211C supports more, maybe ADM8211B too */
 
diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 33fa026..009f8a7 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1599,7 +1599,7 @@ static void at76_rx_tasklet(unsigned long param)
 	at76_dbg_dump(DBG_RX_DATA, priv->rx_skb->data,
 		      priv->rx_skb->len, "RX: len=%d", priv->rx_skb->len);
 
-	rx_status.ssi = buf->rssi;
+	rx_status.signal = buf->rssi;
 	rx_status.flag |= RX_FLAG_DECRYPTED;
 	rx_status.flag |= RX_FLAG_IV_STRIPPED;
 
@@ -2273,7 +2273,8 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	/* mac80211 initialisation */
 	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &at76_supported_band;
-	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS;
+	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+			  IEEE80211_HW_SIGNAL_UNSPEC;
 
 	SET_IEEE80211_DEV(priv->hw, &interface->dev);
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 8862d24..339fbe1 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -461,13 +461,11 @@ ath5k_pci_probe(struct pci_dev *pdev,
 
 	/* Initialize driver private data */
 	SET_IEEE80211_DEV(hw, &pdev->dev);
-	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS;
+	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+		    IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_NOISE_DBM;
 	hw->extra_tx_headroom = 2;
 	hw->channel_change_time = 5000;
-	/* these names are misleading */
-	hw->max_rssi = -110; /* signal in dBm */
-	hw->max_noise = -110; /* noise in dBm */
-	hw->max_signal = 100; /* we will provide a percentage based on rssi */
 	sc = hw->priv;
 	sc->hw = hw;
 	sc->pdev = pdev;
@@ -1896,20 +1894,9 @@ accept:
 		rxs.freq = sc->curchan->center_freq;
 		rxs.band = sc->curband->band;
 
-		/*
-		 * signal quality:
-		 * the names here are misleading and the usage of these
-		 * values by iwconfig makes it even worse
-		 */
-		/* noise floor in dBm, from the last noise calibration */
 		rxs.noise = sc->ah->ah_noise_floor;
-		/* signal level in dBm */
-		rxs.ssi = rxs.noise + rs.rs_rssi;
-		/*
-		 * "signal" is actually displayed as Link Quality by iwconfig
-		 * we provide a percentage based on rssi (assuming max rssi 64)
-		 */
-		rxs.signal = rs.rs_rssi * 100 / 64;
+		rxs.signal = rxs.noise + rs.rs_rssi;
+		rxs.qual = rs.rs_rssi * 100 / 64;
 
 		rxs.antenna = rs.rs_antenna;
 		rxs.rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index a4e6a59..e86cd57 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4301,10 +4301,10 @@ static int b43_wireless_init(struct ssb_device *dev)
 
 	/* fill hw info */
 	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-		    IEEE80211_HW_RX_INCLUDES_FCS;
-	hw->max_signal = 100;
-	hw->max_rssi = -110;
-	hw->max_noise = -110;
+		    IEEE80211_HW_RX_INCLUDES_FCS |
+		    IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_NOISE_DBM;
+
 	hw->queues = b43_modparam_qos ? 4 : 1;
 	SET_IEEE80211_DEV(hw, dev->dev);
 	if (is_valid_ether_addr(sprom->et1mac))
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index ec10a8e..1c8f8e1 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -574,13 +574,12 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		}
 	}
 
-	status.ssi = b43_rssi_postprocess(dev, jssi,
+	status.signal = b43_rssi_postprocess(dev, jssi,
 					  (phystat0 & B43_RX_PHYST0_OFDM),
 					  (phystat0 & B43_RX_PHYST0_GAINCTL),
 					  (phystat3 & B43_RX_PHYST3_TRSTATE));
 	status.noise = dev->stats.link_noise;
-	/* the next line looks wrong, but is what mac80211 wants */
-	status.signal = (jssi * 100) / B43_RX_MAX_SSI;
+	status.qual = (jssi * 100) / B43_RX_MAX_SSI;
 	if (phystat0 & B43_RX_PHYST0_OFDM)
 		status.rate_idx = b43_plcp_get_bitrate_idx_ofdm(plcp,
 						phytype == B43_PHYTYPE_A);
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index f518e79..5f95ef2 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3689,10 +3689,9 @@ static int b43legacy_wireless_init(struct ssb_device *dev)
 
 	/* fill hw info */
 	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-		    IEEE80211_HW_RX_INCLUDES_FCS;
-	hw->max_signal = 100;
-	hw->max_rssi = -110;
-	hw->max_noise = -110;
+		    IEEE80211_HW_RX_INCLUDES_FCS |
+		    IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_NOISE_DBM;
 	hw->queues = 1; /* FIXME: hardware has more queues */
 	SET_IEEE80211_DEV(hw, dev->dev);
 	if (is_valid_ether_addr(sprom->et1mac))
diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index dcad249..906a087 100644
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -532,12 +532,12 @@ void b43legacy_rx(struct b43legacy_wldev *dev,
 		}
 	}
 
-	status.ssi = b43legacy_rssi_postprocess(dev, jssi,
+	status.signal = b43legacy_rssi_postprocess(dev, jssi,
 				      (phystat0 & B43legacy_RX_PHYST0_OFDM),
 				      (phystat0 & B43legacy_RX_PHYST0_GAINCTL),
 				      (phystat3 & B43legacy_RX_PHYST3_TRSTATE));
 	status.noise = dev->stats.link_noise;
-	status.signal = (jssi * 100) / B43legacy_RX_MAX_SSI;
+	status.qual = (jssi * 100) / B43legacy_RX_MAX_SSI;
 	/* change to support A PHY */
 	if (phystat0 & B43legacy_RX_PHYST0_OFDM)
 		status.rate_idx = b43legacy_plcp_get_bitrate_idx_ofdm(plcp, false);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index eb30819..f1fa81d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -520,7 +520,7 @@ static void iwl3945_add_radiotap(struct iwl3945_priv *priv,
 {
 	/* First cache any information we need before we overwrite
 	 * the information provided in the skb from the hardware */
-	s8 signal = stats->ssi;
+	s8 signal = stats->signal;
 	s8 noise = 0;
 	int rate = stats->rate_idx;
 	u64 tsf = stats->mactime;
@@ -697,7 +697,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	}
 
 	/* Convert 3945's rssi indicator to dBm */
-	rx_status.ssi = rx_stats->rssi - IWL_RSSI_OFFSET;
+	rx_status.signal = rx_stats->rssi - IWL_RSSI_OFFSET;
 
 	/* Set default noise value to -127 */
 	if (priv->last_rx_noise == 0)
@@ -716,21 +716,21 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	 * Calculate rx_status.signal (quality indicator in %) based on SNR. */
 	if (rx_stats_noise_diff) {
 		snr = rx_stats_sig_avg / rx_stats_noise_diff;
-		rx_status.noise = rx_status.ssi -
+		rx_status.noise = rx_status.signal -
 					iwl3945_calc_db_from_ratio(snr);
-		rx_status.signal = iwl3945_calc_sig_qual(rx_status.ssi,
+		rx_status.qual = iwl3945_calc_sig_qual(rx_status.signal,
 							 rx_status.noise);
 
 	/* If noise info not available, calculate signal quality indicator (%)
 	 *   using just the dBm signal level. */
 	} else {
 		rx_status.noise = priv->last_rx_noise;
-		rx_status.signal = iwl3945_calc_sig_qual(rx_status.ssi, 0);
+		rx_status.qual = iwl3945_calc_sig_qual(rx_status.signal, 0);
 	}
 
 
 	IWL_DEBUG_STATS("Rssi %d noise %d qual %d sig_avg %d noise_diff %d\n",
-			rx_status.ssi, rx_status.noise, rx_status.signal,
+			rx_status.signal, rx_status.noise, rx_status.qual,
 			rx_stats_sig_avg, rx_stats_noise_diff);
 
 	header = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
@@ -740,8 +740,8 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	IWL_DEBUG_STATS_LIMIT("[%c] %d RSSI:%d Signal:%u, Noise:%u, Rate:%u\n",
 			      network_packet ? '*' : ' ',
 			      le16_to_cpu(rx_hdr->channel),
-			      rx_status.ssi, rx_status.ssi,
-			      rx_status.ssi, rx_status.rate_idx);
+			      rx_status.signal, rx_status.signal,
+			      rx_status.noise, rx_status.rate_idx);
 
 #ifdef CONFIG_IWL3945_DEBUG
 	if (iwl3945_debug_level & (IWL_DL_RX))
@@ -752,7 +752,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	if (network_packet) {
 		priv->last_beacon_time = le32_to_cpu(rx_end->beacon_timestamp);
 		priv->last_tsf = le64_to_cpu(rx_end->timestamp);
-		priv->last_rx_rssi = rx_status.ssi;
+		priv->last_rx_rssi = rx_status.signal;
 		priv->last_rx_noise = rx_status.noise;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 89d600c..d35385e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3292,7 +3292,7 @@ static void iwl4965_add_radiotap(struct iwl_priv *priv,
 				 struct ieee80211_rx_status *stats,
 				 u32 ampdu_status)
 {
-	s8 signal = stats->ssi;
+	s8 signal = stats->signal;
 	s8 noise = 0;
 	int rate = stats->rate_idx;
 	u64 tsf = stats->mactime;
@@ -3945,7 +3945,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	priv->ucode_beacon_time = le32_to_cpu(rx_start->beacon_time_stamp);
 
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
-	rx_status.ssi = iwl4965_calc_rssi(rx_start);
+	rx_status.signal = iwl4965_calc_rssi(rx_start);
 
 	/* Meaningful noise values are available only from beacon statistics,
 	 *   which are gathered only when associated, and indicate noise
@@ -3954,11 +3954,11 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	if (iwl4965_is_associated(priv) &&
 	    !test_bit(STATUS_SCANNING, &priv->status)) {
 		rx_status.noise = priv->last_rx_noise;
-		rx_status.signal = iwl4965_calc_sig_qual(rx_status.ssi,
+		rx_status.qual = iwl4965_calc_sig_qual(rx_status.signal,
 							 rx_status.noise);
 	} else {
 		rx_status.noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-		rx_status.signal = iwl4965_calc_sig_qual(rx_status.ssi, 0);
+		rx_status.qual = iwl4965_calc_sig_qual(rx_status.signal, 0);
 	}
 
 	/* Reset beacon noise level if not associated. */
@@ -3970,12 +3970,12 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	iwl4965_dbg_report_frame(priv, pkt, header, 1);
 
 	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
-			      rx_status.ssi, rx_status.noise, rx_status.signal,
+			      rx_status.signal, rx_status.noise, rx_status.qual,
 			      (unsigned long long)rx_status.mactime);
 
 	network_packet = iwl4965_is_network_packet(priv, header);
 	if (network_packet) {
-		priv->last_rx_rssi = rx_status.ssi;
+		priv->last_rx_rssi = rx_status.signal;
 		priv->last_beacon_time =  priv->ucode_beacon_time;
 		priv->last_tsf = le64_to_cpu(rx_start->timestamp);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 49fb52f..277219f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -221,18 +221,10 @@ static void iwlcore_init_hw(struct iwl_priv *priv)
 	struct ieee80211_hw *hw = priv->hw;
 	hw->rate_control_algorithm = "iwl-4965-rs";
 
-	/* Tell mac80211 and its clients (e.g. Wireless Extensions)
-	 *	 the range of signal quality values that we'll provide.
-	 * Negative values for level/noise indicate that we'll provide dBm.
-	 * For WE, at least, non-0 values here *enable* display of values
-	 *	 in app (iwconfig). */
-	hw->max_rssi = -20; /* signal level, negative indicates dBm */
-	hw->max_noise = -20;	/* noise level, negative indicates dBm */
-	hw->max_signal = 100;	/* link quality indication (%) */
-
-	/* Tell mac80211 our Tx characteristics */
-	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
-
+	/* Tell mac80211 our characteristics */
+	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
+		    IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_NOISE_DBM;
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
 #ifdef CONFIG_IWL4965_HT
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 51480a4..13a1b35 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8007,17 +8007,10 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	priv->ibss_beacon = NULL;
 
-	/* Tell mac80211 and its clients (e.g. Wireless Extensions)
-	 *   the range of signal quality values that we'll provide.
-	 * Negative values for level/noise indicate that we'll provide dBm.
-	 * For WE, at least, non-0 values here *enable* display of values
-	 *   in app (iwconfig). */
-	hw->max_rssi = -20;	/* signal level, negative indicates dBm */
-	hw->max_noise = -20;	/* noise level, negative indicates dBm */
-	hw->max_signal = 100;	/* link quality indication (%) */
-
-	/* Tell mac80211 our Tx characteristics */
-	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
+	/* Tell mac80211 our characteristics */
+	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
+		    IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_NOISE_DBM;
 
 	/* 4 EDCA QOS priorities */
 	hw->queues = 4;
diff --git a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
index 63f9bad..2c131da 100644
--- a/drivers/net/wireless/p54common.c
+++ b/drivers/net/wireless/p54common.c
@@ -355,7 +355,7 @@ static void p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct ieee80211_rx_status rx_status = {0};
 	u16 freq = le16_to_cpu(hdr->freq);
 
-	rx_status.ssi = hdr->rssi;
+	rx_status.signal = hdr->rssi;
 	/* XX correct? */
 	rx_status.rate_idx = hdr->rate & 0xf;
 	rx_status.freq = freq;
@@ -1004,9 +1004,10 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	skb_queue_head_init(&priv->tx_queue);
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
-		    IEEE80211_HW_RX_INCLUDES_FCS;
+		     IEEE80211_HW_RX_INCLUDES_FCS |
+		     IEEE80211_HW_SIGNAL_UNSPEC;
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
-	dev->max_rssi = 127;
+	dev->max_signal = 127;
 
 	priv->tx_stats.data[0].limit = 5;
 	dev->queues = 1;
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index b41187a..e659caa 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1364,10 +1364,9 @@ static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 */
-	rt2x00dev->hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
+	rt2x00dev->hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+			       IEEE80211_HW_SIGNAL_DBM;
 	rt2x00dev->hw->extra_tx_headroom = 0;
-	rt2x00dev->hw->max_signal = MAX_SIGNAL;
-	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->queues = 2;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_pci(rt2x00dev)->dev);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5ade097..8ab8476 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1684,10 +1684,10 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 */
-	rt2x00dev->hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
+	rt2x00dev->hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+			       IEEE80211_HW_SIGNAL_DBM;
+
 	rt2x00dev->hw->extra_tx_headroom = 0;
-	rt2x00dev->hw->max_signal = MAX_SIGNAL;
-	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->queues = 2;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_pci(rt2x00dev)->dev);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 6bb07b3..a2264ea 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1587,10 +1587,10 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 	    IEEE80211_HW_RX_INCLUDES_FCS |
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
+	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+	    IEEE80211_HW_SIGNAL_DBM;
+
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
-	rt2x00dev->hw->max_signal = MAX_SIGNAL;
-	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->queues = 2;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_usb(rt2x00dev)->dev);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 50ea7bd..8bd7071 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -613,9 +613,9 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	rt2x00dev->link.qual.rx_success++;
 
 	rx_status->rate_idx = idx;
-	rx_status->signal =
+	rx_status->qual =
 	    rt2x00lib_calculate_link_signal(rt2x00dev, rxdesc->rssi);
-	rx_status->ssi = rxdesc->rssi;
+	rx_status->signal = rxdesc->rssi;
 	rx_status->flag = rxdesc->flags;
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 1cb056b..e20d32f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2249,10 +2249,9 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
+	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+	    IEEE80211_HW_SIGNAL_DBM;
 	rt2x00dev->hw->extra_tx_headroom = 0;
-	rt2x00dev->hw->max_signal = MAX_SIGNAL;
-	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->queues = 4;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_pci(rt2x00dev)->dev);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index a9efe25..98693cd 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1831,10 +1831,9 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
+	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+	    IEEE80211_HW_SIGNAL_DBM;
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
-	rt2x00dev->hw->max_signal = MAX_SIGNAL;
-	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->queues = 4;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_usb(rt2x00dev)->dev);
diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index c181f23..c220998 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -132,8 +132,8 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 
 			rx_status.antenna = (flags2 >> 15) & 1;
 			/* TODO: improve signal/rssi reporting */
-			rx_status.signal = flags2 & 0xFF;
-			rx_status.ssi = (flags2 >> 8) & 0x7F;
+			rx_status.qual = flags2 & 0xFF;
+			rx_status.signal = (flags2 >> 8) & 0x7F;
 			/* XXX: is this correct? */
 			rx_status.rate_idx = (flags >> 20) & 0xF;
 			rx_status.freq = dev->conf.channel->center_freq;
@@ -894,9 +894,10 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
 
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		     IEEE80211_HW_RX_INCLUDES_FCS;
+		     IEEE80211_HW_RX_INCLUDES_FCS |
+		     IEEE80211_HW_SIGNAL_UNSPEC;
 	dev->queues = 1;
-	dev->max_rssi = 65;
+	dev->max_signal = 65;
 
 	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
 	reg &= RTL818X_TX_CONF_HWVER_MASK;
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index c03834d..9bd5c08 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -261,8 +261,8 @@ static void rtl8187_rx_cb(struct urb *urb)
 	}
 
 	rx_status.antenna = (hdr->signal >> 7) & 1;
-	rx_status.signal = 64 - min(hdr->noise, (u8)64);
-	rx_status.ssi = signal;
+	rx_status.qual = 64 - min(hdr->noise, (u8)64);
+	rx_status.signal = signal;
 	rx_status.rate_idx = rate;
 	rx_status.freq = dev->conf.channel->center_freq;
 	rx_status.band = dev->conf.channel->band;
@@ -737,11 +737,11 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		     IEEE80211_HW_RX_INCLUDES_FCS;
+		     IEEE80211_HW_RX_INCLUDES_FCS |
+		     IEEE80211_HW_SIGNAL_UNSPEC;
 	dev->extra_tx_headroom = sizeof(struct rtl8187_tx_hdr);
 	dev->queues = 1;
-	dev->max_rssi = 65;
-	dev->max_signal = 64;
+	dev->max_signal = 65;
 
 	eeprom.data = dev;
 	eeprom.register_read = rtl8187_eeprom_register_read;
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 69c45ca..6286eb2 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -638,7 +638,7 @@ static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
 
 			memset(&status, 0, sizeof(status));
 			status.flags = IEEE80211_TX_STATUS_ACK;
-			status.ack_signal = stats->ssi;
+			status.ack_signal = stats->signal;
 			__skb_unlink(skb, q);
 			tx_status(hw, skb, &status, 1);
 			goto out;
@@ -691,8 +691,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 
 	stats.freq = zd_channels[_zd_chip_get_channel(&mac->chip) - 1].center_freq;
 	stats.band = IEEE80211_BAND_2GHZ;
-	stats.ssi = status->signal_strength;
-	stats.signal = zd_rx_qual_percent(buffer,
+	stats.signal = status->signal_strength;
+	stats.qual = zd_rx_qual_percent(buffer,
 		                          length - sizeof(struct rx_status),
 		                          status);
 
@@ -982,10 +982,10 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &mac->band;
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
-	hw->max_rssi = 100;
-	hw->max_signal = 100;
+		    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
+		    IEEE80211_HW_SIGNAL_DB;
 
+	hw->max_signal = 100;
 	hw->queues = 1;
 	hw->extra_tx_headroom = sizeof(struct zd_ctrlset);
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 48428a6..e913a7e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -329,13 +329,16 @@ enum mac80211_rx_flags {
  * The low-level driver should provide this information (the subset
  * supported by hardware) to the 802.11 code with each received
  * frame.
+ *
  * @mactime: value in microseconds of the 64-bit Time Synchronization Function
  * 	(TSF) timer when the first data symbol (MPDU) arrived at the hardware.
  * @band: the active band when this frame was received
  * @freq: frequency the radio was tuned to when receiving this frame, in MHz
- * @ssi: signal strength when receiving this frame
- * @signal: used as 'qual' in statistics reporting
- * @noise: PHY noise when receiving this frame
+ * @signal: signal strength when receiving this frame, either in dBm, in dB or
+ *	unspecified depending on the hardware capabilities flags
+ *	@IEEE80211_HW_SIGNAL_*
+ * @noise: noise when receiving this frame, in dBm.
+ * @qual: overall signal quality indication, in percent (0-100).
  * @antenna: antenna used
  * @rate_idx: index of data rate into band's supported rates
  * @flag: %RX_FLAG_*
@@ -344,9 +347,9 @@ struct ieee80211_rx_status {
 	u64 mactime;
 	enum ieee80211_band band;
 	int freq;
-	int ssi;
 	int signal;
 	int noise;
+	int qual;
 	int antenna;
 	int rate_idx;
 	int flag;
@@ -385,7 +388,8 @@ enum ieee80211_tx_status_flags {
  * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
  * @ampdu_ack_map: block ack bit map for the aggregation.
  * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
- * @ack_signal: signal strength of the ACK frame
+ * @ack_signal: signal strength of the ACK frame either in dBm, dB or unspec
+ *	depending on hardware capabilites flags @IEEE80211_HW_SIGNAL_*
  * @queue_length: ?? REMOVE
  * @queue_number: ?? REMOVE
  */
@@ -697,6 +701,25 @@ enum ieee80211_tkip_key_type {
  * @IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE:
  *	Hardware is not capable of receiving frames with short preamble on
  *	the 2.4 GHz band.
+ *
+ * @IEEE80211_HW_SIGNAL_UNSPEC:
+ *	Hardware can provide signal values but we don't know its units. We
+ *	expect values between 0 and @max_signal.
+ *	If possible please provide dB or dBm instead.
+ *
+ * @IEEE80211_HW_SIGNAL_DB:
+ *	Hardware gives signal values in dB, decibel difference from an
+ *	arbitrary, fixed reference. We expect values between 0 and @max_signal.
+ *	If possible please provide dBm instead.
+ *
+ * @IEEE80211_HW_SIGNAL_DBM:
+ *	Hardware gives signal values in dBm, decibel difference from
+ *	one milliwatt. This is the preferred method since it is standardized
+ *	between different devices. @max_signal does not need to be set.
+ *
+ * @IEEE80211_HW_NOISE_DBM:
+ *	Hardware can provide noise (radio interference) values in units dBm,
+ *      decibel difference from one milliwatt.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE		= 1<<0,
@@ -704,6 +727,10 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
 	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE		= 1<<3,
 	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE	= 1<<4,
+	IEEE80211_HW_SIGNAL_UNSPEC			= 1<<5,
+	IEEE80211_HW_SIGNAL_DB				= 1<<6,
+	IEEE80211_HW_SIGNAL_DBM				= 1<<7,
+	IEEE80211_HW_NOISE_DBM				= 1<<8,
 };
 
 /**
@@ -734,12 +761,8 @@ enum ieee80211_hw_flags {
  *
  * @channel_change_time: time (in microseconds) it takes to change channels.
  *
- * @max_rssi: Maximum value for ssi in RX information, use
- *	negative numbers for dBm and 0 to indicate no support.
- *
- * @max_signal: like @max_rssi, but for the signal value.
- *
- * @max_noise: like @max_rssi, but for the noise value.
+ * @max_signal: Maximum value for signal (rssi) in RX information, used
+ *     only when @IEEE80211_HW_SIGNAL_UNSPEC or @IEEE80211_HW_SIGNAL_DB
  *
  * @queues: number of available hardware transmit queues for
  *	data packets. WMM/QoS requires at least four.
@@ -762,9 +785,7 @@ struct ieee80211_hw {
 	int channel_change_time;
 	int vif_data_size;
 	u8 queues;
-	s8 max_rssi;
 	s8 max_signal;
-	s8 max_noise;
 };
 
 /**
diff --git a/net/ieee80211/ieee80211_rx.c b/net/ieee80211/ieee80211_rx.c
index 1e3f87c..c5d7e4c 100644
--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -385,7 +385,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 		wstats.updated = 0;
 		if (rx_stats->mask & IEEE80211_STATMASK_RSSI) {
-			wstats.level = rx_stats->rssi;
+			wstats.level = rx_stats->signal;
 			wstats.updated |= IW_QUAL_LEVEL_UPDATED;
 		} else
 			wstats.updated |= IW_QUAL_LEVEL_INVALID;
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 256ea88..e3443f3 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -63,8 +63,8 @@ STA_FILE(tx_fragments, tx_fragments, LU);
 STA_FILE(tx_filtered, tx_filtered_count, LU);
 STA_FILE(tx_retry_failed, tx_retry_failed, LU);
 STA_FILE(tx_retry_count, tx_retry_count, LU);
-STA_FILE(last_rssi, last_rssi, D);
 STA_FILE(last_signal, last_signal, D);
+STA_FILE(last_qual, last_qual, D);
 STA_FILE(last_noise, last_noise, D);
 STA_FILE(channel_use, channel_use, D);
 STA_FILE(wep_weak_iv_count, wep_weak_iv_count, LU);
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index aaa5480..a45777d 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1675,13 +1675,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	local->hw.conf.beacon_int = 1000;
 
-	local->wstats_flags |= local->hw.max_rssi ?
-			       IW_QUAL_LEVEL_UPDATED : IW_QUAL_LEVEL_INVALID;
-	local->wstats_flags |= local->hw.max_signal ?
+	local->wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
+						  IEEE80211_HW_SIGNAL_DB |
+						  IEEE80211_HW_SIGNAL_DBM) ?
 			       IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
-	local->wstats_flags |= local->hw.max_noise ?
+	local->wstats_flags |= local->hw.flags & IEEE80211_HW_NOISE_DBM ?
 			       IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
-	if (local->hw.max_rssi < 0 || local->hw.max_noise < 0)
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		local->wstats_flags |= IW_QUAL_DBM;
 
 	result = sta_info_start(local);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6c62dd4..e3bbb5e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -90,7 +90,7 @@ struct ieee80211_sta_bss {
 	u16 capability; /* host byte order */
 	enum ieee80211_band band;
 	int freq;
-	int rssi, signal, noise;
+	int signal, noise, qual;
 	u8 *wpa_ie;
 	size_t wpa_ie_len;
 	u8 *rsn_ie;
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index b047eeb..96d04d9 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -155,14 +155,26 @@ static int ieee80211_ioctl_giwrange(struct net_device *dev,
 	range->num_encoding_sizes = 2;
 	range->max_encoding_tokens = NUM_DEFAULT_KEYS;
 
-	range->max_qual.qual = local->hw.max_signal;
-	range->max_qual.level = local->hw.max_rssi;
-	range->max_qual.noise = local->hw.max_noise;
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC ||
+	    local->hw.flags & IEEE80211_HW_SIGNAL_DB)
+		range->max_qual.level = local->hw.max_signal;
+	else if  (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+		range->max_qual.level = -110;
+	else
+		range->max_qual.level = 0;
+
+	if (local->hw.flags & IEEE80211_HW_NOISE_DBM)
+		range->max_qual.noise = -110;
+	else
+		range->max_qual.noise = 0;
+
+	range->max_qual.qual = 100;
 	range->max_qual.updated = local->wstats_flags;
 
-	range->avg_qual.qual = local->hw.max_signal/2;
-	range->avg_qual.level = 0;
-	range->avg_qual.noise = 0;
+	range->avg_qual.qual = 50;
+	/* not always true but better than nothing */
+	range->avg_qual.level = range->max_qual.level / 2;
+	range->avg_qual.noise = range->max_qual.noise / 2;
 	range->avg_qual.updated = local->wstats_flags;
 
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
@@ -971,8 +983,8 @@ static struct iw_statistics *ieee80211_get_wireless_stats(struct net_device *dev
 		wstats->qual.noise = 0;
 		wstats->qual.updated = IW_QUAL_ALL_INVALID;
 	} else {
-		wstats->qual.level = sta->last_rssi;
-		wstats->qual.qual = sta->last_signal;
+		wstats->qual.level = sta->last_signal;
+		wstats->qual.qual = sta->last_qual;
 		wstats->qual.noise = sta->last_noise;
 		wstats->qual.updated = local->wstats_flags;
 	}
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index c20ef89..6bfe938 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1930,8 +1930,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 					   local->hw.conf.channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
-			sta->last_rssi = bss->rssi;
 			sta->last_signal = bss->signal;
+			sta->last_qual = bss->qual;
 			sta->last_noise = bss->noise;
 			ieee80211_rx_bss_put(dev, bss);
 		}
@@ -2662,9 +2662,9 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 
 	bss->timestamp = beacon_timestamp;
 	bss->last_update = jiffies;
-	bss->rssi = rx_status->ssi;
 	bss->signal = rx_status->signal;
 	bss->noise = rx_status->noise;
+	bss->qual = rx_status->qual;
 	if (!beacon)
 		bss->probe_resp++;
 
@@ -3369,9 +3369,9 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 		    !ieee80211_sta_match_ssid(ifsta, bss->ssid, bss->ssid_len))
 			continue;
 
-		if (!selected || top_rssi < bss->rssi) {
+		if (!selected || top_rssi < bss->signal) {
 			selected = bss;
-			top_rssi = bss->rssi;
+			top_rssi = bss->signal;
 		}
 	}
 	if (selected)
@@ -4000,8 +4000,8 @@ ieee80211_sta_scan_result(struct net_device *dev,
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.qual = bss->signal;
-	iwe.u.qual.level = bss->rssi;
+	iwe.u.qual.qual = bss->qual;
+	iwe.u.qual.level = bss->signal;
 	iwe.u.qual.noise = bss->noise;
 	iwe.u.qual.updated = local->wstats_flags;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0ac6db5..58dead4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -209,7 +209,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 				cpu_to_le16(IEEE80211_CHAN_DYN |
 					    IEEE80211_CHAN_2GHZ);
 
-		rtfixed->antsignal = status->ssi;
+		rtfixed->antsignal = status->signal;
 		rthdr->it_len = cpu_to_le16(rtap_len);
 	}
 
@@ -725,8 +725,8 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
-	sta->last_rssi = rx->status->ssi;
 	sta->last_signal = rx->status->signal;
+	sta->last_qual = rx->status->qual;
 	sta->last_noise = rx->status->noise;
 
 	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ebb7b2b..758e947 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -217,8 +217,8 @@ struct sta_info {
 				       * from this STA */
 	unsigned long rx_fragments; /* number of received MPDUs */
 	unsigned long rx_dropped; /* number of dropped MPDUs from this STA */
-	int last_rssi; /* RSSI of last received frame from this STA */
 	int last_signal; /* signal of last received frame from this STA */
+	int last_qual;  /* qual of last received frame from this STA */
 	int last_noise; /* noise of last received frame from this STA */
 	/* last received seq/frag number from this STA (per RX queue) */
 	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];

