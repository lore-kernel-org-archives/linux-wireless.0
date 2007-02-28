Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48611 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbXB1OH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:26 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562551nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:25 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/28] rt2x00: Create rt2x00lib module
Date: Wed, 28 Feb 2007 15:07:12 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.13004.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create rt2x00lib module, this module contains all generic code
that is shared between the individual drivers. The following
patches will start using the code provided by rt2x00lib.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/Kconfig b/drivers/net/wireless/mac80211/rt2x00/Kconfig
index 491fe08..f793abe 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Kconfig
+++ b/drivers/net/wireless/mac80211/rt2x00/Kconfig
@@ -1,5 +1,5 @@
 config RT2X00
-	bool "Ralink driver support"
+	tristate "Ralink driver support"
 	depends on NET_RADIO && MAC80211 && EXPERIMENTAL
 	---help---
 	This will enable the experimental support for the Ralink drivers,
@@ -7,6 +7,10 @@ config RT2X00
 
 	These drivers will make use of the Devicescape ieee80211 stack.
 
+	This option will build the rt2x00 library which is required by
+	each individual driver, when compiled as a module,
+	this library will be called "rt2x00lib.ko".
+
 config RT2400PCI
 	tristate "Ralink rt2400 pci/pcmcia support"
 	depends on RT2X00 && PCI
diff --git a/drivers/net/wireless/mac80211/rt2x00/Makefile b/drivers/net/wireless/mac80211/rt2x00/Makefile
index df706c7..24837d5 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Makefile
+++ b/drivers/net/wireless/mac80211/rt2x00/Makefile
@@ -1,3 +1,4 @@
+obj-$(CONFIG_RT2X00)		+= rt2x00lib.o
 obj-$(CONFIG_RT2400PCI)		+= rt2400pci.o
 obj-$(CONFIG_RT2500PCI)		+= rt2500pci.o
 obj-$(CONFIG_RT61PCI)		+= rt61pci.o
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index e9ff871..06d8f2c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -48,6 +48,7 @@
 #define DRV_NAME "rt2400pci"
 
 #include "rt2x00.h"
+#include "rt2x00lib.h"
 #include "rt2x00pci.h"
 #include "rt2400pci.h"
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
index ab0bc97..6e20d42 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
@@ -28,11 +28,6 @@
 #define RT2400PCI_H
 
 /*
- * RT chip defines.
- */
-#define RT2460				0x0101
-
-/*
  * RF chip defines.
  */
 #define RF2420				0x0000
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 73551b3..3c388d3 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -48,6 +48,7 @@
 #define DRV_NAME "rt2500pci"
 
 #include "rt2x00.h"
+#include "rt2x00lib.h"
 #include "rt2x00pci.h"
 #include "rt2500pci.h"
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
index f4a51b1..faa1953 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
@@ -28,11 +28,6 @@
 #define RT2500PCI_H
 
 /*
- * RT chip defines.
- */
-#define RT2560				0x0201
-
-/*
  * RF chip defines.
  */
 #define RF2522				0x0000
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index c7ef5f8..9569875 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -44,6 +44,7 @@
 #define DRV_NAME "rt2500usb"
 
 #include "rt2x00.h"
