Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbeIXMbQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 08:31:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 24 Sep 2018 12:00:43 +0530
From: Anilkumar Kolli <akolli@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFCv3 1/2] mac80211: implement ieee80211_tx_rate_update to
 update rate
In-Reply-To: <87worfhwgx.fsf@toke.dk>
References: <1537445116-10780-1-git-send-email-akolli@codeaurora.org>
 <1537445116-10780-2-git-send-email-akolli@codeaurora.org>
 <87va706tfz.fsf@toke.dk> <29efd8dc90c7ea75f6cd0d7e3787b463@codeaurora.org>
 <87worfhwgx.fsf@toke.dk>
Message-ID: <39746e839c1ad5011f2948540140ee0d@codeaurora.org> (sfid-20180924_083047_326245_A65F0576)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-21 17:51, Toke Høiland-Jørgensen wrote:
> Anilkumar Kolli <akolli@codeaurora.org> writes:
> 
>> On 2018-09-20 21:40, Toke Høiland-Jørgensen wrote:
>>> Anilkumar Kolli <akolli@codeaurora.org> writes:
>>> 
>>>> Current mac80211 has provision to update tx status through
>>>> ieee80211_tx_status() and ieee80211_tx_status_ext(). But
>>>> drivers like ath10k updates the tx status from the skb except
>>>> txrate, txrate will be updated from a different path, peer stats.
>>>> 
>>>> Using ieee80211_tx_status_ext() in two different paths
>>>>   - (one for the stats, one for the tx rate) will duplicate the 
>>>> stats.
>>>> 
>>>> To avoid this stats duplication, ieee80211_tx_rate_update() is
>>>> implemented.
>>>> 
>>>> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
>>>> ---
>>>> V3:
>>>>   - Added new API in mac80211 to update tx rate(Johannes)
>>>> 
>>>>  include/net/mac80211.h |   14 ++++++++++++++
>>>>  net/mac80211/status.c  |   24 ++++++++++++++++++++++++
>>>>  2 files changed, 38 insertions(+)
>>>> 
>>>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>>>> index 8c26d2d36cbe..042186a21770 100644
>>>> --- a/include/net/mac80211.h
>>>> +++ b/include/net/mac80211.h
>>>> @@ -4331,6 +4331,20 @@ void
>>>> ieee80211_sta_set_expected_throughput(struct ieee80211_sta *pubsta,
>>>>  					   u32 thr);
>>>> 
>>>>  /**
>>>> + * ieee80211_tx_rate_update - transmit rate update callback
>>>> + *
>>>> + * This function can be used in drivers that does not have 
>>>> provision
>>>> + * in updating the tx rate in data path.
>>>> + *
>>>> + * @hw: the hardware the frame was transmitted by
>>>> + * @status: tx status information
>>>> + * @pubsta: the station to update the tx rate for.
>>>> + */
>>>> +void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
>>>> +			      struct ieee80211_sta *pubsta,
>>>> +			      struct ieee80211_tx_info *info);
>>>> +
>>>> +/**
>>>>   * ieee80211_tx_status - transmit status callback
>>>>   *
>>>>   * Call this function for all transmitted frames after they have 
>>>> been
>>>> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
>>>> index 9a6d7208bf4f..232297ddaa02 100644
>>>> --- a/net/mac80211/status.c
>>>> +++ b/net/mac80211/status.c
>>>> @@ -988,6 +988,30 @@ void ieee80211_tx_status_ext(struct 
>>>> ieee80211_hw
>>>> *hw,
>>>>  }
>>>>  EXPORT_SYMBOL(ieee80211_tx_status_ext);
>>>> 
>>>> +void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
>>>> +			      struct ieee80211_sta *pubsta,
>>>> +			      struct ieee80211_tx_info *info)
>>>> +{
>>>> +	struct ieee80211_local *local = hw_to_local(hw);
>>>> +	struct ieee80211_supported_band *sband;
>>>> +	struct sta_info *sta;
>>>> +	struct ieee80211_tx_status status;
>>>> +
>>>> +	sband = hw->wiphy->bands[info->band];
>>>> +
>>>> +	if (pubsta) {
>>> 
>>> The function does nothing if pubsta is NULL; wouldn't it make more
>>> sense
>>> to just mandate that it isn't NULL rather than have this check?
>>> 
>> 
>> ATH10K driver always calls this function with a valid STA [not NULL].
> 
> Yeah, so why the check for non-NULL? :)
> 

Agreed we can remove this check since ath10k driver calls 
ieee80211_tx_rate_update()
with a valid STA. This adds a sanity check to avoid NULL dereference on 
pubsta.

I will update the comments on ieee80211_tx_rate_update() and send RFCv4.

Thanks
Anil.
