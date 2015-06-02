Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40297 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbbFBTj6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 15:39:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: gregory.greenman@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: convert HW flags to unsigned long bitmap
Date: Tue,  2 Jun 2015 21:39:54 +0200
Message-Id: <1433273994-14430-1-git-send-email-johannes@sipsolutions.net> (sfid-20150602_214007_189766_F2A1FB6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As we're running out of hardware capability flags pretty quickly,
convert them to use the regular test_bit() style unsigned long
bitmaps.

This introduces a number of helper functions/macros to set and to
test the bits, along with new debugfs code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/adm8211.c                     |  8 +-
 drivers/net/wireless/at76c50x-usb.c                |  4 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |  6 +-
 drivers/net/wireless/ath/ath10k/mac.c              | 24 +++---
 drivers/net/wireless/ath/ath5k/base.c              | 12 +--
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      | 20 ++---
 drivers/net/wireless/ath/ath9k/init.c              | 24 +++---
 drivers/net/wireless/ath/carl9170/fw.c             |  2 +-
 drivers/net/wireless/ath/carl9170/main.c           | 20 ++---
 drivers/net/wireless/ath/wcn36xx/main.c            | 12 +--
 drivers/net/wireless/b43/main.c                    |  4 +-
 drivers/net/wireless/b43legacy/main.c              |  5 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  7 +-
 drivers/net/wireless/cw1200/main.c                 | 16 ++--
 drivers/net/wireless/iwlegacy/3945-mac.c           |  6 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           | 12 +--
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        | 24 +++---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c        |  4 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        | 30 +++----
 drivers/net/wireless/libertas_tf/main.c            |  2 +-
 drivers/net/wireless/mac80211_hwsim.c              | 26 +++---
 drivers/net/wireless/mwl8k.c                       |  9 +-
 drivers/net/wireless/p54/main.c                    | 12 +--
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |  7 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |  8 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |  8 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |  9 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            | 16 ++--
 drivers/net/wireless/rt2x00/rt61pci.c              |  9 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |  9 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |  9 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |  6 +-
 drivers/net/wireless/rtlwifi/base.c                | 22 +++--
 drivers/net/wireless/ti/wl1251/main.c              |  3 +-
 drivers/net/wireless/ti/wlcore/main.c              | 26 +++---
 drivers/net/wireless/zd1211rw/zd_mac.c             |  8 +-
 drivers/staging/vt6655/device_main.c               |  8 +-
 drivers/staging/vt6656/main_usb.c                  |  8 +-
 include/net/mac80211.h                             | 77 ++++++++++-------
 net/mac80211/agg-tx.c                              |  4 +-
 net/mac80211/cfg.c                                 | 10 +--
 net/mac80211/debugfs.c                             | 96 ++++++++++++----------
 net/mac80211/driver-ops.h                          |  2 +-
 net/mac80211/iface.c                               | 10 +--
 net/mac80211/key.c                                 |  4 +-
 net/mac80211/main.c                                | 14 ++--
 net/mac80211/mlme.c                                | 63 +++++++-------
 net/mac80211/offchannel.c                          |  2 +-
 net/mac80211/pm.c                                  |  4 +-
 net/mac80211/rate.c                                |  6 +-
 net/mac80211/rc80211_minstrel_ht.c                 |  2 +-
 net/mac80211/rx.c                                  | 26 +++---
 net/mac80211/scan.c                                | 10 +--
 net/mac80211/sta_info.c                            | 14 ++--
 net/mac80211/status.c                              | 13 ++-
 net/mac80211/tdls.c                                |  2 +-
 net/mac80211/tx.c                                  | 34 ++++----
 net/mac80211/util.c                                |  6 +-
 58 files changed, 433 insertions(+), 411 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 413528295d72..ad6ead9a8acb 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1369,9 +1369,9 @@ static void adm8211_configure_filter(struct ieee80211_hw *dev,
 	ADM8211_CSR_READ(NAR);
 
 	if (priv->nar & ADM8211_NAR_PR)
-		dev->flags |= IEEE80211_HW_RX_INCLUDES_FCS;
+		ieee80211_hw_set(dev, RX_INCLUDES_FCS);
 	else
-		dev->flags &= ~IEEE80211_HW_RX_INCLUDES_FCS;
+		__clear_bit(IEEE80211_HW_RX_INCLUDES_FCS, dev->flags);
 
 	if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
 		adm8211_set_bssid(dev, bcast);
@@ -1857,8 +1857,8 @@ static int adm8211_probe(struct pci_dev *pdev,
 	SET_IEEE80211_PERM_ADDR(dev, perm_addr);
 
 	dev->extra_tx_headroom = sizeof(struct adm8211_tx_hdr);
-	/* dev->flags = IEEE80211_HW_RX_INCLUDES_FCS in promisc mode */
-	dev->flags = IEEE80211_HW_SIGNAL_UNSPEC;
+	/* dev->flags = RX_INCLUDES_FCS in promisc mode */
+	ieee80211_hw_set(dev, SIGNAL_UNSPEC);
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	dev->max_signal = 100;    /* FIXME: find better value */
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 49219c508963..dab25136214a 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -2360,8 +2360,8 @@ static int at76_init_new_device(struct at76_priv *priv,
 	priv->hw->wiphy->max_scan_ie_len = 0;
 	priv->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &at76_supported_band;
-	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-			  IEEE80211_HW_SIGNAL_UNSPEC;
+	ieee80211_hw_set(priv->hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(priv->hw, SIGNAL_UNSPEC);
 	priv->hw->max_signal = 100;
 
 	SET_IEEE80211_DEV(priv->hw, &interface->dev);
diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 14937cbeca56..3b343c63aa52 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1682,9 +1682,9 @@ static int ar5523_probe(struct usb_interface *intf,
 			(id->driver_info & AR5523_FLAG_ABG) ? '5' : '2');
 
 	ar->vif = NULL;
-	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_HAS_RATE_CONTROL;
+	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
 	hw->extra_tx_headroom = sizeof(struct ar5523_tx_desc) +
 				sizeof(struct ar5523_chunk);
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index fcd08b2f8d26..b947869fc6f3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5490,16 +5490,16 @@ int ath10k_mac_register(struct ath10k *ar)
 			BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			BIT(NL80211_IFTYPE_P2P_GO);
 
-	ar->hw->flags = IEEE80211_HW_SIGNAL_DBM |
-			IEEE80211_HW_SUPPORTS_PS |
-			IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
-			IEEE80211_HW_MFP_CAPABLE |
-			IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-			IEEE80211_HW_HAS_RATE_CONTROL |
-			IEEE80211_HW_AP_LINK_PS |
-			IEEE80211_HW_SPECTRUM_MGMT |
-			IEEE80211_HW_SW_CRYPTO_CONTROL |
-			IEEE80211_HW_SUPPORT_FAST_XMIT;
+	ieee80211_hw_set(ar->hw, SUPPORT_FAST_XMIT);
+	ieee80211_hw_set(ar->hw, SW_CRYPTO_CONTROL);
+	ieee80211_hw_set(ar->hw, SPECTRUM_MGMT);
+	ieee80211_hw_set(ar->hw, AP_LINK_PS);
+	ieee80211_hw_set(ar->hw, HAS_RATE_CONTROL);
+	ieee80211_hw_set(ar->hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(ar->hw, MFP_CAPABLE);
+	ieee80211_hw_set(ar->hw, SUPPORTS_DYNAMIC_PS);
+	ieee80211_hw_set(ar->hw, SIGNAL_DBM);
+	ieee80211_hw_set(ar->hw, SUPPORTS_PS);
 
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
 
@@ -5507,8 +5507,8 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->hw->wiphy->features |= NL80211_FEATURE_DYNAMIC_SMPS;
 
 	if (ar->ht_cap_info & WMI_HT_CAP_ENABLED) {
-		ar->hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
-		ar->hw->flags |= IEEE80211_HW_TX_AMPDU_SETUP_IN_HW;
+		ieee80211_hw_set(ar->hw, AMPDU_AGGREGATION);
+		ieee80211_hw_set(ar->hw, TX_AMPDU_SETUP_IN_HW);
 	}
 
 	ar->hw->wiphy->max_scan_ssids = WLAN_SCAN_PARAMS_MAX_SSID;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a6131825c9f6..23552f43d125 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2537,12 +2537,12 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 
 	/* Initialize driver private data */
 	SET_IEEE80211_DEV(hw, ah->dev);
-	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-			IEEE80211_HW_SIGNAL_DBM |
-			IEEE80211_HW_MFP_CAPABLE |
-			IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-			IEEE80211_HW_SUPPORTS_RC_TABLE;
+	ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index d7beefe60683..bc211ce2eaf6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -717,18 +717,18 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct base_eep_header *pBase;
 
-	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_AMPDU_AGGREGATION |
-		IEEE80211_HW_SPECTRUM_MGMT |
-		IEEE80211_HW_HAS_RATE_CONTROL |
-		IEEE80211_HW_RX_INCLUDES_FCS |
-		IEEE80211_HW_PS_NULLFUNC_STACK |
-		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		IEEE80211_HW_MFP_CAPABLE |
-		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
+	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
+	ieee80211_hw_set(hw, SPECTRUM_MGMT);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 
 	if (ath9k_ps_enable)
-		hw->flags |= IEEE80211_HW_SUPPORTS_PS;
+		ieee80211_hw_set(hw, SUPPORTS_PS);
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f8d11efa7b0f..eff0e5325e6a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -796,7 +796,7 @@ static void ath9k_set_mcc_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (!ath9k_is_chanctx_enabled())
 		return;
 
-	hw->flags |= IEEE80211_HW_QUEUE_CONTROL;
+	ieee80211_hw_set(hw, QUEUE_CONTROL);
 	hw->queues = ATH9K_NUM_TX_QUEUES;
 	hw->offchannel_tx_hw_queue = hw->queues - 1;
 	hw->wiphy->interface_modes &= ~ BIT(NL80211_IFTYPE_WDS);
@@ -818,20 +818,20 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_PS_NULLFUNC_STACK |
-		IEEE80211_HW_SPECTRUM_MGMT |
-		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		IEEE80211_HW_SUPPORTS_RC_TABLE |
-		IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
+	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
+	ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, SPECTRUM_MGMT);
+	ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
 
 	if (ath9k_ps_enable)
-		hw->flags |= IEEE80211_HW_SUPPORTS_PS;
+		ieee80211_hw_set(hw, SUPPORTS_PS);
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
-		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
+		ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 
 		if (AR_SREV_9280_20_OR_LATER(ah))
 			hw->radiotap_mcs_details |=
@@ -839,7 +839,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	}
 
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || ath9k_modparam_nohwcrypt)
-		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
+		ieee80211_hw_set(hw, MFP_CAPABLE);
 
 	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR |
 			       NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE |
diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 020cd46471f5..88045f93a76c 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -286,7 +286,7 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 	}
 
 	if (SUPP(CARL9170FW_PSM) && SUPP(CARL9170FW_FIXED_5GHZ_PSM))
-		ar->hw->flags |= IEEE80211_HW_SUPPORTS_PS;
+		ieee80211_hw_set(ar->hw, SUPPORTS_PS);
 
 	if (!SUPP(CARL9170FW_USB_INIT_FIRMWARE)) {
 		dev_err(&ar->udev->dev, "firmware does not provide "
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 59db6732d4e3..170c209f99b8 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1844,22 +1844,22 @@ void *carl9170_alloc(size_t priv_size)
 	/* firmware decides which modes we support */
 	hw->wiphy->interface_modes = 0;
 
-	hw->flags |= IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_MFP_CAPABLE |
-		     IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		     IEEE80211_HW_SUPPORTS_PS |
-		     IEEE80211_HW_PS_NULLFUNC_STACK |
-		     IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC |
-		     IEEE80211_HW_SUPPORTS_RC_TABLE |
-		     IEEE80211_HW_SIGNAL_DBM |
-		     IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, SUPPORTS_PS);
+	ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(hw, NEED_DTIM_BEFORE_ASSOC);
+	ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
 
 	if (!modparam_noht) {
 		/*
 		 * see the comment above, why we allow the user
 		 * to disable HT by a module parameter.
 		 */
-		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
+		ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	}
 
 	hw->extra_tx_headroom = sizeof(struct _carl9170_tx_superframe);
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 0783d2ed8238..900e72a089d8 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -944,12 +944,12 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
 		WLAN_CIPHER_SUITE_CCMP,
 	};
 
-	wcn->hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_HAS_RATE_CONTROL |
-		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_CONNECTION_MONITOR |
-		IEEE80211_HW_AMPDU_AGGREGATION |
-		IEEE80211_HW_TIMING_BEACON_ONLY;
+	ieee80211_hw_set(wcn->hw, TIMING_BEACON_ONLY);
+	ieee80211_hw_set(wcn->hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(wcn->hw, CONNECTION_MONITOR);
+	ieee80211_hw_set(wcn->hw, SUPPORTS_PS);
+	ieee80211_hw_set(wcn->hw, SIGNAL_DBM);
+	ieee80211_hw_set(wcn->hw, HAS_RATE_CONTROL);
 
 	wcn->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_AP) |
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index f40992969b4a..575b9f4b5589 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5605,8 +5605,8 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 	wl = hw_to_b43_wl(hw);
 
 	/* fill hw info */
-	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_SIGNAL_DBM;
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 39d49d6cd07f..afc1fb3e38df 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3832,8 +3832,9 @@ static int b43legacy_wireless_init(struct ssb_device *dev)
 	}
 
 	/* fill hw info */
-	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_SIGNAL_DBM;
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index b46cab250615..ab775a5d5b33 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1060,10 +1060,9 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
  */
 static int ieee_hw_init(struct ieee80211_hw *hw)
 {
-	hw->flags = IEEE80211_HW_SIGNAL_DBM
-	    /* | IEEE80211_HW_CONNECTION_MONITOR  What is this? */
-	    | IEEE80211_HW_REPORTS_TX_ACK_STATUS
-	    | IEEE80211_HW_AMPDU_AGGREGATION;
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
 
 	hw->extra_tx_headroom = brcms_c_get_header_len();
 	hw->queues = N_TX_QUEUES;
diff --git a/drivers/net/wireless/cw1200/main.c b/drivers/net/wireless/cw1200/main.c
index 3689dbbd10bd..0e51e27d2e3f 100644
--- a/drivers/net/wireless/cw1200/main.c
+++ b/drivers/net/wireless/cw1200/main.c
@@ -278,14 +278,14 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 	else
 		priv->ba_tx_tid_mask = 0xff; /* Enable TX BLKACK for all TIDs */
 
-	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_SUPPORTS_PS |
-		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
-		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		    IEEE80211_HW_CONNECTION_MONITOR |
-		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_TX_AMPDU_SETUP_IN_HW |
-		    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC;
+	ieee80211_hw_set(hw, NEED_DTIM_BEFORE_ASSOC);
+	ieee80211_hw_set(hw, TX_AMPDU_SETUP_IN_HW);
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, CONNECTION_MONITOR);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, SUPPORTS_PS);
 
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 					  BIT(NL80211_IFTYPE_ADHOC) |
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 189cdf58084b..7f4cb692cc57 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3561,8 +3561,10 @@ il3945_setup_mac(struct il_priv *il)
 	hw->vif_data_size = sizeof(struct il_vif_priv);
 
 	/* Tell mac80211 our characteristics */
