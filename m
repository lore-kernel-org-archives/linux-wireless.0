Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:57161 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbYJNJEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 05:04:51 -0400
Received: by gxk9 with SMTP id 9so4860618gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2008 02:04:50 -0700 (PDT)
Message-ID: <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com> (sfid-20081014_110456_258170_82C0D5E7)
Date: Tue, 14 Oct 2008 02:04:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: New Regulatory Domain Api.
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1223969808.2570.153.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
	 <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 14, 2008 at 12:36 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Tue, 2008-10-14 at 01:04 -0600, Luis R. Rodriguez wrote:
>> > Why should the intersection be the correct behavior? In my previous
>> > example, the intersection of a BG card and an ABG card is the BG
>> bands.
>> > Why shouldn't the ABG card have the A band support?
>>
>> Intersection of ABG and BG is BG.
>
> That's what I'm saying. This is unacceptable for users. There is 2
> reasons a channel is not listed in the ieee80211_reg_rule:
>
> 1. the channel is not permitted by regulatory
> 2. the channel is not supported by hardware but it might be permitted by
> regulatory
>
> Intersection for the case 2 is wrong. Are you telling me to insert even
> A band channels into ieee80211_reg_rule for a BG only card?

No, you can add to the regulatory domain structure the regulatory
rules that you determine are valid for the card. The hardware
capabilities (as expressed to mac80211) of a card are separate but in
your case perhaps they are the same (please correct me if I'm wrong)
due to the design or your regulatory solution which is built into the
EEPROM.

The question which I thought was being asked was if you have two cards
present, one a dual band card 2.4 GHz and 5 GHz and another a single
band 2.4 GHz card what happens in terms of regulatory rules. What I'm
suggesting should happen is the intersection of their regulatory rules
should be applied and in this case only the 2.4 GHz channels that work
on both cards should be used. What currently happens is the regulatory
rules of the first card detected takes effect.

I have a feeling I am missing the question or problem here though.
Please let me know.

  Luis
