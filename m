Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42998 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2KLV5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:57:13 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so4070085qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:57:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPjQAd-fniHzup-44V+KoOQT63bV8=VxAsGprH3qo6mV5y_aEw@mail.gmail.com>
References: <1352745513-1265-1-git-send-email-thomas@cozybit.com> <CAPjQAd-fniHzup-44V+KoOQT63bV8=VxAsGprH3qo6mV5y_aEw@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 12 Nov 2012 13:56:52 -0800
Message-ID: <CAG6hwVN4ty1GzKSzWt-m6yCZ_qHfz5vHtFo_+VW4CL8sfU6r2g@mail.gmail.com> (sfid-20121112_225717_500496_AD61E4B9)
Subject: Re: [PATCH] mac80211: support RX_FLAG_MACTIME_END
To: Javier Cardona <javier@cozybit.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 12:11 PM, Javier Cardona <javier@cozybit.com> wrote:
> Thomas,
>
> On Mon, Nov 12, 2012 at 10:38 AM, Thomas Pedersen <thomas@cozybit.com> wrote:
>> Allow drivers to indicate their mactime is at RX completion and adjust
>> for this in mac80211. Based on similar code by Johannes Berg.
>>
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>> ---
>>  include/net/mac80211.h     |    4 ++++
>>  net/mac80211/ibss.c        |   29 +++++--------------------
>>  net/mac80211/ieee80211_i.h |    9 ++++++++
>>  net/mac80211/mesh_sync.c   |   43 ++++++-------------------------------
>>  net/mac80211/rx.c          |   14 ++++++++++---
>>  net/mac80211/util.c        |   50 ++++++++++++++++++++++++++++++++++++++++++++
>>  6 files changed, 85 insertions(+), 64 deletions(-)
>>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 00b7204..a2b9b52 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -704,6 +704,9 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
>>   *     field) is valid and contains the time the first symbol of the MPDU
>>   *     was received. This is useful in monitor mode and for proper IBSS
>>   *     merging.
>> + * @RX_FLAG_MACTIME_END: The timestamp passed in the RX status (@mactime
>> + *     field) is valid and contains the time the last symbol of the MPDU
>> + *     was received.
>
> So with this change, you are suggesting that drivers set at most *one*
> of  RX_FLAG_MACTIME_MPDU (if they report mactime at the start of the
> frame) or RX_FLAG_MACTIME_END (at the end)?  If so, at the risk of
> being too verbose, I would suggest to use
> RX_FLAG_MACTIME_MPDU_{START,END} or to mention this in the comment:
> "This flag should not be set with RX_FLAG_MACTIME_MPDU"

OK, I'll rename RX_FLAG_MACTIME_MDPU to RX_FLAG_MACTIME START in the v2 then.

>>   * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
>>   * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
>>   * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
>> @@ -748,6 +751,7 @@ enum mac80211_rx_flags {
>>         RX_FLAG_AMPDU_IS_LAST           = BIT(18),
>>         RX_FLAG_AMPDU_DELIM_CRC_ERROR   = BIT(19),
>>         RX_FLAG_AMPDU_DELIM_CRC_KNOWN   = BIT(20),
>> +       RX_FLAG_MACTIME_END             = BIT(21),
>>  };
>>
>>  /**
>> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
>> index c7386b2..92500d8 100644
>> --- a/net/mac80211/ibss.c
>> +++ b/net/mac80211/ibss.c
>> @@ -543,30 +543,11 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
>>         if (ether_addr_equal(cbss->bssid, sdata->u.ibss.bssid))
>>                 goto put_bss;
>>
>> -       if (rx_status->flag & RX_FLAG_MACTIME_MPDU) {
>> -               /*
>> -                * For correct IBSS merging we need mactime; since mactime is
>> -                * defined as the time the first data symbol of the frame hits
>> -                * the PHY, and the timestamp of the beacon is defined as "the
>> -                * time that the data symbol containing the first bit of the
>> -                * timestamp is transmitted to the PHY plus the transmitting
>> -                * STA's delays through its local PHY from the MAC-PHY
>> -                * interface to its interface with the WM" (802.11 11.1.2)
>> -                * - equals the time this bit arrives at the receiver - we have
>> -                * to take into account the offset between the two.
>> -                *
>> -                * E.g. at 1 MBit that means mactime is 192 usec earlier
>> -                * (=24 bytes * 8 usecs/byte) than the beacon timestamp.
>> -                */
>> -               int rate;
>> -
>> -               if (rx_status->flag & RX_FLAG_HT)
>> -                       rate = 65; /* TODO: HT rates */
>
> Ah, and I see that in your proposed
> ieee80211_calculate_rx_timestamp() you take care of HT rates... nice.
>
>> -               else
>> -                       rate = local->hw.wiphy->bands[band]->
>> -                               bitrates[rx_status->rate_idx].bitrate;
>> -
>> -               rx_timestamp = rx_status->mactime + (24 * 8 * 10 / rate);
>> +       if (ieee80211_have_rx_timestamp(rx_status)) {
>> +               /* time when timestamp field was received */
>> +               rx_timestamp =
>> +                       ieee80211_calculate_rx_timestamp(local, rx_status,
>> +                                                        len + 4, 24);
>>         } else {
>>                 /*
>>                  * second best option: get current TSF
>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>> index 3026519..6162342 100644
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -1251,7 +1251,16 @@ static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
>>                is_broadcast_ether_addr(raddr);
>>  }
>>
>> +static inline bool
>> +ieee80211_have_rx_timestamp(struct ieee80211_rx_status *status)
>> +{
>
> Maybe...
>
> WARN_ON((status->flag & RX_FLAG_MACTIME_MPDU) &&
>                      (status->flag & RX_FLAG_MACTIME_END))  ?
>

OK.

Thomas
