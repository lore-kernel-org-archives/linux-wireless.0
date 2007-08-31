Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:53462 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbXHaTYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 15:24:17 -0400
Date: Fri, 31 Aug 2007 14:23:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Change radio hardware switch status printk from  debug to regular
Message-ID: <46d86ab6.O689o6H7QjCOyAyx%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some distros ship bcm43xx with debugging printout disabled. For those
BCM43xx devices with radio on/off switches, this makes it impossible
to know if the radio is on or off. This patch changes a pair of debug
printk's into ordinary printk's.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I know this is late in the cycle, but I hope this can make it into 2.6.23.

Thanks,

Larry

 bcm43xx_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
