Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33699 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaAYAgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 19:36:55 -0500
Received: by mail-lb0-f174.google.com with SMTP id l4so3038352lbv.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 16:36:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140125003255.GE28512@garbanzo.do-not-panic.com>
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
 <1390394624-3927-2-git-send-email-janusz.dziedzic@tieto.com>
 <1390492620.4142.33.camel@jlt4.sipsolutions.net> <20140125003255.GE28512@garbanzo.do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 24 Jan 2014 16:36:33 -0800
Message-ID: <CAB=NE6Wag0Zr_vUX3q6fitbDHEVKgdwSi7qnyVqy6oOR=HcF9A@mail.gmail.com> (sfid-20140125_013658_683692_661DAC07)
Subject: Re: [PATCH v2 2/3] cfg80211: introduce regulatory wide bandwidth flag
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 24, 2014 at 4:32 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Thu, Jan 23, 2014 at 04:57:00PM +0100, Johannes Berg wrote:
>> On Wed, 2014-01-22 at 13:43 +0100, Janusz Dziedzic wrote:
>> > Introduce regulatory flags field, NL80211_REG_WIDE_BW
>> > country flag and new attribute NL80211_ATTR_REG_FLAGS.
>> > If NL80211_REG_WIDE_BW is set, check rules and calculate
>> > maximum bandwidth base on all contiguous regulatory rules.
>> > If unset get maximum badwitdh from regulatory rule.
>> > This patch is backward compatible with current CRDA/db.txt
>> > implementation.
>>
>> This seems reasonable, thanks. Maybe we should require the bandwidth to
>> not be set at all or something? At least maybe in the regdb parser - it
>> makes very little sense to have @20 and then ignore it completely?
>>
>> Or maybe the userspace code could just not expose the flag, but rather
>> set the new "wide_bw" flag when all the rules are marked as @N/A (and
>> treat a combination of @number and @N/A as a bug)?
>
> The optimizer code I added to CRDA does all this for us, so technically,
> unless I'm missing something, this could be dealt with magically in
> userspace. Its also unclear why we'd define this as a regulatory
> parameter -- this just seems to make sense.
>
> I'd look at extending CRDA binary to use the optimizer on the regulatory
> domain prior to sending it to the kernel. All of a sudden you get full
> support for this for free on any kernel.

And as for the users of the internal regdb -- have them use the
optimizer to optimize their db prior to compiling the kernel ;)

  Luis
