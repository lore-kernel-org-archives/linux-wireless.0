Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.227]:31601 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYJTGdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 02:33:38 -0400
Received: by wx-out-0506.google.com with SMTP id h27so756197wxd.4
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2008 23:33:37 -0700 (PDT)
Message-ID: <43e72e890810192333r7b3f6a0m56d499d0aed9240e@mail.gmail.com> (sfid-20081020_083342_720637_019064D8)
Date: Sun, 19 Oct 2008 23:33:36 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: New Regulatory Domain Api.
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224479933.24677.148.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081015112517.GF6509@tesla>
	 <1ba2fa240810151735t100ceda5s7fe7b495f735c507@mail.gmail.com>
	 <20081015174447.GF15902@tesla>
	 <1ba2fa240810151757r11060dfble6b58c76a7d0d8d1@mail.gmail.com>
	 <20081015185636.GH15902@tesla>
	 <1224126030.24677.78.camel@debian.sh.intel.com>
	 <20081016113848.GB5899@tesla>
	 <1224471102.24677.124.camel@debian.sh.intel.com>
	 <43e72e890810192040w567fa4f6j1bf40e80084a857e@mail.gmail.com>
	 <1224479933.24677.148.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 19, 2008 at 10:18 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Sun, 2008-10-19 at 20:40 -0700, Luis R. Rodriguez wrote:
>> On Sun, Oct 19, 2008 at 7:51 PM, Zhu Yi <yi.zhu@intel.com> wrote:
>> > On Thu, 2008-10-16 at 04:38 -0700, Luis R. Rodriguez wrote:
>> >> So.. you didn't look at the code to check where it may have failed...
>> >
>> > IIRC, below patch changes the previously allowing none 5GHz channels to
>> > allowing all 5GHZ channels. It does resolve our problem. But is it the
>> > correct behaviour? Or did I miss anything?
>>
>> Well if you are using regulatory_hint() and only have rules defined in
>> the 2 GHz band then yes it won't ever touch 5 GHz channels... I don't
>> like this at all but its what I thought you were asking for.
>
> No, with this patch the 5GHz reg_rules on the second card are bypassed
> by regdomain.

Well the code specifically disregards secondary regulatory_hint()'s
right now and we reviewed why -- we discussed it at OLS and agreed to
go with the first one as that will usually be the built in one. That's
why. The restrictive thing to do next to handle more cards better is
to keep doing intersections.

Regarding doing unions on the regulatory information on bands -- I'm
not sure I even like the current patch I posted.. it means for
regulatory domains in db.txt which have no 5 GHz band we should be
passing at least one small frequency range to indicate to the core no
5 GHz channels are allowed. I'm not liking this... and this is just to
handle the case where you cannot provide a regulatory domain for 5 GHz
as your EEPROM doesn't have it as your EEPROM is the intersection of
the hw capabilities and the regulatory domain so for 2 GHz cards you
have no 5 GHz definitions.

Again -- how about a static 5 GHz definition for your 2 GHz band
cards? This way you can deal with the *rare* case where users plug in
a new dual band card and the system had a built in 2 Ghz card. Also --
we do have support for iw reg set, it doesn't seem you have considered
the advantages of this as well.

Tomas mentioned your 5 GHz case for >= iwlagn cards is pretty easy,
how about for iwl3945 and iwl4965? If you have it listed how about
putting it in the driver code path for those drivers? How many 5 GHz
SKUs are there for these cards?

Are there Intel express cards sold BTW? Or we dealing with a case
where a box can be sold with a lot of cards pre-installed?

  Luis
