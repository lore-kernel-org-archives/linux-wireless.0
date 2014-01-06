Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbaAFVYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 16:24:41 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove channel_change_time
Date: Mon,  6 Jan 2014 22:24:36 +0100
Message-Id: <1389043476-6193-1-git-send-email-johannes@sipsolutions.net> (sfid-20140106_222445_458949_E5C4ADFB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This value is no longer used by mac80211, and practically no
driver ever set it to a correct value anyway, so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/adm8211.c                        |  1 -
 drivers/net/wireless/at76c50x-usb.c                   |  1 -
 drivers/net/wireless/ath/ath10k/mac.c                 |  1 -
 drivers/net/wireless/ath/ath5k/base.c                 |  1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c         |  1 -
 drivers/net/wireless/ath/ath9k/init.c                 |  1 -
 drivers/net/wireless/ath/carl9170/main.c              | 12 ------------
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |  1 -
 drivers/net/wireless/cw1200/main.c                    |  1 -
 drivers/net/wireless/mac80211_hwsim.c                 |  1 -
 drivers/net/wireless/mwl8k.c                          |  2 --
 drivers/net/wireless/p54/main.c                       |  1 -
 drivers/net/wireless/rtlwifi/base.c                   |  1 -
 drivers/net/wireless/ti/wl1251/main.c                 |  1 -
 drivers/net/wireless/ti/wlcore/main.c                 |  1 -
 drivers/staging/winbond/wbusb.c                       |  1 -
 include/net/mac80211.h                                |  3 ---
 17 files changed, 31 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index cfce83e..54afde0 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1866,7 +1866,6 @@ static int adm8211_probe(struct pci_dev *pdev,
 	dev->flags = IEEE80211_HW_SIGNAL_UNSPEC;
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
-	dev->channel_change_time = 1000;
 	dev->max_signal = 100;    /* FIXME: find better value */
 
 	dev->queues = 1; /* ADM8211C supports more, maybe ADM8211B too */
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 34c8a33..8cfd1d6 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -2112,7 +2112,6 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	priv->pm_period = 0;
 
 	/* unit us */
-	priv->hw->channel_change_time = 100000;
 
 	return priv;
 }
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ce9ef349..747c8bd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3704,7 +3704,6 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	ar->hw->vif_data_size = sizeof(struct ath10k_vif);
 
-	ar->hw->channel_change_time = 5000;
 	ar->hw->max_listen_interval = ATH10K_MAX_HW_LISTEN_INTERVAL;
 
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 69f58b0..fe6878b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2549,7 +2549,6 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 	hw->wiphy->available_antennas_rx = 0x3;
 
 	hw->extra_tx_headroom = 2;
-	hw->channel_change_time = 5000;
 
 	/*
 	 * Mark the device as detached to avoid processing
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index c3676bf..bcdb50a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -748,7 +748,6 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 	hw->queues = 4;
-	hw->channel_change_time = 5000;
 	hw->max_listen_interval = 1;
 
 	hw->vif_data_size = sizeof(struct ath9k_htc_vif);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 609b7e1..d878769 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -950,7 +950,6 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	hw->queues = 4;
 	hw->max_rates = 4;
-	hw->channel_change_time = 5000;
 	hw->max_listen_interval = 1;
 	hw->max_rate_tries = 10;
 	hw->sta_data_size = sizeof(struct ath_node);
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 349fa22..5ab68fd 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1968,18 +1968,6 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 		return -ENOMEM;
 	ar->num_channels = chans;
 
-	/*
-	 * I measured this, a bandswitch takes roughly
-	 * 135 ms and a frequency switch about 80.
-	 *
-	 * FIXME: measure these values again once EEPROM settings
-	 *	  are used, that will influence them!
-	 */
-	if (bands == 2)
-		ar->hw->channel_change_time = 135 * 1000;
-	else
-		ar->hw->channel_change_time = 80 * 1000;
-
 	regulatory->current_rd = le16_to_cpu(ar->eeprom.reg_domain[0]);
 
 	/* second part of wiphy init */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index e71ce8c..925034b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1071,7 +1071,6 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	hw->max_rates = 2;	/* Primary rate and 1 fallback rate */
 
 	/* channel change time is dependent on chip and band  */
-	hw->channel_change_time = 7 * 1000;
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				     BIT(NL80211_IFTYPE_AP) |
 				     BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/cw1200/main.c b/drivers/net/wireless/cw1200/main.c
index 090f015..1be819d 100644
--- a/drivers/net/wireless/cw1200/main.c
+++ b/drivers/net/wireless/cw1200/main.c
@@ -302,7 +302,6 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 
 	hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 
-	hw->channel_change_time = 1000;	/* TODO: find actual value */
 	hw->queues = 4;
 
 	priv->rts_threshold = -1;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ff48cea..4e94224 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2340,7 +2340,6 @@ static int __init init_mac80211_hwsim(void)
 		INIT_DELAYED_WORK(&data->roc_done, hw_roc_done);
 		INIT_DELAYED_WORK(&data->hw_scan, hw_scan_work);
 
-		hw->channel_change_time = 1;
 		hw->queues = 5;
 		hw->offchannel_tx_hw_queue = 4;
 		hw->wiphy->interface_modes =
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b953ad6..721c738 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5893,8 +5893,6 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 
 	hw->extra_tx_headroom -= priv->ap_fw ? REDUCED_TX_HEADROOM : 0;
 
-	hw->channel_change_time = 10;
-
 	hw->queues = MWL8K_TX_WMM_QUEUES;
 
 	/* Set rssi values to dBm */
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 067e6f2..b61fefa 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -757,7 +757,6 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 				      BIT(NL80211_IFTYPE_AP) |
 				      BIT(NL80211_IFTYPE_MESH_POINT);
 
-	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	priv->beacon_req_id = cpu_to_le32(0);
 	priv->tx_stats[P54_QUEUE_BEACON].limit = 1;
 	priv->tx_stats[P54_QUEUE_FWSCAN].limit = 1;
diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index fcf9b621..2cfb6d4 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -353,7 +353,6 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 
 	/* TODO: Correct this value for our hw */
 	/* TODO: define these hard code value */
-	hw->channel_change_time = 100;
 	hw->max_listen_interval = 10;
 	hw->max_rate_tries = 4;
 	/* hw->max_rates = 1; */
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 3291ffa..ee4ec4e 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1347,7 +1347,6 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 
 	/* unit us */
 	/* FIXME: find a proper value */
-	wl->hw->channel_change_time = 10000;
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_SUPPORTS_PS |
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index e9da47c..18a009e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5710,7 +5710,6 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 
 	/* unit us */
 	/* FIXME: find a proper value */
-	wl->hw->channel_change_time = 10000;
 	wl->hw->max_listen_interval = wl->conf.conn.max_listen_interval;
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 07891a3..0d29624 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -788,7 +788,6 @@ static int wb35_probe(struct usb_interface *intf,
 	dev->flags = IEEE80211_HW_SIGNAL_UNSPEC;
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
-	dev->channel_change_time = 1000;
 	dev->max_signal = 100;
 	dev->queues = 1;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f838af8..25b1887 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1616,8 +1616,6 @@ enum ieee80211_hw_flags {
  * @extra_beacon_tailroom: tailroom to reserve in each beacon tx skb.
  *	Can be used by drivers to add extra IEs.
  *
- * @channel_change_time: time (in microseconds) it takes to change channels.
- *
  * @max_signal: Maximum value for signal (rssi) in RX information, used
  *	only when @IEEE80211_HW_SIGNAL_UNSPEC or @IEEE80211_HW_SIGNAL_DB
  *
@@ -1699,7 +1697,6 @@ struct ieee80211_hw {
 	u32 flags;
 	unsigned int extra_tx_headroom;
 	unsigned int extra_beacon_tailroom;
-	int channel_change_time;
 	int vif_data_size;
 	int sta_data_size;
 	int chanctx_data_size;
-- 
1.8.5.1

