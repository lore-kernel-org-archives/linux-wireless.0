Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:40666 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935415Ab0KQUaD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 15:30:03 -0500
Subject: Re: [RFC][PATCH] b43: rfkill: use HI enabled bit for all devices
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <AANLkTi=ddd9gTmfWgXgn-8SnTh_br_dTnagOFO0xztvh@mail.gmail.com> (sfid-20101117_212336_672388_05898F4E)
References: <1290023808-26672-1-git-send-email-zajec5@gmail.com>
	 <1290025040.2513.69.camel@maggie>
	 <AANLkTi=ddd9gTmfWgXgn-8SnTh_br_dTnagOFO0xztvh@mail.gmail.com>
	 (sfid-20101117_212336_672388_05898F4E)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 21:29:58 +0100
Message-ID: <1290025798.2513.74.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-17 at 21:23 +0100, Rafał Miłecki wrote: 
> >>  /* Returns TRUE, if the radio is enabled in hardware. */
> >> -bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
> >> +inline bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
> >
> > inline doesn't make sense here.
> 
> Err, tip for compiler for optimization? To avoid some JUMPs in generated ASM?

Inline doesn't really work that way. In this case it might generate
an inline version for callers inside of rfkill.c and an 
always-out-of-line version for other callers.
If you really want it inline (Which I think isn't really necessary
as this isn't a fastpath), you'll need to make it static inline
and put it into rfkill.h

-- 
Greetings Michael.

