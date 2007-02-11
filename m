Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:40198 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbXBKP7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 10:59:21 -0500
Message-ID: <45CF3D51.5050302@lwfinger.net>
Date: Sun, 11 Feb 2007 09:59:13 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <200702111407.08099.mb@bu3sch.de> <200702111502.19545.rjw@sisk.pl> <200702111514.04893.mb@bu3sch.de>
In-Reply-To: <200702111514.04893.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Sunday 11 February 2007 15:02, Rafael J. Wysocki wrote:
>> PM: Removing info for No Bus:0000:30:00.0
>> bcm43xx: IRQ_READY timeout
>> bcm43xx: core_up for active 802.11 core failed (-19)
> 
> I never tried suspend to disk with the driver.

This implies that suspend to RAM works. Is that true?

> Larry, an idea why the microcode doesn't respond?

Is this code snippet supposed to keep the firmware loaded when the system is suspended?

                bcm->firmware_norelease = 1;
                bcm43xx_free_board(bcm);
                bcm->firmware_norelease = 0;

If so, that may be the problem. What would force it to be reloaded when resuming after a suspend to
disk and subsequent power off? That would certainly explain why a reload is successful. Is there a
volatile location that would safely indicate that the firmware is not good? Perhaps, we need to bite
the bullet and reload the firmware after every resume. The patch below should do that.

I am also working on a case where the user has troubles with a suspend to disk from Windows followed
by a reboot to Linux, and warm reboots from Windows to Linux. In these cases, he gets a firmware
file-format error; however, his firmware is fine from a cold boot.

Larry

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -4296,6 +4297,7 @@ static int bcm43xx_resume(struct pci_dev
 		printk(KERN_ERR PFX "Resume failed!\n");
 		return err;
 	}
+	bcm43xx_request_firmware(bcm);
 	netif_device_attach(net_dev);

 	dprintk(KERN_INFO PFX "Device resumed.\n");
