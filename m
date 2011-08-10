Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:40173 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab1HJQoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 12:44:20 -0400
Date: Wed, 10 Aug 2011 18:44:06 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] ssb: fix DMA translation for some specific boards
Message-ID: <20110810184406.6cad6d17@milhouse> (sfid-20110810_184423_775264_26C1F383)
In-Reply-To: <CACna6rxBof9T+vaZ=wHZJcXY12XVrYvFbHEdXk1+=_LAwjmtig@mail.gmail.com>
References: <1312992688-6976-1-git-send-email-zajec5@gmail.com>
	<20110810184028.3cb9c532@milhouse>
	<CACna6rxBof9T+vaZ=wHZJcXY12XVrYvFbHEdXk1+=_LAwjmtig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 10 Aug 2011 18:42:59 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> W dniu 10 sierpnia 2011 18:40 użytkownik Michael Büsch <m@bues.ch> napisał:
> > On Wed, 10 Aug 2011 18:11:27 +0200
> >> +/* Some chipsets need routing known for PCIe and 64-bit DMA */
> >> +static bool ssb_dma_translation_special_bit(struct ssb_device *dev)
> >> +{
> >> +     u16 chip_id = dev->bus->chip_id;
> >> +
> >> +     if (dev->id.coreid == SSB_DEV_80211)
> >> +             return (chip_id == 0x4322 || chip_id == 43221 ||
> >> +                     chip_id == 43231 || chip_id == 43222);
> >> +     return 0;
> >> +}
> >
> > ACK, apart from this coding style violation (missing curly braces).
> 
> From kernel CodingStyle:
> > Do not unnecessarily use braces where a single statement will do.
> >
> > if (condition)
> > 	action();
> 
> I guess simple "return" (even when using line break) is still like
> single statement...
> Am I wrong?
> 

Last time I checked this only applied to single-line-statements.
Maybe it changed, though.

-- 
Greetings, Michael.
