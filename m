Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:39715 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbXBLAyA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 19:54:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
Date: Mon, 12 Feb 2007 01:50:58 +0100
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <200702111514.04893.mb@bu3sch.de> <45CF3D51.5050302@lwfinger.net>
In-Reply-To: <45CF3D51.5050302@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702120150.59747.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, 11 February 2007 16:59, Larry Finger wrote:
> Michael Buesch wrote:
> > On Sunday 11 February 2007 15:02, Rafael J. Wysocki wrote:
> >> PM: Removing info for No Bus:0000:30:00.0
> >> bcm43xx: IRQ_READY timeout
> >> bcm43xx: core_up for active 802.11 core failed (-19)
> > 
> > I never tried suspend to disk with the driver.
> 
> This implies that suspend to RAM works. Is that true?
> 
> > Larry, an idea why the microcode doesn't respond?
> 
> Is this code snippet supposed to keep the firmware loaded when the system is suspended?
> 
>                 bcm->firmware_norelease = 1;
>                 bcm43xx_free_board(bcm);
>                 bcm->firmware_norelease = 0;
> 
> If so, that may be the problem. What would force it to be reloaded when resuming after a suspend to
> disk and subsequent power off? That would certainly explain why a reload is successful. Is there a
> volatile location that would safely indicate that the firmware is not good? Perhaps, we need to bite
> the bullet and reload the firmware after every resume. The patch below should do that.
> 
> I am also working on a case where the user has troubles with a suspend to disk from Windows followed
> by a reboot to Linux, and warm reboots from Windows to Linux. In these cases, he gets a firmware
> file-format error; however, his firmware is fine from a cold boot.
> 
> Larry
> 
> Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> +++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> @@ -4296,6 +4297,7 @@ static int bcm43xx_resume(struct pci_dev
>  		printk(KERN_ERR PFX "Resume failed!\n");
>  		return err;
>  	}
> +	bcm43xx_request_firmware(bcm);
>  	netif_device_attach(net_dev);
> 
>  	dprintk(KERN_INFO PFX "Device resumed.\n");

It doesn't help in my case.  The behavior is similar to that without the patch,
but also with the patch it loses the association entirely.

Greetings,
Rafael
