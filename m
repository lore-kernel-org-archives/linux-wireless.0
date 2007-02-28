Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48611 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481AbXB1OHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:30 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562551nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:29 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/28] rt2x00: define MAX_RX_NOISE
Date: Wed, 28 Feb 2007 15:07:14 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.14996.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move max_noise value into a MAX_NOISE define.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 1db9eb2..038e384 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -2703,7 +2703,7 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
 	if (rt2x00dev->hw->max_rssi == 0x00 || rt2x00dev->hw->max_rssi == (s8)0xff)
 		rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->max_noise = -110;
+	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
index fc4a865..f4a51b1 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
@@ -53,6 +53,7 @@
  * Max RSSI value, required for RSSI <-> dBm conversion.
  */
 #define MAX_RX_SSI			120
+#define MAX_RX_NOISE			-110
 
 /*
  * Register layout information.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 1021663..483b1ba 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -2547,7 +2547,7 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
 	if (rt2x00dev->hw->max_rssi == 0x00 || rt2x00dev->hw->max_rssi == (s8)0xff)
 		rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->max_noise = -110;
+	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
index 7f97799..93e7b0d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
@@ -46,6 +46,7 @@
  * Max RSSI value, required for RSSI <-> dBm conversion.
  */
 #define MAX_RX_SSI			120
+#define MAX_RX_NOISE			-110
 
 /*
  * Register layout information.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 8a51a7d..3739c2f 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -3530,7 +3530,7 @@ static int rt61pci_init_hw(struct rt2x00_dev *rt2x00dev)
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom = 0;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->max_noise = -110;
+	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
 	num_modes = rt61pci_init_hw_modes(rt2x00dev);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
index 6db5e9c..12df048 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
@@ -46,6 +46,7 @@
  * Max RSSI value, required for RSSI <-> dBm conversion.
  */
 #define MAX_RX_SSI			120
+#define MAX_RX_NOISE			-110
 
 /*
  * Register layout information.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 10246dd..85ae23e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -3186,7 +3186,7 @@ static int rt73usb_init_hw(struct rt2x00_dev *rt2x00dev)
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom = 0;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->max_noise = -110;
+	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
 	num_modes = rt73usb_init_hw_modes(rt2x00dev);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
index 4f7d338..32c04f9 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
@@ -44,6 +44,7 @@
  * Max RSSI value, required for RSSI <-> dBm conversion.
  */
 #define MAX_RX_SSI			120
+#define MAX_RX_NOISE			-110
 
 /*
  * Register layout information.
