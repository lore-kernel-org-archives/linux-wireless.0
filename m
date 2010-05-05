Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:33519 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab0EEG2w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 02:28:52 -0400
Message-ID: <4BE1101C.4010708@free.fr>
Date: Wed, 05 May 2010 08:28:44 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Check for channel HT capabilities in an IBSS
References: <1272955622-6987-1-git-send-email-benoit.papillault@free.fr> 	<1272955622-6987-2-git-send-email-benoit.papillault@free.fr> <o2h43e72e891005041114sb04fbfcbl7e1f144826a02479@mail.gmail.com>
In-Reply-To: <o2h43e72e891005041114sb04fbfcbl7e1f144826a02479@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 04/05/2010 20:14, Luis R. Rodriguez a écrit :
> On Mon, May 3, 2010 at 11:47 PM, Benoit Papillault
> <benoit.papillault@free.fr>  wrote:
>> When configuring an HT IBSS, we need to check if the specified channel
>> is capable of ht40+, ht40- or ht20.
>>
>> Signed-off-by: Benoit Papillault<benoit.papillault@free.fr>
>> ---
>>   net/wireless/nl80211.c |    8 ++++----
>>   1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index 8da9823..0a82623 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -3858,11 +3858,11 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
>>                 ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
>>         }
>>
>> -       ibss.channel = ieee80211_get_channel(wiphy,
>> -               nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
>> +       ibss.channel = rdev_freq_to_chan(rdev,
>> +               nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
>> +               channel_type);
>>         if (!ibss.channel ||
>> -           ibss.channel->flags&  IEEE80211_CHAN_NO_IBSS ||
>> -           ibss.channel->flags&  IEEE80211_CHAN_DISABLED) {
>> +           ibss.channel->flags&  IEEE80211_CHAN_NO_IBSS) {
>>                 err = -EINVAL;
>
> Why is the disabled channel check being removed here?
>
>    Luis
>

Hi Luis,

It's because the check is already done in rdev_freq_to_chan.

Regards,
Benoit
