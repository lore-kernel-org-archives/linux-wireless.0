Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:62748 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab2LMWuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:50:16 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2268793lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 14:50:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355438841.9463.33.camel@jlt4.sipsolutions.net>
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net>
 <1354812784-15845-3-git-send-email-johannes@sipsolutions.net>
 <CAB=NE6W=BAOwcQ_XjbDiySx7xvAFoutv96Kcc9ULujUAWDHMGA@mail.gmail.com> <1355438841.9463.33.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 14:49:54 -0800
Message-ID: <CAB=NE6U8_YibHNu+rBP-rXUTnFom9N4gqck1R9-hK=g-OBBBRg@mail.gmail.com> (sfid-20121213_235020_886396_380B4DD0)
Subject: Re: [RFC 2/2] cfg80211: check (VHT) bandwidth against regulatory
To: Johannes Berg <johannes@sipsolutions.net>,
	Felix Bitterli <felixb@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
