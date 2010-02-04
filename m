Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55494 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab0BDKMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 05:12:01 -0500
Received: by vws20 with SMTP id 20so846257vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 02:12:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87pr4ljs0j.fsf@purkki.valot.fi>
References: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
	 <1265266442-6273-2-git-send-email-vnatarajan@atheros.com>
	 <87pr4ljs0j.fsf@purkki.valot.fi>
Date: Thu, 4 Feb 2010 15:42:00 +0530
Message-ID: <8e92b4101002040212k6a8e594ao6191fda61ca867b4@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] mac80211: Reset dynamic ps timer in Rx path.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 4, 2010 at 2:29 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> If there is a continuous Rx UDP traffic with power save enabled,
>> there is some loss of packets with ath9k as Atheros chipsets
>> need to be awake to do Rx, unlike other vendor chipsets.
>
> Most probably this problem is related to ath9k staying awake after
> PS-Poll frame. Maybe we need to change mac80211 disable PS (but not
> send nullfunc!) when sending PS-Poll frames. But that might break p54,
> I don't know.
>
The issue I observed is related to dynamic power save getting triggered
by mac80211 eventhough there might be a continuous Rx traffic.

>> The current mac80211 implementation enables power save if there is
>> no Tx traffic for a specific timeout. This adversely affects ath9k
>> when there is a continuous Rx UDP traffic going on since it depends
>> only on the tim bit in the next beacon to awake. Fix this by
>> restarting the dynamic ps timer on receiving every data packet.

> But received multicast frames powersave should not disable powersave,
> otherwise on a busy network we would wakeup way too often.
Yes, this has been taken care in the patch.

>>  ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
>>  {
>>       struct ieee80211_sub_if_data *sdata = rx->sdata;
>> +     struct ieee80211_local *local = rx->local;
>>       struct net_device *dev = sdata->dev;
>>       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
>>       __le16 fc = hdr->frame_control;
>> @@ -1750,6 +1751,15 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
>>       dev->stats.rx_packets++;
>>       dev->stats.rx_bytes += rx->skb->len;
>>
>> +     if ((local->hw.flags & IEEE80211_HW_NEEDS_RX_PS_RESET) &&
>> +         ieee80211_is_data(hdr->frame_control) &&
>> +         !is_multicast_ether_addr(hdr->addr1)) {
>> +             if (local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
>> +                     mod_timer(&local->dynamic_ps_timer, jiffies +
>> +                      msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
>> +             }
>> +     }
>
> What if CONF_PS is set? You need to take that into account here and
> disable powersave when it's enabled.

With ath9k, for a data frame(non-multicast) to reach mac80211, CONF_PS
should have been disabled. in other words,a data packet will not reach mac80211
when CONF_PS is set. Hence that check might be redundant here.

Thanks
Vivek.
