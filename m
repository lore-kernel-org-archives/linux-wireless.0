Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:49981 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYCHM1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Mar 2008 07:27:50 -0500
From: bruno randolf <bruno@thinktube.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH] mac80211: use hardware flags for signal/noise units
Date: Sat, 8 Mar 2008 21:01:24 +0900
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net, jbenc@suse.cz, mcgrof@gmail.com,
	jirislaby@gmail.com, mickflemm@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803082101.24424.bruno@thinktube.com> (sfid-20080308_122758_161139_2C410540)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RFC: trying to clean up the signal/noise mess - what do you think? 
(yep, my mailer probably messed up the linebreaks)

    mac80211: use hardware flags for signal/noise units

    introduce hardware capability flags to let the hardware specify if it can
    provide signal and noise quality readings and which units it can provide:
    
    	IEEE80211_HW_SIGNAL_UNITLESS
    	IEEE80211_HW_SIGNAL_DB
    	IEEE80211_HW_SIGNAL_DBM
    	IEEE80211_HW_NOISE_DBM
    
    also clean up the really misleading and confusing names which were used
    for signal, noise and qual before.
    
    i tried my best to find out for each driver what it can provide but i'm 
    not sure (?) for some of them. could driver authors please check? seems we
    are doing good, most drivers seem to have dBm....
    
    DRIVER		SIGNAL	NOISE	QUAL
    
    ath5k           dBm     dBm     percent rssi
    b43legacy       dBm(?)  dBm     percent jssi(?)
    b43             dBm(?)  dBm     percent jssi(?)
    iwl-3945        dBm     dBm     percent snr+more
    iwl-4965        dBm     dBm     percent snr+more
    rt2x00          dBm(?)  n/a     percent rssi+tx/rx frame success
      rt2400        dBm(?)  n/a
      rt2500pci     dBm(?)  n/a
      rt2500usb     dBm(?)  n/a
      rt61pci       dBm(?)  n/a
      rt73usb       dBm(?)  n/a
    rtl8180		nounit	n/a    (?)
    rtl8187		nounit	(?)    (?)
    zd1211		dB(?)	/      percent

diff --git a/drivers/net/wireless/ath5k/base.c 
b/drivers/net/wireless/ath5k/base.c
index b5c0a0d..538c815 100644
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
@@ -1893,20 +1891,9 @@ accept:
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
index 694e295..3cd0f1a 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4303,10 +4303,10 @@ static int b43_wireless_init(struct ssb_device *dev)
 
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
@@ -574,13 +574,12 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, 
const void *_rxhdr)
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
diff --git a/drivers/net/wireless/b43legacy/main.c 
b/drivers/net/wireless/b43legacy/main.c
index f518e79..5f95ef2 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3689,10 +3689,9 @@ static int b43legacy_wireless_init(struct ssb_device 
*dev)
 
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
diff --git a/drivers/net/wireless/b43legacy/xmit.c 
b/drivers/net/wireless/b43legacy/xmit.c
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c 
b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 50a641c..52104b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -518,7 +518,7 @@ static void iwl3945_add_radiotap(struct iwl3945_priv 
*priv,
 {
 	/* First cache any information we need before we overwrite
 	 * the information provided in the skb from the hardware */
-	s8 signal = stats->ssi;
+	s8 signal = stats->signal;
 	s8 noise = 0;
 	int rate = stats->rate_idx;
 	u64 tsf = stats->mactime;
@@ -691,7 +691,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	}
 
 	/* Convert 3945's rssi indicator to dBm */
-	rx_status.ssi = rx_stats->rssi - IWL_RSSI_OFFSET;
+	rx_status.signal = rx_stats->rssi - IWL_RSSI_OFFSET;
 
 	/* Set default noise value to -127 */
 	if (priv->last_rx_noise == 0)
@@ -710,21 +710,21 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv 
*priv,
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
@@ -734,8 +734,8 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	IWL_DEBUG_STATS_LIMIT("[%c] %d RSSI:%d Signal:%u, Noise:%u, Rate:%u\n",
 			      network_packet ? '*' : ' ',
 			      le16_to_cpu(rx_hdr->channel),
-			      rx_status.ssi, rx_status.ssi,
-			      rx_status.ssi, rx_status.rate_idx);
+			      rx_status.signal, rx_status.signal,
+			      rx_status.noise, rx_status.rate_idx);
 
 #ifdef CONFIG_IWL3945_DEBUG
 	if (iwl3945_debug_level & (IWL_DL_RX))
