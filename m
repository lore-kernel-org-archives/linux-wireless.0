Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:53196 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYJTG76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 02:59:58 -0400
Received: by rn-out-0910.google.com with SMTP id k40so570305rnd.17
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2008 23:59:56 -0700 (PDT)
Message-ID: <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com> (sfid-20081020_090003_674645_C8ECAA09)
Date: Sun, 19 Oct 2008 23:59:56 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: New Regulatory Domain Api.
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224485431.18024.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081015112517.GF6509@tesla>
	 <1224126030.24677.78.camel@debian.sh.intel.com>
	 <20081016113848.GB5899@tesla>
	 <1224471102.24677.124.camel@debian.sh.intel.com>
	 <43e72e890810192040w567fa4f6j1bf40e80084a857e@mail.gmail.com>
	 <1224479933.24677.148.camel@debian.sh.intel.com>
	 <43e72e890810192333r7b3f6a0m56d499d0aed9240e@mail.gmail.com>
	 <1224484685.18024.5.camel@johannes.berg>
	 <43e72e890810192346q5e0eadbcm26febe45392a2172@mail.gmail.com>
	 <1224485431.18024.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 19, 2008 at 11:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-10-19 at 23:46 -0700, Luis R. Rodriguez wrote:
>
>> Sure but an issue here is that if we do deal with band-specific
>> regulatory domain definitions we change the regulatory behavior from
>> being "disallow everything first" to "allow everything first, disable
>> everything in the band for which we encounter a rule in except what
>> the rule allows".
>>
>> Since the regulatory definitions in db.txt are in KHz we are allowing
>> it to grow as more technology pops up with support for more bands. I
>> think the first approach was better. The current suggestion of only
>> applying rules if a band reg definition is present is only to deal
>> with a rare case. I think its better we try to handle that instead and
>> keep our existing behaviour.
>
> Ack on both points, which is why I said "If we're going to [...]". I
> don't think I've seen a convincing use case for this other than test
> environments, in which you can very well just use crda.

Ah, ok :)

Yi, BTW a simple way to get a distribution to add support initially
for crda is to have as part of an init script to call

iw reg set $COUNTRY

where $COUNTRY is determined though whatever distribution heuristics.

  Luis
