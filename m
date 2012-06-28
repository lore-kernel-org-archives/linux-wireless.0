Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39779 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2F1T4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 15:56:43 -0400
Received: by wgbds11 with SMTP id ds11so443330wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 12:56:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340912894.5257.0.camel@jlt3.sipsolutions.net>
References: <1340912688-3089-1-git-send-email-zajec5@gmail.com>
	<1340912894.5257.0.camel@jlt3.sipsolutions.net>
Date: Thu, 28 Jun 2012 21:56:38 +0200
Message-ID: <CACna6rwXrspQ_PDfwZbL7jk=hZ6EmhCnebLcp82LaC4T-Khscw@mail.gmail.com> (sfid-20120628_215655_311280_6D76802C)
Subject: Re: [PATCH option A] bcma: use custom printing functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/28 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2012-06-28 at 21:44 +0200, Rafał Miłecki wrote:
>
>> +#define bcma_err(fmt, ...) \
>> +     pr_err(KBUILD_MODNAME "-%d: " fmt, bus->num, ##__VA_ARGS__)
>
> both of your options seem to rely on "bus" being a variable in the
> context, is that really a good idea?

Yeah, I made that assumption to make calls nicer & shorter. We may
need to get reference to "bus" in function or two.

I saw such a solution in "radeon" gpu driver, example:
value = RREG32(R600_AUDIO_STATUS_BITS);
(they assume "rdev" is available in every function calling RREG32).

If you believe it's ugly, I can change that. I also wonder what Joe
will respond.

P.S.
Both patches are not signed yet and they are supposed to be RFC. Sorry
for missing that in subject line.

-- 
Rafał
