Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53871
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359AbXKTPT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 10:19:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH v3] remove bcm43xx
Date: Tue, 20 Nov 2007 16:18:21 +0100
Cc: Andreas Schwab <schwab@suse.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
References: <20071119202121.6ad3fa70@morte> <jeir3xdyqu.fsf@sykes.suse.de> <4742F8A7.6070903@lwfinger.net>
In-Reply-To: <4742F8A7.6070903@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711201618.21372.mb@bu3sch.de> (sfid-20071120_151932_624287_576814D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 20 November 2007 16:09:27 Larry Finger wrote:
> Andreas Schwab wrote:
> > Stefano Brivio <stefano.brivio@polimi.it> writes:
> > 
> >> --- drivers/net/wireless/b43/main.c.orig        2007-11-20 01:12:12.186524483 +0100
> >> +++ drivers/net/wireless/b43/main.c     2007-11-20 01:12:34.922702865 +0100
> >> @@ -947,7 +947,7 @@
> >>
> >>         while (1) {
> >>                 v0 = b43_read32(dev, B43_MMIO_XMITSTAT_0);
> >> -               if (!(v0 & 0x00000001))
> >> +               if (!v0)
> >>                         break;
> >>                 v1 = b43_read32(dev, B43_MMIO_XMITSTAT_1);
> >>
> >> (probably it's not the solution, I just want to see what happens then).
> > 
> > That didn't change anything.
> > 
> >> BTW, what firmware are you using?
> > 
> > It's 410.2160 from wl_ap.o.
> 
> Please try version 351.126 from http://downloads.openwrt.org/sources/broadcom-wl-4.80.53.0.tar.bz2,
> which is the officially supported version.

There was some minor API change for newer firmware.
I think the TX and RX header layout slightly changed. I'll address that
later, as it's not too important now. (Or if someone else does want
to fix it, please send some patches...)

-- 
Greetings Michael.
