Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:50039 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZGJSnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 14:43:00 -0400
Received: by ewy26 with SMTP id 26so1303716ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 11:42:58 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Implement set_tim callback for all drivers
Date: Fri, 10 Jul 2009 20:42:55 +0200
Cc: Stefan Steuerwald <salsasepp@googlemail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907102042.56110.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stefan Steuerwald <salsasepp@googlemail.com>

Implement set_tim callback for all rt2x00 drivers, this makes the
device wake up powersaving stations properly while in AP mode.

The only way to update the beacon is by simply calling mac80211 and
requesting the new beacon. This means the set_tim() event is mostly the
same as a beacon_done() event which was already defined in rt2x00lib.

Signed-off-by: Stefan Steuerwald <salsasepp@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index d8035e3..30185ad 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1561,6 +1561,7 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
+	.set_tim		= rt2x00mac_set_tim,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2400pci_conf_tx,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index c123e28..3b31715 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1860,6 +1860,7 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
+	.set_tim		= rt2x00mac_set_tim,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 795706d..27e80d0 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1894,6 +1894,7 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
+	.set_tim		= rt2x00mac_set_tim,
 	.set_key		= rt2x00mac_set_key,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 372c632..5a675a6 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -3053,6 +3053,7 @@ static const struct ieee80211_ops rt2800pci_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
+	.set_tim		= rt2x00mac_set_tim,
 	.set_key		= rt2x00mac_set_key,
 	.get_stats		= rt2x00mac_get_stats,
 	.get_tkip_seq		= rt2800pci_get_tkip_seq,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index a204e66..66e001c 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2786,6 +2786,7 @@ static const struct ieee80211_ops rt2800usb_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
+	.set_tim		= rt2x00mac_set_tim,
 	.set_key		= rt2x00mac_set_key,
 	.get_stats		= rt2x00mac_get_stats,
 	.get_tkip_seq		= rt2800usb_get_tkip_seq,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index de3f13a..8a2a425 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -969,6 +969,8 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 				unsigned int changed_flags,
 				unsigned int *total_flags,
 				int mc_count, struct dev_addr_list *mc_list);
+int rt2x00mac_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		      bool set);
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
 int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		      struct ieee80211_vif *vif, struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index b7e0ddd..3425984 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -454,6 +454,16 @@ static void memcpy_tkip(struct rt2x00lib_crypto *crypto, u8 *key, u8 key_len)
 		       sizeof(crypto->rx_mic));
 }
 
+int rt2x00mac_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		      bool set)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	rt2x00lib_beacondone(rt2x00dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_set_tim);
+
 int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		      struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		      struct ieee80211_key_conf *key)
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 8a49d99..b435c14 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2716,6 +2716,7 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
+	.set_tim		= rt2x00mac_set_tim,
 	.set_key		= rt2x00mac_set_key,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ad2898c..4f9b177 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2241,6 +2241,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
 	.configure_filter	= rt2x00mac_configure_filter,
+	.set_tim		= rt2x00mac_set_tim,
 	.set_key		= rt2x00mac_set_key,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
