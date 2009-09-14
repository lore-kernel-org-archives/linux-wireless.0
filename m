Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:53772 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbZINTJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 15:09:50 -0400
Received: by fxm17 with SMTP id 17so1071846fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 12:09:52 -0700 (PDT)
Message-ID: <4AAE950C.2050704@gmail.com>
Date: Mon, 14 Sep 2009 21:10:04 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Fix analog core switching
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The generic analog switch routine is not correct for LP-PHY according
to the latest specs. Implement the proper analog core switch routine.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 80da9c7..b0e127a 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -2160,6 +2160,16 @@ static int lpphy_b2063_tune(struct b43_w
 	return 0;
 }
 
+static void b43_lpphy_op_switch_analog(struct b43_wldev *dev, bool on)
+{
+	if (on) {
+		b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0x7);
+		b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVR, 0x7);
+	} else {
+		b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVR, 0xFFF8);
+	}
+}
+
 static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
 				       unsigned int new_channel)
 {
@@ -2239,7 +2249,7 @@ const struct b43_phy_operations b43_phyo
 	.radio_read		= b43_lpphy_op_radio_read,
 	.radio_write		= b43_lpphy_op_radio_write,
 	.software_rfkill	= b43_lpphy_op_software_rfkill,
-	.switch_analog		= b43_phyop_switch_analog_generic,
+	.switch_analog		= b43_lpphy_op_switch_analog,
 	.switch_channel		= b43_lpphy_op_switch_channel,
 	.get_default_chan	= b43_lpphy_op_get_default_chan,
 	.set_rx_antenna		= b43_lpphy_op_set_rx_antenna,

