Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:26435 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYJUGCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 02:02:15 -0400
Received: by yx-out-2324.google.com with SMTP id 8so380899yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 23:02:13 -0700 (PDT)
Message-ID: <43e72e890810202302j6cdf5be0m127846b502f395a0@mail.gmail.com> (sfid-20081021_080219_974158_1D276E3A)
Date: Mon, 20 Oct 2008 23:02:13 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: New Regulatory Domain Api.
Cc: "Marcel Holtmann" <holtmann@linux.intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224566923.24677.289.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081015112517.GF6509@tesla>
	 <1224487340.24677.192.camel@debian.sh.intel.com>
	 <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
	 <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com>
	 <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
	 <1224561748.24677.274.camel@debian.sh.intel.com>
	 <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com>
	 <1224566923.24677.289.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 10:28 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Mon, 2008-10-20 at 21:58 -0700, Luis R. Rodriguez wrote:
>> I do not agree. Consider old devices with built-in regulatory rules in
>> hardware which go out of date. The regulatory framework accounts for
>> such flaws and *helps* to remain compliant.
>
> That's another story. For these devices, you can do what you want in
> user space. But for other correct behavioured devices, bypass regulatory
> framework is necessary. Because you have to trust the driver anyway.

We do trust the driver and we do let it say "I know better". More on this below.

>> >To solve the problem,
>>
>> What problem?
>
> The problem a driver is not able to give a SKU as regulatory hint.

That is not the problem though as there is a solution to that.

The issue at hand, which started this 60-message thread, involves a
built-in Intel single band 2 GHz card and an external dual band card.
The issue is the dual band card's regulatory_hint() is ignored as the
current infrastructure ignores secondary requests and the first one
did not define a set of rules for 5 GHz as part of its
regulatory_hint(). A resolution to this is to have crda called for the
country the user is in. The reason this solves the issue at and is
hardware which is designed to not allow channels out of its EEPROM
won't be enabled as these channels are not registered and channels
which *should* be disabled based on the user's location *are*
disabled. The 5 GHz channels on the dual band card which *should* be
allowed are allowed. Additionally we do allow drivers to be cocky
about regulatory and to claim they know better through reg_notifier().

>> > I'd
>> > suggest a special regdomain named EVERYTHING. In the case the driver
>> or
>> > firmware enforces reg_rules, the core wireless reg_rules are safe to
>> be
>> > bypassed.
>>
>> You mean we add a flag to allow cfg80211 to ignore applying its
>> central regulatory definition to a wiphy? I disagree -- consider
>> outdated set of rules.
>
> It has nothing to do with ourdated rules. If a reg_rule is "wrong" in a
> device, it will still be wrong after the regulatory_hint() call.

If a hardware device has a built in channel 14 and a user in the US
buys this device and goes to the US he/she should disable this channel
to remain compliant. Under your current suggestion this is not dealt
with. That is what I mean by handling outdated rules.

> The current regulatory framework 100% trust the alpha2 or regdomain the
> driver provided. Thus it should also trust a hint from driver "bypass
> your regulatory check, I'll handle it myself".

Agreed 100%, and this is why we allowed a reg_notfier() callback so
bossy drivers can review the information and say "Let me review this..
I think I know better, so I'm in charge here".

  Luis