-	hw->flags = IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_SPECTRUM_MGMT |
-		    IEEE80211_HW_SUPPORTS_PS | IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
+	ieee80211_hw_set(hw, SUPPORTS_PS);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, SPECTRUM_MGMT);
 
 	hw->wiphy->interface_modes =
 	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index e4b175cbeefd..44fa422f255e 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5751,11 +5751,13 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 	hw->rate_control_algorithm = "iwl-4965-rs";
 
 	/* Tell mac80211 our characteristics */
-	hw->flags =
-	    IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_AMPDU_AGGREGATION |
-	    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC | IEEE80211_HW_SPECTRUM_MGMT |
-	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | IEEE80211_HW_SUPPORTS_PS |
-	    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
+	ieee80211_hw_set(hw, SUPPORTS_PS);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, SPECTRUM_MGMT);
+	ieee80211_hw_set(hw, NEED_DTIM_BEFORE_ASSOC);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	if (il->cfg->sku & IL_SKU_N)
 		hw->wiphy->features |= NL80211_FEATURE_DYNAMIC_SMPS |
 				       NL80211_FEATURE_STATIC_SMPS;
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index ba7fc42edf97..738f3246cdc5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -104,15 +104,15 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	hw->rate_control_algorithm = "iwl-agn-rs";
 
 	/* Tell mac80211 our characteristics */
-	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC |
-		    IEEE80211_HW_SPECTRUM_MGMT |
-		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		    IEEE80211_HW_QUEUE_CONTROL |
-		    IEEE80211_HW_SUPPORTS_PS |
-		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
-		    IEEE80211_HW_WANT_MONITOR_VIF;
+	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
+	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
+	ieee80211_hw_set(hw, SUPPORTS_PS);
+	ieee80211_hw_set(hw, QUEUE_CONTROL);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, SPECTRUM_MGMT);
+	ieee80211_hw_set(hw, NEED_DTIM_BEFORE_ASSOC);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 
 	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
 	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_FMT;
@@ -135,7 +135,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	 */
 	if (priv->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_MFP &&
 	    !iwlwifi_mod_params.sw_crypto)
-		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
+		ieee80211_hw_set(hw, MFP_CAPABLE);
 
 	hw->sta_data_size = sizeof(struct iwl_station_priv);
 	hw->vif_data_size = sizeof(struct iwl_vif_priv);
@@ -1341,9 +1341,9 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	 * other interfaces are added, this is safe.
 	 */
 	if (vif->type == NL80211_IFTYPE_MONITOR)
-		priv->hw->flags |= IEEE80211_HW_RX_INCLUDES_FCS;
+		ieee80211_hw_set(priv->hw, RX_INCLUDES_FCS);
 	else
-		priv->hw->flags &= ~IEEE80211_HW_RX_INCLUDES_FCS;
+		__clear_bit(IEEE80211_HW_RX_INCLUDES_FCS, priv->hw->flags);
 
 	err = iwl_setup_interface(priv, ctx);
 	if (!err || reset)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 8088c7137f7c..1812dd018af2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -852,7 +852,7 @@ static int iwl_mvm_mac_ctxt_cmd_listener(struct iwl_mvm *mvm,
 				       MAC_FILTER_IN_BEACON |
 				       MAC_FILTER_IN_PROBE_REQUEST |
 				       MAC_FILTER_IN_CRC32);
-	mvm->hw->flags |= IEEE80211_HW_RX_INCLUDES_FCS;
+	ieee80211_hw_set(mvm->hw, RX_INCLUDES_FCS);
 
 	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
 }
@@ -1270,7 +1270,7 @@ int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	mvmvif->uploaded = false;
 
 	if (vif->type == NL80211_IFTYPE_MONITOR)
-		mvm->hw->flags &= ~IEEE80211_HW_RX_INCLUDES_FCS;
+		__clear_bit(IEEE80211_HW_RX_INCLUDES_FCS, mvm->hw->flags);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 6b45b96ac238..1a2206e33445 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -418,18 +418,18 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	int num_mac, ret, i;
 
 	/* Tell mac80211 our characteristics */
-	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_SPECTRUM_MGMT |
-		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		    IEEE80211_HW_QUEUE_CONTROL |
-		    IEEE80211_HW_WANT_MONITOR_VIF |
-		    IEEE80211_HW_SUPPORTS_PS |
-		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
-		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_TIMING_BEACON_ONLY |
-		    IEEE80211_HW_CONNECTION_MONITOR |
-		    IEEE80211_HW_CHANCTX_STA_CSA |
-		    IEEE80211_HW_SUPPORTS_CLONED_SKBS;
+	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
+	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
+	ieee80211_hw_set(hw, CONNECTION_MONITOR);
+	ieee80211_hw_set(hw, TIMING_BEACON_ONLY);
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
+	ieee80211_hw_set(hw, SUPPORTS_PS);
+	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
+	ieee80211_hw_set(hw, QUEUE_CONTROL);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, SPECTRUM_MGMT);
 
 	hw->queues = mvm->first_agg_queue;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
