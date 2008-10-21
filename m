Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:50182 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYJUE6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 00:58:10 -0400
Received: by gxk9 with SMTP id 9so4938511gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 21:58:08 -0700 (PDT)
Message-ID: <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com> (sfid-20081021_065814_826257_F30C4AFF)
Date: Mon, 20 Oct 2008 21:58:08 -0700
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
In-Reply-To: <1224561748.24677.274.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081015112517.GF6509@tesla>
	 <1224485431.18024.12.camel@johannes.berg>
	 <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com>
	 <1224487340.24677.192.camel@debian.sh.intel.com>
	 <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
	 <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com>
	 <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
	 <1224561748.24677.274.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 9:02 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Mon, 2008-10-20 at 19:37 -0700, Luis R. Rodriguez wrote:

>> The real problem here is you are not providing 5 GHz regulatory rules
>> on a 2 GHz capable built-in card because you currently handle
>> regulatory definitions by intersecting with hardware capabilities
>> *and* the issue is what happens when a user plugs in a 5 GHz capable
>> card. For >= iwlagn you have only a few SKUs so if you want you can
>> put these definitions in the driver. As Tomas points out for iwl3945
>> and iwl4965 your SKUs are more complicated. Regulatory *is*
>> complicated, and that is the current outsourcing of db.txt to
>> userspace tries to accomplish. So the solution isn't to try to "fix"
>> the regulatory infrastructure to handle your particular issue when a
>> single Intel 2 GHz band card is present and you connect a dual band
>> card by changing its overall design, because we already provide a
>> mechanism to deal with overriding regulatory rules to help the user be
>> more compliant.
>
> The real problem is you are forcing a device to provide a SKU even it is
> not capable of.

We would be if we didn't provide a db.txt with public regulatory
definitions which people can contribute to, but we do have such db.

> An SKU is not always necessary as long as the hardware
> provides other ways to comply with regulatory.

I do not agree. Consider old devices with built-in regulatory rules in
hardware which go out of date. The regulatory framework accounts for
such flaws and *helps* to remain compliant.

>To solve the problem,

What problem?

> I'd
> suggest a special regdomain named EVERYTHING. In the case the driver or
> firmware enforces reg_rules, the core wireless reg_rules are safe to be
> bypassed.

You mean we add a flag to allow cfg80211 to ignore applying its
central regulatory definition to a wiphy? I disagree -- consider
outdated set of rules.

> EVERYTHING can always be overwritten by other regdomains. For
> example, when the user inserts a second card with regdomain of EU, EU
> becomes the global regdomain.

EU is not an ISO3166 alpha2 though, but I understand your point here,
however the goal of building a central regulatory infrastructure for
wireless was so it applies to all wiphys, not just mac80211 drivers.

> A driver should only claim to use
> EVERYTHING when it has its own way to enforce regulatory. Now the
> concept changes to "the first non-EVERYTHING regdomain wins".
> Thoughts?

Yeah, again, I think this proposal is trying to solve the wrong problem.

>> The proper solution is to either add 5 GHz regulatory rules to your
>> regulatory_hint() and/or rely on crda to enable the 5 GHz channels
>> required for the country the user is in. It is true that you need
>> manual intervention and the way I am trying to resolve that is not by
>> changing the design of the current regulatory infrastructure, instead
>> I want to add country selection support to say wpa_supplicant or
>> Network Manager. That, IMO, is how to address the problem correctly. I
>> also suggested a temporary solution which a distribution can use which
>> requires absolutely no manual user intervention, that of determining
>> the country through whatever means the distribution deems more fit and
>> calling iw reg set on $COUNTRY.
>
> See Marcel's comment on supporting new kernels with old applications.

Old userspace still works, we can however require new userspace for
new features. A compliant regulatory infrastructure is a feature.

I'm inclined to believe a patch to add country selection on
wpa_supplicant is the right next step.

  Luis
