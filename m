Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26345 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbYJUGr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 02:47:26 -0400
Subject: Re: New Regulatory Domain Api.
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810202302j6cdf5be0m127846b502f395a0@mail.gmail.com>
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
	 <43e72e890810202302j6cdf5be0m127846b502f395a0@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 14:46:53 +0800
Message-Id: <1224571613.24677.317.camel@debian.sh.intel.com> (sfid-20081021_084728_843263_23E89EA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 23:02 -0700, Luis R. Rodriguez wrote:
> The issue at hand, which started this 60-message thread, involves a
> built-in Intel single band 2 GHz card and an external dual band card.
> The issue is the dual band card's regulatory_hint() is ignored as the
> current infrastructure ignores secondary requests and the first one
> did not define a set of rules for 5 GHz as part of its
> regulatory_hint(). A resolution to this is to have crda called for the
> country the user is in. 

A suboptimal solution. We all know that. The kernel has to rely on some
help from iw to resolve a problem it has the ablility to resolve itself.

> The reason this solves the issue at and is
> hardware which is designed to not allow channels out of its EEPROM
> won't be enabled as these channels are not registered and channels
> which *should* be disabled based on the user's location *are*
> disabled. The 5 GHz channels on the dual band card which *should* be
> allowed are allowed. Additionally we do allow drivers to be cocky
> about regulatory and to claim they know better through reg_notifier().

Driver's reg_notifier should only disable a channel which the regulatory
framework marks as enabled. But not vice versa. Otherwise your below
case fails.

> If a hardware device has a built in channel 14 and a user in the US
> buys this device and goes to the US he/she should disable this channel
> to remain compliant. Under your current suggestion this is not dealt
> with. That is what I mean by handling outdated rules.

I don't see where it doesn't fit in my model. The driver hints
EVERYTHING after loading. Then the user overwrote it to "US". After
that, channel 14 is forbiddened by reg framework (although driver still
claims it supports it). This is what I said EVERYTHING should always be
overwritten by other regdomains.

Thanks,
-yi