@@ -448,9 +448,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	 */
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_MFP &&
 	    !iwlwifi_mod_params.sw_crypto)
-		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
+		ieee80211_hw_set(hw, MFP_CAPABLE);
 
-	hw->flags |= IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS;
+	ieee80211_hw_set(hw, SINGLE_SCAN_ON_ALL_BANDS);
 	hw->wiphy->features |=
 		NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
 		NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
@@ -2863,7 +2863,7 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
-		WARN_ON_ONCE(!(hw->flags & IEEE80211_HW_MFP_CAPABLE));
+		WARN_ON_ONCE(!ieee80211_hw_check(hw, MFP_CAPABLE));
 		break;
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 1bdf18674fb8..a47f0acc099a 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -634,7 +634,7 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
 	priv->tx_skb = NULL;
 
 	hw->queues = 1;
-	hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
+	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
 	hw->extra_tx_headroom = sizeof(struct txpd);
 	memcpy(priv->channels, lbtf_channels, sizeof(lbtf_channels));
 	memcpy(priv->rates, lbtf_rates, sizeof(lbtf_rates));
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 8d2f6bbf9598..99e873dc8684 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1286,7 +1286,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	if (control->sta)
 		hwsim_check_sta_magic(control->sta);
 
-	if (hw->flags & IEEE80211_HW_SUPPORTS_RC_TABLE)
+	if (ieee80211_hw_check(hw, SUPPORTS_RC_TABLE))
 		ieee80211_get_tx_rates(txi->control.vif, control->sta, skb,
 				       txi->control.rates,
 				       ARRAY_SIZE(txi->control.rates));