+#include "rt2x00lib.h"
 #include "rt2x00usb.h"
 #include "rt2500usb.h"
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
index 93e7b0d..316bf3a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
@@ -28,11 +28,6 @@
 #define RT2500USB_H
 
 /*
- * RT chip defines.
- */
-#define RT2570				0x1201
-
-/*
  * RF chip defines.
  */
 #define RF2522				0x0000
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index ef84e1a..1b2a0fb 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -143,6 +143,11 @@ static int rt2x00_debug_level = 0;
 	     (((__fc) & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP)) )
 
 /*
+ * Link tuning at 1 second intervals
+ */
+#define LINK_TUNE_INTERVAL	( 1 * HZ )
+
+/*
  * TX result flags.
  */
 enum TX_STATUS {
@@ -446,6 +451,14 @@ static inline u16 rt2x00_get_field16(const u16 reg,
  */
 struct rt2x00_chip {
 	u16 rt;
+#define RT2460		0x0101
+#define RT2560		0x0201
+#define RT2570		0x1201
+#define RT2561		0x0301
+#define RT2561s		0x0302
+#define RT2661		0x0401
+#define RT73		0x1300
+
 	u16 rf;
 	u32 rev;
 	u8 fw_h;
@@ -680,6 +693,13 @@ static inline int rt2x00_ring_full(struct data_ring *ring)
 	return ring->stats.len == ring->stats.limit;
 }
 
+static inline int rt2x00_ring_free(struct data_ring *ring)
+{
+	if (ring->index_done >= ring->index)
+		return ring->index_done - ring->index;
+	return ring->stats.len - (ring->index - ring->index_done);
+}
+
 /*
  * To optimize the quality of the link we need to store
  * the quality of received frames and periodically
@@ -908,6 +928,48 @@ static inline int rt2x00_wait_scan(struct scanning *scan)
 }
 
 /*
+ * rt2x00lib callback functions.
+ */
+struct rt2x00lib_ops {
+	/*
+	 * Device initialization/deinitialization handlers.
+	 */
+	int (*initialize)(struct rt2x00_dev *rt2x00dev);
+	void (*uninitialize)(struct rt2x00_dev *rt2x00dev);
+
+	/*
+	 * Radio control handlers.
+	 */
+	int (*enable_radio)(struct rt2x00_dev *rt2x00dev);
+	void (*disable_radio)(struct rt2x00_dev *rt2x00dev);
+	void (*toggle_rx)(struct rt2x00_dev *rt2x00dev, int enable);
+
+	/*
+	 * TX control handlers
+	 */
+	int (*write_tx_data)(struct rt2x00_dev *rt2x00dev,
+		struct data_ring *ring, struct sk_buff *skb,
+		struct ieee80211_tx_control *control);
+	void (*kick_tx_queue)(struct rt2x00_dev *rt2x00dev, int queue);
+
+	/*
+	 * Configuration handlers.
+	 */
+	void (*config_type)(struct rt2x00_dev *rt2x00dev, int type);
+	void (*config_phymode)(struct rt2x00_dev *rt2x00dev, const int phy);
+	void (*config_channel)(struct rt2x00_dev *rt2x00dev, const int rf2,
+		const int channel, const int freq, const int txpower);
+	void (*config_mac_addr)(struct rt2x00_dev *rt2x00dev, u8 *mac);
+	void (*config_bssid)(struct rt2x00_dev *rt2x00dev, u8 *bssid);
+	void (*config_promisc)(struct rt2x00_dev *rt2x00dev, int promisc);
+	void (*config_txpower)(struct rt2x00_dev *rt2x00dev, int txpower);
+	void (*config_antenna)(struct rt2x00_dev *rt2x00dev,
+		int antenna_tx, int antenna_rx);
+	void (*config_duration)(struct rt2x00_dev *rt2x00dev,
+		int short_slot_time);
+};
+
+/*
  * rt2x00 device structure.
  */
 struct rt2x00_dev {
@@ -923,10 +985,20 @@ struct rt2x00_dev {
 #define rt2x00dev_usb(__dev)	( (struct usb_interface*)(__dev)->dev )
 
 	/*
+	 * Callback functions.
+	 */
+	const struct rt2x00lib_ops *lib_ops;
+	const struct ieee80211_ops *hw_ops;
+
+	/*
 	 * IEEE80211 control structure.
 	 */
 	struct ieee80211_hw *hw;
 	struct ieee80211_hw_mode *hwmodes;
+	unsigned int curr_hwmode;
+#define HWMODE_B	0
+#define HWMODE_G	1
+#define HWMODE_A	2
 
 	/*
 	 * Device flags.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00pci.h
index 62c9131..dd2d2b8 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00pci.h
@@ -36,9 +36,4 @@
 #define REGISTER_BUSY_COUNT	5
 #define REGISTER_BUSY_DELAY	100
 
-/*
- * Link tuning at 1 second intervals
- */
-#define LINK_TUNE_INTERVAL	( 1 * HZ )
-
 #endif /* RT2X00PCI_H */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h
index b4f2961..3b9242a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h
@@ -74,11 +74,6 @@
 #define USB_MODE_WAKEUP		0x09	/* RT73USB */
 
 /*
- * Link tuning at 1 second intervals
- */
-#define LINK_TUNE_INTERVAL	( 1 * HZ )
-
-/*
  * USB devices need an additional Beacon (guardian beacon) to be generated.
  */
 #undef BEACON_ENTRIES
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 9acae84..1142d5a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -50,6 +50,7 @@
 #define DRV_NAME "rt61pci"
 
 #include "rt2x00.h"
+#include "rt2x00lib.h"
 #include "rt2x00pci.h"
 #include "rt61pci.h"
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
index 12df048..a030e90 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
@@ -28,13 +28,6 @@
 #define RT61PCI_H
 
 /*
- * RT chip defines.
- */
-#define RT2561				0x0301
-#define RT2561s				0x0302
-#define RT2661				0x0401
-
-/*
  * RF chip defines.
  */
 #define RF5225				0x0001
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 98f6595..fe1aeba 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -46,6 +46,7 @@
 #define DRV_NAME "rt73usb"
 
 #include "rt2x00.h"
+#include "rt2x00lib.h"
 #include "rt2x00usb.h"
 #include "rt73usb.h"
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
index 32c04f9..dd32800 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
@@ -28,11 +28,6 @@
 #define RT73USB_H
 
 /*
- * RT chip defines.
- */
-#define RT73				0x1300
-
-/*
  * RF chip defines.
  */
 #define RF5226				0x0001
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c
new file mode 100644
index 0000000..33fd035
--- /dev/null
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.c
@@ -0,0 +1,739 @@
+/*
+	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00lib
+	Abstract: rt2x00 generic routines.
+	Supported chipsets: RT2460, RT2560, RT2570,
+	rt2561, rt2561s, rt2661 & rt2573.
+ */
+
+/*
+ * Set enviroment defines for rt2x00.h
+ */
+#define DRV_NAME "rt2x00lib"
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/netdevice.h>
+
+#include <net/mac80211.h>
+
+#include "rt2x00.h"
+#include "rt2x00lib.h"
+
+struct fw_entry {
+	u32	chip;
+	char	*name;
+};
+
+int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev, struct device *dev,
+	void (*cont)(const struct firmware *fw, void *context))
+{
+	unsigned int i;
+	int status = -EINVAL;
+	static const struct fw_entry fw_list[] = {
+		{ RT2561,	"rt2561.bin" },
+		{ RT2561s,	"rt2561s.bin" },
+		{ RT2661,	"rt2661.bin" },
+		{ RT73,		"rt73.bin" },
+	};
+
+	/*
+	 * Read correct firmware from harddisk.
+	 */
+	for (i = 0; i < ARRAY_SIZE(fw_list); i++) {
+		if (!rt2x00_rt(&rt2x00dev->chip, fw_list[i].chip))
+			continue;
+		status = request_firmware_nowait(THIS_MODULE,
+			FW_ACTION_HOTPLUG, fw_list[i].name, dev,
+			rt2x00dev, cont);
+	}
+
+	if (status)
+		ERROR("Failed to request Firmware.\n");
+
+	return status;
+
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_load_firmware);
+
+int rt2x00lib_load_firmware_wait(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+
+	for (i = 0; i < 150; i++) {
+		if (GET_FLAG(rt2x00dev, FIRMWARE_FAILED))
+			return -EIO;
+		if (GET_FLAG(rt2x00dev, FIRMWARE_LOADED))
+			return 0;
+		msleep(20);
+	}
+
+	ERROR("Firmware loading timed out.\n");
+	return -ETIMEDOUT;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_load_firmware_wait);
+
+void rt2x00lib_update_tx_stats(struct data_entry *entry,
+	const int status, const int is_ack, const int retry)
+{
+	struct ieee80211_low_level_stats *stats =
+		&entry->ring->rt2x00dev->low_level_stats;
+
+	entry->tx_status.flags = 0;
+	entry->tx_status.ack_signal = 0;
+	entry->tx_status.excessive_retries = (status == TX_FAIL_RETRY);
+	entry->tx_status.retry_count = retry;
+	if (is_ack)
+		entry->tx_status.flags |= IEEE80211_TX_STATUS_ACK;
+
+	entry->tx_status.queue_length = entry->ring->stats.limit;
+	entry->tx_status.queue_number = entry->tx_status.control.queue;
+
+	if (!is_ack && status == TX_FAIL_RETRY)
+		stats->dot11ACKFailureCount++;
+
+	if (entry->tx_status.control.flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+		if (status == TX_SUCCESS || status == TX_SUCCESS_RETRY)
+			stats->dot11RTSSuccessCount++;
+		else
+			stats->dot11RTSFailureCount++;
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_update_tx_stats);
+
+void rt2x00lib_update_rx_stats(struct rt2x00_dev *rt2x00dev,
+	const int signal, const int rssi, const int ofdm)
+{
+	struct ieee80211_hw_mode *mode;
+	struct ieee80211_rate *rate;
+	unsigned int i;
+	int val = 0;
+
+	mode = &rt2x00dev->hwmodes[rt2x00dev->curr_hwmode];
+	for (i = 0; i < mode->num_rates; i++) {
+		rate = &mode->rates[i];
+
+		/*
+		 * When frame was received with an OFDM bitrate,
+		 * the signal is the PLCP value. If it was received with
+		 * a CCK bitrate the signal is the rate in 0.5kbit/s.
+		 */
+		if (!ofdm)
+			val = DEVICE_GET_RATE_FIELD(rate->val, RATE);
+		else
+			val = DEVICE_GET_RATE_FIELD(rate->val, PLCP);
+
+		if (val == signal) {
+			/*
+			 * Check for preamble bit.
+			 */
+			if (signal & 0x08)
+				val = rate->val2;
+			val = rate->val;
+			break;
+		}
+	}
+
+	rt2x00dev->rx_status.rate = val;
+	rt2x00dev->rx_status.ssi = rssi;
+	rt2x00dev->rx_status.noise = rt2x00_get_link_noise(&rt2x00dev->link);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_update_rx_stats);
+
+int rt2x00lib_detect_channel_time(struct rt2x00_dev *rt2x00dev)
+{
+	struct ieee80211_hw_mode *mode;
+	unsigned long jiffies_start;
+	unsigned long jiffies_end;
+
+	/*
+	 * Only initialize the channel_change_time
+	 * if it has not been set previously.
+	 */
+	if (rt2x00dev->hw->channel_change_time)
+		return 0;
+
+	/*
+	 * Invalidate the rx_status.channel value to make sure
+	 * the config channel will be correctly executed.
+	 */
+	rt2x00dev->rx_status.channel = 0;
+
+	/*
+	 * Determine channel_change_time
+	 * by measuring the time it takes
+	 * to switch the channel.
+	 */
+	jiffies_start = jiffies;
+	mode = &rt2x00dev->hwmodes[rt2x00dev->curr_hwmode];
+	rt2x00dev->lib_ops->config_channel(rt2x00dev,
+		mode->channels[0].val,
+		mode->channels[0].chan,
+		mode->channels[0].freq,
+		mode->channels[0].power_level);
+	jiffies_end = jiffies;
+
+	rt2x00dev->hw->channel_change_time =
+		jiffies_to_usecs((long)jiffies_end - (long)jiffies_start);
+
+	NOTICE("Channel change time has been set to %d.\n",
+		rt2x00dev->hw->channel_change_time);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_detect_channel_time);
+
+static int rt2x00_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
+	struct data_ring *ring, struct sk_buff *frag_skb,
+	struct ieee80211_tx_control *control)
+{
+	struct sk_buff *skb;
+	int size;
+
+	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+		size = sizeof(struct ieee80211_cts);
+	else
+		size = sizeof(struct ieee80211_rts);
+
+	skb = dev_alloc_skb(size + rt2x00dev->hw->extra_tx_headroom);
+	if (!skb) {
+		WARNING("Failed to create RTS/CTS frame.\n");
+		return NETDEV_TX_BUSY;
+	}
+
+	skb_reserve(skb, rt2x00dev->hw->extra_tx_headroom);
+	skb_put(skb, size);
+
+	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+		ieee80211_ctstoself_get(rt2x00dev->hw,
+			frag_skb->data, frag_skb->len, control,
+			(struct ieee80211_cts*)(skb->data));
+	else
+		ieee80211_rts_get(rt2x00dev->hw,
+			frag_skb->data, frag_skb->len, control,
+			(struct ieee80211_rts*)(skb->data));
+
+	if (rt2x00dev->lib_ops->write_tx_data(rt2x00dev, ring, skb, control)) {
+		WARNING("Failed to send RTS/CTS frame.\n");
+		return NETDEV_TX_BUSY;
+	}
+
+	return NETDEV_TX_OK;
+}
+
+int rt2x00lib_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+	struct ieee80211_tx_control *control)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
+	struct data_ring *ring;
+	u16 frame_control;
+
+	/*
+	 * Determine which ring to put packet on.
+	 */
+	ring = rt2x00_get_ring(rt2x00dev, control->queue);
+	if (unlikely(!ring)) {
+		ERROR("Attempt to send packet over invalid queue %d.\n"
+			"Please file bug report to %s.\n",
+			control->queue, DRV_PROJECT);
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
+	/*
+	 * If CTS/RTS is required. and this frame is not CTS or RTS,
+	 * create and queue that frame first. But make sure we have
+	 * at least enough entries available to send this CTS/RTS
+	 * frame as well as the data frame.
+	 */
+	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
+	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS &&
+	    !is_cts_frame(frame_control) && !is_rts_frame(frame_control)) {
+		if (rt2x00_ring_free(ring) <= 1)
+			return NETDEV_TX_BUSY;
+
+		if (rt2x00_tx_rts_cts(rt2x00dev, ring, skb, control))
+			return NETDEV_TX_BUSY;
+	}
+
+	if (rt2x00dev->lib_ops->write_tx_data(rt2x00dev, ring, skb, control))
+		return NETDEV_TX_BUSY;
+
+	if (rt2x00dev->lib_ops->kick_tx_queue)
+		rt2x00dev->lib_ops->kick_tx_queue(rt2x00dev, control->queue);
+
+	return NETDEV_TX_OK;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_tx);
+
+int rt2x00lib_reset(struct ieee80211_hw *hw)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	rt2x00dev->lib_ops->disable_radio(rt2x00dev);
+	return rt2x00dev->lib_ops->enable_radio(rt2x00dev);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_reset);
+
+int rt2x00lib_add_interface(struct ieee80211_hw *hw,
+	struct ieee80211_if_init_conf *conf)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct interface *intf = &rt2x00dev->interface;
+	int status;
+
+	/*
+	 * We only support 1 non-monitor interface.
+	 */
+	if (conf->type != IEEE80211_IF_TYPE_MNTR &&
+	    GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+		return -ENOBUFS;
+
+	/*
+	 * We support muliple monitor mode interfaces.
+	 * All we need to do is increase the monitor_count.
+	 */
+	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
+		intf->monitor_count++;
+	} else {
+		intf->id = conf->if_id;
+		intf->type = conf->type;
+		if (conf->type == IEEE80211_IF_TYPE_AP)
+			memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
+		intf->promisc = 0;
+	}
+
+	/*
+	 * Initialize interface, and enable the radio when this
+	 * is the first interface that is brought up.
+	 */
+	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
+		/*
+		 * Before doing anything else, the MAC address
+		 * of this device should be initialized correctly.
+		 */
+		rt2x00dev->lib_ops->config_mac_addr(rt2x00dev, conf->mac_addr);
+
+		/*
+		 * Initialize the device.
+		 */
+		status = rt2x00dev->lib_ops->initialize(rt2x00dev);
+		if (status)
+			return status;
+
+		/*
+		 * Enable radio.
+		 */
+		status = rt2x00dev->lib_ops->enable_radio(rt2x00dev);
+		if (status)
+			return status;
+	}
+
+	/*
+	 * Enable periodic link tuning if this is a non-monitor
+	 * interface. Also set the INTERFACE_INITIALIZED FLAG
+	 * to prevent new non-monitor interfaces to be added.
+	 */
+	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
+		queue_delayed_work(rt2x00dev->workqueue,
+			&rt2x00dev->link.work, LINK_TUNE_INTERVAL);
+		SET_FLAG(rt2x00dev, INTERFACE_INITIALIZED);
+	} else
+		SET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_add_interface);
+
+void rt2x00lib_remove_interface(struct ieee80211_hw *hw,
+	struct ieee80211_if_init_conf *conf)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct interface *intf = &rt2x00dev->interface;
+
+	/*
+	 * We only support 1 non-monitor interface.
+	 */
+	if (conf->type != IEEE80211_IF_TYPE_MNTR &&
+	    !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+		return;
+
+	/*
+	 * We support muliple monitor mode interfaces.
+	 * All we need to do is decrease the monitor_count.
+	 */
+	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
+		intf->monitor_count--;
+	} else if (intf->type == conf->type) {
+		intf->id = 0;
+		intf->type = -EINVAL;
+		memset(&intf->bssid, 0x00, ETH_ALEN);
+		intf->promisc = 0;
+	}
+
+	/*
+	 * When this is a non-monitor mode,
+	 * stop the periodic link tuning,
+	 * and clear the INTERFACE_INITIALIZED FLAG to allow
+	 * new non-monitor interfaces to be added.
+	 */
+	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
+		if (work_pending(&rt2x00dev->link.work.work))
+			cancel_rearming_delayed_workqueue(
+				rt2x00dev->workqueue, &rt2x00dev->link.work);
+		CLEAR_FLAG(rt2x00dev, INTERFACE_INITIALIZED);
+	}
+
+	/*
+	 * Disable radio if this was the last interface
+	 * that was working with this device.
+	 */
+	if (!GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
+	    !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+		rt2x00dev->lib_ops->disable_radio(rt2x00dev);
+
+	/*
+	 * Check if we still have 1 non-monitor or a monitor
+	 * interface enabled. In that case we should update the
+	 * registers.
+	 */
+	if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) ^
+	    GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED)) {
+		if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+			rt2x00dev->lib_ops->config_type(rt2x00dev,
+				rt2x00dev->interface.type);
+		else
+			rt2x00dev->lib_ops->config_type(rt2x00dev,
+				IEEE80211_IF_TYPE_MNTR);
+	}
+
+	/*
+	 * Check which interfaces have been disabled.
+	 */
+	if (!GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+		CLEAR_FLAG(rt2x00dev, INTERFACE_ENABLED);
+	else if (!rt2x00dev->interface.monitor_count)
+		CLEAR_FLAG(rt2x00dev, INTERFACE_ENABLED_MONITOR);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_remove_interface);
+
+int rt2x00lib_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	/*
+	 * Check if we need to disable the radio,
+	 * if this is not the case, at least the RX must be disabled.
+	 */
+	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
+		if (!conf->radio_enabled)
+			rt2x00dev->lib_ops->disable_radio(rt2x00dev);
+		else {
+			rt2x00dev->lib_ops->toggle_rx(rt2x00dev, 0);
+		}
+	}
+
+	rt2x00dev->lib_ops->config_phymode(rt2x00dev, conf->phymode);
+	rt2x00dev->lib_ops->config_channel(rt2x00dev,
+		conf->channel_val, conf->channel, conf->freq,
+		conf->power_level);
+	rt2x00dev->lib_ops->config_txpower(rt2x00dev, conf->power_level);
+	rt2x00dev->lib_ops->config_antenna(rt2x00dev,
+		conf->antenna_sel_tx, conf->antenna_sel_rx);
+	rt2x00dev->lib_ops->config_duration(rt2x00dev,
+		(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME));
+
+	/*
+	 * Reenable RX only if the radio should be on.
+	 */
+	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
+		rt2x00dev->lib_ops->toggle_rx(rt2x00dev, 1);
+	} else if (conf->radio_enabled)
+		return rt2x00dev->lib_ops->enable_radio(rt2x00dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_config);
+
+int rt2x00lib_config_interface(struct ieee80211_hw *hw, int if_id,
+	struct ieee80211_if_conf *conf)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	/*
+	 * Monitor mode does not need configuring.
+	 * If the given type does not match the configured type,
+	 * there has been a problem.
+	 */
+	if (conf->type == IEEE80211_IF_TYPE_MNTR)
+		return 0;
+	else if (conf->type != rt2x00dev->interface.type)
+		return -EINVAL;
+
+	/*
+	 * If the interface does not work in master mode,
+	 * then the bssid value in the interface structure
+	 * should now be set.
+	 */
+	if (conf->type != IEEE80211_IF_TYPE_AP)
+		memcpy(&rt2x00dev->interface.bssid, conf->bssid, ETH_ALEN);
+
+	/*
+	 * Enable configuration.
+	 */
+	rt2x00dev->lib_ops->config_type(rt2x00dev, conf->type);
+	rt2x00dev->lib_ops->config_bssid(rt2x00dev, conf->bssid);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_config_interface);
+
+void rt2x00lib_set_multicast_list(struct ieee80211_hw *hw,
+	unsigned short flags, int mc_count)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	int update = 0;
+
+	if (GET_FLAG(rt2x00dev, INTERFACE_ENABLED_PROMISC)) {
+		if (!(flags & IFF_PROMISC)) {
+			rt2x00dev->interface.promisc = 0;
+			update = 1;
+		}
+	} else {
+		if (flags & IFF_PROMISC) {
+			rt2x00dev->interface.promisc = 1;
+			update = 1;
+		}
+	}
+
+	/*
+	 * Monitor mode works with PROMISC mode forced on,
+	 * so there is nothing to be done here in that case.
+	 */
+	if (update && !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR)) {
+		if (rt2x00dev->lib_ops->config_promisc)
+			rt2x00dev->lib_ops->config_promisc(rt2x00dev,
+				rt2x00dev->interface.promisc);
+		else
+			NOTICE("For the moment promisc mode is ignored");
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_set_multicast_list);
+
+static void rt2x00lib_scan(struct work_struct *work)
+{
+	struct scanning *scan =
+		container_of(work, struct scanning, work);
+
+	if (unlikely(!scan->rt2x00dev))
+		return;
+
+	/*
+	 * Before we can start switch the channel for scanning
+	 * we need to wait until all TX rings are empty to guarantee
+	 * that all frames are send on the correct channel.
+	 * Check if the status is set SCANNING_WAITING in order to
+	 * start waiting, or if it is set to SCANNING_CANCELLED which
+	 * means that we shouldn't proceed with the scanning.
+	 */
+	if (scan->status == SCANNING_WAITING)
+		wait_for_completion(&scan->completion);
+	if (scan->status == SCANNING_CANCELLED)
+		goto exit;
+
+	/*
+	 * Switch channel and update active info for RX.
+	 */
+	if (scan->state == IEEE80211_SCAN_START) {
+		scan->rt2x00dev->lib_ops->config_phymode(
+			scan->rt2x00dev,
+			scan->conf.scan_phymode);
+
+		scan->rt2x00dev->lib_ops->config_channel(
+			scan->rt2x00dev,
+			scan->conf.scan_channel_val,
+			scan->conf.scan_channel,
+			scan->conf.scan_freq,
+			scan->conf.scan_power_level);
+	} else {
+		scan->rt2x00dev->lib_ops->config_phymode(
+			scan->rt2x00dev,
+			scan->conf.running_phymode);
+
+		scan->rt2x00dev->lib_ops->config_channel(
+			scan->rt2x00dev,
+			scan->conf.running_channel_val,
+			scan->conf.running_channel,
+			scan->conf.running_freq,
+			scan->conf.scan_power_level);
+	}
+
+exit:
+	scan->rt2x00dev->scan = NULL;
+	kfree(scan);
+}
+
+int rt2x00lib_passive_scan(struct ieee80211_hw *hw,
+	int state, struct ieee80211_scan_conf *conf)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	/*
+	 * Check if we are not busy with the previous
+	 * passive scan request.
+	 */
+	if (rt2x00dev->scan)
+		return -EBUSY;
+
+	/*
+	 * Check if the radio is enabled.
+	 */
+	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
+		return -EIO;
+
+	/*
+	 * Allocate scanning structure to store scanning info.
+	 */
+	rt2x00dev->scan = kzalloc(sizeof(struct scanning), GFP_ATOMIC);
+	if (!rt2x00dev->scan)
+		return -ENOMEM;
+
+	/*
+	 * Initialize Scanning structure.
+	 */
+	rt2x00dev->scan->rt2x00dev = rt2x00dev;
+	rt2x00dev->scan->state = state;
+	memcpy(&rt2x00dev->scan->conf, conf, sizeof(*conf));
+
+	/*
+	 * Initialize completion handler.
+	 * Set initial status to SCANNING_WAITING to prevent scanning
+	 * to begin while there are still TX packets queued.
+	 */
+	init_completion(&rt2x00dev->scan->completion);
+	rt2x00dev->scan->status = SCANNING_WAITING;
+
+	/*
+	 * Check if we have to send a packet before the
+	 * channel switch.
+	 */
+	if (conf->skb) {
+		if (rt2x00dev->hw_ops->tx(hw, conf->skb, conf->tx_control))
+			goto exit;
+	}
+
+	/*
+	 * Queue work.
+	 */
+	INIT_WORK(&rt2x00dev->scan->work, rt2x00lib_scan);
+	if (!queue_work(rt2x00dev->workqueue, &rt2x00dev->scan->work))
+		goto exit;
+
+	return 0;
+
+exit:
+	kfree(rt2x00dev->scan);
+	rt2x00dev->scan = NULL;
+
+	return -EIO;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_passive_scan);
+
+int rt2x00lib_get_tx_stats(struct ieee80211_hw *hw,
+	struct ieee80211_tx_queue_stats *stats)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	unsigned int i;
+
+	for (i = 0; i < hw->queues; i++)
+		memcpy(&stats->data[i], &rt2x00dev->ring[i].stats,
+			sizeof(rt2x00dev->ring[i].stats));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_get_tx_stats);
+
+int rt2x00lib_conf_tx(struct ieee80211_hw *hw, int queue,
+	const struct ieee80211_tx_queue_params *params)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct data_ring *ring;
+
+	ring = rt2x00_get_ring(rt2x00dev, queue);
+	if (unlikely(!ring))
+		return -EINVAL;
+
+	/*
+	 * The passed variables are stored as real value ((2^n)-1).
+	 * RT2500 registers require to know the bit number 'n'.
+	 */
+	if (params->cw_min)
+		ring->tx_params.cw_min = fls(params->cw_min);
+	else
+		ring->tx_params.cw_min = 5; /* cw_min: 2^5 = 32. */
+
+	if (params->cw_max)
+		ring->tx_params.cw_max = fls(params->cw_max);
+	else
+		ring->tx_params.cw_max = 10; /* cw_min: 2^10 = 1024. */
+
+	if (params->aifs)
+		ring->tx_params.aifs = params->aifs;
+	else
+		ring->tx_params.aifs = 2;
+
+	INFO("Configured TX ring %d - CWmin: %d, CWmax: %d, Aifs: %d.\n",
+		queue, ring->tx_params.cw_min, ring->tx_params.cw_max,
+		ring->tx_params.aifs);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_conf_tx);
+
+/*
+ * rt2x00lib module information.
+ */
+static char version[] =
+	DRV_NAME " - " DRV_VERSION " (" DRV_RELDATE ") by " DRV_PROJECT;
+
+MODULE_AUTHOR(DRV_PROJECT);
+MODULE_VERSION(DRV_VERSION);
+MODULE_DESCRIPTION("rt2x00 library");
+MODULE_LICENSE("GPL");
+
+static int __init rt2x00lib_init(void)
+{
+	printk(KERN_INFO "Loading module: %s.\n", version);
+	return 0;
+}
+
+static void __exit rt2x00lib_exit(void)
+{
+	printk(KERN_INFO "Unloading module: %s.\n", version);
+}
+
+module_init(rt2x00lib_init);
+module_exit(rt2x00lib_exit);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
new file mode 100644
index 0000000..5ec88a6
--- /dev/null
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
@@ -0,0 +1,63 @@
+/*
+	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00lib
+	Abstract: Data structures for the rt2x00lib module.
+	Supported chipsets: RT2460, RT2560, RT2570,
+	rt2561, rt2561s, rt2661 & rt2573.
+ */
+
+#ifndef RT2X00LIB_H
+#define RT2X00LIB_H
+
+#include <linux/firmware.h>
+
+int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev, struct device *dev,
+	void (*cont)(const struct firmware *fw, void *context));
+int rt2x00lib_load_firmware_wait(struct rt2x00_dev *rt2x00dev);
+
+void rt2x00lib_update_tx_stats(struct data_entry *entry,
+	const int status, const int is_ack, const int retry);
+void rt2x00lib_update_rx_stats(struct rt2x00_dev *rt2x00dev,
+	const int signal, const int rssi, const int ofdm);
+
+int rt2x00lib_detect_channel_time(struct rt2x00_dev *rt2x00dev);
+
+int rt2x00lib_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+	struct ieee80211_tx_control *control);
+int rt2x00lib_reset(struct ieee80211_hw *hw);
+int rt2x00lib_add_interface(struct ieee80211_hw *hw,
+	struct ieee80211_if_init_conf *conf);
+void rt2x00lib_remove_interface(struct ieee80211_hw *hw,
+	struct ieee80211_if_init_conf *conf);
+int rt2x00lib_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
+int rt2x00lib_config_interface(struct ieee80211_hw *hw, int if_id,
+	struct ieee80211_if_conf *conf);
+void rt2x00lib_set_multicast_list(struct ieee80211_hw *hw,
+	unsigned short flags, int mc_count);
+int rt2x00lib_passive_scan(struct ieee80211_hw *hw,
+	int state, struct ieee80211_scan_conf *conf);
+int rt2x00lib_get_tx_stats(struct ieee80211_hw *hw,
+	struct ieee80211_tx_queue_stats *stats);
+int rt2x00lib_conf_tx(struct ieee80211_hw *hw, int queue,
+	const struct ieee80211_tx_queue_params *params);
+
+#endif /* RT2X00LIB_H */
