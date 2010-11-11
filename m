Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59202 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0KKXgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 18:36:44 -0500
Received: by iwn10 with SMTP id 10so2748772iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 15:36:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik35wHXiznjGm7nc9HBYUy7iQk65FVSq7T2Gw8u@mail.gmail.com>
References: <185731CC-606D-407D-80F4-33FEF08ED35D@moxienet.com> <AANLkTik35wHXiznjGm7nc9HBYUy7iQk65FVSq7T2Gw8u@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Nov 2010 15:36:23 -0800
Message-ID: <AANLkTikf13HMEtVkpTftKrZenvPwPcHbuhgqmh2m-UYU@mail.gmail.com>
Subject: Re: Regulatory/CRDA Race
To: Mark Mentovai <mark@moxienet.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 9, 2010 at 1:19 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, Nov 8, 2010 at 11:40 AM, Mark Mentovai <mark@moxienet.com> wrote:
>> Following up on the old-ish “[ath5k-devel] Race condition in CRDA calls?” thread…
>>
>> I independently experienced this problem, debugged it, and came to the same conclusion. There is in fact a race between regulatory requests being made via regulatory_hint and CRDA actually updating regulatory data. I see this on a system with two cards that come up one after the other during boot.
>>
>> 1. cfg80211 calls CRDA to update the world regulatory domain and CRDA does so. The regulatory domain is now 00.
>>
>> 2. The first card’s driver (in my case, ath9k) calls regulatory_hint to provide US as a driver hint. ignore_request decides against intersection because the last request came from the core. There’s a CRDA call, but CRDA isn’t quick enough to respond. The regulatory domain is still 00, because CRDA hasn’t changed it yet.
>>
>> 3. The second card’s driver (also ath9k) calls regulatory_hint to provide US as a driver hint. ignore_request sees that the last request came from a driver (instead of the core) and since the regulatory domain is changing from 00 to US, decides that intersection must be performed.
>>
>> 4. When CRDA finally responds to the request from #2 or #3, cfg80211 sees that last_request->intersect is true, and intersects. The regulatory domain is set to the intersection of 00 and US.
>>
>> The race here is between CRDA providing data and the second card’s request being made via regulatory_hint. regulatory_hint and ignore_request assume that last_request is in sync with the currently-set regulatory domain, but there is no such synchronization.
>>
>> Here’s my openwrt-devel post describing the above in a slightly different level of detail:https://lists.openwrt.org/pipermail/openwrt-devel/2010-November/008570.html.--
>
> I'll take a look at this once I get done with the
> compat-wireless-2.6.37 release. Thanks for the report.

I'm looking at this now, can you do me a favor and test against
today's wireless-testing to verify the issue is still present? I'll be
digging at this in the mean time.

  Luis
