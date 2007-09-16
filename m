Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:54182 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbXIPW1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 18:27:23 -0400
Date: Sun, 16 Sep 2007 17:26:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] bcm43xx: Change radio hardware switch status printk  from debug to regular
Message-ID: <46edada9.p7TujTB8lnlVSSMg%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some distros ship bcm43xx with debugging printout disabled. For those
BCM43xx devices with radio on/off switches, this makes it impossible
to know if the radio is on or off. This patch changes a pair of debug
printk's into ordinary printk's. It also changes the message that
prints when the radio is initialized to the off state as the old message
seems to confuse users.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.24 material.

Thanks,

Larry

 bcm43xx_main.c  |    4 ++--
 bcm43xx_radio.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -2394,7 +2394,7 @@ static int bcm43xx_chip_init(struct bcm4
 		goto err_gpio_cleanup;
 	bcm43xx_radio_turn_on(bcm);
 	bcm->radio_hw_enable = bcm43xx_is_hw_radio_enabled(bcm);
-	dprintk(KERN_INFO PFX "Radio %s by hardware\n",
+	printk(KERN_INFO PFX "Radio %s by hardware\n",
 		(bcm->radio_hw_enable == 0) ? "disabled" : "enabled");
 
 	bcm43xx_write16(bcm, 0x03E6, 0x0000);
@@ -3143,7 +3143,7 @@ static void bcm43xx_periodic_every1sec(s
 	radio_hw_enable = bcm43xx_is_hw_radio_enabled(bcm);
 	if (unlikely(bcm->radio_hw_enable != radio_hw_enable)) {
 		bcm->radio_hw_enable = radio_hw_enable;
-		dprintk(KERN_INFO PFX "Radio hardware status changed to %s\n",
+		printk(KERN_INFO PFX "Radio hardware status changed to %s\n",
 		       (radio_hw_enable == 0) ? "disabled" : "enabled");
 		bcm43xx_leds_update(bcm, 0);
 	}
Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
@@ -2146,7 +2146,7 @@ void bcm43xx_radio_turn_off(struct bcm43
 	} else
 		bcm43xx_phy_write(bcm, 0x0015, 0xAA00);
 	radio->enabled = 0;
-	dprintk(KERN_INFO PFX "Radio turned off\n");
+	dprintk(KERN_INFO PFX "Radio initialized\n");
 	bcm43xx_leds_update(bcm, 0);
 }
 
