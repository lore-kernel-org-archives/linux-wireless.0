Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:50180 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030880AbXCNUHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2007 16:07:12 -0400
Date: Wed, 14 Mar 2007 15:06:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx:Eliminate some 'G Mode Enable' magic numbers
Message-ID: <45f855be.d6q3Pv+rtlMA4ojm%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In code manipulating the TM State Low register of 802.11 cores, two
different magic numbers are used to reference the 'G Mode Enable' bit.
One of these, 0x20000000, is clear, but the other, (0x800 << 18), is not.
This patch replaces both types with a defined constant. In addition, two
bits in the TM State High registers are given definitions to help in
following the code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx.h
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx.h
@@ -277,11 +277,14 @@
 #define BCM43xx_SBTMSTATELOW_REJECT		0x02
 #define BCM43xx_SBTMSTATELOW_CLOCK		0x10000
 #define BCM43xx_SBTMSTATELOW_FORCE_GATE_CLOCK	0x20000
+#define BCM43xx_SBTMSTATELOW_G_MODE_ENABLE	0x20000000
 
 /* sbtmstatehigh state flags */
 #define BCM43xx_SBTMSTATEHIGH_SERROR		0x00000001
 #define BCM43xx_SBTMSTATEHIGH_BUSY		0x00000004
 #define BCM43xx_SBTMSTATEHIGH_TIMEOUT		0x00000020
+#define BCM43xx_SBTMSTATEHIGH_G_PHY_AVAIL	0x00010000
+#define BCM43xx_SBTMSTATEHIGH_A_PHY_AVAIL	0x00020000
 #define BCM43xx_SBTMSTATEHIGH_COREFLAGS		0x1FFF0000
 #define BCM43xx_SBTMSTATEHIGH_DMA64BIT		0x10000000
 #define BCM43xx_SBTMSTATEHIGH_GATEDCLK		0x20000000
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -168,16 +168,16 @@ int bcm43xx_phy_connect(struct bcm43xx_p
 
 	flags = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATEHIGH);
 	if (connect) {
-		if (!(flags & 0x00010000))
+		if (!(flags & BCM43xx_SBTMSTATEHIGH_G_PHY_AVAIL))
 			return -ENODEV;
 		flags = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-		flags |= (0x800 << 18);
+		flags |= BCM43xx_SBTMSTATELOW_G_MODE_ENABLE;
 		bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, flags);
 	} else {
-		if (!(flags & 0x00020000))
+		if (!(flags & BCM43xx_SBTMSTATEHIGH_A_PHY_AVAIL))
 			return -ENODEV;
 		flags = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-		flags &= ~(0x800 << 18);
+		flags &= ~BCM43xx_SBTMSTATELOW_G_MODE_ENABLE;
 		bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, flags);
 	}
 out:
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -1389,7 +1389,7 @@ void bcm43xx_wireless_core_reset(struct 
 				& ~(BCM43xx_SBF_MAC_ENABLED | 0x00000002));
 	} else {
 		if (connect_phy)
-			flags |= 0x20000000;
+			flags |= BCM43xx_SBTMSTATELOW_G_MODE_ENABLE;
 		bcm43xx_phy_connect(bcm, connect_phy);
 		bcm43xx_core_enable(bcm, flags);
 		bcm43xx_write16(bcm, 0x03E6, 0x0000);
@@ -3662,7 +3662,7 @@ int bcm43xx_select_wireless_core(struct 
 		u32 sbtmstatelow;
 
 		sbtmstatelow = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-		sbtmstatelow |= 0x20000000;
+		sbtmstatelow |= BCM43xx_SBTMSTATELOW_G_MODE_ENABLE;
 		bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, sbtmstatelow);
 	}
 	err = wireless_core_up(bcm, 1);
