Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41261 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab0GKKb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:31:57 -0400
Received: by eya25 with SMTP id 25so426224eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:31:55 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/17] rt2x00: Disable link tuning while scanning
Date: Sun, 11 Jul 2010 12:24:47 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111223.51704.IvDoorn@gmail.com> <201007111224.23529.IvDoorn@gmail.com>
In-Reply-To: <201007111224.23529.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111224.48247.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While scanning the link tuner must be disabled. Otherwise
it will interfere with receiving all beacons for each channel
due to changing sensitivity levels.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c  |    2 ++
 drivers/net/wireless/rt2x00/rt2500pci.c  |    2 ++
 drivers/net/wireless/rt2x00/rt2500usb.c  |    2 ++
 drivers/net/wireless/rt2x00/rt2800lib.c  |    2 ++
 drivers/net/wireless/rt2x00/rt2x00.h     |    3 +++
 drivers/net/wireless/rt2x00/rt2x00link.c |   12 +++++++++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c  |   24 +++++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt61pci.c    |    2 ++
 drivers/net/wireless/rt2x00/rt73usb.c    |    2 ++
 9 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 5d5047f..d5f1fab 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1567,6 +1567,8 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
 	.set_tim		= rt2x00mac_set_tim,
+	.sw_scan_start		= rt2x00mac_sw_scan_start,
+	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2400pci_conf_tx,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 1d4758a..096d6db 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1864,6 +1864,8 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
 	.set_tim		= rt2x00mac_set_tim,
+	.sw_scan_start		= rt2x00mac_sw_scan_start,
+	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 6e48a15..0b7888d 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1755,6 +1755,8 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.configure_filter	= rt2x00mac_configure_filter,
 	.set_tim		= rt2x00mac_set_tim,
 	.set_key		= rt2x00mac_set_key,
+	.sw_scan_start		= rt2x00mac_sw_scan_start,
+	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 255d089..bcf50fc 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2896,6 +2896,8 @@ const struct ieee80211_ops rt2800_mac80211_ops = {
 	.configure_filter	= rt2x00mac_configure_filter,
 	.set_tim		= rt2x00mac_set_tim,
 	.set_key		= rt2x00mac_set_key,
+	.sw_scan_start		= rt2x00mac_sw_scan_start,
+	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
 	.get_stats		= rt2x00mac_get_stats,
 	.get_tkip_seq		= rt2800_get_tkip_seq,
 	.set_rts_threshold	= rt2800_set_rts_threshold,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 42f4661..bf5e3f3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -628,6 +628,7 @@ enum rt2x00_flags {
 	DEVICE_STATE_INITIALIZED,
 	DEVICE_STATE_STARTED,
 	DEVICE_STATE_ENABLED_RADIO,
+	DEVICE_STATE_SCANNING,
 
 	/*
 	 * Driver requirements
@@ -1081,6 +1082,8 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 #else
 #define rt2x00mac_set_key	NULL
 #endif /* CONFIG_RT2X00_LIB_CRYPTO */
+void rt2x00mac_sw_scan_start(struct ieee80211_hw *hw);
+void rt2x00mac_sw_scan_complete(struct ieee80211_hw *hw);
 int rt2x00mac_get_stats(struct ieee80211_hw *hw,
 			struct ieee80211_low_level_stats *stats);
 void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 801925b..14f1d51 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -278,6 +278,15 @@ void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00dev->intf_sta_count)
 		return;
 
+	/**
+	 * While scanning, link tuning is disabled. By default
+	 * the most sensitive settings will be used to make sure
+	 * that all beacons and probe responses will be recieved
+	 * during the scan.
+	 */
+	if (test_bit(DEVICE_STATE_SCANNING, &rt2x00dev->flags))
+		return;
+
 	rt2x00link_reset_tuner(rt2x00dev, false);
 
 	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
@@ -338,7 +347,8 @@ static void rt2x00link_tuner(struct work_struct *work)
 	 * When the radio is shutting down we should
 	 * immediately cease all link tuning.
 	 */
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags) ||
+	    test_bit(DEVICE_STATE_SCANNING, &rt2x00dev->flags))
 		return;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 3b838c0..bbce496 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -347,9 +347,11 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	/*
 	 * Some configuration parameters (e.g. channel and antenna values) can
 	 * only be set when the radio is enabled, but do require the RX to
-	 * be off.
+	 * be off. During this period we should keep link tuning enabled,
+	 * if for any reason the link tuner must be reset, this will be
+	 * handled by rt2x00lib_config().
 	 */
-	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
+	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF_LINK);
 
 	/*
 	 * When we've just turned on the radio, we want to reprogram
@@ -367,7 +369,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	rt2x00lib_config_antenna(rt2x00dev, rt2x00dev->default_ant);
 
 	/* Turn RX back on */
-	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
+	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON_LINK);
 
 	return 0;
 }
@@ -540,6 +542,22 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 EXPORT_SYMBOL_GPL(rt2x00mac_set_key);
 #endif /* CONFIG_RT2X00_LIB_CRYPTO */
 
+void rt2x00mac_sw_scan_start(struct ieee80211_hw *hw)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	__set_bit(DEVICE_STATE_SCANNING, &rt2x00dev->flags);
+	rt2x00link_stop_tuner(rt2x00dev);
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_sw_scan_start);
+
+void rt2x00mac_sw_scan_complete(struct ieee80211_hw *hw)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	__clear_bit(DEVICE_STATE_SCANNING, &rt2x00dev->flags);
+	rt2x00link_start_tuner(rt2x00dev);
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_sw_scan_complete);
+
 int rt2x00mac_get_stats(struct ieee80211_hw *hw,
 			struct ieee80211_low_level_stats *stats)
 {
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index ee84536..fe7bce7 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2784,6 +2784,8 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.configure_filter	= rt2x00mac_configure_filter,
 	.set_tim		= rt2x00mac_set_tim,
 	.set_key		= rt2x00mac_set_key,
+	.sw_scan_start		= rt2x00mac_sw_scan_start,
+	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt61pci_conf_tx,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 156f5d3..9ea6a67 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2229,6 +2229,8 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.configure_filter	= rt2x00mac_configure_filter,
 	.set_tim		= rt2x00mac_set_tim,
 	.set_key		= rt2x00mac_set_key,
+	.sw_scan_start		= rt2x00mac_sw_scan_start,
+	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt73usb_conf_tx,
-- 
1.7.1.1

