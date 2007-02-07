Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:42586 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161303AbXBGNun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 08:50:43 -0500
Message-ID: <45C9D930.5010307@lwfinger.net>
Date: Wed, 07 Feb 2007 07:50:40 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx: Fix for oops on resume
References: <45c8bd59.oamnvaNRMZvKoPBa%Larry.Finger@lwfinger.net>	 <1170850549.6798.22.camel@johannes.berg>  <45C9D2E1.7040906@lwfinger.net> <1170855150.6798.38.camel@johannes.berg>
In-Reply-To: <1170855150.6798.38.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2007-02-07 at 07:23 -0600, Larry Finger wrote:
> 
>> As you suggested earlier, a slow clock setting in the bcm43xx device may be the cause of this
>> difficulty. If my laptop would suspend/resume correctly, then I could test various fixes based on
>> that hypothesis. 
> 
> Mine does suspend, but I don't see the problem...

Could you please apply this patch and tell me what gets printed after you resume, and whether you
did a suspend to RAM or disk?

I welcome the results of this test from anyone whose system will suspend/resume. Please also note if
any further action is needed to get wireless communication re-established.

Thanks,

Larry


==========

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -2401,6 +2401,7 @@ static int bcm43xx_chip_init(struct bcm4
 		}
 		udelay(10);
 	}
+	dprintk(KERN_INFO PFX "It took %d tries to set IRQ_READY\n", i);
 	bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON); /* dummy read */

 	value16 = bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED,

