Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34691 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab2JISoH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 14:44:07 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so3280626lag.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2012 11:44:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5073F336.4000900@openwrt.org>
References: <1349527254-41080-1-git-send-email-nbd@openwrt.org>
 <20121008183758.GJ3354@lenteja.do-not-panic.com> <50733D22.80407@openwrt.org>
 <20121009010003.GN3354@lenteja.do-not-panic.com> <5073F336.4000900@openwrt.org>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 9 Oct 2012 11:43:45 -0700
Message-ID: <CAB=NE6XAJuxof97ESBLGsF62WsYskHJN2onfbQsS0cS5Soz8tQ@mail.gmail.com> (sfid-20121009_204416_349072_CD37EF9A)
Subject: Re: [PATCH v2 3.7 1/2] cfg80211: fix antenna gain handling
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, arend@broadcom.com, mjg59@srcf.ucam.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 9, 2012 at 2:49 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2012-10-09 3:00 AM, Luis R. Rodriguez wrote:
>> I never followed up but we should see if we can get this but I'll
>> use this as a prelude to work on this.
>
> Well, the regulatory related variable seem like a pretty bad place to
> store the embedded antenna gain. Some drivers even share the
> ieee80211_channel array between multiple instances...

True, specially no need to have it for each channel.

>> The antenna gain nomenclature came from the HAL but that's just baggage.  The
>> antenna gain stuff remained a puzzle for a central regulatory code base due to
>> the fact that as far as I am concerned only ath9k was exposing the antenna gain
>> value from EEPROM and using it.
>
> No, ath9k was (and still is) not filling anything EEPROM related into
> chan->max_antenna_gain. And that's a good thing, because putting the
> EEPROM value in there would have made the whole thing even more wrong
> and confused than it already is.

Heh, OK. Then forget my ramblings as its eroded brain cache.

>> How about just adding a check for now:
>>
>> -       chan->max_antenna_gain = min(chan->orig_mag,
>> -               (int) MBI_TO_DBI(power_rule->max_antenna_gain));
>> +     if (chan->orig_mag)
>> +             chan->max_antenna_gain =
>> +                     min(chan->orig_mag, (int) MBI_TO_DBI(power_rule->max_antenna_gain));
>> +     else
>> +             chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
>> +
>>
>> Then we can go ahead and clarify usage of these values.
>
> No, because 0 is a valid value too, it does not indicate 'not present'.
> I don't want to add fragile checks that will not do anything useful for
> *any* current driver and are not useful for future changes either.

Alright, its obvious I'm rusty with antenna gain review here and
you've already thought out some kinks, this change is fine by me then
provided we also then proceed to clarify its usage more than what we
have.

  Luis
