Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bounty.rbfh.de ([85.25.54.223]:34054 "EHLO bounty.rbfh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZIIIAB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 04:00:01 -0400
Date: Wed, 9 Sep 2009 09:41:59 +0200
From: Markus Mueller <akamoto@ml1.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	John Daiker <daikerjohn@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Dave Young <hidave.darkstar@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: b43 dma error
Message-ID: <20090909074159.GA2254@m.k.vu>
References: <20090908134732.GA1936@darkstar> <200909081638.36897.mb@bu3sch.de> <4AA67009.4020400@lwfinger.net> <4AA69961.9010808@gmail.com> <4AA69F61.2040300@lwfinger.net> <69e28c910909081124v71e6fa1cy815a2366385051e6@mail.gmail.com> <4AA6A2B3.2010300@lwfinger.net> <69e28c910909081132l464c2effq31665b22365de1c2@mail.gmail.com> <4AA70DD6.8040905@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4AA70DD6.8040905@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 08, 2009 at 09:07:18PM -0500, Larry Finger wrote:
> After some tests with the 32-bit architecture, I'm now thoroughly
> confused. I tried different memory models including PAE - everything
> worked. I even generated a 2.6.31-rc9-wl kernel with John's config and
> it worked. Whatever is happening is not related to his configuration.
> I'm not sure what the problem is.
> 
> I'm going to be offline for a few days - I hope the solution will be
> in my mailbox by the weekend.

I hope so, too :)

I have the same b4312 dma errors.

$ dmesg | tail -7
 Registered led device: b43-phy0::rx
 Registered led device: b43-phy0::radio
 __ratelimit: 8 callbacks suppressed
 b43-phy0 ERROR: Fatal DMA error: 0x00000400, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
 b43-phy0: Controller RESET (DMA error) ...
 b43-phy0: Controller restarted
 b43-phy0: Controller restarted

I built b43 from daily tarball compat-wireless-2009-09-07,tar.bz2 .

Card: B4312 low-power phy, 
BCM4312 802.11b/g [14e4:4315] (rev 01) (on a Dell Mini 10, N-Series). 

Kernel: 2.6.31-rc9 . 32bit. 
Hyperthreading Patch: I assume this means
http://bu3sch.de/patches/wireless-testing/20090816-1535/patches/002-b43-threaded-irq-handler.patch

I did not actually apply this patch, i just checked the source for a few
lines added in this patch and assumed it is merged in the daily tarball
already. Is this correct?

Firmware: Debian Sid. b43-fwcutter version 012 comes with 4.150 fw it
seems. On Openwrt I only found the afore mentioned "v478" firmware
http://downloads.openwrt.org/sources/broadcom-wl-4.178.10.4.tar.bz2 .
b43-fwcutter does not work with it. Is there documentation as to how
to extract newer firmware?

I couldn't find the v5xx firmware. It's nowhere on your sites, is it?

Let me know if there is something I can do to help, but be aware I am
not knowledgeable with linux-wireless, it's my first WLAN Device in
Years. And your site is a bit.. confused.. errm confusing ;)

Cheers,
 Markus
