Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63153 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab1LMJHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 04:07:38 -0500
Message-ID: <4EE71542.8040602@qca.qualcomm.com> (sfid-20111213_100744_057945_1762B25A)
Date: Tue, 13 Dec 2011 14:35:06 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>
Subject: Re: [RFC 2/2] mac80211: Fix power save in change save
References: <1323766515-19223-1-git-send-email-mohammed@qca.qualcomm.com>	 <1323766515-19223-2-git-send-email-mohammed@qca.qualcomm.com> <1323766643.3355.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1323766643.3355.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tuesday 13 December 2011 02:27 PM, Johannes Berg wrote:
> On Tue, 2011-12-13 at 14:25 +0530, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> we found that power save is not getting enabled when we do
>> change interface in this order STA->IBSS->STA. this is
>> because ieee80211_setup_sdata clears type-dependen union
>>
>> Reported-by: Leela Kella<leela@qca.qualcomm.com>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>> ---
>>   net/mac80211/mlme.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index 67a6be1..d87fde3 100644
>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>> @@ -2371,6 +2371,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
>>   		    (unsigned long) sdata);
>>
>>   	ifmgd->flags = 0;
>> +	ifmgd->powersave = sdata->wdev.ps;
>
> Makes sense.

thanks for the review, I will fix the subject name also.

>
> johannes
>


-- 
thanks,
shafi
