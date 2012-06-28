Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55126 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2F1USB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 16:18:01 -0400
Received: by werb14 with SMTP id b14so682947wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 13:18:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340913949.2602.27.camel@joe2Laptop>
References: <1340912688-3089-1-git-send-email-zajec5@gmail.com>
	<1340912894.5257.0.camel@jlt3.sipsolutions.net>
	<CACna6rwXrspQ_PDfwZbL7jk=hZ6EmhCnebLcp82LaC4T-Khscw@mail.gmail.com>
	<1340913949.2602.27.camel@joe2Laptop>
Date: Thu, 28 Jun 2012 22:18:00 +0200
Message-ID: <CACna6rwV3Cffm0nG_kHmE8ZO9oHOqSpfSysd9H1pgAHK71iLFQ@mail.gmail.com> (sfid-20120628_221806_834176_015B562A)
Subject: Re: [PATCH option A] bcma: use custom printing functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/28 Joe Perches <joe@perches.com>:
> On Thu, 2012-06-28 at 21:56 +0200, Rafał Miłecki wrote:
>> 2012/6/28 Johannes Berg <johannes@sipsolutions.net>:
>> > On Thu, 2012-06-28 at 21:44 +0200, Rafał Miłecki wrote:
>> >
>> >> +#define bcma_err(fmt, ...) \
>> >> +     pr_err(KBUILD_MODNAME "-%d: " fmt, bus->num, ##__VA_ARGS__)
>> >
>> > both of your options seem to rely on "bus" being a variable in the
>> > context, is that really a good idea?
>>
>> Yeah, I made that assumption to make calls nicer & shorter. We may
>> need to get reference to "bus" in function or two.
>>
>> I saw such a solution in "radeon" gpu driver, example:
>> value = RREG32(R600_AUDIO_STATUS_BITS);
>> (they assume "rdev" is available in every function calling RREG32).
>
> I think that radeon use is ugly myself.
>
>> If you believe it's ugly, I can change that. I also wonder what Joe
>> will respond.
>>
>> P.S.
>> Both patches are not signed yet and they are supposed to be RFC. Sorry
>> for missing that in subject line.
>
> I think it'd be better to add and use:
>
> #define bcma_bus_err(bus, fmt, ...)                             \
>        pr_err("bus %d: " fmt, (bus)->num, ##__VA_ARGS__)
>
> #define bcma_bus_info(bus, fmt, ...)                            \
>        pr_info("bus %d: " fmt, (bus)->num, ##__VA_ARGS__)
>
> or some other equivalent use if you're wedded
> to wanting "bcma-%d:" prefixed output.
>
> I'd rather have the prefix be something like "bcma: <bus#>: ",
> so a dmesg grep pattern can be "^bcma:" but hey, it ain't my code.

OK, thanks for your opinion. Just to be sure, did you mean:
bcma: bus0: FOO BAR
or
bcma: <bus0>: FOO BAR
?

Personally I don't really care, but maybe there is already similar
case in some other driver you know about? It could be nice to be
consistent across the kernel.

-- 
Rafał
