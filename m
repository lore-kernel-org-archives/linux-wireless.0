Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbXHSScc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:32:32 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:32:32 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 29/30] rt2x00: Lindent
Date: Sun, 19 Aug 2007 20:36:52 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192036.52287.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From f88ee9f3e67bd509f14e07f0dfcfe32649694e10 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 18:24:23 +0200
Subject: [PATCH 29/30] rt2x00: Lindent

Lindent still caught a few lines exceeding the 80 character limit,
a few reduntant spaces, and some other minor things.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    7 ++++---
 drivers/net/wireless/rt2x00/rt2500pci.c   |   10 +++++-----
 drivers/net/wireless/rt2x00/rt2500usb.c   |    7 +++----
 drivers/net/wireless/rt2x00/rt2x00.h      |   12 ++++++------
 drivers/net/wireless/rt2x00/rt2x00debug.c |   19 +++++++++++--------
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   14 +++++++-------
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c     |    6 +++---
 drivers/net/wireless/rt2x00/rt73usb.c     |    8 ++++----
 10 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 524f529..d3ac1c1 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1154,7 +1154,8 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_RTS_FRAME, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
-			   !!(control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT));
+			   !!(control->flags &
+			      IEEE80211_TXCTL_LONG_RETRY_LIMIT));
 	rt2x00_desc_write(txd, 0, word);
 }
 
@@ -1398,8 +1399,8 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Store led mode, for correct led behaviour.
 	 */
-	rt2x00dev->led_mode = rt2x00_get_field16(eeprom,
-						 EEPROM_ANTENNA_LED_MODE);
+	rt2x00dev->led_mode =
+	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	/*
 	 * Detect if this device has an hardware controlled radio.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index cc90597..b6f9266 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -625,8 +625,7 @@ static void rt2500pci_config(struct rt2x00_dev *rt2x00dev,
 	if (flags & CONFIG_UPDATE_CHANNEL)
 		rt2500pci_config_channel(rt2x00dev, conf->channel_val,
 					 conf->channel, conf->power_level);
-	if (!(flags & CONFIG_UPDATE_CHANNEL) &&
-	    flags & CONFIG_UPDATE_TXPOWER)
+	if ((flags & CONFIG_UPDATE_TXPOWER) && !(flags & CONFIG_UPDATE_CHANNEL))
 		rt2500pci_config_txpower(rt2x00dev, conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
 		rt2500pci_config_antenna(rt2x00dev, conf->antenna_sel_tx,
@@ -1282,7 +1281,8 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_OWNER, 1);
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
-			   !!(control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT));
+			   !!(control->flags &
+			      IEEE80211_TXCTL_LONG_RETRY_LIMIT));
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
@@ -1554,8 +1554,8 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Store led mode, for correct led behaviour.
 	 */
-	rt2x00dev->led_mode = rt2x00_get_field16(eeprom,
-						 EEPROM_ANTENNA_LED_MODE);
+	rt2x00dev->led_mode =
+	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	/*
 	 * Detect if this device has an hardware controlled radio.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index ba6c099..3c78a97 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -568,8 +568,7 @@ static void rt2500usb_config(struct rt2x00_dev *rt2x00dev,
 	if (flags & CONFIG_UPDATE_CHANNEL)
 		rt2500usb_config_channel(rt2x00dev, conf->channel_val,
 					 conf->channel, conf->power_level);
-	if (!(flags & CONFIG_UPDATE_CHANNEL) &&
-	    flags & CONFIG_UPDATE_TXPOWER)
+	if ((flags & CONFIG_UPDATE_TXPOWER) && !(flags & CONFIG_UPDATE_CHANNEL))
 		rt2500usb_config_txpower(rt2x00dev, conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
 		rt2500usb_config_antenna(rt2x00dev, conf->antenna_sel_tx,
@@ -1281,8 +1280,8 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Store led mode, for correct led behaviour.
 	 */
