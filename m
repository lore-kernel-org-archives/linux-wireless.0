Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:53842 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754624Ab0C2H45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 03:56:57 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
Subject: [PATCH] rt2500usb: fix powersaving random failures
Date: Mon, 29 Mar 2010 09:56:53 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201003290956.54234.linux@rainbow-software.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch seems to fix random powersaving failure where the device state is
stuck at 1 (STATE_SLEEP) and does not change to 3 (STATE_AWAKE), resulting in
to associate and these error messages:
phy0 -> rt2500usb_set_device_state: Error - Device failed to enter state 3 (-16).
No probe response from AP xx:xx:xx:xx:xx:xx after 500ms, disconnecting.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-20 02:17:57.000000000 +0100
+++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-29 09:38:02.000000000 +0200
@@ -648,6 +648,10 @@
 
 		rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 1);
 		rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
+	} else {
+		rt2500usb_register_read(rt2x00dev, MAC_CSR18, &reg);
+		rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 0);
+		rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
 	}
 
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);

-- 
Ondrej Zary
