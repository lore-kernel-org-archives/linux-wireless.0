Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36395 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933359AbeGJPW1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 11:22:27 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2] mac80211: add stop/start logic for software TXQs
In-Reply-To: <defe411e-1371-6e1c-9414-02fc323c4ec8@codeaurora.org>
References: <1531225597-4736-1-git-send-email-mpubbise@codeaurora.org> <87o9ffcknp.fsf@toke.dk> <defe411e-1371-6e1c-9414-02fc323c4ec8@codeaurora.org>
Date: Tue, 10 Jul 2018 17:22:24 +0200
Message-ID: <87in5ncdzj.fsf@toke.dk> (sfid-20180710_172230_614449_7C5ECE84)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Manikanta Pubbisetty <mpubbise@codeaurora.org> writes:

> On 7/10/2018 6:28 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>>> index 172aeae..d07f7f9 100644
>>> --- a/net/mac80211/ieee80211_i.h
>>> +++ b/net/mac80211/ieee80211_i.h
>>> @@ -818,6 +818,7 @@ enum txq_info_flags {
>>>   	IEEE80211_TXQ_STOP,
>>>   	IEEE80211_TXQ_AMPDU,
>>>   	IEEE80211_TXQ_NO_AMSDU,
>>> +	IEEE80211_TXQ_PAUSED,
>>>   };
>> I think it would be a good idea to either rename the flags, or at least
>> add an explanation somewhere of the difference between a paused and a
>> stopped queue...
>
> Initially, the idea was to use IEEE80211_TXQ_STOP flag to indicate that=20
> iTXQs are stopped; since this flag was used in the aggregation code, I=20
> was unsure whether the same flag can be used to indicate the iTXQ stop=20
> condition.
> I could not find any better name for this:-).

Hmm, yeah, not sure whether the two code paths can stomp on each other
if you reuse the flag. It would be neat to be able to reuse it, though...

Otherwise, how about renaming the old one to _STOP_AGGR and calling the
new one _STOP_NETIF or something?

>>>   /**
>>> @@ -1226,6 +1227,7 @@ struct ieee80211_local {
>>>=20=20=20
>>>   	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
>>>   	struct tasklet_struct tx_pending_tasklet;
>>> +	struct tasklet_struct wake_txqs_tasklet;
>> It's not quite clear to me why a tasklet is needed? Couldn't you just
>> call the ieee80211_wake_txqs() function at the same place where you
>> currently schedule the tasklet?
>
> Since driver can also invoke wake_queues() operation; there can be a=20
> possible deadlock situation. At least, in ath10k there was deadlock on=20
> the "htt->tx_lock"; wake_queues() is invoked by taking the tx_lock and=20
> the same lock is acquired again in wake_tx_queue().
> Also, by deferring wake_txqs(), drivers can safely invoke wake_queues().

Right, that makes sense :)

-Toke
