Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:48071 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaEGHZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 03:25:38 -0400
Received: by mail-we0-f181.google.com with SMTP id w61so544822wes.40
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 00:25:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399387345.4218.44.camel@jlt4.sipsolutions.net>
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-3-git-send-email-michal.kazior@tieto.com>
	<1399387345.4218.44.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 09:25:37 +0200
Message-ID: <CA+BoTQ=FqfB46Bd6iC3F=Ps=b4f6CP77p5d6f4fiVLUttCYQjg@mail.gmail.com> (sfid-20140507_092542_289584_66F1DCE0)
Subject: Re: [PATCH v4 2/5] mac80211: use chanctx reservation for AP CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 May 2014 16:42, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-04-09 at 15:45 +0200, Michal Kazior wrote:
>> Channel switch finalization is now 2-step. First
>> step is when driver calls csa_finish(), the other
>> is when reservation is actually finalized (which
>> be defered for in-place reservation).
>
> "which be defered"? should that be "can be"?

Oh, you're right.


>> +     if (sdata->reserved_chanctx) {
>> +             /*
>> +              * with multi-vif csa driver may call ieee80211_csa_finish()
>> +              * many times while waiting for other interfaces to use their
>> +              * reservations
>> +              */
>> +             if (sdata->reserved_ready)
>> +                     return 0;
>> +
>> +             err = ieee80211_vif_use_reserved_context(sdata);
>> +             if (err)
>> +                     return err;
>> +
>> +             return 0;
>>       }
>>
>> +     if (!cfg80211_chandef_identical(&sdata->vif.bss_conf.chandef,
>> +                                     &sdata->csa_chandef))
>> +             return -EINVAL;
>> +
>>       sdata->vif.csa_active = false;
>
> Should csa_active really stay true in the reserved_chanctx case?
> Wouldn't that leave it beaconing, with potentially suddenly negative
> (due to underflow) CSA counter, or something?

Hmm.. I think drivers should check ieee80211_csa_is_complete() before
calling to ieee80211_beacon_get(). At least that's what ath9k and
ath10k effectively do now. Hwsim might complain though but this should
be changed for multi-vif CSA. You may need to wait for other vifs to
finish CS (the incompat case) so you shouldn't call
ieee80211_beacon_get() after you get last CSA beacon on a given AP
vif.

Btw. shouldn't csa_active be protected/synchronized between CPUs
somehow? I think it's possible now to get inconsistencies and hit
WARN_ONs due to that.


Michał
