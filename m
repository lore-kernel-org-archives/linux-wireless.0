Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:43912 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbXDNSNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2007 14:13:47 -0400
Date: Sat, 14 Apr 2007 13:14:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mac80211 - drivers: Convert drivers that use mac80211 to new statistics variable names
Message-ID: <46211a11.o2MyXN/RwAenmIMD%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 3/4: Convert drivers that use 80211 to new stats variable names.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
@@ -3757,8 +3757,8 @@ static int bcm43xx_wireless_init(struct 
 		    IEEE80211_HW_MONITOR_DURING_OPER |
 		    IEEE80211_HW_DEVICE_HIDES_WEP |
 		    IEEE80211_HW_WEP_INCLUDE_IV;
-	hw->max_signal = -110;
-	hw->max_rssi = BCM43xx_RX_MAX_SSI;
+	hw->max_qual = 100;
+	hw->max_level = BCM43xx_RX_MAX_LEVEL;
 	hw->max_noise = -110;
 	hw->queues = 1;
 	SET_IEEE80211_DEV(hw, dev->dev);
Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
@@ -456,7 +456,7 @@ void bcm43xx_rx(struct bcm43xx_wldev *de
 	u16 phystat0, phystat3, chanstat, mactime;
 	u32 macstat;
 	u16 chanid;
-	u8 jssi;
+	u8 qual;
 	int padding;
 
 	memset(&status, 0, sizeof(status));
@@ -464,7 +464,7 @@ void bcm43xx_rx(struct bcm43xx_wldev *de
 	/* Get metadata about the frame from the header. */
 	phystat0 = le16_to_cpu(rxhdr->phy_status0);
 	phystat3 = le16_to_cpu(rxhdr->phy_status3);
-	jssi = rxhdr->jssi;
+	qual = rxhdr->jssi;
 	macstat = le32_to_cpu(rxhdr->mac_status);
 	mactime = le16_to_cpu(rxhdr->mac_time);
 	chanstat = le16_to_cpu(rxhdr->channel);
@@ -525,12 +525,12 @@ void bcm43xx_rx(struct bcm43xx_wldev *de
 		}
 	}
 
-	status.signal = bcm43xx_rssi_postprocess(dev, jssi,
+	status.level = bcm43xx_rssi_postprocess(dev, qual,
 					      (phystat0 & BCM43xx_RX_PHYST0_OFDM),
 					      (phystat0 & BCM43xx_RX_PHYST0_GAINCTL),
 					      (phystat3 & BCM43xx_RX_PHYST3_TRSTATE));
 	status.noise = dev->stats.link_noise;
-	status.ssi = jssi;
+	status.qual = qual;
 	if (phystat0 & BCM43xx_RX_PHYST0_OFDM)
 		status.rate = bcm43xx_plcp_get_bitrate_ofdm(plcp);
 	else
Index: wireless-dev/drivers/net/wireless/mac80211/adm8211/adm8211.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/adm8211/adm8211.c
+++ wireless-dev/drivers/net/wireless/mac80211/adm8211/adm8211.c
@@ -65,7 +65,7 @@ ADM8211_IER_TDUIE | ADM8211_IER_GPTIE)
 #define PLCP_SIGNAL_5M5		0x37
 #define PLCP_SIGNAL_11M		0x6e
 
-#define ADM8211_RX_MAX_SSI	100
+#define ADM8211_RX_MAX_LEVEL	100
 
 struct adm8211_tx_hdr {
 	u8 da[6];
@@ -540,9 +540,9 @@ static void adm8211_interrupt_rci(struct
 			struct ieee80211_rx_status rx_status = {0};
 
 			if (priv->revid < ADM8211_REV_CA)
-				rx_status.ssi = rssi;
+				rx_status.level = rssi;
 			else
-				rx_status.ssi = 100 - rssi;
+				rx_status.level = 100 - rssi;
 
 			if (rate <= 4)
 				rx_status.rate = rate_tbl[rate];
@@ -2002,7 +2002,7 @@ static int __devinit adm8211_probe(struc
 	// however, IEEE80211_HW_RX_INCLUDES_FCS in promisc mode
 
 	dev->channel_change_time = 1000;
-	dev->max_rssi = ADM8211_RX_MAX_SSI;// FIXME - This is an approximation
+	dev->max_level = ADM8211_RX_MAX_LEVEL;// FIXME - This is an approximation
 
 	priv->modes[0].mode = MODE_IEEE80211B;
 	/* channel info filled in by adm8211_read_eeprom */
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -1751,7 +1751,7 @@ static void rt2500pci_rxdone(struct work
 		 * Update link statistics
 		 */
 		rt2x00_update_link_rssi(&rt2x00dev->link,
-			rt2x00dev->rx_status.ssi);
+			rt2x00dev->rx_status.level);
 
 skip_entry:
 		rt2x00_set_field32(&word0, RXD_W0_OWNER_NIC, 1);
@@ -2195,10 +2195,10 @@ static int rt2500pci_init_eeprom(struct 
 	 * Read the RSSI <-> dBm offset information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
-	rt2x00dev->hw->max_rssi =
+	rt2x00dev->hw->max_level =
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
-	if (rt2x00dev->hw->max_rssi < 0 || rt2x00dev->hw->max_rssi == (s8)0xff)
-		rt2x00dev->hw->max_rssi = MAX_RX_SSI;
+	if (rt2x00dev->hw->max_level < 0 || rt2x00dev->hw->max_level == (s8)0xff)
+		rt2x00dev->hw->max_level = MAX_RX_LEVEL;
 
 	return 0;
 }
@@ -2533,7 +2533,7 @@ static int rt2500pci_init_hw(struct rt2x
 		IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom = 0;
-	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
+	rt2x00dev->hw->max_level = MAX_RX_LEVEL;
 	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1711,7 +1711,7 @@ static void rt2500usb_interrupt_rxdone(s
 	/*
 	 * Update link statistics
 	 */
-	rt2x00_update_link_rssi(&rt2x00dev->link, rt2x00dev->rx_status.ssi);
+	rt2x00_update_link_rssi(&rt2x00dev->link, rt2x00dev->rx_status.level);
 
 skip_entry:
 	if (!GET_FLAG(ring->rt2x00dev, DEVICE_ENABLED_RADIO))
@@ -2040,10 +2040,10 @@ static int rt2500usb_init_eeprom(struct 
 	 * Read the RSSI <-> dBm offset information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
-	rt2x00dev->hw->max_rssi =
+	rt2x00dev->hw->max_level =
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
-	if (rt2x00dev->hw->max_rssi < 0 || rt2x00dev->hw->max_rssi == (s8)0xff)
-		rt2x00dev->hw->max_rssi = MAX_RX_SSI;
+	if (rt2x00dev->hw->max_level < 0 || rt2x00dev->hw->max_level == (s8)0xff)
+		rt2x00dev->hw->max_level = MAX_RX_LEVEL;
 
 	return 0;
 }
@@ -2377,7 +2377,7 @@ static int rt2500usb_init_hw(struct rt2x
 		IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
-	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
+	rt2x00dev->hw->max_level = MAX_RX_LEVEL;
 	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
@@ -157,7 +157,7 @@ void rt2x00lib_update_rx_stats(struct rt
 	}
 
 	rt2x00dev->rx_status.rate = val;
-	rt2x00dev->rx_status.ssi = rssi;
+	rt2x00dev->rx_status.level = rssi;
 	rt2x00dev->rx_status.noise = rt2x00_get_link_noise(&rt2x00dev->link);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_update_rx_stats);
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -2045,7 +2045,7 @@ static void rt61pci_rxdone(struct work_s
 		 * Update link statistics
 		 */
 		rt2x00_update_link_rssi(&rt2x00dev->link,
-			rt2x00dev->rx_status.ssi);
+			rt2x00dev->rx_status.level);
 
 skip_entry:
 		rt2x00_set_field32(&word0, RXD_W0_OWNER_NIC, 1);
@@ -2874,7 +2874,7 @@ static int rt61pci_init_hw(struct rt2x00
 		IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom = 0;
-	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
+	rt2x00dev->hw->max_level = MAX_RX_LEVEL;
 	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1857,7 +1857,7 @@ static void rt73usb_interrupt_rxdone(str
 	/*
 	 * Update link statistics
 	 */
-	rt2x00_update_link_rssi(&rt2x00dev->link, rt2x00dev->rx_status.ssi);
+	rt2x00_update_link_rssi(&rt2x00dev->link, rt2x00dev->rx_status.level);
 
 skip_entry:
 	if (!GET_FLAG(ring->rt2x00dev, DEVICE_ENABLED_RADIO))
@@ -2577,7 +2577,7 @@ static int rt73usb_init_hw(struct rt2x00
 		IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
-	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
+	rt2x00dev->hw->max_level = MAX_RX_LEVEL;
 	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
Index: wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
+++ wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
@@ -161,8 +161,8 @@ static void rtl8187_rx_cb(struct urb *ur
 	}
 
 	rx_status.antenna = (hdr->signal >> 7) & 1;
-	rx_status.signal = 64 - min(hdr->noise, (u8)64);
-	rx_status.ssi = signal;
+	rx_status.qual = 64 - min(hdr->noise, (u8)64);
+	rx_status.level = signal;
 	rx_status.rate = priv->rates[rate].rate;
 	rx_status.freq = dev->conf.freq;
 	rx_status.channel = dev->conf.channel;
@@ -608,8 +608,8 @@ static int __devinit rtl8187_probe(struc
 		     IEEE80211_HW_DATA_NULLFUNC_ACK;
 	dev->extra_tx_headroom = sizeof(struct rtl8187_tx_hdr);
 	dev->queues = 1;
-	dev->max_rssi = 65;
-	dev->max_signal = 64;
+	dev->max_level = 65;
+	dev->max_qual = 64;
 
 	for (i = 0; i < 2; i++)
 		if ((err = ieee80211_register_hwmode(dev, &priv->modes[i])))
Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -407,8 +407,8 @@ static int fill_rx_stats(struct ieee8021
 	stats->channel = _zd_chip_get_channel(&mac->chip);
 	stats->freq = zd_channels[stats->channel - 1].freq;
 	stats->phymode = MODE_IEEE80211G;
-	stats->ssi = zd_rx_strength_percent(status->signal_strength);
-	stats->signal = zd_rx_qual_percent(buffer,
+	stats->level = zd_rx_strength_percent(status->signal_strength);
+	stats->qual = zd_rx_qual_percent(buffer,
 		                          length - sizeof(struct rx_status),
 		                          status);
 	stats->rate = zd_rx_rate(buffer, status);
@@ -453,7 +453,7 @@ static int filter_ack(struct ieee80211_h
 	if (control) {
 		memcpy(&status.control, control, sizeof(status.control));
 		status.flags = IEEE80211_TX_STATUS_ACK;
-		status.ack_signal = stats->ssi;
+		status.ack_signal = stats->level;
 		ieee80211_tx_status_irqsafe(dev, skb, &status);
 		kfree(control);
 	} else
@@ -633,8 +633,8 @@ struct ieee80211_hw *zd_mac_alloc(struct
 
 	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_WEP_INCLUDE_IV;
-	dev->max_rssi = 100;
-	dev->max_signal = 100;
+	dev->max_level = 100;
+	dev->max_qual = 100;
 
 	dev->queues = 1;
 	dev->extra_tx_headroom = sizeof(struct zd_ctrlset);
Index: wireless-dev/drivers/net/wireless/mac80211/p54/prism54common.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/p54/prism54common.c
+++ wireless-dev/drivers/net/wireless/mac80211/p54/prism54common.c
@@ -282,7 +282,7 @@ static void p54_rx_data(struct ieee80211
 	struct ieee80211_rx_status rx_status = {0};
 	u16 freq = le16_to_cpu(hdr->freq);
 
-	rx_status.ssi = hdr->rssi;	/* TODO: check this */
+	rx_status.level = hdr->rssi;	/* TODO: check this */
 	rx_status.rate = hdr->rate & 0x0f;
 	rx_status.channel = freq == 2484 ? 14 : (freq - 2407)/5;
 	rx_status.freq = freq;
@@ -782,7 +782,7 @@ struct ieee80211_hw *p54_init_common(siz
 		    IEEE80211_HW_DATA_NULLFUNC_ACK; /* TODO: check */
 		    /* IEEE80211_HW_MONITOR_DURING_OPER FIXME: check */
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
-	dev->max_rssi = 100;
+	dev->max_level = 100;
 
 	dev->queues = 1;
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx.h
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx.h
@@ -29,7 +29,7 @@
 
 #define BCM43xx_IO_SIZE			8192
 
-#define BCM43xx_RX_MAX_SSI		60
+#define BCM43xx_RX_MAX_LEVEL		60
 
 /* MMIO offsets */
 #define BCM43xx_MMIO_DMA0_REASON	0x20
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -2236,7 +2236,7 @@ static int rt2400pci_init_hw(struct rt2x
 		IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom = 0;
-	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
+	rt2x00dev->hw->max_level = MAX_RX_LEVEL;
 	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
@@ -36,7 +36,7 @@
 /*
  * Max RSSI value, required for RSSI <-> dBm conversion.
  */
-#define MAX_RX_SSI			100
+#define MAX_RX_LEVEL			100
 #define MAX_RX_NOISE			-110
 
 /*
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
@@ -47,7 +47,7 @@
 /*
  * Max RSSI value, required for RSSI <-> dBm conversion.
  */
-#define MAX_RX_SSI			120
+#define MAX_RX_LEVEL			120
 #define MAX_RX_NOISE			-110
 
 /*
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
@@ -40,7 +40,7 @@
 /*
  * Max RSSI value, required for RSSI <-> dBm conversion.
  */
-#define MAX_RX_SSI			120
+#define MAX_RX_LEVEL			120
 #define MAX_RX_NOISE			-110
 
 /*
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
@@ -38,7 +38,7 @@
 /*
  * Max RSSI value, required for RSSI <-> dBm conversion.
  */
-#define MAX_RX_SSI			120
+#define MAX_RX_LEVEL			120
 #define MAX_RX_NOISE			-110
 
 /*
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
@@ -38,7 +38,7 @@
 /*
  * Max RSSI value, required for RSSI <-> dBm conversion.
  */
-#define MAX_RX_SSI			120
+#define MAX_RX_LEVEL			120
 #define MAX_RX_NOISE			-110
 
 /*
Index: wireless-dev/net/mac80211/ieee80211_ioctl.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c
@@ -1591,7 +1591,7 @@ static int ieee80211_ioctl_giwrange(stru
 	range->max_encoding_tokens = NUM_DEFAULT_KEYS;
 
 	range->max_qual.qual = local->hw.max_qual;
-	range->max_qual.level = local->hw.max_rssi;
+	range->max_qual.level = local->hw.max_level;
 	range->max_qual.noise = local->hw.max_noise;
 	range->max_qual.updated = local->wstats_flags;
 
