Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45852 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab0IJJAG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 05:00:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OtzSm-0007TS-Ad
	for linux-wireless@vger.kernel.org; Fri, 10 Sep 2010 11:00:04 +0200
Received: from 217.110.62.223 ([217.110.62.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 Sep 2010 11:00:04 +0200
Received: from claus.ried by 217.110.62.223 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 10 Sep 2010 11:00:04 +0200
To: linux-wireless@vger.kernel.org
From: Claus Ried <claus.ried@gmail.com>
Subject: Re: Conversion of driver for Realtek 8192SU
Date: Fri, 10 Sep 2010 08:55:19 +0000 (UTC)
Message-ID: <loom.20100910T104213-662@post.gmane.org>
References: <4BFE9A22.5040005@lwfinger.net> <20100605205015.65979235@devel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frederic Leroy <fredo@...> writes:

> 
> Le Thu, 27 May 2010 11:13:22 -0500,
> Larry Finger <Larry.Finger@...> a écrit :
> 
> > I am in the process of converting the driver contained in the file
> > RTL8192SU_usb_linux_v2.6.0006.20100511.zip obtained from the Realtek
> > site. This driver is used for the following USB IDs:
> > 
> > Realtek (0x0bda)  0x8171, 0x8172, 0x8173, 0x8174, 0x8712,
> > 0x8713,
> > [...]
> > My test device is a D-Link DWA-130 (14b2:3300). The Realtek driver
> > compiles cleanly and works as-is for this device on i386 architecture;
> 
> I own a Trendnet TEW-649UB (usb ids : 0bda:8172).
> I got the staging driver working only once. Since then, I found that the
> function which sets the channel didn't work.
> The 20100511 driver has the same behaviour at first sight, looking at
> wireshark trace.
> 
> > My initial plan is to modify this driver code for inclusion in
> > drivers/staging. The above list includes some, but not all, of the IDs
> > in the driver currently in drivers/staging/rtl8192su. I will likely
> > put this in as drivers/staging/rtl8712u, which is the name used in
> > the code, and remove the duplicate IDs from rtl8192su. Once this step
> > is done, I will then work at modifying it to use mac80211 so that it
> > can go into mainline.
> 
> Some work has been made in the staging driver. Can it be a better
> start ?
> 
> Have you a repository with your work ? I would like to test it again my
> device and if possible join our effort.
> 


Hi Frederic,

maybe it's the wrong place to ask, but did you get the work in converting the
original driver any further?
My problem is, i have an usb wlan stick using an realtek 8188su chipset. 
I used the (staging) driver for rtl8192su contained in the 2.6.33 kernel
on a amd64-mandriva system and included the usid of the stick, compiled
and installed.
Up to now, the stick is recognized, and scans the surrounding networks. 
It also detects the available wlans (displaying their ssids)

But, i never did get it to work when i try to connect to a wpa2-protected 
wlan. (never tried open or wep wlans yet).
Could you please assist in how to achieve a connection? Any help is 
appreciated...

(other things done already:
- i compiled the driver rtl8192su in the more recent kernel release 2.6.34 
and installed it. This one already got my usb-id included, so no further
changes to the code necessary. compiling, installing and using on my amd64
mandriva (still running kernel 2.6.33) had the same effects as above - 
scanning wlans is ok, connecting to a wpa2 protected wlan does not work)

As a last resort i tried the original realtek driver, compiled this stuff 
and had a kernel panic when inserting the usb stick. According to your 
previous posts, this might be due to the pointer problems on an amd64 
system as you pointed out.
)

So, any ideas how to proceed?
Thanks,
 Claus





