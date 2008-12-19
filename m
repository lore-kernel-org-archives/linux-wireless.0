Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54770 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbYLSRou (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 12:44:50 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Suspend MAC while killing the radio
Date: Fri, 19 Dec 2008 18:40:00 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812191840.00731.mb@bu3sch.de> (sfid-20081219_184453_685697_B43975FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should suspend the MAC, before we kill the radio. This gives
the MAC a chance to leave any TX/RX state and it avoids races on
the PHY/RADIO registers.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.29

Index: wireless-testing/drivers/net/wireless/b43/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.c	2008-12-19 18:32:33.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/phy_common.c	2008-12-19 18:35:49.000000000 +0100
@@ -293,14 +293,16 @@ void b43_software_rfkill(struct b43_wlde
 
 	if (state == RFKILL_STATE_HARD_BLOCKED) {
 		/* We cannot hardware-block the device */
 		state = RFKILL_STATE_SOFT_BLOCKED;
 	}
 
+	b43_mac_suspend(dev);
 	phy->ops->software_rfkill(dev, state);
 	phy->radio_on = (state == RFKILL_STATE_UNBLOCKED);
+	b43_mac_enable(dev);
 }
 
 /**
  * b43_phy_txpower_adjust_work - TX power workqueue.
  *
  * Workqueue for updating the TX power parameters in hardware.

-- 
Greetings, Michael.