@@ -746,7 +746,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	if (network_packet) {
 		priv->last_beacon_time = le32_to_cpu(rx_end->beacon_timestamp);
 		priv->last_tsf = le64_to_cpu(rx_end->timestamp);
-		priv->last_rx_rssi = rx_status.ssi;
+		priv->last_rx_rssi = rx_status.signal;
 		priv->last_rx_noise = rx_status.noise;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c 
b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2f01a49..13aceb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3238,7 +3238,7 @@ static void iwl4965_add_radiotap(struct iwl4965_priv 
*priv,
 				 struct ieee80211_rx_status *stats,
 				 u32 ampdu_status)
 {
-	s8 signal = stats->ssi;
+	s8 signal = stats->signal;
 	s8 noise = 0;
 	int rate = stats->rate_idx;
 	u64 tsf = stats->mactime;
@@ -3820,7 +3820,7 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv 
*priv,
 	priv->ucode_beacon_time = le32_to_cpu(rx_start->beacon_time_stamp);
 
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
-	rx_status.ssi = iwl4965_calc_rssi(rx_start);
+	rx_status.signal = iwl4965_calc_rssi(rx_start);
 
 	/* Meaningful noise values are available only from beacon statistics,
 	 *   which are gathered only when associated, and indicate noise
@@ -3829,11 +3829,11 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv 
*priv,
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
@@ -3845,12 +3845,12 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv 
*priv,
 	iwl4965_dbg_report_frame(priv, pkt, header, 1);
 
 	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
-			      rx_status.ssi, rx_status.noise, rx_status.signal,
+			      rx_status.signal, rx_status.noise, rx_status.qual,
 			      rx_status.mactime);
 
 	network_packet = iwl4965_is_network_packet(priv, header);
 	if (network_packet) {
-		priv->last_rx_rssi = rx_status.ssi;
+		priv->last_rx_rssi = rx_status.signal;
 		priv->last_beacon_time =  priv->ucode_beacon_time;
 		priv->last_tsf = le64_to_cpu(rx_start->timestamp);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c 
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ecf749c..0bf4649 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7968,17 +7968,10 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, 
const struct pci_device_id *e
 
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
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c 
b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 28c64c3..053c58a 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8626,17 +8626,10 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, 
const struct pci_device_id *e
 
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
 
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c 
b/drivers/net/wireless/rt2x00/rt2400pci.c
index 460ef2f..da6e02d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1331,10 +1331,9 @@ static void rt2400pci_probe_hw_mode(struct rt2x00_dev 
*rt2x00dev)
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
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c 
b/drivers/net/wireless/rt2x00/rt2500pci.c
index ffcd996..ce11f75 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1645,10 +1645,10 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev 
*rt2x00dev)
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
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c 
b/drivers/net/wireless/rt2x00/rt2500usb.c
index 9f59db9..ded6161 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1571,10 +1571,10 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev 
*rt2x00dev)
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
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c 
b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b3a639a..16a1948 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -604,9 +604,9 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	rt2x00dev->link.qual.rx_success++;
 
 	rx_status->rate_idx = idx;
-	rx_status->signal =
+	rx_status->qual =
 	    rt2x00lib_calculate_link_signal(rt2x00dev, rxdesc->rssi);
-	rx_status->ssi = rxdesc->rssi;
+	rx_status->signal = rxdesc->rssi;
 	rx_status->flag = rxdesc->flags;
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c 
b/drivers/net/wireless/rt2x00/rt61pci.c
index 091fe39..fef6615 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2188,10 +2188,9 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev 
*rt2x00dev)
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
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c 
b/drivers/net/wireless/rt2x00/rt73usb.c
index 6546b0d..8aa7b49 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1779,10 +1779,9 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev 
*rt2x00dev)
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
diff --git a/drivers/net/wireless/rtl8180_dev.c 
b/drivers/net/wireless/rtl8180_dev.c
index b1b3a47..d67f0be 100644
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
@@ -894,7 +894,8 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
 
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		     IEEE80211_HW_RX_INCLUDES_FCS;
+		     IEEE80211_HW_RX_INCLUDES_FCS |
+		     IEEE80211_HW_SIGNAL_UNITLESS;
 	dev->queues = 1;
 	dev->max_rssi = 65;
 
diff --git a/drivers/net/wireless/rtl8187_dev.c 
b/drivers/net/wireless/rtl8187_dev.c
index c03834d..0f37eb0 100644
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
@@ -737,7 +737,8 @@ static int __devinit rtl8187_probe(struct usb_interface 
*intf,
 
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		     IEEE80211_HW_RX_INCLUDES_FCS;
+		     IEEE80211_HW_RX_INCLUDES_FCS |
+		     IEEE80211_HW_SIGNAL_UNITLESS;
 	dev->extra_tx_headroom = sizeof(struct rtl8187_tx_hdr);
 	dev->queues = 1;
 	dev->max_rssi = 65;
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c 
b/drivers/net/wireless/zd1211rw/zd_mac.c
index 69c45ca..335f2d0 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -638,7 +638,7 @@ static int filter_ack(struct ieee80211_hw *hw, struct 
ieee80211_hdr *rx_hdr,
 
 			memset(&status, 0, sizeof(status));
 			status.flags = IEEE80211_TX_STATUS_ACK;
-			status.ack_signal = stats->ssi;
+			status.ack_signal = stats->signal;
 			__skb_unlink(skb, q);
 			tx_status(hw, skb, &status, 1);
 			goto out;
@@ -691,8 +691,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, 
unsigned int length)
 
 	stats.freq = zd_channels[_zd_chip_get_channel(&mac->chip) - 1].center_freq;
 	stats.band = IEEE80211_BAND_2GHZ;
-	stats.ssi = status->signal_strength;
-	stats.signal = zd_rx_qual_percent(buffer,
+	stats.signal = status->signal_strength;
+	stats.qual = zd_rx_qual_percent(buffer,
 		                          length - sizeof(struct rx_status),
 		                          status);
 
@@ -982,9 +982,8 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface 
*intf)
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &mac->band;
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
-	hw->max_rssi = 100;
-	hw->max_signal = 100;
+		    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
+		    IEEE80211_HW_SIGNAL_DB;
 
 	hw->queues = 1;
 	hw->extra_tx_headroom = sizeof(struct zd_ctrlset);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5ab6a35..390dddd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -329,13 +329,16 @@ enum mac80211_rx_flags {
  * The low-level driver should provide this information (the subset
  * supported by hardware) to the 802.11 code with each received
  * frame.
+ *
  * @mactime: value in microseconds of the 64-bit Time Synchronization 
Function
  * 	(TSF) timer when the first data symbol (MPDU) arrived at the hardware.
  * @band: the active band when this frame was received
  * @freq: frequency the radio was tuned to when receiving this frame, in MHz
- * @ssi: signal strength when receiving this frame
- * @signal: used as 'qual' in statistics reporting
- * @noise: PHY noise when receiving this frame
+ * @signal: signal strength when receiving this frame, either in dBm, in dB 
or
+ *	unitless depending on the hardware capabilities flags
+ *	@IEEE80211_HW_SIGNAL_*
+ * @noise: noise when receiving this frame, in dBm
+ * @qual: other signal quality indication, in percent (0-100).
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
+ * @ack_signal: signal strength of the ACK frame either in dBm, dB or 
unitless
+ *	depending on hardware capabilites flags @IEEE80211_HW_SIGNAL_*
  * @queue_length: ?? REMOVE
  * @queue_number: ?? REMOVE
  */
@@ -682,6 +686,24 @@ enum sta_notify_cmd {
  * @IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE:
  *	Hardware is not capable of receiving frames with short preamble on
  *	the 2.4 GHz band.
+ *
+ * @IEEE80211_HW_SIGNAL_UNITLESS:
+ *	Hardware can provide signal values but we don't know its units. To be
+ *	able to standardize between different devices we assume linear values
+ *	from 0-100. If possible please provide dBm instead.
+ *
+ * @IEEE80211_HW_SIGNAL_DB:
+ *	Hardware gives signal values in dB, decibel difference from an
+ *      arbitrary, fixed reference. If possible please provide dBm instead.
+ *
+ * @IEEE80211_HW_SIGNAL_DBM:
+ *	Hardware gives signal values in dBm, decibel difference from
+ *      one milliwatt. This is the only one which we can compare between
+ *	different devices.
+ *
+ * @IEEE80211_HW_NOISE_DBM:
+ *	Hardware can provide noise values. We always assume them to be in dBm,
+ *	decibel difference from one milliwatt.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE		= 1<<0,
@@ -689,6 +711,10 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
 	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE		= 1<<3,
 	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE	= 1<<4,
+	IEEE80211_HW_SIGNAL_UNITLESS			= 1<<5,
+	IEEE80211_HW_SIGNAL_DB				= 1<<6,
+	IEEE80211_HW_SIGNAL_DBM				= 1<<7,
+	IEEE80211_HW_NOISE_DBM				= 1<<8,
 };
 
 /**
@@ -719,13 +745,6 @@ enum ieee80211_hw_flags {
  *
  * @channel_change_time: time (in microseconds) it takes to change channels.
  *
- * @max_rssi: Maximum value for ssi in RX information, use
- *	negative numbers for dBm and 0 to indicate no support.
- *
- * @max_signal: like @max_rssi, but for the signal value.
- *
- * @max_noise: like @max_rssi, but for the noise value.
- *
  * @queues: number of available hardware transmit queues for
  *	data packets. WMM/QoS requires at least four.
  *
@@ -747,9 +766,6 @@ struct ieee80211_hw {
 	int channel_change_time;
 	int vif_data_size;
 	u8 queues;
-	s8 max_rssi;
-	s8 max_signal;
-	s8 max_noise;
 };
 
 /**
diff --git a/net/ieee80211/ieee80211_rx.c b/net/ieee80211/ieee80211_rx.c
index 1e3f87c..5161d95 100644
--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -385,7 +385,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct 
sk_buff *skb,
 
 		wstats.updated = 0;
 		if (rx_stats->mask & IEEE80211_STATMASK_RSSI) {
-			wstats.level = rx_stats->rssi;
+			wstats.level = rx_stats->signal;
 			wstats.updated |= IW_QUAL_LEVEL_UPDATED;
 		} else
 			wstats.updated |= IW_QUAL_LEVEL_INVALID;
@@ -397,7 +397,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct 
sk_buff *skb,
 			wstats.updated |= IW_QUAL_NOISE_INVALID;
 
 		if (rx_stats->mask & IEEE80211_STATMASK_SIGNAL) {
-			wstats.qual = rx_stats->signal;
+			wstats.qual = rx_stats->qual;
 			wstats.updated |= IW_QUAL_QUAL_UPDATED;
 		} else
 			wstats.updated |= IW_QUAL_QUAL_INVALID;
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index fc2c1a1..04216c2 100644
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
index 484b063..83e2808 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1648,13 +1648,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	local->hw.conf.beacon_int = 1000;
 
-	local->wstats_flags |= local->hw.max_rssi ?
-			       IW_QUAL_LEVEL_UPDATED : IW_QUAL_LEVEL_INVALID;
-	local->wstats_flags |= local->hw.max_signal ?
+	local->wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNITLESS |
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
index 7f10ff5..1438476 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -81,7 +81,7 @@ struct ieee80211_sta_bss {
 	u16 capability; /* host byte order */
 	enum ieee80211_band band;
 	int freq;
-	int rssi, signal, noise;
+	int signal, noise, qual;
 	u8 *wpa_ie;
 	size_t wpa_ie_len;
 	u8 *rsn_ie;
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 1d91575..22f2813 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -158,12 +158,19 @@ static int ieee80211_ioctl_giwrange(struct net_device 
*dev,
 	range->num_encoding_sizes = 2;
 	range->max_encoding_tokens = NUM_DEFAULT_KEYS;
 
-	range->max_qual.qual = local->hw.max_signal;
-	range->max_qual.level = local->hw.max_rssi;
-	range->max_qual.noise = local->hw.max_noise;
+	range->max_qual.level = 0;
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNITLESS)
+		range->max_qual.level = 100;
+	else if  (local->hw.flags & IEEE80211_HW_SIGNAL_DB)
+		 range->max_qual.level = 64;
+	else if  (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+		range->max_qual.level = -110;
+
+	range->max_qual.noise = -110;
+	range->max_qual.qual = 100;
 	range->max_qual.updated = local->wstats_flags;
 
-	range->avg_qual.qual = local->hw.max_signal/2;
+	range->avg_qual.qual = 0;
 	range->avg_qual.level = 0;
 	range->avg_qual.noise = 0;
 	range->avg_qual.updated = local->wstats_flags;
@@ -995,8 +1002,8 @@ static struct iw_statistics 
*ieee80211_get_wireless_stats(struct net_device *dev
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
index 8b991eb..80aae6e 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1842,8 +1842,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct 
ieee80211_sub_if_data *sdata,
 					   local->hw.conf.channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
-			sta->last_rssi = bss->rssi;
 			sta->last_signal = bss->signal;
+			sta->last_qual = bss->qual;
 			sta->last_noise = bss->noise;
 			ieee80211_rx_bss_put(dev, bss);
 		}
@@ -2552,9 +2552,9 @@ static void ieee80211_rx_bss_info(struct net_device 
*dev,
 
 	bss->timestamp = beacon_timestamp;
 	bss->last_update = jiffies;
-	bss->rssi = rx_status->ssi;
 	bss->signal = rx_status->signal;
 	bss->noise = rx_status->noise;
+	bss->qual = rx_status->qual;
 	if (!beacon)
 		bss->probe_resp++;
 
@@ -3259,9 +3259,9 @@ static int ieee80211_sta_config_auth(struct net_device 
*dev,
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
@@ -3919,8 +3919,8 @@ ieee80211_sta_scan_result(struct net_device *dev,
 
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
index 644d277..c1efdcf 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -209,7 +209,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct 
sk_buff *origskb,
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
index f166c80..63b0f30 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -214,8 +214,8 @@ struct sta_info {
 				       * from this STA */
 	unsigned long rx_fragments; /* number of received MPDUs */
 	unsigned long rx_dropped; /* number of dropped MPDUs from this STA */
-	int last_rssi; /* RSSI of last received frame from this STA */
 	int last_signal; /* signal of last received frame from this STA */
+	int last_qual;  /* qual of last received frame from this STA */
 	int last_noise; /* noise of last received frame from this STA */
 	/* last received seq/frag number from this STA (per RX queue) */
 	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
