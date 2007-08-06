Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:48320 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbXHFV3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 17:29:21 -0400
Date: Mon, 06 Aug 2007 16:29:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC] bcm43xx-mac80211: Hack to turn automatic pctl off
Message-ID: <46b792a0.FdNEyH1qMrUgo6oh%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

I sent the wrong message under this subject before.

This hack disabled hardware power control. With this installed and the
desired power set to 10 dBm using the previous patch, I get much, much
better performance from bcm43xx-mac80211 on my BCM4311. I have not yet
tested it on the BCM4306 or the BCM4318.

The new iperf readings for transmit/receive with the computer about 2 m
from the AP are as follows:

Bit Rate	xmit/receive (Mbs)

1M		1.11/8.70
2M		1.44/11.0
5.5M		4.15/13.3
6M		4.76/17.4
9M		6.55/18.2
11M		6.54/14.3
18M		10.7/18.5
24M		12.8/19.5
36M		16.1/19.7
48M		18.0/19.5
54M		18.6/19.0

These numbers are comparable with what I'm getting with the PHY port from
softmac. I don't understand the dip in received rate at 11M, but it is real.
On Richard Jonsson's 4311, he isn't able to measure the transfer rate at
11M.

With these settings, the rate adjustment proces bumps the rate to 54M
automatically.

Larry



Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
@@ -471,6 +471,7 @@ void bcm43xx_phy_early_init(struct bcm43
 	struct bcm43xx_phy *phy = &dev->phy;
 	struct bcm43xx_txpower_lo_control *lo = phy->lo_control;
 
+	phy->hw_pctl_off = 1;
 	default_baseband_attenuation(dev, &phy->bbatt);
 	default_radio_attenuation(dev, &phy->rfatt);
 	phy->tx_control = (default_tx_control(dev) << 4);
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.h
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.h
@@ -219,8 +219,9 @@ void bcm43xx_gphy_dc_lt_init(struct bcm4
 
 /* Returns the boolean whether the board has HardwarePowerControl */
 #define has_hardware_pctl(phy) \
+	(!((phy)->hw_pctl_off) &&				\
 	(((phy)->type == BCM43xx_PHYTYPE_A && (phy)->rev >= 5) ||	\
-	 ((phy)->type == BCM43xx_PHYTYPE_G && (phy)->rev >= 6))
+	 ((phy)->type == BCM43xx_PHYTYPE_G && (phy)->rev >= 6)))
 /* Returns the boolean whether "TX Magnification" is enabled. */
 #define has_tx_magnification(phy) \
 	(((phy)->rev >= 2) &&			\
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
@@ -534,6 +534,7 @@ struct bcm43xx_phy {
 	struct bcm43xx_bbatt bbatt;
 	struct bcm43xx_rfatt rfatt;
 	u8 tx_control; /* BCM43xx_TXCTL_XXX */
+	bool hw_pctl_off;
 #ifdef CONFIG_BCM43XX_MAC80211_DEBUG
 	bool manual_txpower_control; /* Manual TX-power control enabled? */
 #endif

---
