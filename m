Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:52757 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbYDCQBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 12:01:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add more N-PHY stuff
Date: Thu, 3 Apr 2008 18:01:12 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804031801.12711.mb@bu3sch.de> (sfid-20080403_170149_063233_05B56AAB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds some minor stuff for N-PHY support. Nothing special.
Adds Analog switching and some TODOs for RSSI processing.
Just a patch I had floating around for quite some time now.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2008-04-02 19:26:27.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2008-04-03 17:46:06.000000000 +0200
@@ -510,21 +510,19 @@ void b43_rx(struct b43_wldev *dev, struc
 	const struct b43_rxhdr_fw4 *rxhdr = _rxhdr;
 	u16 fctl;
 	u16 phystat0, phystat3, chanstat, mactime;
 	u32 macstat;
 	u16 chanid;
 	u16 phytype;
-	u8 jssi;
 	int padding;
 
 	memset(&status, 0, sizeof(status));
 
 	/* Get metadata about the frame from the header. */
 	phystat0 = le16_to_cpu(rxhdr->phy_status0);
 	phystat3 = le16_to_cpu(rxhdr->phy_status3);
-	jssi = rxhdr->jssi;
 	macstat = le32_to_cpu(rxhdr->mac_status);
 	mactime = le16_to_cpu(rxhdr->mac_time);
 	chanstat = le16_to_cpu(rxhdr->channel);
 	phytype = chanstat & B43_RX_CHAN_PHYTYPE;
 
 	if (macstat & B43_RX_MAC_FCSERR)
@@ -572,19 +570,28 @@ void b43_rx(struct b43_wldev *dev, struc
 				goto drop;
 			}
 			status.flag |= RX_FLAG_DECRYPTED;
 		}
 	}
 
-	status.ssi = b43_rssi_postprocess(dev, jssi,
-					  (phystat0 & B43_RX_PHYST0_OFDM),
-					  (phystat0 & B43_RX_PHYST0_GAINCTL),
-					  (phystat3 & B43_RX_PHYST3_TRSTATE));
+	/* Link quality statistics */
 	status.noise = dev->stats.link_noise;
-	/* the next line looks wrong, but is what mac80211 wants */
-	status.signal = (jssi * 100) / B43_RX_MAX_SSI;
+	if ((chanstat & B43_RX_CHAN_PHYTYPE) == B43_PHYTYPE_N) {
+//		s8 rssi = max(rxhdr->power0, rxhdr->power1);
+		//TODO: Find out what the rssi value is (dBm or percentage?)
+		//      and also find out what the maximum possible value is.
+		//      Fill status.ssi and status.signal fields.
+	} else {
+		status.ssi = b43_rssi_postprocess(dev, rxhdr->jssi,
+						  (phystat0 & B43_RX_PHYST0_OFDM),
+						  (phystat0 & B43_RX_PHYST0_GAINCTL),
+						  (phystat3 & B43_RX_PHYST3_TRSTATE));
+		/* the next line looks wrong, but is what mac80211 wants */
+		status.signal = (rxhdr->jssi * 100) / B43_RX_MAX_SSI;
+	}
+
 	if (phystat0 & B43_RX_PHYST0_OFDM)
 		status.rate_idx = b43_plcp_get_bitrate_idx_ofdm(plcp,
 						phytype == B43_PHYTYPE_A);
 	else
 		status.rate_idx = b43_plcp_get_bitrate_idx_cck(plcp);
 	status.antenna = !!(phystat0 & B43_RX_PHYST0_ANT);
Index: wireless-testing/drivers/net/wireless/b43/xmit.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.h	2008-04-02 19:26:27.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/xmit.h	2008-04-03 17:46:06.000000000 +0200
@@ -209,14 +209,25 @@ enum {
 
 /* Receive header for v4 firmware. */
 struct b43_rxhdr_fw4 {
 	__le16 frame_len;	/* Frame length */
 	 PAD_BYTES(2);
 	__le16 phy_status0;	/* PHY RX Status 0 */
-	__u8 jssi;		/* PHY RX Status 1: JSSI */
-	__u8 sig_qual;		/* PHY RX Status 1: Signal Quality */
+	union {
+		/* RSSI for A/B/G-PHYs */
+		struct {
+			__u8 jssi;	/* PHY RX Status 1: JSSI */
+			__u8 sig_qual;	/* PHY RX Status 1: Signal Quality */
+		} __attribute__ ((__packed__));
+
+		/* RSSI for N-PHYs */
+		struct {
+			__s8 power0;	/* PHY RX Status 1: Power 0 */
+			__s8 power1;	/* PHY RX Status 1: Power 1 */
+		} __attribute__ ((__packed__));
+	} __attribute__ ((__packed__));
 	__le16 phy_status2;	/* PHY RX Status 2 */
 	__le16 phy_status3;	/* PHY RX Status 3 */
 	__le32 mac_status;	/* MAC RX status */
 	__le16 mac_time;
 	__le16 channel;
 } __attribute__ ((__packed__));
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-03 17:45:38.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-03 17:47:01.000000000 +0200
@@ -43,12 +43,13 @@
 #include <asm/unaligned.h>
 
 #include "b43.h"
 #include "main.h"
 #include "debugfs.h"
 #include "phy.h"
+#include "nphy.h"
 #include "dma.h"
 #include "pio.h"
 #include "sysfs.h"
 #include "xmit.h"
 #include "lo.h"
 #include "pcmcia.h"
@@ -1016,13 +1017,24 @@ void b43_power_saving_ctl_bits(struct b4
 	}
 }
 
 /* Turn the Analog ON/OFF */
 static void b43_switch_analog(struct b43_wldev *dev, int on)
 {
-	b43_write16(dev, B43_MMIO_PHY0, on ? 0 : 0xF4);
+	switch (dev->phy.type) {
+	case B43_PHYTYPE_A:
+	case B43_PHYTYPE_G:
+		b43_write16(dev, B43_MMIO_PHY0, on ? 0 : 0xF4);
+		break;
+	case B43_PHYTYPE_N:
+		b43_phy_write(dev, B43_NPHY_AFECTL_OVER,
+			      on ? 0 : 0x7FFF);
+		break;
+	default:
+		B43_WARN_ON(1);
+	}
 }
 
 void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 {
 	u32 tmslow;
 	u32 macctl;
Index: wireless-testing/drivers/net/wireless/b43/nphy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/nphy.c	2008-03-23 12:33:07.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/nphy.c	2008-04-03 17:46:06.000000000 +0200
@@ -237,13 +237,12 @@ static void b43_nphy_workarounds(struct 
 {
 	struct b43_phy *phy = &dev->phy;
 	unsigned int i;
 
 	b43_phy_set(dev, B43_NPHY_IQFLIP,
 		    B43_NPHY_IQFLIP_ADC1 | B43_NPHY_IQFLIP_ADC2);
-	//FIXME the following condition is different in the specs.
 	if (1 /* FIXME band is 2.4GHz */) {
 		b43_phy_set(dev, B43_NPHY_CLASSCTL,
 			    B43_NPHY_CLASSCTL_CCKEN);
 	} else {
 		b43_phy_mask(dev, B43_NPHY_CLASSCTL,
 			     ~B43_NPHY_CLASSCTL_CCKEN);