@@ -1395,7 +1395,7 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 {
 	u32 _pid = ACCESS_ONCE(wmediumd_portid);
 
-	if (hw->flags & IEEE80211_HW_SUPPORTS_RC_TABLE) {
+	if (ieee80211_hw_check(hw, SUPPORTS_RC_TABLE)) {
 		struct ieee80211_tx_info *txi = IEEE80211_SKB_CB(skb);
 		ieee80211_get_tx_rates(txi->control.vif, NULL, skb,
 				       txi->control.rates,
@@ -1432,7 +1432,7 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 	if (skb == NULL)
 		return;
 	info = IEEE80211_SKB_CB(skb);
-	if (hw->flags & IEEE80211_HW_SUPPORTS_RC_TABLE)
+	if (ieee80211_hw_check(hw, SUPPORTS_RC_TABLE))
 		ieee80211_get_tx_rates(vif, NULL, skb,
 				       info->control.rates,
 				       ARRAY_SIZE(info->control.rates));
@@ -2391,16 +2391,16 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	if (param->p2p_device)
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_DEVICE);
 
-	hw->flags = IEEE80211_HW_MFP_CAPABLE |
-		    IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_WANT_MONITOR_VIF |
-		    IEEE80211_HW_QUEUE_CONTROL |
-		    IEEE80211_HW_SUPPORTS_HT_CCK_RATES |
-		    IEEE80211_HW_CHANCTX_STA_CSA |
-		    IEEE80211_HW_SUPPORT_FAST_XMIT;
+	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
+	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
+	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
+	ieee80211_hw_set(hw, QUEUE_CONTROL);
+	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
 	if (rctbl)
-		hw->flags |= IEEE80211_HW_SUPPORTS_RC_TABLE;
+		ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
 
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
@@ -2509,7 +2509,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	}
 
 	if (param->no_vif)
-		hw->flags |= IEEE80211_HW_NO_AUTO_VIF;
+		ieee80211_hw_set(hw, NO_AUTO_VIF);
 
 	err = ieee80211_register_hw(hw);
 	if (err < 0) {
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b71fc74d14ab..77361af68b18 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2380,7 +2380,7 @@ mwl8k_set_ht_caps(struct ieee80211_hw *hw,
 	if (cap & MWL8K_CAP_GREENFIELD)
 		band->ht_cap.cap |= IEEE80211_HT_CAP_GRN_FLD;
 	if (cap & MWL8K_CAP_AMPDU) {
-		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
+		ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 		band->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
 		band->ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
 	}
@@ -5431,7 +5431,7 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	u8 *addr = sta->addr, idx;
 	struct mwl8k_sta *sta_info = MWL8K_STA(sta);
 
-	if (!(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION))
+	if (!ieee80211_hw_check(hw, AMPDU_AGGREGATION))
 		return -ENOTSUPP;
 
 	spin_lock(&priv->stream_lock);
@@ -6076,14 +6076,15 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 	hw->queues = MWL8K_TX_WMM_QUEUES;
 
 	/* Set rssi values to dBm */
-	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_HAS_RATE_CONTROL;
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 
 	/*
 	 * Ask mac80211 to not to trigger PS mode
 	 * based on PM bit of incoming frames.
 	 */
 	if (priv->ap_fw)
-		hw->flags |= IEEE80211_HW_AP_LINK_PS;
+		ieee80211_hw_set(hw, AP_LINK_PS);
 
 	hw->vif_data_size = sizeof(struct mwl8k_vif);
 	hw->sta_data_size = sizeof(struct mwl8k_sta);
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 2947ad21053c..7805864e76f9 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -746,12 +746,12 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	spin_lock_init(&priv->tx_stats_lock);
 	skb_queue_head_init(&priv->tx_queue);
 	skb_queue_head_init(&priv->tx_pending);
-	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_SIGNAL_DBM |
-		     IEEE80211_HW_SUPPORTS_PS |
-		     IEEE80211_HW_PS_NULLFUNC_STACK |
-		     IEEE80211_HW_MFP_CAPABLE |
-		     IEEE80211_HW_REPORTS_TX_ACK_STATUS;
+	ieee80211_hw_set(dev, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(dev, MFP_CAPABLE);
+	ieee80211_hw_set(dev, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(dev, SUPPORTS_PS);
+	ieee80211_hw_set(dev, RX_INCLUDES_FCS);
+	ieee80211_hw_set(dev, SIGNAL_DBM);
 
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				      BIT(NL80211_IFTYPE_ADHOC) |
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index aeaf87bb5518..7e804324bfa7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1062,10 +1062,9 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	hw->priv = adapter;
 	adapter->hw = hw;
 
-	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_HAS_RATE_CONTROL |
-		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    0;
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 
 	hw->queues = MAX_HW_QUEUES;
 	hw->extra_tx_headroom = RSI_NEEDED_HEADROOM;
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 7da138892026..9a3966cd6fbe 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1574,10 +1574,10 @@ static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 */
-	rt2x00dev->hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-			       IEEE80211_HW_SIGNAL_DBM |
-			       IEEE80211_HW_SUPPORTS_PS |
-			       IEEE80211_HW_PS_NULLFUNC_STACK;
+	ieee80211_hw_set(rt2x00dev->hw, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
+	ieee80211_hw_set(rt2x00dev->hw, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 4ea53aa9ede3..1a6740b4d396 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1869,10 +1869,10 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 */
-	rt2x00dev->hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-			       IEEE80211_HW_SIGNAL_DBM |
-			       IEEE80211_HW_SUPPORTS_PS |
-			       IEEE80211_HW_PS_NULLFUNC_STACK;
+	ieee80211_hw_set(rt2x00dev->hw, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
+	ieee80211_hw_set(rt2x00dev->hw, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 237bbb54c7a8..b50d873145d5 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1696,11 +1696,10 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 * multicast and broadcast traffic immediately instead of buffering it
 	 * infinitly and thus dropping it after some time.
 	 */
-	rt2x00dev->hw->flags =
-	    IEEE80211_HW_RX_INCLUDES_FCS |
-	    IEEE80211_HW_SIGNAL_DBM |
-	    IEEE80211_HW_SUPPORTS_PS |
-	    IEEE80211_HW_PS_NULLFUNC_STACK;
+	ieee80211_hw_set(rt2x00dev->hw, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
+	ieee80211_hw_set(rt2x00dev->hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
 
 	/*
 	 * Disable powersaving as default.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index dfeca8355b22..0bc5ac56f283 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7497,13 +7497,12 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 */
-	rt2x00dev->hw->flags =
-	    IEEE80211_HW_SIGNAL_DBM |
-	    IEEE80211_HW_SUPPORTS_PS |
-	    IEEE80211_HW_PS_NULLFUNC_STACK |
-	    IEEE80211_HW_AMPDU_AGGREGATION |
-	    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-	    IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
+	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_HT_CCK_RATES);
+	ieee80211_hw_set(rt2x00dev->hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(rt2x00dev->hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(rt2x00dev->hw, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
+	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
 
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
@@ -7513,8 +7512,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 * infinitly and thus dropping it after some time.
 	 */
 	if (!rt2x00_is_usb(rt2x00dev))
-		rt2x00dev->hw->flags |=
-			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
+		ieee80211_hw_set(rt2x00dev->hw, HOST_BROADCAST_PS_BUFFERING);
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index c8a967247a9a..c0e730ea1b69 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2758,11 +2758,10 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 */
-	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_SIGNAL_DBM |
-	    IEEE80211_HW_SUPPORTS_PS |
-	    IEEE80211_HW_PS_NULLFUNC_STACK;
+	ieee80211_hw_set(rt2x00dev->hw, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
+	ieee80211_hw_set(rt2x00dev->hw, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 65ce3afb888a..7081e13b4fd6 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2105,16 +2105,15 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 *
-	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING unless we are
+	 * Don't set IEEE80211_HOST_BROADCAST_PS_BUFFERING unless we are
 	 * capable of sending the buffered frames out after the DTIM
 	 * transmission using rt2x00lib_beacondone. This will send out
 	 * multicast and broadcast traffic immediately instead of buffering it
 	 * infinitly and thus dropping it after some time.
 	 */
-	rt2x00dev->hw->flags =
-	    IEEE80211_HW_SIGNAL_DBM |
-	    IEEE80211_HW_SUPPORTS_PS |
-	    IEEE80211_HW_PS_NULLFUNC_STACK;
+	ieee80211_hw_set(rt2x00dev->hw, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
+	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 706b844bce00..a43a16fde59d 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1802,8 +1802,9 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	priv->band.n_bitrates = 4;
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
 
-	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		IEEE80211_HW_RX_INCLUDES_FCS;
+	ieee80211_hw_set(dev, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(dev, RX_INCLUDES_FCS);
+
 	dev->vif_data_size = sizeof(struct rtl8180_vif);
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 					BIT(NL80211_IFTYPE_ADHOC);
@@ -1868,9 +1869,9 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	}
 
 	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180)
-		dev->flags |= IEEE80211_HW_SIGNAL_DBM;
+		ieee80211_hw_set(dev, SIGNAL_DBM);
 	else
-		dev->flags |= IEEE80211_HW_SIGNAL_UNSPEC;
+		ieee80211_hw_set(dev, SIGNAL_UNSPEC);
 
 	rtl8180_eeprom_read(priv);
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 629ad8cfa17b..b7f72f9c7988 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -1478,9 +1478,9 @@ static int rtl8187_probe(struct usb_interface *intf,
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
 
 
-	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		     IEEE80211_HW_SIGNAL_DBM |
-		     IEEE80211_HW_RX_INCLUDES_FCS;
+	ieee80211_hw_set(dev, RX_INCLUDES_FCS);
+	ieee80211_hw_set(dev, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(dev, SIGNAL_DBM);
 	/* Initialize rate-control variables */
 	dev->max_rates = 1;
 	dev->max_rate_tries = RETRY_COUNT;
diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 01f56c7df8b5..0517a4f2d3f2 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -394,20 +394,18 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 		}
 	}
 	/* <5> set hw caps */
-	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-	    IEEE80211_HW_RX_INCLUDES_FCS |
-	    IEEE80211_HW_AMPDU_AGGREGATION |
-	    IEEE80211_HW_CONNECTION_MONITOR |
-	    /* IEEE80211_HW_SUPPORTS_CQM_RSSI | */
-	    IEEE80211_HW_MFP_CAPABLE |
-	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | 0;
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, CONNECTION_MONITOR);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
+	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
 
 	/* swlps or hwlps has been set in diff chip in init_sw_vars */
-	if (rtlpriv->psc.swctrl_lps)
-		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
-			IEEE80211_HW_PS_NULLFUNC_STACK |
-			/* IEEE80211_HW_SUPPORTS_DYNAMIC_PS | */
-			0;
+	if (rtlpriv->psc.swctrl_lps) {
+		ieee80211_hw_set(hw, SUPPORTS_PS);
+		ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
+	}
 	hw->wiphy->interface_modes =
 	    BIT(NL80211_IFTYPE_AP) |
 	    BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index f238ee54226c..cd4777954f87 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1476,7 +1476,8 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	/* unit us */
 	/* FIXME: find a proper value */
 
-	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_SUPPORTS_PS;
+	ieee80211_hw_set(wl->hw, SIGNAL_DBM);
+	ieee80211_hw_set(wl->hw, SUPPORTS_PS);
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 					 BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 257b9d5821a6..cc1f6c0423f0 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6065,19 +6065,19 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	/* FIXME: find a proper value */
 	wl->hw->max_listen_interval = wl->conf.conn.max_listen_interval;
 
-	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
-		IEEE80211_HW_HAS_RATE_CONTROL |
-		IEEE80211_HW_CONNECTION_MONITOR |
-		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		IEEE80211_HW_SPECTRUM_MGMT |
-		IEEE80211_HW_AP_LINK_PS |
-		IEEE80211_HW_AMPDU_AGGREGATION |
-		IEEE80211_HW_TX_AMPDU_SETUP_IN_HW |
-		IEEE80211_HW_QUEUE_CONTROL |
-		IEEE80211_HW_CHANCTX_STA_CSA |
-		IEEE80211_HW_SUPPORT_FAST_XMIT;
+	ieee80211_hw_set(wl->hw, SUPPORT_FAST_XMIT);
+	ieee80211_hw_set(wl->hw, CHANCTX_STA_CSA);
+	ieee80211_hw_set(wl->hw, QUEUE_CONTROL);
+	ieee80211_hw_set(wl->hw, TX_AMPDU_SETUP_IN_HW);
+	ieee80211_hw_set(wl->hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(wl->hw, AP_LINK_PS);
+	ieee80211_hw_set(wl->hw, SPECTRUM_MGMT);
+	ieee80211_hw_set(wl->hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(wl->hw, CONNECTION_MONITOR);
+	ieee80211_hw_set(wl->hw, HAS_RATE_CONTROL);
+	ieee80211_hw_set(wl->hw, SUPPORTS_DYNAMIC_PS);
+	ieee80211_hw_set(wl->hw, SIGNAL_DBM);
+	ieee80211_hw_set(wl->hw, SUPPORTS_PS);
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 89b6f69f09c8..e539d9b1b562 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1397,10 +1397,10 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &mac->band;
 
-	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_SIGNAL_UNSPEC |
-		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		    IEEE80211_HW_MFP_CAPABLE;
+	ieee80211_hw_set(hw, MFP_CAPABLE);
+	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, SIGNAL_UNSPEC);
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_MESH_POINT) |
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 6b2f813afb52..9da7f255537e 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1785,10 +1785,10 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
 
-	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_TIMING_BEACON_ONLY;
+	ieee80211_hw_set(priv->hw, TIMING_BEACON_ONLY);
+	ieee80211_hw_set(priv->hw, SIGNAL_DBM);
+	ieee80211_hw_set(priv->hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(priv->hw, REPORTS_TX_ACK_STATUS);
 
 	priv->hw->max_signal = 100;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 0d97b6457ead..2ccfbff37c42 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -978,10 +978,10 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
 
-	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_TIMING_BEACON_ONLY;
+	ieee80211_hw_set(priv->hw, TIMING_BEACON_ONLY);
+	ieee80211_hw_set(priv->hw, SIGNAL_DBM);
+	ieee80211_hw_set(priv->hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(priv->hw, REPORTS_TX_ACK_STATUS);
 
 	priv->hw->max_signal = 100;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e09a32cb139f..dc56734d0154 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1889,35 +1889,38 @@ struct ieee80211_txq {
  *	in one command, mac80211 doesn't have to run separate scans per band.
  */
 enum ieee80211_hw_flags {
-	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
-	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
-	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
-	IEEE80211_HW_SIGNAL_UNSPEC			= 1<<5,
-	IEEE80211_HW_SIGNAL_DBM				= 1<<6,
-	IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC		= 1<<7,
-	IEEE80211_HW_SPECTRUM_MGMT			= 1<<8,
-	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<9,
-	IEEE80211_HW_SUPPORTS_PS			= 1<<10,
-	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<11,
-	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
-	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
-	IEEE80211_HW_WANT_MONITOR_VIF			= 1<<14,
-	IEEE80211_HW_NO_AUTO_VIF			= 1<<15,
-	IEEE80211_HW_SW_CRYPTO_CONTROL			= 1<<16,
-	IEEE80211_HW_SUPPORT_FAST_XMIT			= 1<<17,
-	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
-	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
-	IEEE80211_HW_QUEUE_CONTROL			= 1<<20,
-	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
-	IEEE80211_HW_AP_LINK_PS				= 1<<22,
-	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
-	IEEE80211_HW_SUPPORTS_RC_TABLE			= 1<<24,
-	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
-	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
-	IEEE80211_HW_SUPPORTS_HT_CCK_RATES		= 1<<27,
-	IEEE80211_HW_CHANCTX_STA_CSA			= 1<<28,
-	IEEE80211_HW_SUPPORTS_CLONED_SKBS		= 1<<29,
-	IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS		= 1<<30,
+	IEEE80211_HW_HAS_RATE_CONTROL,
+	IEEE80211_HW_RX_INCLUDES_FCS,
+	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING,
+	IEEE80211_HW_SIGNAL_UNSPEC,
+	IEEE80211_HW_SIGNAL_DBM,
+	IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC,
+	IEEE80211_HW_SPECTRUM_MGMT,
+	IEEE80211_HW_AMPDU_AGGREGATION,
+	IEEE80211_HW_SUPPORTS_PS,
+	IEEE80211_HW_PS_NULLFUNC_STACK,
+	IEEE80211_HW_SUPPORTS_DYNAMIC_PS,
+	IEEE80211_HW_MFP_CAPABLE,
+	IEEE80211_HW_WANT_MONITOR_VIF,
+	IEEE80211_HW_NO_AUTO_VIF,
+	IEEE80211_HW_SW_CRYPTO_CONTROL,
+	IEEE80211_HW_SUPPORT_FAST_XMIT,
+	IEEE80211_HW_REPORTS_TX_ACK_STATUS,
+	IEEE80211_HW_CONNECTION_MONITOR,
+	IEEE80211_HW_QUEUE_CONTROL,
+	IEEE80211_HW_SUPPORTS_PER_STA_GTK,
+	IEEE80211_HW_AP_LINK_PS,
+	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW,
+	IEEE80211_HW_SUPPORTS_RC_TABLE,
+	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF,
+	IEEE80211_HW_TIMING_BEACON_ONLY,
+	IEEE80211_HW_SUPPORTS_HT_CCK_RATES,
+	IEEE80211_HW_CHANCTX_STA_CSA,
+	IEEE80211_HW_SUPPORTS_CLONED_SKBS,
+	IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS,
+
+	/* keep last, obviously */
+	NUM_IEEE80211_HW_FLAGS
 };
 
 /**
@@ -2024,7 +2027,7 @@ struct ieee80211_hw {
 	struct wiphy *wiphy;
 	const char *rate_control_algorithm;
 	void *priv;
-	u32 flags;
+	unsigned long flags[BITS_TO_LONGS(NUM_IEEE80211_HW_FLAGS)];
 	unsigned int extra_tx_headroom;
 	unsigned int extra_beacon_tailroom;
 	int vif_data_size;
@@ -2050,6 +2053,20 @@ struct ieee80211_hw {
 	int txq_ac_max_pending;
 };
 
+static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
+				       enum ieee80211_hw_flags flg)
+{
+	return test_bit(flg, hw->flags);
+}
+#define ieee80211_hw_check(hw, flg)	_ieee80211_hw_check(hw, IEEE80211_HW_##flg)
+
+static inline void _ieee80211_hw_set(struct ieee80211_hw *hw,
+				     enum ieee80211_hw_flags flg)
+{
+	return __set_bit(flg, hw->flags);
+}
+#define ieee80211_hw_set(hw, flg)	_ieee80211_hw_set(hw, IEEE80211_HW_##flg)
+
 /**
  * struct ieee80211_scan_request - hw scan request
  *
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index cce9d425c718..c8ba2e77737c 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -564,8 +564,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		return -EINVAL;
 
 	if ((tid >= IEEE80211_NUM_TIDS) ||
-	    !(local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) ||
-	    (local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW))
+	    !ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION) ||
+	    ieee80211_hw_check(&local->hw, TX_AMPDU_SETUP_IN_HW))
 		return -EINVAL;
 
 	ht_dbg(sdata, "Open BA session requested for %pM tid %u\n",
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1a17d3208d8f..73f861b5ce54 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1763,7 +1763,7 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		/* our RSSI threshold implementation is supported only for
 		 * devices that report signal in dBm.
 		 */
-		if (!(sdata->local->hw.flags & IEEE80211_HW_SIGNAL_DBM))
+		if (!ieee80211_hw_check(&sdata->local->hw, SIGNAL_DBM))
 			return -ENOTSUPP;
 		conf->rssi_threshold = nconf->rssi_threshold;
 	}
@@ -2407,7 +2407,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
 
-	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
+	if (!ieee80211_hw_check(&local->hw, SUPPORTS_PS))
 		return -EOPNOTSUPP;
 
 	if (enabled == sdata->u.mgd.powersave &&
@@ -2422,7 +2422,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	__ieee80211_request_smps_mgd(sdata, sdata->u.mgd.req_smps);
 	sdata_unlock(sdata);
 
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
+	if (ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS))
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 
 	ieee80211_recalc_ps(local, -1);
@@ -2466,7 +2466,7 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
-	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) {
+	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
 		ret = drv_set_bitrate_mask(local, sdata, mask);
 		if (ret)
 			return ret;
@@ -3487,7 +3487,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN |
 					IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
-	if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
+	if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
 		IEEE80211_SKB_CB(skb)->hw_queue =
 			local->hw.offchannel_tx_hw_queue;
 
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 1b94d2704c27..3ea8b7de9633 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -91,56 +91,66 @@ static const struct file_operations reset_ops = {
 };
 #endif
 
+static const char *hw_flag_names[NUM_IEEE80211_HW_FLAGS + 1] = {
+#define FLAG(F)	[IEEE80211_HW_##F] = #F
+	FLAG(HAS_RATE_CONTROL),
+	FLAG(RX_INCLUDES_FCS),
+	FLAG(HOST_BROADCAST_PS_BUFFERING),
+	FLAG(SIGNAL_UNSPEC),
+	FLAG(SIGNAL_DBM),
+	FLAG(NEED_DTIM_BEFORE_ASSOC),
+	FLAG(SPECTRUM_MGMT),
+	FLAG(AMPDU_AGGREGATION),
+	FLAG(SUPPORTS_PS),
+	FLAG(PS_NULLFUNC_STACK),
+	FLAG(SUPPORTS_DYNAMIC_PS),
+	FLAG(MFP_CAPABLE),
+	FLAG(WANT_MONITOR_VIF),
+	FLAG(NO_AUTO_VIF),
+	FLAG(SW_CRYPTO_CONTROL),
+	FLAG(SUPPORT_FAST_XMIT),
+	FLAG(REPORTS_TX_ACK_STATUS),
+	FLAG(CONNECTION_MONITOR),
+	FLAG(QUEUE_CONTROL),
+	FLAG(SUPPORTS_PER_STA_GTK),
+	FLAG(AP_LINK_PS),
+	FLAG(TX_AMPDU_SETUP_IN_HW),
+	FLAG(SUPPORTS_RC_TABLE),
+	FLAG(P2P_DEV_ADDR_FOR_INTF),
+	FLAG(TIMING_BEACON_ONLY),
+	FLAG(SUPPORTS_HT_CCK_RATES),
+	FLAG(CHANCTX_STA_CSA),
+	FLAG(SUPPORTS_CLONED_SKBS),
+	FLAG(SINGLE_SCAN_ON_ALL_BANDS),
+
+	/* keep last for the build bug below */
+	(void *)0x1
+#undef FLAG
+};
+
 static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 			    size_t count, loff_t *ppos)
 {
 	struct ieee80211_local *local = file->private_data;
-	int mxln = 500;
+	size_t bufsz = 30 * NUM_IEEE80211_HW_FLAGS;
+	char *buf = kzalloc(bufsz, GFP_KERNEL);
+	char *pos = buf, *end = buf + bufsz - 1;
 	ssize_t rv;
-	char *buf = kzalloc(mxln, GFP_KERNEL);
-	int sf = 0; /* how many written so far */
+	int i;
 
 	if (!buf)
-		return 0;
-
-	sf += scnprintf(buf, mxln - sf, "0x%x\n", local->hw.flags);
-	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
-		sf += scnprintf(buf + sf, mxln - sf, "HAS_RATE_CONTROL\n");
-	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
-		sf += scnprintf(buf + sf, mxln - sf, "RX_INCLUDES_FCS\n");
-	if (local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING)
-		sf += scnprintf(buf + sf, mxln - sf,
-				"HOST_BCAST_PS_BUFFERING\n");
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
-		sf += scnprintf(buf + sf, mxln - sf, "SIGNAL_UNSPEC\n");
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
-		sf += scnprintf(buf + sf, mxln - sf, "SIGNAL_DBM\n");
-	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC)
-		sf += scnprintf(buf + sf, mxln - sf,
-				"NEED_DTIM_BEFORE_ASSOC\n");
-	if (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT)
-		sf += scnprintf(buf + sf, mxln - sf, "SPECTRUM_MGMT\n");
-	if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
-		sf += scnprintf(buf + sf, mxln - sf, "AMPDU_AGGREGATION\n");
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PS)
-		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_PS\n");
-	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
-		sf += scnprintf(buf + sf, mxln - sf, "PS_NULLFUNC_STACK\n");
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
-		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_DYNAMIC_PS\n");
-	if (local->hw.flags & IEEE80211_HW_MFP_CAPABLE)
-		sf += scnprintf(buf + sf, mxln - sf, "MFP_CAPABLE\n");
-	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		sf += scnprintf(buf + sf, mxln - sf,
-				"REPORTS_TX_ACK_STATUS\n");
-	if (local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
-		sf += scnprintf(buf + sf, mxln - sf, "CONNECTION_MONITOR\n");
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PER_STA_GTK)
-		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_PER_STA_GTK\n");
-	if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
-		sf += scnprintf(buf + sf, mxln - sf, "AP_LINK_PS\n");
-	if (local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW)
-		sf += scnprintf(buf + sf, mxln - sf, "TX_AMPDU_SETUP_IN_HW\n");
+		return -ENOMEM;
+
+	/* fail compilation if somebody adds or removes
+	 * a flag without updating the name array above
+	 */
+	BUILD_BUG_ON(hw_flag_names[NUM_IEEE80211_HW_FLAGS] != (void *)0x1);
+
+	for (i = 0; i < NUM_IEEE80211_HW_FLAGS; i++) {
+		if (test_bit(i, local->hw.flags))
+			pos += scnprintf(pos, end - pos, "%s",
+					 hw_flag_names[i]);
+	}
 
 	rv = simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 	kfree(buf);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index c01e681b90fb..32a2e707e222 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -146,7 +146,7 @@ static inline int drv_add_interface(struct ieee80211_local *local,
 
 	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 		    (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
-		     !(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF) &&
+		     !ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF) &&
 		     !(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))))
 		return -EINVAL;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index dc2d7133c4f6..327a0c065031 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -338,7 +338,7 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata,
 	if ((iftype != NL80211_IFTYPE_AP &&
 	     iftype != NL80211_IFTYPE_P2P_GO &&
 	     iftype != NL80211_IFTYPE_MESH_POINT) ||
-	    !(sdata->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)) {
+	    !ieee80211_hw_check(&sdata->local->hw, QUEUE_CONTROL)) {
 		sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
 		return 0;
 	}
@@ -378,7 +378,7 @@ static void ieee80211_set_default_queues(struct ieee80211_sub_if_data *sdata)
 	int i;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
+		if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
 			sdata->vif.hw_queue[i] = IEEE80211_INVAL_HW_QUEUE;
 		else if (local->hw.queues >= IEEE80211_NUM_ACS)
 			sdata->vif.hw_queue[i] = i;
@@ -393,7 +393,7 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	int ret;
 
-	if (!(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF))
+	if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
 		return 0;
 
 	ASSERT_RTNL();
@@ -454,7 +454,7 @@ void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
-	if (!(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF))
+	if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
 		return;
 
 	ASSERT_RTNL();
@@ -1578,7 +1578,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
-		if (local->hw.flags & IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF) {
+		if (ieee80211_hw_check(&local->hw, P2P_DEV_ADDR_FOR_INTF)) {
 			list_for_each_entry(sdata, &local->interfaces, list) {
 				if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
 					continue;
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 9a4a4bfafdc2..e0024e05d499 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -120,7 +120,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	 * is supported; if not, return.
 	 */
 	if (sta && !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
-	    !(key->local->hw.flags & IEEE80211_HW_SUPPORTS_PER_STA_GTK))
+	    !ieee80211_hw_check(&key->local->hw, SUPPORTS_PER_STA_GTK))
 		goto out_unsupported;
 
 	if (sta && !sta->uploaded)
@@ -174,7 +174,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		/* all of these we can do in software - if driver can */
 		if (ret == 1)
 			return 0;
-		if (key->local->hw.flags & IEEE80211_HW_SW_CRYPTO_CONTROL)
+		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL))
 			return -EINVAL;
 		return 0;
 	default:
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 674164fe5cdb..3c63468b4dfb 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -661,7 +661,7 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 {
 	bool have_wep = !(IS_ERR(local->wep_tx_tfm) ||
 			  IS_ERR(local->wep_rx_tfm));
-	bool have_mfp = local->hw.flags & IEEE80211_HW_MFP_CAPABLE;
+	bool have_mfp = ieee80211_hw_check(&local->hw, MFP_CAPABLE);
 	int n_suites = 0, r = 0, w = 0;
 	u32 *suites;
 	static const u32 cipher_suites[] = {
@@ -681,7 +681,7 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		WLAN_CIPHER_SUITE_BIP_GMAC_256,
 	};
 
-	if (local->hw.flags & IEEE80211_HW_SW_CRYPTO_CONTROL ||
+	if (ieee80211_hw_check(&local->hw, SW_CRYPTO_CONTROL) ||
 	    local->hw.wiphy->cipher_suites) {
 		/* If the driver advertises, or doesn't support SW crypto,
 		 * we only need to remove WEP if necessary.
@@ -797,7 +797,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	netdev_features_t feature_whitelist;
 	struct cfg80211_chan_def dflt_chandef = {};
 
-	if (hw->flags & IEEE80211_HW_QUEUE_CONTROL &&
+	if (ieee80211_hw_check(hw, QUEUE_CONTROL) &&
 	    (local->hw.offchannel_tx_hw_queue == IEEE80211_INVAL_HW_QUEUE ||
 	     local->hw.offchannel_tx_hw_queue >= local->hw.queues))
 		return -EINVAL;
@@ -945,9 +945,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	/* mac80211 supports control port protocol changing */
 	local->hw.wiphy->flags |= WIPHY_FLAG_CONTROL_PORT_PROTOCOL;
 
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM)) {
 		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
-	} else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC) {
+	} else if (ieee80211_hw_check(&local->hw, SIGNAL_UNSPEC)) {
 		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
 		if (hw->max_signal <= 0) {
 			result = -EINVAL;
@@ -1001,7 +1001,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		local->hw.wiphy->flags |= WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
 
 	/* mac80211 supports eCSA, if the driver supports STA CSA at all */
-	if (local->hw.flags & IEEE80211_HW_CHANCTX_STA_CSA)
+	if (ieee80211_hw_check(&local->hw, CHANCTX_STA_CSA))
 		local->ext_capa[0] |= WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING;
 
 	local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
@@ -1069,7 +1069,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	/* add one default STA interface if supported */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
-	    !(hw->flags & IEEE80211_HW_NO_AUTO_VIF)) {
+	    !ieee80211_hw_check(hw, NO_AUTO_VIF)) {
 		result = ieee80211_if_add(local, "wlan%d", NET_NAME_ENUM, NULL,
 					  NL80211_IFTYPE_STATION, NULL);
 		if (result)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 94274ef569fa..8848073a9056 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -118,7 +118,7 @@ void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata)
 	if (sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)
 		return;
 
-	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+	if (ieee80211_hw_check(&sdata->local->hw, CONNECTION_MONITOR))
 		return;
 
 	mod_timer(&sdata->u.mgd.bcn_mon_timer,
@@ -134,7 +134,7 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 
 	ifmgd->probe_send_count = 0;
 
-	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+	if (ieee80211_hw_check(&sdata->local->hw, CONNECTION_MONITOR))
 		return;
 
 	mod_timer(&sdata->u.mgd.conn_mon_timer,
@@ -677,7 +677,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		capab |= WLAN_CAPABILITY_PRIVACY;
 
 	if ((assoc_data->capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
-	    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
+	    ieee80211_hw_check(&local->hw, SPECTRUM_MGMT))
 		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
 
 	if (ifmgd->flags & IEEE80211_STA_ENABLE_RRM)
@@ -885,7 +885,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	drv_mgd_prepare_tx(local, sdata);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
 						IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_tx_skb(sdata, skb);
@@ -927,7 +927,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 					IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
 
-	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL)
@@ -1198,7 +1198,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	chanctx = container_of(conf, struct ieee80211_chanctx, conf);
 
 	if (local->use_chanctx &&
-	    !(local->hw.flags & IEEE80211_HW_CHANCTX_STA_CSA)) {
+	    !ieee80211_hw_check(&local->hw, CHANCTX_STA_CSA)) {
 		sdata_info(sdata,
 			   "driver doesn't support chan-switch with channel contexts\n");
 		goto drop_connection;
@@ -1407,15 +1407,15 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 		return;
 
 	if (conf->dynamic_ps_timeout > 0 &&
-	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)) {
+	    !ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS)) {
 		mod_timer(&local->dynamic_ps_timer, jiffies +
 			  msecs_to_jiffies(conf->dynamic_ps_timeout));
 	} else {
-		if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+		if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK))
 			ieee80211_send_nullfunc(local, sdata, 1);
 
-		if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
-		    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
+		if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) &&
+		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
 			return;
 
 		conf->flags |= IEEE80211_CONF_PS;
@@ -1474,7 +1474,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 	int count = 0;
 	int timeout;
 
-	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS)) {
+	if (!ieee80211_hw_check(&local->hw, SUPPORTS_PS)) {
 		local->ps_sdata = NULL;
 		return;
 	}
@@ -1620,7 +1620,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 	}
 
-	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
+	if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) &&
 	    !(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
 		if (drv_tx_frames_pending(local)) {
 			mod_timer(&local->dynamic_ps_timer, jiffies +
@@ -1633,8 +1633,8 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		}
 	}
 
-	if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
-	      (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) ||
+	if (!(ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS) &&
+	      ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK)) ||
 	    (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
@@ -2159,7 +2159,7 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 	ieee80211_recalc_ps(local, -1);
 	mutex_unlock(&local->iflist_mtx);
 
-	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+	if (ieee80211_hw_check(&sdata->local->hw, CONNECTION_MONITOR))
 		goto out;
 
 	/*
@@ -2257,7 +2257,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	 */
 	ifmgd->probe_send_count++;
 
-	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+	if (ieee80211_hw_check(&sdata->local->hw, REPORTS_TX_ACK_STATUS)) {
 		ifmgd->nullfunc_failed = false;
 		ieee80211_send_nullfunc(sdata->local, sdata, 0);
 	} else {
@@ -2562,7 +2562,7 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 		return;
 	auth_data->expected_transaction = 4;
 	drv_mgd_prepare_tx(sdata->local, sdata);
-	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
 		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
 			   IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_send_auth(sdata, 3, auth_data->algorithm, 0,
@@ -3337,7 +3337,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 		ifmgd->have_beacon = true;
 		ifmgd->assoc_data->need_beacon = false;
-		if (local->hw.flags & IEEE80211_HW_TIMING_BEACON_ONLY) {
+		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
 			sdata->vif.bss_conf.sync_tsf =
 				le64_to_cpu(mgmt->u.beacon.timestamp);
 			sdata->vif.bss_conf.sync_device_ts =
@@ -3443,7 +3443,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					  len - baselen, false, &elems,
 					  care_about_ies, ncrc);
 
-	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
+	if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK)) {
 		bool directed_tim = ieee80211_check_tim(elems.tim,
 							elems.tim_len,
 							ifmgd->aid);
@@ -3511,7 +3511,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	 * the driver will use them. The synchronized view is currently
 	 * guaranteed only in certain callbacks.
 	 */
-	if (local->hw.flags & IEEE80211_HW_TIMING_BEACON_ONLY) {
+	if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
 		sdata->vif.bss_conf.sync_tsf =
 			le64_to_cpu(mgmt->u.beacon.timestamp);
 		sdata->vif.bss_conf.sync_device_ts =
@@ -3749,7 +3749,7 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 			auth_data->expected_transaction = trans;
 		}
 
-		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
 			tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
 				   IEEE80211_TX_INTFL_MLME_CONN_TX;
 
@@ -3822,7 +3822,7 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 		   IEEE80211_ASSOC_MAX_TRIES);
 	ieee80211_send_assoc(sdata);
 
-	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
+	if (!ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 		assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
 		assoc_data->timeout_started = true;
 		run_again(sdata, assoc_data->timeout);
@@ -3936,7 +3936,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 		memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
 
-		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
 			max_tries = max_nullfunc_tries;
 		else
 			max_tries = max_probe_tries;
@@ -3961,7 +3961,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			}
 		} else if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(sdata, ifmgd->probe_timeout);
-		else if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+		else if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 			mlme_dbg(sdata,
 				 "Failed to send nullfunc to AP %pM after %dms, disconnecting\n",
 				 bssid, probe_wait_ms);
@@ -4030,14 +4030,11 @@ static void ieee80211_sta_monitor_work(struct work_struct *work)
 
 static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 {
-	u32 flags;
-
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		__ieee80211_stop_poll(sdata);
 
 		/* let's probe the connection once */
-		flags = sdata->local->hw.flags;
-		if (!(flags & IEEE80211_HW_CONNECTION_MONITOR))
+		if (!ieee80211_hw_check( &sdata->local->hw, CONNECTION_MONITOR))
 			ieee80211_queue_work(&sdata->local->hw,
 					     &sdata->u.mgd.monitor_work);
 		/* and do all the other regular work too */
@@ -4450,8 +4447,8 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 				sdata->vif.bss_conf.sync_dtim_count = tim_ie[2];
 			else
 				sdata->vif.bss_conf.sync_dtim_count = 0;
-		} else if (!(local->hw.flags &
-					IEEE80211_HW_TIMING_BEACON_ONLY)) {
+		} else if (!ieee80211_hw_check(&sdata->local->hw,
+					       TIMING_BEACON_ONLY)) {
 			ies = rcu_dereference(cbss->proberesp_ies);
 			/* must be non-NULL since beacon IEs were NULL */
 			sdata->vif.bss_conf.sync_tsf = ies->tsf;
@@ -4826,7 +4823,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 
 	if (WARN((sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_UAPSD) &&
-		 (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK),
+		 ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK),
 	     "U-APSD not supported with HW_PS_NULLFUNC_STACK\n"))
 		sdata->vif.driver_flags &= ~IEEE80211_VIF_SUPPORTS_UAPSD;
 
@@ -4907,7 +4904,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	rcu_read_lock();
 	beacon_ies = rcu_dereference(req->bss->beacon_ies);
 
-	if (sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC &&
+	if (ieee80211_hw_check(&sdata->local->hw, NEED_DTIM_BEFORE_ASSOC) &&
 	    !beacon_ies) {
 		/*
 		 * Wait up to one beacon interval ...
@@ -4934,7 +4931,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		assoc_data->timeout = jiffies;
 		assoc_data->timeout_started = true;
 
-		if (local->hw.flags & IEEE80211_HW_TIMING_BEACON_ONLY) {
+		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
 			sdata->vif.bss_conf.sync_tsf = beacon_ies->tsf;
 			sdata->vif.bss_conf.sync_device_ts =
 				bss->device_ts_beacon;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 683f0e3cb124..f2c75cf491fc 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -46,7 +46,7 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 	}
 
 	if (!local->offchannel_ps_enabled ||
-	    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
+	    !ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK))
 		/*
 		 * If power save was enabled, no need to send a nullfunc
 		 * frame because AP knows that we are sleeping. But if the
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index ac6ad6238e3a..06b60980c62c 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -23,7 +23,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	ieee80211_del_virtual_monitor(local);
 
-	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+	if (ieee80211_hw_check(hw, AMPDU_AGGREGATION)) {
 		mutex_lock(&local->sta_mtx);
 		list_for_each_entry(sta, &local->sta_list, list) {
 			set_sta_flag(sta, WLAN_STA_BLOCK_BA);
@@ -82,7 +82,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		if (err < 0) {
 			local->quiescing = false;
 			local->wowlan = false;
-			if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+			if (ieee80211_hw_check(hw, AMPDU_AGGREGATION)) {
 				mutex_lock(&local->sta_mtx);
 				list_for_each_entry(sta,
 						    &local->sta_list, list) {
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index de69adf24f53..36ba7c4f0283 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -680,7 +680,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 		info->control.rates[i].count = 0;
 	}
 
-	if (sdata->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
+	if (ieee80211_hw_check(&sdata->local->hw, HAS_RATE_CONTROL))
 		return;
 
 	if (ista) {
@@ -691,7 +691,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 		ref->ops->get_rate(ref->priv, NULL, NULL, txrc);
 	}
 
-	if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_RC_TABLE)
+	if (ieee80211_hw_check(&sdata->local->hw, SUPPORTS_RC_TABLE))
 		return;
 
 	ieee80211_get_tx_rates(&sdata->vif, ista, txrc->skb,
@@ -733,7 +733,7 @@ int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 	if (local->open_count)
 		return -EBUSY;
 
-	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) {
+	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
 		if (WARN_ON(!local->ops->set_rts_threshold))
 			return -EINVAL;
 		return 0;
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 7430a1df2ab1..543b67233535 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1070,7 +1070,7 @@ minstrel_ht_update_cck(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	if (sband->band != IEEE80211_BAND_2GHZ)
 		return;
 
-	if (!(mp->hw->flags & IEEE80211_HW_SUPPORTS_HT_CCK_RATES))
+	if (!ieee80211_hw_check(mp->hw, SUPPORTS_HT_CCK_RATES))
 		return;
 
 	mi->cck_supported = 0;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index aa35977a9c4d..93391d5f52e3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -52,7 +52,7 @@ static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
 					   struct sk_buff *skb,
 					   unsigned int rtap_vendor_space)
 {
-	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) {
+	if (ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS)) {
 		if (likely(skb->len > FCS_LEN))
 			__pskb_trim(skb, skb->len - FCS_LEN);
 		else {
@@ -110,7 +110,7 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 		len = ALIGN(len, 8);
 		len += 8;
 	}
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM))
 		len += 1;
 
 	/* antenna field, if we don't have per-chain info */
@@ -185,7 +185,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	}
 
 	mpdulen = skb->len;
-	if (!(has_fcs && (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)))
+	if (!(has_fcs && ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS)))
 		mpdulen += FCS_LEN;
 
 	rthdr = (struct ieee80211_radiotap_header *)skb_push(skb, rtap_len);
@@ -239,7 +239,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	}
 
 	/* IEEE80211_RADIOTAP_FLAGS */
-	if (has_fcs && (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS))
+	if (has_fcs && ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS))
 		*pos |= IEEE80211_RADIOTAP_F_FCS;
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
 		*pos |= IEEE80211_RADIOTAP_F_BADFCS;
@@ -289,7 +289,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	pos += 2;
 
 	/* IEEE80211_RADIOTAP_DBM_ANTSIGNAL */
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM &&
+	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM) &&
 	    !(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		*pos = status->signal;
 		rthdr->it_present |=
@@ -458,7 +458,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	 * the SKB because it has a bad FCS/PLCP checksum.
 	 */
 
-	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
+	if (ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS))
 		present_fcs_len = FCS_LEN;
 
 	/* ensure hdr->frame_control and vendor radiotap data are in skb head */
@@ -1197,7 +1197,7 @@ static void sta_ps_start(struct sta_info *sta)
 
 	atomic_inc(&ps->num_sta_ps);
 	set_sta_flag(sta, WLAN_STA_PS_STA);
-	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
+	if (!ieee80211_hw_check(&local->hw, AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_SLEEP, &sta->sta);
 	ps_dbg(sdata, "STA %pM aid %d enters power save mode\n",
 	       sta->sta.addr, sta->sta.aid);
@@ -1245,7 +1245,7 @@ int ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start)
 	struct sta_info *sta_inf = container_of(sta, struct sta_info, sta);
 	bool in_ps;
 
-	WARN_ON(!(sta_inf->local->hw.flags & IEEE80211_HW_AP_LINK_PS));
+	WARN_ON(!ieee80211_hw_check(&sta_inf->local->hw, AP_LINK_PS));
 
 	/* Don't let the same PS state be set twice */
 	in_ps = test_sta_flag(sta_inf, WLAN_STA_PS_STA);
@@ -1281,7 +1281,7 @@ ieee80211_rx_h_uapsd_and_pspoll(struct ieee80211_rx_data *rx)
 	 * uAPSD and PS-Poll frames (the latter shouldn't even come up from
 	 * it to mac80211 since they're handled.)
 	 */
-	if (sdata->local->hw.flags & IEEE80211_HW_AP_LINK_PS)
+	if (ieee80211_hw_check(&sdata->local->hw, AP_LINK_PS))
 		return RX_CONTINUE;
 
 	/*
@@ -1413,7 +1413,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	 * Change STA power saving mode only at the end of a frame
 	 * exchange sequence.
 	 */
-	if (!(sta->local->hw.flags & IEEE80211_HW_AP_LINK_PS) &&
+	if (!ieee80211_hw_check(&sta->local->hw, AP_LINK_PS) &&
 	    !ieee80211_has_morefrags(hdr->frame_control) &&
 	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
@@ -2542,7 +2542,7 @@ ieee80211_rx_h_mgmt_check(struct ieee80211_rx_data *rx)
 	    !(rx->flags & IEEE80211_RX_BEACON_REPORTED)) {
 		int sig = 0;
 
-		if (rx->local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+		if (ieee80211_hw_check(&rx->local->hw, SIGNAL_DBM))
 			sig = status->signal;
 
 		cfg80211_report_obss_beacon(rx->local->hw.wiphy,
@@ -2873,7 +2873,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 	 * it transmitted were processed or returned.
 	 */
 
-	if (rx->local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+	if (ieee80211_hw_check(&rx->local->hw, SIGNAL_DBM))
 		sig = status->signal;
 
 	if (cfg80211_rx_mgmt(&rx->sdata->wdev, status->freq, sig,
@@ -2938,7 +2938,7 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 			info->flags = IEEE80211_TX_CTL_TX_OFFCHAN |
 				      IEEE80211_TX_INTFL_OFFCHAN_TX_OK |
 				      IEEE80211_TX_CTL_NO_CCK_RATE;
-			if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
+			if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
 				info->hw_queue =
 					local->hw.offchannel_tx_hw_queue;
 		}
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 3eb121d2aa45..a4f662fbbb04 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -70,9 +70,9 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	enum nl80211_bss_scan_width scan_width;
 	s32 signal = 0;
 
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM))
 		signal = rx_status->signal * 100;
-	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
+	else if (ieee80211_hw_check(&local->hw, SIGNAL_UNSPEC))
 		signal = (rx_status->signal * 100) / local->hw.max_signal;
 
 	scan_width = NL80211_BSS_CHAN_WIDTH_20;
@@ -257,7 +257,7 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	if (test_bit(SCAN_HW_CANCELLED, &local->scanning))
 		return false;
 
-	if (local->hw.flags & IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS) {
+	if (ieee80211_hw_check(&local->hw, SINGLE_SCAN_ON_ALL_BANDS)) {
 		for (i = 0; i < req->n_channels; i++) {
 			local->hw_scan_req->req.channels[i] = req->channels[i];
 			bands_used |= BIT(req->channels[i]->band);
@@ -326,7 +326,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 		return;
 
 	if (hw_scan && !aborted &&
-	    !(local->hw.flags & IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS) &&
+	    !ieee80211_hw_check(&local->hw, SINGLE_SCAN_ON_ALL_BANDS) &&
 	    ieee80211_prep_hw_scan(local)) {
 		int rc;
 
@@ -520,7 +520,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 		local->hw_scan_ies_bufsize = local->scan_ies_len + req->ie_len;
 
-		if (local->hw.flags & IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS) {
+		if (ieee80211_hw_check(&local->hw, SINGLE_SCAN_ON_ALL_BANDS)) {
 			int i, n_bands = 0;
 			u8 bands_counted = 0;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index aec15d746aea..90468fd24492 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -265,7 +265,7 @@ static void sta_deliver_ps_frames(struct work_struct *wk)
 static int sta_prepare_rate_control(struct ieee80211_local *local,
 				    struct sta_info *sta, gfp_t gfp)
 {
-	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
+	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL))
 		return 0;
 
 	sta->rate_ctrl = local->rate_ctrl;
@@ -626,7 +626,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 	}
 
 	/* No need to do anything if the driver does all */
-	if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
+	if (ieee80211_hw_check(&local->hw, AP_LINK_PS))
 		return;
 
 	if (sta->dead)
@@ -1131,7 +1131,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	sta->driver_buffered_tids = 0;
 	sta->txq_buffered_tids = 0;
 
-	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
+	if (!ieee80211_hw_check(&local->hw, AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
 	if (sta->sta.txq[0]) {
@@ -1862,8 +1862,8 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->rx_beacon_signal_avg = ieee80211_ave_rssi(&sdata->vif);
 	}
 
-	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
-	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
+	if (ieee80211_hw_check(&sta->local->hw, SIGNAL_DBM) ||
+	    ieee80211_hw_check(&sta->local->hw, SIGNAL_UNSPEC)) {
 		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL))) {
 			sinfo->signal = (s8)sta->last_signal;
 			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
@@ -1915,7 +1915,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 		if (!(tidstats->filled &
 				BIT(NL80211_TID_STATS_TX_MSDU_RETRIES)) &&
-		    local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 			tidstats->filled |=
 				BIT(NL80211_TID_STATS_TX_MSDU_RETRIES);
 			tidstats->tx_msdu_retries = sta->tx_msdu_retries[i];
@@ -1923,7 +1923,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 		if (!(tidstats->filled &
 				BIT(NL80211_TID_STATS_TX_MSDU_FAILED)) &&
-		    local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 			tidstats->filled |=
 				BIT(NL80211_TID_STATS_TX_MSDU_FAILED);
 			tidstats->tx_msdu_failed = sta->tx_msdu_failed[i];
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 67c428735a51..45628f37c083 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -181,7 +181,7 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
-	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
 		sta->last_rx = jiffies;
 
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
@@ -414,8 +414,7 @@ static void ieee80211_tdls_td_tx_handle(struct ieee80211_local *local,
 
 	if (is_teardown) {
 		/* This mechanism relies on being able to get ACKs */
-		WARN_ON(!(local->hw.flags &
-			  IEEE80211_HW_REPORTS_TX_ACK_STATUS));
+		WARN_ON(!ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS));
 
 		/* Check if peer has ACKed */
 		if (flags & IEEE80211_TX_STAT_ACK) {
@@ -731,7 +730,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 					ieee80211_get_qos_ctl(hdr),
 					sta, true, acked);
 
-		if ((local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
+		if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL) &&
 		    (ieee80211_is_data(hdr->frame_control)) &&
 		    (rates_idx != -1))
 			sta->last_tx_rate = info->status.rates[rates_idx];
@@ -798,11 +797,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			ieee80211_frame_acked(sta, skb);
 
 		if ((sta->sdata->vif.type == NL80211_IFTYPE_STATION) &&
-		    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
+		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
 			ieee80211_sta_tx_notify(sta->sdata, (void *) skb->data,
 						acked, info->status.tx_time);
 
-		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 			if (info->flags & IEEE80211_TX_STAT_ACK) {
 				if (sta->lost_packets)
 					sta->lost_packets = 0;
@@ -853,7 +852,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
-	    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
+	    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS) &&
 	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
 	    local->ps_sdata && !(local->scanning)) {
 		if (info->flags & IEEE80211_TX_STAT_ACK) {
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 28298cc50326..ad31b2dab4f5 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -935,7 +935,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	 * packet through the AP.
 	 */
 	if ((action_code == WLAN_TDLS_TEARDOWN) &&
-	    (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
+	    ieee80211_hw_check(&sdata->local->hw, REPORTS_TX_ACK_STATUS)) {
 		bool try_resend; /* Should we keep skb for possible resend */
 
 		/* If not sending directly to peer - no point in keeping skb */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index dbef1b881b3d..82e1e8484593 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -211,11 +211,11 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	struct ieee80211_if_managed *ifmgd;
 
 	/* driver doesn't support power save */
-	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
+	if (!ieee80211_hw_check(&local->hw, SUPPORTS_PS))
 		return TX_CONTINUE;
 
 	/* hardware does dynamic power save */
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
+	if (ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS))
 		return TX_CONTINUE;
 
 	/* dynamic power save disabled */
@@ -431,7 +431,7 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	if (ieee80211_is_probe_req(hdr->frame_control))
 		return TX_CONTINUE;
 
-	if (tx->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
+	if (ieee80211_hw_check(&tx->local->hw, QUEUE_CONTROL))
 		info->hw_queue = tx->sdata->vif.cab_queue;
 
 	/* no stations in PS mode */
@@ -441,7 +441,7 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
 
 	/* device releases frame after DTIM beacon */
-	if (!(tx->local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING))
+	if (!ieee80211_hw_check(&tx->local->hw, HOST_BROADCAST_PS_BUFFERING))
 		return TX_CONTINUE;
 
 	/* buffered in mac80211 */
@@ -1185,8 +1185,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
 	    !ieee80211_is_qos_nullfunc(hdr->frame_control) &&
-	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) &&
-	    !(local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW)) {
+	    ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION) &&
+	    !ieee80211_hw_check(&local->hw, TX_AMPDU_SETUP_IN_HW)) {
 		struct tid_ampdu_tx *tid_tx;
 
 		qc = ieee80211_get_qos_ctl(hdr);
@@ -1429,7 +1429,7 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
 			vif = &sdata->vif;
 			info->hw_queue =
 				vif->hw_queue[skb_get_queue_mapping(skb)];
-		} else if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL) {
+		} else if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL)) {
 			dev_kfree_skb(skb);
 			return true;
 		} else
@@ -1475,7 +1475,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_check_control_port_protocol);
 	CALL_TXH(ieee80211_tx_h_select_key);
-	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
+	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
@@ -1490,7 +1490,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	/* handlers after fragment must be aware of tx info fragmentation! */
 	CALL_TXH(ieee80211_tx_h_stats);
 	CALL_TXH(ieee80211_tx_h_encrypt);
-	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
+	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
 		CALL_TXH(ieee80211_tx_h_calculate_duration);
 #undef CALL_TXH
 
@@ -1580,7 +1580,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 
 	/* set up hw_queue value early */
 	if (!(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) ||
-	    !(local->hw.flags & IEEE80211_HW_QUEUE_CONTROL))
+	    !ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
 		info->hw_queue =
 			sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
 
@@ -1607,7 +1607,7 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (skb_cloned(skb) &&
-	    (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CLONED_SKBS) ||
+	    (!ieee80211_hw_check(&local->hw, SUPPORTS_CLONED_SKBS) ||
 	     !skb_clone_writable(skb, ETH_HLEN) ||
 	     (may_encrypt && sdata->crypto_tx_tailroom_needed_cnt)))
 		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
@@ -2426,7 +2426,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	__le16 fc;
 
-	if (!(local->hw.flags & IEEE80211_HW_SUPPORT_FAST_XMIT))
+	if (!ieee80211_hw_check(&local->hw, SUPPORT_FAST_XMIT))
 		return;
 
 	/* Locking here protects both the pointer itself, and against concurrent
@@ -2442,8 +2442,8 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	 * cleared/changed already.
 	 */
 	spin_lock_bh(&sta->lock);
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PS &&
-	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS) &&
+	if (ieee80211_hw_check(&local->hw, SUPPORTS_PS) &&
+	    !ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS) &&
 	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		goto out;
 
@@ -2787,7 +2787,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (fast_tx->key)
 		info->control.hw_key = &fast_tx->key->conf;
 
-	if (!(local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)) {
+	if (!ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
 		tx.skb = skb;
 		r = ieee80211_tx_h_rate_ctrl(&tx);
 		skb = tx.skb;
@@ -3804,7 +3804,7 @@ int ieee80211_reserve_tid(struct ieee80211_sta *pubsta, u8 tid)
 	synchronize_net();
 
 	/* Tear down BA sessions so we stop aggregating on this TID */
-	if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+	if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION)) {
 		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 		__ieee80211_stop_tx_ba_session(sta, tid,
 					       AGG_STOP_LOCAL_REQUEST);
@@ -3818,7 +3818,7 @@ int ieee80211_reserve_tid(struct ieee80211_sta *pubsta, u8 tid)
 	ieee80211_wake_vif_queues(local, sdata,
 				  IEEE80211_QUEUE_STOP_REASON_RESERVE_TID);
 
-	if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
+	if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION))
 		clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 
 	ret = 0;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 79412f16b61d..79ded5783440 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -564,7 +564,7 @@ ieee80211_get_vif_queues(struct ieee80211_local *local,
 {
 	unsigned int queues;
 
-	if (sdata && local->hw.flags & IEEE80211_HW_QUEUE_CONTROL) {
+	if (sdata && ieee80211_hw_check(&local->hw, QUEUE_CONTROL)) {
 		int ac;
 
 		queues = 0;
@@ -592,7 +592,7 @@ void __ieee80211_flush_queues(struct ieee80211_local *local,
 	 * If no queue was set, or if the HW doesn't support
 	 * IEEE80211_HW_QUEUE_CONTROL - flush all queues
 	 */
-	if (!queues || !(local->hw.flags & IEEE80211_HW_QUEUE_CONTROL))
+	if (!queues || !ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
 		queues = ieee80211_get_vif_queues(local, sdata);
 
 	ieee80211_stop_queues_by_reason(&local->hw, queues,
@@ -2043,7 +2043,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 * about the sessions, but we and the AP still think they
 	 * are active. This is really a workaround though.
 	 */
-	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+	if (ieee80211_hw_check(hw, AMPDU_AGGREGATION)) {
 		mutex_lock(&local->sta_mtx);
 
 		list_for_each_entry(sta, &local->sta_list, list) {
-- 
2.1.4

