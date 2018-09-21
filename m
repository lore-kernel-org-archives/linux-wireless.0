Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:56511 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727697AbeIUSKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 14:10:31 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Anilkumar Kolli <akolli@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFCv3 1/2] mac80211: implement ieee80211_tx_rate_update to update rate
In-Reply-To: <29efd8dc90c7ea75f6cd0d7e3787b463@codeaurora.org>
References: <1537445116-10780-1-git-send-email-akolli@codeaurora.org> <1537445116-10780-2-git-send-email-akolli@codeaurora.org> <87va706tfz.fsf@toke.dk> <29efd8dc90c7ea75f6cd0d7e3787b463@codeaurora.org>
Date: Fri, 21 Sep 2018 14:21:50 +0200
Message-ID: <87worfhwgx.fsf@toke.dk> (sfid-20180921_142156_473748_D8D5F8F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anilkumar Kolli <akolli@codeaurora.org> writes:

> On 2018-09-20 21:40, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Anilkumar Kolli <akolli@codeaurora.org> writes:
>>=20
>>> Current mac80211 has provision to update tx status through
>>> ieee80211_tx_status() and ieee80211_tx_status_ext(). But
>>> drivers like ath10k updates the tx status from the skb except
>>> txrate, txrate will be updated from a different path, peer stats.
>>>=20
>>> Using ieee80211_tx_status_ext() in two different paths
>>>   - (one for the stats, one for the tx rate) will duplicate the stats.
>>>=20
>>> To avoid this stats duplication, ieee80211_tx_rate_update() is=20
>>> implemented.
>>>=20
>>> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
>>> ---
>>> V3:
>>>   - Added new API in mac80211 to update tx rate(Johannes)
>>>=20
>>>  include/net/mac80211.h |   14 ++++++++++++++
>>>  net/mac80211/status.c  |   24 ++++++++++++++++++++++++
>>>  2 files changed, 38 insertions(+)
>>>=20
>>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>>> index 8c26d2d36cbe..042186a21770 100644
>>> --- a/include/net/mac80211.h
>>> +++ b/include/net/mac80211.h
>>> @@ -4331,6 +4331,20 @@ void=20
>>> ieee80211_sta_set_expected_throughput(struct ieee80211_sta *pubsta,
>>>  					   u32 thr);
>>>=20
>>>  /**
>>> + * ieee80211_tx_rate_update - transmit rate update callback
>>> + *
>>> + * This function can be used in drivers that does not have provision
>>> + * in updating the tx rate in data path.
>>> + *
>>> + * @hw: the hardware the frame was transmitted by
>>> + * @status: tx status information
>>> + * @pubsta: the station to update the tx rate for.
>>> + */
>>> +void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
>>> +			      struct ieee80211_sta *pubsta,
>>> +			      struct ieee80211_tx_info *info);
>>> +
>>> +/**
>>>   * ieee80211_tx_status - transmit status callback
>>>   *
>>>   * Call this function for all transmitted frames after they have been
>>> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
>>> index 9a6d7208bf4f..232297ddaa02 100644
>>> --- a/net/mac80211/status.c
>>> +++ b/net/mac80211/status.c
>>> @@ -988,6 +988,30 @@ void ieee80211_tx_status_ext(struct ieee80211_hw=20
>>> *hw,
>>>  }
>>>  EXPORT_SYMBOL(ieee80211_tx_status_ext);
>>>=20
>>> +void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
>>> +			      struct ieee80211_sta *pubsta,
>>> +			      struct ieee80211_tx_info *info)
>>> +{
>>> +	struct ieee80211_local *local =3D hw_to_local(hw);
>>> +	struct ieee80211_supported_band *sband;
>>> +	struct sta_info *sta;
>>> +	struct ieee80211_tx_status status;
>>> +
>>> +	sband =3D hw->wiphy->bands[info->band];
>>> +
>>> +	if (pubsta) {
>>=20
>> The function does nothing if pubsta is NULL; wouldn't it make more=20
>> sense
>> to just mandate that it isn't NULL rather than have this check?
>>=20
>
> ATH10K driver always calls this function with a valid STA [not NULL].

Yeah, so why the check for non-NULL? :)

-Toke
