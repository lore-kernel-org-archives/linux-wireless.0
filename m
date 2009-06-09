Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:26738 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034AbZFII4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 04:56:05 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2491413ywb.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 01:56:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244537651.4672.0.camel@johannes.local>
References: <1244536211-22535-1-git-send-email-lrodriguez@atheros.com>
	<1244536211-22535-2-git-send-email-lrodriguez@atheros.com>
	<1244537651.4672.0.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 9 Jun 2009 01:55:47 -0700
Message-ID: <43e72e890906090155n15f286x19a82910272016a1@mail.gmail.com>
Subject: Re: [PATCH 1/3] mac80211: fix - drop frames for sta with no valid
	rate
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, j@w1.fi, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 9, 2009 at 1:54 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Tue, 2009-06-09 at 04:30 -0400, Luis R. Rodriguez wrote:
>> If we're associated and scanning mac80211 will allow through
>> nullfunc and probe request frames. When we're scanning on a
>> different band than the one we're associated on we should
>> not send nullfunc frames to the sta on that band as it would
>> be the incorrect band.
>>
>> Lets catch the case where no valid rate is usable when associated
>> and discard those frames and warn only for the case the frame is
>> not a nullfunc or probe request as those are the only accounted
>> for frames mac80211 should allow through while scanning.
>>
>> This fixes an oops which occured due to an assert in ath9k:
>>
>> http://marc.info/?l=linux-wireless&m=124277331319024
>>
>> The assert was happening because the rate control algorithm
>> figures it should find at least one valid dual stream or
>> single stream rate. Since we allow mac80211 to send get_rate
>> callback for drivers for a sta on invalid band no valid will
>> actually have been found and hence the assert.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  include/net/mac80211.h |   11 +++++++++++
>>  net/mac80211/tx.c      |   38 ++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 49 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 17d61d1..9559efa 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -2103,6 +2103,17 @@ rate_lowest_index(struct ieee80211_supported_band *sband,
>>       return 0;
>>  }
>>
>> +static inline
>> +bool rate_usable_index_exists(struct ieee80211_supported_band *sband,
>> +                           struct ieee80211_sta *sta)
>> +{
>> +     unsigned int i;
>> +
>> +     for (i = 0; i < sband->n_bitrates; i++)
>> +             if (rate_supported(sta, sband->band, i))
>> +                     return true;
>> +     return false;
>> +}
>>
>>  int ieee80211_rate_control_register(struct rate_control_ops *ops);
>>  void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index 1436f74..03f9a4e 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -511,6 +511,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
>>       int i, len;
>>       bool inval = false, rts = false, short_preamble = false;
>>       struct ieee80211_tx_rate_control txrc;
>> +     u32 sta_flags;
>>
>>       memset(&txrc, 0, sizeof(txrc));
>>
>> @@ -543,7 +544,44 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
>>            (tx->sta && test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE))))
>>               txrc.short_preamble = short_preamble = true;
>>
>> +     sta_flags = tx->sta ? get_sta_flags(tx->sta) : 0;
>> +
>> +     /*
>> +      * Lets not bother rate control if we're associated and cannot
>> +      * talk to the sta. It makes little since for this to happen,
>> +      * it should mean we're scanning on another band somehow some frames
>> +      * got through the TX queue -- these should have been not been added
>> +      * to our TX queue. There is one excemption to this, but we handle
>> +      * these below.
>> +      */
>> +
>> +     if (unlikely((tx->local->sw_scanning) &&
>> +         (sta_flags & WLAN_STA_ASSOC) &&
>> +         !rate_usable_index_exists(sband, &tx->sta->sta))) {
>> +             /*
>> +              *  The only accounted for frames of this type in
>> +              *  mac80211 are probe requests and null func frames,
>> +              *  so just warn for other drop of frames. Drop the
>> +              *  frames anyway as we have no usable bit rate.
>> +              */
>
> Can we not avoid this situation to start with by flushing the master
> device queues before we go scan?

How do you do that?

  Luis
