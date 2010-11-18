Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51634 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760133Ab0KRSfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 13:35:04 -0500
Received: by iwn35 with SMTP id 35so3794730iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 10:35:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikACJ35YFDCS5NucXjhNDFyT7VU9FeYUGY9hMmo@mail.gmail.com>
References: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com> <AANLkTikACJ35YFDCS5NucXjhNDFyT7VU9FeYUGY9hMmo@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 18 Nov 2010 10:34:40 -0800
Message-ID: <AANLkTim28M7aRPSS1W71dEQ0a7PxS8QxKHAZ8jhx7C+2@mail.gmail.com>
Subject: Re: [PATCH 0/4] cfg80211: fix bug with multiple cards and a CRDA delay
To: Mark Mentovai <mark@moxienet.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 9:41 AM, Mark Mentovai <mark@moxienet.com> wrote:
> Luis R. Rodriguez wrote:
>> This series addresses the bug pointed out by Mark Mentovai <mark@moxienet.com>
>> when there is a delay on CRDA and you use multiple cards with the same regulatory
>> domain. After some testing I realized this also introduced an issue when using
>> multiple cards with different regulatory settings. The issue is present only
>> when there is a delay in CRDA so technically this is not a regression so I am
>> not marking these as stable fixes. It also does not seem to be a regulatory bug
>> as when the issue is present you'd end up with an intersected regulatory domain
>> (same alpha2s) or get the regulatory domain rejected for the second card if
>> the alpha2 was different.
>>
>> Thanks to Mark for his testing, good ideas on alternative ways to resolve this
>> and thorough reports.
>
> Excellent! I’ve read through this patch set and approve. I’ve tested
> it out. It definitely does the trick.
>
> The one thing I spotted was that you didn’t revise the @processed
> comment in regulatory.h from patch 4.

I did but did not see any difference in your comments.

> I don’t know which of Signed-off-by, Acked-by, or Tested-by is
> appropriate here, but as far as I’m concerned, this is a winner.

Tesed-by: foo would be good.

  Luis
