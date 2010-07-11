Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36634 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab0GKKcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:08 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so640223ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:07 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/17] rt2x00: Use separate mac80211_ops for rt2800pci and rt2800usb
Date: Sun, 11 Jul 2010 12:28:54 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111227.58927.IvDoorn@gmail.com> <201007111228.24393.IvDoorn@gmail.com>
In-Reply-To: <201007111228.24393.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111228.56050.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Use separate mac80211_ops for rt2800pci and rt2800usb in preparation
for further fixes. This shouldn't introduce functional changes.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   48 +++++++++----------------------
 drivers/net/wireless/rt2x00/rt2800lib.h |   10 ++++++-
 drivers/net/wireless/rt2x00/rt2800pci.c |   24 +++++++++++++++-
 drivers/net/wireless/rt2x00/rt2800usb.c |   24 +++++++++++++++-
 4 files changed, 69 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 5572732..64bfa6e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2740,8 +2740,8 @@ EXPORT_SYMBOL_GPL(rt2800_probe_hw_mode);
 /*
  * IEEE80211 stack callback functions.
  */
-static void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx,
-				u32 *iv32, u16 *iv16)
+void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx, u32 *iv32,
+			 u16 *iv16)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct mac_iveiv_entry iveiv_entry;
@@ -2754,8 +2754,9 @@ static void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx,
 	memcpy(iv16, &iveiv_entry.iv[0], sizeof(*iv16));
 	memcpy(iv32, &iveiv_entry.iv[4], sizeof(*iv32));
 }
+EXPORT_SYMBOL_GPL(rt2800_get_tkip_seq);
 
-static int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
+int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	u32 reg;
@@ -2791,9 +2792,10 @@ static int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rt2800_set_rts_threshold);
 
-static int rt2800_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
-			  const struct ieee80211_tx_queue_params *params)
+int rt2800_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
+		   const struct ieee80211_tx_queue_params *params)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct data_queue *queue;
@@ -2858,8 +2860,9 @@ static int rt2800_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rt2800_conf_tx);
 
-static u64 rt2800_get_tsf(struct ieee80211_hw *hw)
+u64 rt2800_get_tsf(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	u64 tsf;
@@ -2872,12 +2875,11 @@ static u64 rt2800_get_tsf(struct ieee80211_hw *hw)
 
 	return tsf;
 }
+EXPORT_SYMBOL_GPL(rt2800_get_tsf);
 
-static int rt2800_ampdu_action(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       enum ieee80211_ampdu_mlme_action action,
-			       struct ieee80211_sta *sta,
-			       u16 tid, u16 *ssn)
+int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			enum ieee80211_ampdu_mlme_action action,
+			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	int ret = 0;
 
@@ -2901,29 +2903,7 @@ static int rt2800_ampdu_action(struct ieee80211_hw *hw,
 
 	return ret;
 }
-
-const struct ieee80211_ops rt2800_mac80211_ops = {
-	.tx			= rt2x00mac_tx,
-	.start			= rt2x00mac_start,
-	.stop			= rt2x00mac_stop,
-	.add_interface		= rt2x00mac_add_interface,
-	.remove_interface	= rt2x00mac_remove_interface,
-	.config			= rt2x00mac_config,
-	.configure_filter	= rt2x00mac_configure_filter,
-	.set_tim		= rt2x00mac_set_tim,
-	.set_key		= rt2x00mac_set_key,
-	.sw_scan_start		= rt2x00mac_sw_scan_start,
-	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
-	.get_stats		= rt2x00mac_get_stats,
-	.get_tkip_seq		= rt2800_get_tkip_seq,
-	.set_rts_threshold	= rt2800_set_rts_threshold,
-	.bss_info_changed	= rt2x00mac_bss_info_changed,
-	.conf_tx		= rt2800_conf_tx,
-	.get_tsf		= rt2800_get_tsf,
-	.rfkill_poll		= rt2x00mac_rfkill_poll,
-	.ampdu_action		= rt2800_ampdu_action,
-};
-EXPORT_SYMBOL_GPL(rt2800_mac80211_ops);
+EXPORT_SYMBOL_GPL(rt2800_ampdu_action);
 
 MODULE_AUTHOR(DRV_PROJECT ", Bartlomiej Zolnierkiewicz");
 MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index eb3a4f5..10f8f2f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -159,6 +159,14 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev);
 int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev);
 int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev);
 
