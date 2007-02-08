Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:13798 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbXBHSUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 13:20:06 -0500
Received: by wr-out-0506.google.com with SMTP id 68so606412wri
        for <linux-wireless@vger.kernel.org>; Thu, 08 Feb 2007 10:20:05 -0800 (PST)
Message-ID: <45CB69EE.4000102@gmail.com>
Date: Thu, 08 Feb 2007 12:20:30 -0600
From: "Jory A. Pratt" <geekypenguin@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: RFT bcm43xx: Really _GOOD_ news
References: <45C8E64B.1050605@lwfinger.net>
In-Reply-To: <45C8E64B.1050605@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> I have really _GOOD_ news!!!!! While reviewing the latest changes in the V4 specs, I found an
> interchange of the PHY version and PHY revision fields, relative to the current V3 specs. Of the
> three cards that I have, the 4306 had the same value for the PHY version and revision. In addition,
> it was the only card of the 3 thaw would work at 11Mbs. A light went on!
>
> After installing the patch listed below, both my 4318 and my 4311 will now run at 11Mbs. From tests
> with iperf, I now get rates of 6.1 - 6.5 Mbs from all three.
>
> Larry
>
>
> ==========
>
> Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> +++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> @@ -3707,9 +3707,9 @@ static int bcm43xx_read_phyinfo(struct b
>
>  	value = bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_VER);
>
> -	phy_version = (value & 0xF000) >> 12;
> +	phy_rev = (value & 0xF000) >> 12;
>  	phy_type = (value & 0x0F00) >> 8;
> -	phy_rev = (value & 0x000F);
> +	phy_version = (value & 0x000F);
>
>  	dprintk(KERN_INFO PFX "Detected PHY: Version: %x, Type %x, Revision %x\n",
>  		phy_version, phy_type, phy_rev);
>
>   
I have tested this until I am blue in the face on a 4318. It killed me,
I was getting less then 200k/b a sec on a 5M pipe :(. I reverted the
patch and all is back to working even tho transfering files on the
internal network is still way out there.

