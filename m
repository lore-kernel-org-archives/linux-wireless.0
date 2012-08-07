Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2HGScF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 14:32:05 -0400
Message-ID: <1344364321.4766.3.camel@jlt3.sipsolutions.net> (sfid-20120807_203210_164073_E7091A02)
Subject: Re: [PATCH] compat: handle pci suspend/resume on kernel 2.6.29
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 07 Aug 2012 20:32:01 +0200
In-Reply-To: <1344363868.4766.2.camel@jlt3.sipsolutions.net> (sfid-20120807_202435_066114_3D3D3816)
References: <1343938505.4471.31.camel@jlt3.sipsolutions.net>
	 <CAB=NE6UUCVUDAn75UNX1uH=BMPkmjCtWr16iYBrGifkESCv=sA@mail.gmail.com>
	 <CAB=NE6VUre2eDdszhw3wCq7mrWvZW1uB7n5yp+hOTRTChZNRBQ@mail.gmail.com>
	 (sfid-20120807_200133_412545_A1FB50E7) <1344362732.4766.1.camel@jlt3.sipsolutions.net>
	 (sfid-20120807_200542_628002_964015C7) <1344363868.4766.2.camel@jlt3.sipsolutions.net>
	 (sfid-20120807_202435_066114_3D3D3816)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-08-07 at 20:24 +0200, Johannes Berg wrote:
> On Tue, 2012-08-07 at 20:05 +0200, Johannes Berg wrote:
> > On Tue, 2012-08-07 at 10:55 -0700, Luis R. Rodriguez wrote:
> > 
> > > /home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:4922:1:
> > > error: conflicting type qualifiers for ‘il_pm_ops’
> > > In file included from
> > > /home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:43:0:
> > > /home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.h:1854:32:
> > > note: previous declaration of ‘il_pm_ops’ was here
> > > /home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:
> > > In function ‘il_isr’:
> > > /home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:5415:12:
> > > warning: variable ‘inta_mask’ set but not used
> > > [-Wunused-but-set-variable]
> > >   CC [M]  /home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/ath/ath6kl/sdio.o
> > > make[4]: *** [/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.o]
> > > Error 1
> > > make[3]: *** [/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy]
> > > Error 2
> > 
> > Gee, fun, that's because of the static ... more hackery required then I
> > guess :-(
> 
> Not static, of course, the "const"

This should work, but I didn't test it:
http://p.sipsolutions.net/448a4a1fe8f98b30.txt

johannes

