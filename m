Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54260 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0KQVCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 16:02:18 -0500
Received: by qwi2 with SMTP id 2so51630qwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 13:02:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290025798.2513.74.camel@maggie>
References: <1290023808-26672-1-git-send-email-zajec5@gmail.com>
	<1290025040.2513.69.camel@maggie>
	<AANLkTi=ddd9gTmfWgXgn-8SnTh_br_dTnagOFO0xztvh@mail.gmail.com>
	<1290025798.2513.74.camel@maggie>
Date: Wed, 17 Nov 2010 22:02:17 +0100
Message-ID: <AANLkTinLu4-VyZ9cePjgMb1sU12MmB8SG=BL4_8P=4x0@mail.gmail.com>
Subject: Re: [RFC][PATCH] b43: rfkill: use HI enabled bit for all devices
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 17 listopada 2010 21:29 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> On Wed, 2010-11-17 at 21:23 +0100, Rafał Miłecki wrote:
>> >>  /* Returns TRUE, if the radio is enabled in hardware. */
>> >> -bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
>> >> +inline bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
>> >
>> > inline doesn't make sense here.
>>
>> Err, tip for compiler for optimization? To avoid some JUMPs in generated ASM?
>
> Inline doesn't really work that way. In this case it might generate
> an inline version for callers inside of rfkill.c and an
> always-out-of-line version for other callers.
> If you really want it inline (Which I think isn't really necessary
> as this isn't a fastpath), you'll need to make it static inline
> and put it into rfkill.h

Huh, I got no idea inline works differently for local calls and calls
from other files. That's tricky.

Thanks, I'll send V2.

-- 
Rafał
