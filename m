Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:65141 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbbAWO1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 09:27:15 -0500
Received: by mail-ob0-f181.google.com with SMTP id nt9so4277724obb.12
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 06:27:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422006174.2728.12.camel@sipsolutions.net>
References: <CAFk-A4nF4jPiFR1c9fx-+sa=YWUZseEOKtut7rKWHihmLWp02w@mail.gmail.com>
	<1421722023-4691-1-git-send-email-masashi.honma@gmail.com>
	<1422006174.2728.12.camel@sipsolutions.net>
Date: Fri, 23 Jan 2015 23:27:14 +0900
Message-ID: <CAFk-A4kSa=TznTNdtbWnUMaGWKM=WHYppfdyywagNMYS=VBcmQ@mail.gmail.com> (sfid-20150123_152724_598398_694A1C2A)
Subject: Re: [PATCH v3] mac80211: Avoid STA expiration timer truncation to u32
From: Masashi Honma <masashi.honma@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-01-23 18:42 GMT+09:00 Johannes Berg <johannes@sipsolutions.net>:
> Ok - but that doesn't really disable the timer? Perhaps we should have a
> new userspace API to explicitly disable it? OTOH, worst case I guess
> that means it's like >100 years in the future, so I guess it doesn't
> matter. However, though, you can hardly rely on this fix being present
> in the kernel, so you can't really set such a large value
> unconditionally anyway, no? Otherwise a newer wpa_supplicant running on
> an older kernel would suddenly behave incorrectly. That doesn't seem
> right.
>
> Having an explicit feature to disable plink timeout would perhaps be
> better?

Thank you for your review.

On my environment, HZ macro is 250. So jiffies counts up 250 per seconds.
So jiffies overflows in 199 days.
It is a large value still. But on my arm64 environment, jiffies could over the
u32 max value. Because it looks starts with about 0xffff0000.
So I need this patch. On the i386 environment, it does not occur.

> I'm not convinced this is right. For one, I believe on 32-bit machines
> you'll need to write "0x100000000ULL" instead of the plain constant.
> Perhaps preferably, you'd use use ">= MAX_UINT".

I have written such a code "0x100000000ULL" few years ago. But now,
"0x100000000" works. I re-tested on 64bit.
Anyway I think using "MAX_UINT" is better.

> However, the argument to ieee80211_sta_expire() is an unsigned long (as
> is jiffies), so on 64-bit machines you could even still use the value
> and the conditional isn't needed.

Yes, this is a code for 32bit machine.

> Given these complications, I would prefer having a feature attribute to
> treat e.g. 0 as disabling the timer entirely, and if this feature isn't
> present then have wpa_supplicant instead use a safe value that doesn't
> trigger the kernel bug - e.g. 0xffffffff/1000 [which is the max possible
> HZ].

Looks fine. I will modify this patch.
