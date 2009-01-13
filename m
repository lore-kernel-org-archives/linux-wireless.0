Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:6667 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759880AbZAMX7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 18:59:38 -0500
Received: by yw-out-2324.google.com with SMTP id 9so134285ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 15:59:37 -0800 (PST)
Message-ID: <43e72e890901131559xf5fc017l7b6c575085277856@mail.gmail.com> (sfid-20090114_005956_943506_58824E66)
Date: Tue, 13 Jan 2009 15:59:37 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 00/12] cfg80211/mac80211: fixes/enhancements for reg_notifier()
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1231889014.3728.19.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
	 <1231887621.3728.12.camel@johannes> <20090113231741.GU4416@tesla>
	 <1231889014.3728.19.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2009 at 3:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-01-13 at 15:17 -0800, Luis R. Rodriguez wrote:
>> > (2) you
>> > should not do via the regulatory code and the notifier but rather by not
>> > registering those channels to start with
>>
>> I did a lot of this work because you had opposed to allow drivers dynamically register
>> their channels.
>
> I think we may have had some miscommunication here? I didn't like
> registering the channels dynamically with new calls, but I certainly
> don't care how you arrive at your channel array, you can kmalloc it if
> you want.

It seems like it, anyway I'd prefer we use a static set of channels.

>> The size of the code also increases considerably by using static set of
>> channels for each custom regulatory domain, its possible though.
>
> You don't have to.
>
>> >, or setting the disabled flag
>> > before registration if that's easier.
>>
>> You'll still need some sort of table. Either way -- all these are options of how to
>> accomplish the same task. I did this as part of cfg80211 as I figured it could be
>> used by other drivers.
>
> In what form do you have this data?

I posted the respective ath9k patch.

> Is it "valid 2412-2472 and 4950-5250
> MHz"?

Yes, with flags, it consists of 5 static ieee80211_regdomain structs
and a helper to change flags where required.

> If so, can we just have a function that marks all channel that
> would fall outside these ranges as invalid, and you call that function
> with a specific band and channel before registering your wiphy?

Yeah that would work too. Only other thing I can think about is that
of us requiring custom preferences on the regulatory flags when on the
world regulatory domains. For now we have only one such custom rule:

- Do not allow adhoc on 5 GHz unless specified by country IE -- only
when on some specific world regulatory domains. The other regdomains
must follow the world regdomain / country rule.

The active / passive scan stuff is dealt with in similar with in the
patch I posted but that's just to condense the number of world
regulatory domain structs to 5. I suppose the above custom rule I
mentioned could just be dealt with on the reg_notifier(). Hmm -- yeah
I like your suggestion.

  Luis
