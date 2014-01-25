Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44527 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaAYK3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jan 2014 05:29:52 -0500
Received: by mail-ie0-f174.google.com with SMTP id tp5so3843269ieb.5
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jan 2014 02:29:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Wag0Zr_vUX3q6fitbDHEVKgdwSi7qnyVqy6oOR=HcF9A@mail.gmail.com>
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
	<1390394624-3927-2-git-send-email-janusz.dziedzic@tieto.com>
	<1390492620.4142.33.camel@jlt4.sipsolutions.net>
	<20140125003255.GE28512@garbanzo.do-not-panic.com>
	<CAB=NE6Wag0Zr_vUX3q6fitbDHEVKgdwSi7qnyVqy6oOR=HcF9A@mail.gmail.com>
Date: Sat, 25 Jan 2014 11:29:51 +0100
Message-ID: <CAFED-jmWNZULA+uSD9LjSscHCTdNXZ9yXAGWFLT4hhidcWR38g@mail.gmail.com> (sfid-20140125_112955_700148_1DFA223B)
Subject: Re: [PATCH v2 2/3] cfg80211: introduce regulatory wide bandwidth flag
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/25 Luis R. Rodriguez <mcgrof@do-not-panic.com>:
> On Fri, Jan 24, 2014 at 4:32 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> On Thu, Jan 23, 2014 at 04:57:00PM +0100, Johannes Berg wrote:
>>> On Wed, 2014-01-22 at 13:43 +0100, Janusz Dziedzic wrote:
>>> > Introduce regulatory flags field, NL80211_REG_WIDE_BW
>>> > country flag and new attribute NL80211_ATTR_REG_FLAGS.
>>> > If NL80211_REG_WIDE_BW is set, check rules and calculate
>>> > maximum bandwidth base on all contiguous regulatory rules.
>>> > If unset get maximum badwitdh from regulatory rule.
>>> > This patch is backward compatible with current CRDA/db.txt
>>> > implementation.
>>>
>>> This seems reasonable, thanks. Maybe we should require the bandwidth to
>>> not be set at all or something? At least maybe in the regdb parser - it
>>> makes very little sense to have @20 and then ignore it completely?
>>>
>>> Or maybe the userspace code could just not expose the flag, but rather
>>> set the new "wide_bw" flag when all the rules are marked as @N/A (and
>>> treat a combination of @number and @N/A as a bug)?
>>
>> The optimizer code I added to CRDA does all this for us, so technically,
>> unless I'm missing something, this could be dealt with magically in
>> userspace. Its also unclear why we'd define this as a regulatory
>> parameter -- this just seems to make sense.
>>
>> I'd look at extending CRDA binary to use the optimizer on the regulatory
>> domain prior to sending it to the kernel. All of a sudden you get full
>> support for this for free on any kernel.
>
> And as for the users of the internal regdb -- have them use the
> optimizer to optimize their db prior to compiling the kernel ;)
>

Sounds good. This mean we have to remove from kernel:

freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
if (freq_range->max_bandwidth_khz > freq_diff)
    return false;

For internal regdb/also my case this should be enough, while I can set
correct BW manually

Anyway
I send new version with changes Johannes suggest.

-- 
Janusz Dziedzic
