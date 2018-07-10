Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43680 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933506AbeGJQ1q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 12:27:46 -0400
Subject: Re: [PATCHv2] mac80211: add stop/start logic for software TXQs
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <1531225597-4736-1-git-send-email-mpubbise@codeaurora.org>
 <87o9ffcknp.fsf@toke.dk>
 <defe411e-1371-6e1c-9414-02fc323c4ec8@codeaurora.org>
 <87in5ncdzj.fsf@toke.dk>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <b91ace0b-412a-c654-0a03-49ed7138abd0@codeaurora.org> (sfid-20180710_182750_469035_C1B7AB2E)
Date: Tue, 10 Jul 2018 21:57:42 +0530
MIME-Version: 1.0
In-Reply-To: <87in5ncdzj.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 7/10/2018 8:52 PM, Toke Høiland-Jørgensen wrote:
> Manikanta Pubbisetty <mpubbise@codeaurora.org> writes:
>
>> On 7/10/2018 6:28 PM, Toke Høiland-Jørgensen wrote:
>>
>>>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>>>> index 172aeae..d07f7f9 100644
>>>> --- a/net/mac80211/ieee80211_i.h
>>>> +++ b/net/mac80211/ieee80211_i.h
>>>> @@ -818,6 +818,7 @@ enum txq_info_flags {
>>>>    	IEEE80211_TXQ_STOP,
>>>>    	IEEE80211_TXQ_AMPDU,
>>>>    	IEEE80211_TXQ_NO_AMSDU,
>>>> +	IEEE80211_TXQ_PAUSED,
>>>>    };
>>> I think it would be a good idea to either rename the flags, or at least
>>> add an explanation somewhere of the difference between a paused and a
>>> stopped queue...
>> Initially, the idea was to use IEEE80211_TXQ_STOP flag to indicate that
>> iTXQs are stopped; since this flag was used in the aggregation code, I
>> was unsure whether the same flag can be used to indicate the iTXQ stop
>> condition.
>> I could not find any better name for this:-).
> Hmm, yeah, not sure whether the two code paths can stomp on each other
> if you reuse the flag. It would be neat to be able to reuse it, though...
>
> Otherwise, how about renaming the old one to _STOP_AGGR and calling the
> new one _STOP_NETIF or something?

These ones are much better, thanks toke!!
I would probably like to extend the name to _STOP_NETIF_TX; how about 
keeping the old one as is  and renaming _TXQ_PAUSED to _TXQ_STOP_NETIF_TX ?

-Manikanta
