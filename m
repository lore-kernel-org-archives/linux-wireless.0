Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:48951 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727683AbeIJQJy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 12:09:54 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 0/4] Move TXQ scheduling into mac80211
In-Reply-To: <1536565561.3224.10.camel@sipsolutions.net>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <1536565561.3224.10.camel@sipsolutions.net>
Date: Mon, 10 Sep 2018 13:16:19 +0200
Message-ID: <87bm95li0s.fsf@toke.dk> (sfid-20180910_131624_104214_E65F059F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2018-09-08 at 00:22 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> - I didn't get rid of the register_airtime() callback. As far as I can t=
ell,
>>   only iwlwifi uses the tx_time field in the struct tx_info. Which means=
 that
>>   we *could* probably use it for this and just make the other drivers se=
t it;
>>   but I'm not sure what effects that would have in relation to WMM-AC for
>>   those drivers, so I chickened out. Will have to try it out, I guess; b=
ut it
>>   also depends on whether ath10k needs to be able to report airtime
>>   asynchronously anyway. So I'll hold off on that for a bit more.
>
> I don't think you need to be concerned, the reporting through this has
> no immediate effect as the driver would also have to set the feature
> flag (NL80211_FEATURE_SUPPORTS_WMM_ADMISSION) for userspace to be able
> to use WMM admission TSPECs, and getting tx_tspec->admitted_time to be
> non-zero in ieee80211_sta_tx_wmm_ac_notify().

Great! In that case I'll try moving the reporting go through the tx_info
struct and check that it works for ath9k :)

-Toke
