Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57294 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933359AbeGJPEr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 11:04:47 -0400
Subject: Re: [PATCHv2] mac80211: add stop/start logic for software TXQs
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <1531225597-4736-1-git-send-email-mpubbise@codeaurora.org>
 <87o9ffcknp.fsf@toke.dk>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <defe411e-1371-6e1c-9414-02fc323c4ec8@codeaurora.org> (sfid-20180710_170451_607752_4A4DF8D3)
Date: Tue, 10 Jul 2018 20:34:38 +0530
MIME-Version: 1.0
In-Reply-To: <87o9ffcknp.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/10/2018 6:28 PM, Toke Høiland-Jørgensen wrote:

>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>> index 172aeae..d07f7f9 100644
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -818,6 +818,7 @@ enum txq_info_flags {
>>   	IEEE80211_TXQ_STOP,
>>   	IEEE80211_TXQ_AMPDU,
>>   	IEEE80211_TXQ_NO_AMSDU,
>> +	IEEE80211_TXQ_PAUSED,
>>   };
> I think it would be a good idea to either rename the flags, or at least
> add an explanation somewhere of the difference between a paused and a
> stopped queue...

Initially, the idea was to use IEEE80211_TXQ_STOP flag to indicate that 
iTXQs are stopped; since this flag was used in the aggregation code, I 
was unsure whether the same flag can be used to indicate the iTXQ stop 
condition.
I could not find any better name for this:-).

Johannes, any thought?

>>   /**
>> @@ -1226,6 +1227,7 @@ struct ieee80211_local {
>>   
>>   	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
>>   	struct tasklet_struct tx_pending_tasklet;
>> +	struct tasklet_struct wake_txqs_tasklet;
> It's not quite clear to me why a tasklet is needed? Couldn't you just
> call the ieee80211_wake_txqs() function at the same place where you
> currently schedule the tasklet?

Since driver can also invoke wake_queues() operation; there can be a 
possible deadlock situation. At least, in ath10k there was deadlock on 
the "htt->tx_lock"; wake_queues() is invoked by taking the tx_lock and 
the same lock is acquired again in wake_tx_queue().
Also, by deferring wake_txqs(), drivers can safely invoke wake_queues().

-Manikanta
