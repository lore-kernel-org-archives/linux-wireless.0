Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:36550 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbdAMJML (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 04:12:11 -0500
Received: by mail-qk0-f176.google.com with SMTP id 11so47773698qkl.3
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 01:12:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1484295383.19860.7.camel@sipsolutions.net>
References: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com> <1484295383.19860.7.camel@sipsolutions.net>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 13 Jan 2017 10:04:42 +0100
Message-ID: <CA+BoTQnA4X+OPC2eFQO9tj+a+-z=_FTKA6UR_uJAUrQvzjZZ8Q@mail.gmail.com> (sfid-20170113_101216_244282_58698D2E)
Subject: Re: [PATCH] mac80211: prevent skb/txq mismatch
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 January 2017 at 09:16, Johannes Berg <johannes@sipsolutions.net> wrot=
e:
> On Thu, 2017-01-12 at 15:28 +0100, Michal Kazior wrote:
>> Station structure is considered as not uploaded
>> (to driver) until drv_sta_state() finishes. This
>> call is however done after the structure is
>> attached to mac80211 internal lists and hashes.
>> This means mac80211 can lookup (and use) station
>> structure before it is uploaded to a driver.
>>
>> If this happens (structure exists, but
>> sta->uploaded is false) fast_tx path can still be
>> taken. Deep in the fastpath call the sta->uploaded
>> is checked against to derive "pubsta" argument for
>> ieee80211_get_txq(). If sta->uploaded is false
>> (and sta is actually non-NULL) ieee80211_get_txq()
>> effectively downgraded to vif->txq.
>>
>> At first glance this may look innocent but coerces
>> mac80211 into a state that is almost guaranteed
>> (codel may drop offending skb) to crash because a
>> station-oriented skb gets queued up on
>> vif-oriented txq. The ieee80211_tx_dequeue() ends
>> up looking at info->control.flags and tries to use
>> txq->sta which in the fail case is NULL.
>>
>> It's probably pointless to pretend one can
>> downgrade skb from sta-txq to vif-txq.
>
> Ok. I understand things until this point, more or less.
>
> What I don't understand - and you haven't really described - is how the
> changes fix it? Could you resend with a paragraph added that explains
> that?

"Since downgrading unicast traffic to vif->txq must not be done
there's no txq to put a frame on if sta->uploaded is false. Therefore
the code is made to fall back to regular tx() op path if the described
condition is hit. " -- is this sufficient?


> Also, you're adding a test:
>
>>       if (sta && !sta->uploaded)
>
> but couldn't do move that into the existing "if (sta)" block?
> Everything before that only ever returns NULL anyway.

Good point. It makes more sense to put the sta->uploaded check in if
(sta) block. I'll move it.


Micha=C5=82