-extern const struct ieee80211_ops rt2800_mac80211_ops;
+void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx, u32 *iv32,
+			 u16 *iv16);
+int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
+int rt2800_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
+		   const struct ieee80211_tx_queue_params *params);
+u64 rt2800_get_tsf(struct ieee80211_hw *hw);
+int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			enum ieee80211_ampdu_mlme_action action,
+			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 
 #endif /* RT2800LIB_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index c0c38f9..4c138eb 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1088,6 +1088,28 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
+static const struct ieee80211_ops rt2800pci_mac80211_ops = {
+	.tx			= rt2x00mac_tx,
+	.start			= rt2x00mac_start,
+	.stop			= rt2x00mac_stop,
+	.add_interface		= rt2x00mac_add_interface,
+	.remove_interface	= rt2x00mac_remove_interface,
+	.config			= rt2x00mac_config,
+	.configure_filter	= rt2x00mac_configure_filter,
+	.set_tim		= rt2x00mac_set_tim,
+	.set_key		= rt2x00mac_set_key,
+	.sw_scan_start		= rt2x00mac_sw_scan_start,
+	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
+	.get_stats		= rt2x00mac_get_stats,
+	.get_tkip_seq		= rt2800_get_tkip_seq,
+	.set_rts_threshold	= rt2800_set_rts_threshold,
+	.bss_info_changed	= rt2x00mac_bss_info_changed,
+	.conf_tx		= rt2800_conf_tx,
+	.get_tsf		= rt2800_get_tsf,
+	.rfkill_poll		= rt2x00mac_rfkill_poll,
+	.ampdu_action		= rt2800_ampdu_action,
+};
+
 static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.irq_handler		= rt2800pci_interrupt,
 	.irq_handler_thread	= rt2800pci_interrupt_thread,
@@ -1152,7 +1174,7 @@ static const struct rt2x00_ops rt2800pci_ops = {
 	.tx			= &rt2800pci_queue_tx,
 	.bcn			= &rt2800pci_queue_bcn,
 	.lib			= &rt2800pci_rt2x00_ops,
-	.hw			= &rt2800_mac80211_ops,
+	.hw			= &rt2800pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 	.debugfs		= &rt2800_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index df78e28..f8eb6d7 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -645,6 +645,28 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
+static const struct ieee80211_ops rt2800usb_mac80211_ops = {
+	.tx			= rt2x00mac_tx,
+	.start			= rt2x00mac_start,
+	.stop			= rt2x00mac_stop,
+	.add_interface		= rt2x00mac_add_interface,
+	.remove_interface	= rt2x00mac_remove_interface,
+	.config			= rt2x00mac_config,
+	.configure_filter	= rt2x00mac_configure_filter,
+	.set_tim		= rt2x00mac_set_tim,
+	.set_key		= rt2x00mac_set_key,
+	.sw_scan_start		= rt2x00mac_sw_scan_start,
+	.sw_scan_complete	= rt2x00mac_sw_scan_complete,
+	.get_stats		= rt2x00mac_get_stats,
+	.get_tkip_seq		= rt2800_get_tkip_seq,
+	.set_rts_threshold	= rt2800_set_rts_threshold,
+	.bss_info_changed	= rt2x00mac_bss_info_changed,
+	.conf_tx		= rt2800_conf_tx,
+	.get_tsf		= rt2800_get_tsf,
+	.rfkill_poll		= rt2x00mac_rfkill_poll,
+	.ampdu_action		= rt2800_ampdu_action,
+};
+
 static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.probe_hw		= rt2800usb_probe_hw,
 	.get_firmware_name	= rt2800usb_get_firmware_name,
@@ -708,7 +730,7 @@ static const struct rt2x00_ops rt2800usb_ops = {
 	.tx			= &rt2800usb_queue_tx,
 	.bcn			= &rt2800usb_queue_bcn,
 	.lib			= &rt2800usb_rt2x00_ops,
-	.hw			= &rt2800_mac80211_ops,
+	.hw			= &rt2800usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 	.debugfs		= &rt2800_rt2x00debug,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
-- 
1.7.1.1

