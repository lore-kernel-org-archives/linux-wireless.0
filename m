Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5500 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2LMXNE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 18:13:04 -0500
From: "Bitterli, Felix" <felixb@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC 2/2] cfg80211: check (VHT) bandwidth against regulatory
Date: Thu, 13 Dec 2012 23:13:02 +0000
Message-ID: <40F35DA312B2CC468349B21A177FEE63382FC9A8@NASANEXD02E.na.qualcomm.com> (sfid-20121214_001307_605762_53691B8E)
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net>
 <1354812784-15845-3-git-send-email-johannes@sipsolutions.net>
 <CAB=NE6W=BAOwcQ_XjbDiySx7xvAFoutv96Kcc9ULujUAWDHMGA@mail.gmail.com>
 <1355438841.9463.33.camel@jlt4.sipsolutions.net>,<CAB=NE6U8_YibHNu+rBP-rXUTnFom9N4gqck1R9-hK=g-OBBBRg@mail.gmail.com>
In-Reply-To: <CAB=NE6U8_YibHNu+rBP-rXUTnFom9N4gqck1R9-hK=g-OBBBRg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: mcgrof@gmail.com [mcgrof@gmail.com] on behalf of Luis R. Rodriguez [mcgrof@do-not-panic.com]
Sent: Thursday, December 13, 2012 2:49 PM
To: Johannes Berg; Bitterli, Felix
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] cfg80211: check (VHT) bandwidth against regulatory

On Thu, Dec 13, 2012 at 2:47 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-12-13 at 14:38 -0800, Luis R. Rodriguez wrote:
>> On Thu, Dec 6, 2012 at 8:53 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > -       /* TODO: missing regulatory check on 80/160 bandwidth */
>> > +       /*
>> > +        * TODO: What if there are only certain 80/160/80+80 MHz channels
>> > +        *       allowed by the driver, or only certain combinations?
>> > +        *       For 40 MHz the driver can set the NO_HT40 flags, but for
>> > +        *       80/160 MHz and in particular 80+80 MHz this isn't really
>> > +        *       feasible -- should we ask the driver here?
>> > +        */
>>
>> It'd be real odd if a card could only do certain settings but at least
>> from what I was told the spec did limit the required combinations to a
>> smaller set so technically I could see the firmware having the checks
>> to only allow those settings. I don't think it makes sense to add this
>> as a limitation that gets annotated by a flag on the driver though. I
>> suspect we can assume a driver that supports VHT80 will support those
>> combos defined on the spec and so will a card that can support VHT160
>> and the only restriction really should be regulatory.
>
> Ok so mostly I'm thinking 80+80 limitations. I could imagine, for
> example, that a card doesn't want to do 80+80 if they're adjacent (do
> 160 instead), but I have no idea what 80+80 cards are like...

Pfft, yeah I have no clue yet. Felix would you know if there are any
limitations hardware wise in theory at least of doing 80+80
configurations (apart form what the standard would allow).

  Luis

[Felix:] Firstly, overlapping 40M channels are not allowed, overlapping 80M channels are not allowed, same for 160M. So each individual 80 of the 80+80 has to follow previous rule. In case the two 80 are adjacent, it's called 160.

  Best regards, Felix (apologies for owa quoting improperly)
