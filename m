Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9176 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab2DQIHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 04:07:45 -0400
Message-ID: <4F8D24CC.5030205@qca.qualcomm.com> (sfid-20120417_100756_517819_E66A630B)
Date: Tue, 17 Apr 2012 13:37:40 +0530
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Validate legacy rateset.
References: <1334298173-4132-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120413_082304_815922_B50E6F19) <4F8C5776.6060209@sipsolutions.net>
In-Reply-To: <4F8C5776.6060209@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 11:01 PM, Johannes Berg wrote:
> On 4/12/2012 11:22 PM, Bala Shanmugam wrote:
>> Legacy rates are not validated while configuring
>> tx rateset using iw. So below cmd is accepted by nl80211.
>> sudo iw wlan2 set bitrates legacy-2.4 3
>>
>> Validate legacy rates and return
>> error while configuring improper rates.
>>
>> Signed-off-by: Bala Shanmugam<bkamatch@qca.qualcomm.com>
>> ---
>>   net/wireless/nl80211.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index e49da27..cc7bef7 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -5540,6 +5540,8 @@ static int nl80211_set_tx_bitrate_mask(struct 
>> sk_buff *skb,
>>                   sband,
>>                   nla_data(tb[NL80211_TXRATE_LEGACY]),
>>                   nla_len(tb[NL80211_TXRATE_LEGACY]));
>> +            if (mask.control[band].legacy == 0)
>> +                return -EINVAL;
>
> I don't think this is right since it would also reject an 
> intentionally empty set.
>
> johannes

This check comes into picture only when legacy rates are configured.
For intentionally empty set "if (tb[NL80211_TXRATE_LEGACY])" condition
will fail and control will not come here.  I tested the same.
With this patch
     "sudo iw wlan0 set bitrates mcs-5 6" executes without any error 
message.
     "sudo iw wlan0 set bitrates legacy-2.4 3" fails with error (command 
failed: Invalid argument (-22))

Without this patch
     "sudo iw wlan0 set bitrates legacy-2.4 3" executes without any 
error message

Regards,
Bala.
