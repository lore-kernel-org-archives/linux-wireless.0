Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms048pub.verizon.net ([206.46.252.48]:55199 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252AbXBFVhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 16:37:33 -0500
Received: from coyote.coyote.den ([141.153.122.81])
 by vms048.mailsrvcs.net (Sun Java System Messaging Server 6.2-6.01 (built Apr
 3 2006)) with ESMTPA id <0JD2001BR9EK9IL5@vms048.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Tue, 06 Feb 2007 15:37:33 -0600 (CST)
Date: Tue, 06 Feb 2007 16:37:31 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: RFT bcm43xx: Really _GOOD_ news
In-reply-to: <45C8E64B.1050605@lwfinger.net>
To: bcm43xx-dev@lists.berlios.de
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Message-id: <200702061637.31756.gene.heskett@verizon.net>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
References: <45C8E64B.1050605@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 February 2007 15:34, Larry Finger wrote:
>I have really _GOOD_ news!!!!! While reviewing the latest changes in the
> V4 specs, I found an interchange of the PHY version and PHY revision
> fields, relative to the current V3 specs. Of the three cards that I
> have, the 4306 had the same value for the PHY version and revision. In
> addition, it was the only card of the 3 thaw would work at 11Mbs. A
> light went on!
>
>After installing the patch listed below, both my 4318 and my 4311 will
> now run at 11Mbs. From tests with iperf, I now get rates of 6.1 - 6.5
> Mbs from all three.
>
>Larry
>

That's great Larry.  Now how long does it take to get this into a distro's 
update kernel queue?  Or do I have to build a kernel for my lappy, 
currently on FC5?

>==========
>
>Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
>===================================================================
>--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
>+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
>@@ -3707,9 +3707,9 @@ static int bcm43xx_read_phyinfo(struct b
>
> 	value = bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_VER);
>
>-	phy_version = (value & 0xF000) >> 12;
>+	phy_rev = (value & 0xF000) >> 12;
> 	phy_type = (value & 0x0F00) >> 8;
>-	phy_rev = (value & 0x000F);
>+	phy_version = (value & 0x000F);
>
> 	dprintk(KERN_INFO PFX "Detected PHY: Version: %x, Type %x, Revision
> %x\n", phy_version, phy_type, phy_rev);
>
>
>_______________________________________________
>Bcm43xx-dev mailing list
>Bcm43xx-dev@lists.berlios.de
>https://lists.berlios.de/mailman/listinfo/bcm43xx-dev

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Yahoo.com and AOL/TW attorneys please note, additions to the above
message by Gene Heskett are:
Copyright 2007 by Maurice Eugene Heskett, all rights reserved.