-	rt2x00dev->led_mode = rt2x00_get_field16(eeprom,
-						 EEPROM_ANTENNA_LED_MODE);
+	rt2x00dev->led_mode =
+	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_LED_MODE);
 
 	/*
 	 * Check if the BBP tuning should be disabled.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 24ad264..06738e4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -133,20 +133,20 @@
  */
 static inline int is_rts_frame(u16 fc)
 {
-	return !!(((fc &  IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
-		  ((fc &  IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_RTS));
+	return !!(((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
+		  ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_RTS));
 }
 
 static inline int is_cts_frame(u16 fc)
 {
-	return !!(((fc &  IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
-		  ((fc &  IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_CTS));
+	return !!(((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
+		  ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_CTS));
 }
 
 static inline int is_probe_resp(u16 fc)
 {
-	return !!(((fc &  IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-		  ((fc &  IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP));
+	return !!(((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+		  ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP));
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index c7b331c..eaa4c54 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -193,10 +193,11 @@ RT2X00DEBUGFS_OPS(eeprom, "0x%.4x\n", u16);
 RT2X00DEBUGFS_OPS(bbp, "0x%.2x\n", u8);
 RT2X00DEBUGFS_OPS(rf, "0x%.8x\n", u32);
 
-static struct dentry *
-rt2x00debug_create_file_driver(const char *name,
-			       struct rt2x00debug_intf *intf,
-			       struct debugfs_blob_wrapper *blob)
+static struct dentry *rt2x00debug_create_file_driver(const char *name,
+						     struct rt2x00debug_intf
+						     *intf,
+						     struct debugfs_blob_wrapper
+						     *blob)
 {
 	char *data;
 
@@ -213,10 +214,12 @@ rt2x00debug_create_file_driver(const char *name,
 	return debugfs_create_blob(name, S_IRUGO, intf->driver_folder, blob);
 }
 
-static struct dentry *
-rt2x00debug_create_file_chipset(const char *name,
-				struct rt2x00debug_intf *intf,
-				struct debugfs_blob_wrapper *blob)
+static struct dentry *rt2x00debug_create_file_chipset(const char *name,
+						      struct rt2x00debug_intf
+						      *intf,
+						      struct
+						      debugfs_blob_wrapper
+						      *blob)
 {
 	const struct rt2x00debug *debug = intf->debug;
 	char *data;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 75888ea..8c24797 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -222,7 +222,7 @@ static int rt2x00lib_calculate_link_signal(struct rt2x00_dev *rt2x00dev)
 		  (WEIGHT_TX * tx_percentage) +
 		  (WEIGHT_RX * rx_percentage)) / 100;
 
-	return (signal > 100) ? 100 :  signal;
+	return (signal > 100) ? 100 : signal;
 }
 
 static void rt2x00lib_link_tuner(struct work_struct *work)
@@ -338,7 +338,8 @@ void rt2x00lib_txdone(struct data_entry *entry,
 	 * else then we should cleanup the skb structure.
 	 */
 	if (tx_status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS)
-		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb, tx_status);
+		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb,
+					    tx_status);
 	else
 		dev_kfree_skb_any(entry->skb);
 
@@ -561,9 +562,9 @@ static void rt2x00lib_rate(struct ieee80211_rate *entry,
 {
 	entry->rate = rate;
 	entry->val =
-		DEVICE_SET_RATE_FIELD(rate, RATE) |
-		DEVICE_SET_RATE_FIELD(mask, RATEMASK) |
-		DEVICE_SET_RATE_FIELD(plcp, PLCP);
+	    DEVICE_SET_RATE_FIELD(rate, RATE) |
+	    DEVICE_SET_RATE_FIELD(mask, RATEMASK) |
+	    DEVICE_SET_RATE_FIELD(plcp, PLCP);
 	entry->flags = flags;
 	entry->val2 = entry->val;
 	if (entry->flags & IEEE80211_RATE_PREAMBLE2)
@@ -637,8 +638,7 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 			tx_power = spec->tx_power_default;
 
 		rt2x00lib_channel(&channels[i],
-				  spec->channels[i].channel,
-				  tx_power, i);
+				  spec->channels[i].channel, tx_power, i);
 	}
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 2b1b910..3ceb79d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -35,7 +35,8 @@
 #include "rt2x00lib.h"
 
 static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
-				struct data_ring *ring, struct sk_buff *frag_skb,
+				struct data_ring *ring,
+				struct sk_buff *frag_skb,
 				struct ieee80211_tx_control *control)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index c763606..03815b6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -50,7 +50,7 @@ int rt2x00usb_vendor_request(const struct rt2x00_dev *rt2x00dev,
 	unsigned int i;
 	unsigned int pipe =
 	    (requesttype == USB_VENDOR_REQUEST_IN) ?
-	     usb_rcvctrlpipe(usb_dev, 0) : usb_sndctrlpipe(usb_dev, 0);
+	    usb_rcvctrlpipe(usb_dev, 0) : usb_sndctrlpipe(usb_dev, 0);
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		status = usb_control_msg(usb_dev, pipe, request, requesttype,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0dacd59..0b4e757 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -688,8 +688,7 @@ static void rt61pci_config(struct rt2x00_dev *rt2x00dev,
 	if (flags & CONFIG_UPDATE_CHANNEL)
 		rt61pci_config_channel(rt2x00dev, conf->channel_val,
 				       conf->channel, conf->power_level);
-	if (!(flags & CONFIG_UPDATE_CHANNEL) &&
-	    flags & CONFIG_UPDATE_TXPOWER)
+	if ((flags & CONFIG_UPDATE_TXPOWER) && !(flags & CONFIG_UPDATE_CHANNEL))
 		rt61pci_config_txpower(rt2x00dev, conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
 		rt61pci_config_antenna(rt2x00dev, conf->antenna_sel_tx,
@@ -1532,7 +1531,8 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
-			   !!(control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT));
+			   !!(control->flags &
+			      IEEE80211_TXCTL_LONG_RETRY_LIMIT));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_BURST,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 7eb1f02..ed05e4b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -659,8 +659,7 @@ static void rt73usb_config(struct rt2x00_dev *rt2x00dev,
 	if (flags & CONFIG_UPDATE_CHANNEL)
 		rt73usb_config_channel(rt2x00dev, conf->channel_val,
 				       conf->channel, conf->power_level);
-	if (!(flags & CONFIG_UPDATE_CHANNEL) &&
-	    flags & CONFIG_UPDATE_TXPOWER)
+	if ((flags & CONFIG_UPDATE_TXPOWER) && !(flags & CONFIG_UPDATE_CHANNEL))
 		rt73usb_config_txpower(rt2x00dev, conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
 		rt73usb_config_antenna(rt2x00dev, conf->antenna_sel_tx,
@@ -925,7 +924,7 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 		buflen = min_t(int, len - i, CSR_CACHE_SIZE_FIRMWARE);
 		timeout = REGISTER_TIMEOUT * (buflen / sizeof(u32));
 
-		memcpy(cache, ptr ,buflen);
+		memcpy(cache, ptr, buflen);
 
 		rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
 					 USB_VENDOR_REQUEST_OUT,
@@ -1269,7 +1268,8 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
-			   !!(control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT));
+			   !!(control->flags &
+			      IEEE80211_TXCTL_LONG_RETRY_LIMIT));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_BURST2,
-- 
1.5.3.rc5

