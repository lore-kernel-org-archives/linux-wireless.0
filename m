Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32845 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab1JaHDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 03:03:14 -0400
Received: by wyg36 with SMTP id 36so5548338wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 00:03:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110291140.12311.chunkeey@googlemail.com>
References: <1319864732-11286-1-git-send-email-thomas@cozybit.com>
	<1319864732-11286-2-git-send-email-thomas@cozybit.com>
	<201110291140.12311.chunkeey@googlemail.com>
Date: Mon, 31 Oct 2011 00:03:12 -0700
Message-ID: <CAG6hwVPNfqriCij5p3Lia2+=ob0AwQjPQFXUssumvBMvu51qTg@mail.gmail.com> (sfid-20111031_080328_949903_AC781190)
Subject: Re: [PATCH 2/4] mac80211: QoS multicast frames have No Ack policy
From: Thomas Pedersen <thomas@cozybit.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 29, 2011 at 2:40 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Saturday 29 October 2011 07:05:30 Thomas Pedersen wrote:
>> Previously QoS multicast frames had the Normal Acknowledgment QoS
>> control bits set. This would cause broadcast frames to be discarded by
>> peers with which we have a BA session, since their sequence number would
>> fall outside the allowed range. Set No Ack QoS control bits on multicast
>> QoS frames and filter these in de-aggregation code.
>>
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>> ---
>>  net/mac80211/rx.c  |    8 +++++++-
>>  net/mac80211/wme.c |    3 ++-
>>  2 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
>> index b867bd5..ee9e71b 100644
>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -747,7 +747,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
>>       struct sta_info *sta = rx->sta;
>>       struct tid_ampdu_rx *tid_agg_rx;
>>       u16 sc;
>> -     int tid;
>> +     u8 tid, ack_policy;
>>
>>       if (!ieee80211_is_data_qos(hdr->frame_control))
>>               goto dont_reorder;
>> @@ -760,6 +760,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
>>       if (!sta)
>>               goto dont_reorder;
>>
>> +     ack_policy = *ieee80211_get_qos_ctl(hdr) & ~IEEE80211_QOS_CTL_TID_MASK;
> uh, while it might be a bit far fetched, but ack_policy might now clash with
> frames that have set:
>
> IEEE80211_QOS_CTL_EOSP (0x10)
> IEEE80211_QOS_CTL_A_MSDU_PRESENT (0x80)
> IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT (0x100)
>
> so I think we would be better of with something like:
>
> (in include/linux/ieee80211.h)
> #define IEEE80211_QOS_CTL_ACK_POLICY_MASK 0x0060
>
> ack_policy = *ieee80211_get_qos_ctl(hdr) & ~IEEE80211_QOS_CTL_ACK_POLICY_MASK;

Good idea. Will fix and resubmit.
>
>> @@ -770,6 +771,11 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
>>       if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
>>               goto dont_reorder;
>>
>> +     /* not part of a BA session */
>> +     if (!((ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK) ||
>> +           (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)))
>> +             goto dont_reorder;
>> +


Thanks,
Thomas
