Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43809 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYJUECw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 00:02:52 -0400
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
In-Reply-To: <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
References: <20081015112517.GF6509@tesla>
	 <1224484685.18024.5.camel@johannes.berg>
	 <43e72e890810192346q5e0eadbcm26febe45392a2172@mail.gmail.com>
	 <1224485431.18024.12.camel@johannes.berg>
	 <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com>
	 <1224487340.24677.192.camel@debian.sh.intel.com>
	 <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
	 <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com>
	 <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 12:02:28 +0800
Message-Id: <1224561748.24677.274.camel@debian.sh.intel.com> (sfid-20081021_060257_443777_1995FE44)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 19:37 -0700, Luis R. Rodriguez wrote:
> As I mentioned in my previous e-mail, the real problem is what you are
> asking for changes the entire regulatory design from: "disable
> everything and enable only this" to "enable everything except for
> elements I don't define in the band I tell you to". There are many
> design flaws with this; an obvious problem to this is what is a band?
> In my patch I took the liberty to define that a frequency is part of a
> band if a rule was present within 2 GHz of itself. This works but it
> is trying to make a definition out of something that doesn't exist --
> its trying to solve the wrong problem. Since regulatory database is in
> KHz it is designed to allow us to grow regardless of band notions or
> associations. In the regulatory database we allow for 2 GHz, 5 GHz,
> etc KH  definitions for any country and this was designed to account
> for misinformation on drivers to help the user be more compliant. By
> changing the design to what you are suggesting you'd have to add a
> dummy rule for every frequency "band" if you really want to disable
> all other bands.

I agree you on the band and KHz.

> The real problem here is you are not providing 5 GHz regulatory rules
> on a 2 GHz capable built-in card because you currently handle
> regulatory definitions by intersecting with hardware capabilities
> *and* the issue is what happens when a user plugs in a 5 GHz capable
> card. For >= iwlagn you have only a few SKUs so if you want you can
> put these definitions in the driver. As Tomas points out for iwl3945
> and iwl4965 your SKUs are more complicated. Regulatory *is*
> complicated, and that is the current outsourcing of db.txt to
> userspace tries to accomplish. So the solution isn't to try to "fix"
> the regulatory infrastructure to handle your particular issue when a
> single Intel 2 GHz band card is present and you connect a dual band
> card by changing its overall design, because we already provide a
> mechanism to deal with overriding regulatory rules to help the user be
> more compliant.

The real problem is you are forcing a device to provide a SKU even it is
not capable of. An SKU is not always necessary as long as the hardware
provides other ways to comply with regulatory. To solve the problem, I'd
suggest a special regdomain named EVERYTHING. In the case the driver or
firmware enforces reg_rules, the core wireless reg_rules are safe to be
bypassed. EVERYTHING can always be overwritten by other regdomains. For
example, when the user inserts a second card with regdomain of EU, EU
becomes the global regdomain. A driver should only claim to use
EVERYTHING when it has its own way to enforce regulatory. Now the
concept changes to "the first non-EVERYTHING regdomain wins". Thoughts?

> The proper solution is to either add 5 GHz regulatory rules to your
> regulatory_hint() and/or rely on crda to enable the 5 GHz channels
> required for the country the user is in. It is true that you need
> manual intervention and the way I am trying to resolve that is not by
> changing the design of the current regulatory infrastructure, instead
> I want to add country selection support to say wpa_supplicant or
> Network Manager. That, IMO, is how to address the problem correctly. I
> also suggested a temporary solution which a distribution can use which
> requires absolutely no manual user intervention, that of determining
> the country through whatever means the distribution deems more fit and
> calling iw reg set on $COUNTRY.

See Marcel's comment on supporting new kernels with old applications.

Thanks,
-yi

