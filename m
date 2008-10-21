Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63940 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbYJUF3V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 01:29:21 -0400
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
In-Reply-To: <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com>
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
	 <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 13:28:43 +0800
Message-Id: <1224566923.24677.289.camel@debian.sh.intel.com> (sfid-20081021_072925_947826_BD53AD6B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 21:58 -0700, Luis R. Rodriguez wrote:
> I do not agree. Consider old devices with built-in regulatory rules in
> hardware which go out of date. The regulatory framework accounts for
> such flaws and *helps* to remain compliant.

That's another story. For these devices, you can do what you want in
user space. But for other correct behavioured devices, bypass regulatory
framework is necessary. Because you have to trust the driver anyway.

> >To solve the problem,
> 
> What problem?

The problem a driver is not able to give a SKU as regulatory hint.

> > I'd
> > suggest a special regdomain named EVERYTHING. In the case the driver
> or
> > firmware enforces reg_rules, the core wireless reg_rules are safe to
> be
> > bypassed.
> 
> You mean we add a flag to allow cfg80211 to ignore applying its
> central regulatory definition to a wiphy? I disagree -- consider
> outdated set of rules.

It has nothing to do with ourdated rules. If a reg_rule is "wrong" in a
device, it will still be wrong after the regulatory_hint() call.

The current regulatory framework 100% trust the alpha2 or regdomain the
driver provided. Thus it should also trust a hint from driver "bypass
your regulatory check, I'll handle it myself".

Thanks,
-yi

