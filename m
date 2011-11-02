Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62862 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab1KBRfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 13:35:20 -0400
Received: by wyh15 with SMTP id 15so386845wyh.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2011 10:35:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1320229077.3950.40.camel@jlt3.sipsolutions.net>
References: <1319864732-11286-1-git-send-email-thomas@cozybit.com>
	<1319864732-11286-2-git-send-email-thomas@cozybit.com>
	<1320229077.3950.40.camel@jlt3.sipsolutions.net>
Date: Wed, 2 Nov 2011 10:35:18 -0700
Message-ID: <CAG6hwVOqyb6Oi63vjD0j6KLAc70cpiWsb9MOR2mZjqPqnVNAcQ@mail.gmail.com> (sfid-20111102_183524_064249_CE28CF8E)
Subject: Re: [PATCH 2/4] mac80211: QoS multicast frames have No Ack policy
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 2, 2011 at 3:17 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-10-28 at 22:05 -0700, Thomas Pedersen wrote:
>> Previously QoS multicast frames had the Normal Acknowledgment QoS
>> control bits set. This would cause broadcast frames to be discarded by
>> peers with which we have a BA session, since their sequence number would
>> fall outside the allowed range. Set No Ack QoS control bits on multicast
>> QoS frames and filter these in de-aggregation code.
>
> I'm not sure why you would attempt to deaggregate broadcast frames but I
> guess mesh is a bit special.
>
>> @@ -770,6 +771,11 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
>>       if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
>>               goto dont_reorder;
>>
>> +     /* not part of a BA session */
>> +     if (!((ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK) ||
>> +           (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)))
>> +             goto dont_reorder;
>
> Maybe ack_policy != BA && ack_policy != NORMAl would be easier to read?

OK.
>
>> --- a/net/mac80211/wme.c
>> +++ b/net/mac80211/wme.c
>> @@ -147,7 +147,8 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
>>
>>               tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
>>
>> -             if (unlikely(sdata->local->wifi_wme_noack_test))
>> +             if (unlikely(sdata->local->wifi_wme_noack_test) ||
>> +                 is_multicast_ether_addr(hdr->addr1))
>>                       ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
>
> Interestingly, this seems to have been a bug for a long time --
> 7.1.3.5.3 indicates this is supposed to be done.

I'll fix up the other patches as well and resubmit.

Thanks!
Thomas
