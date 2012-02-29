Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31309 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964954Ab2B2Gsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 01:48:30 -0500
Message-ID: <4F4DCA37.4090000@qca.qualcomm.com> (sfid-20120229_074835_209418_D7C4388D)
Date: Wed, 29 Feb 2012 12:18:23 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Add provision to define suspend policy in disconnected
 state.
References: <1329308528-2925-1-git-send-email-rmani@qca.qualcomm.com> <4F4BC77F.2010400@qca.qualcomm.com>
In-Reply-To: <4F4BC77F.2010400@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 27 February 2012 11:42 PM, Kalle Valo wrote:
> On 02/15/2012 02:22 PM, rmani@qca.qualcomm.com wrote:
>> From: Raja Mani<rmani@qca.qualcomm.com>
>>
>> It gives flexibility to the user to define suspend policy
>> when the suspend mode is set to WOW and the device is in
>> disconnected state at the time of suspend.
>>
>> Some bits (bit 4 to 7) of existing mod parameter suspend_mode
>> is used for that purpose. There is no change in the existing
>> way of defining suspend mode.
>>
>> To force cut power:
>>    suspend_mode=0x1
>>
>> To force deep sleep:
>>    suspend_mode=0x2
>>
>> To force wow (deep sleep is the default mode
>> in disconnected state):
>>    suspend_mode=0x3
>>
>> To force wow in connected state and cut power
>> in disconnected state:
>>    suspend_mode=0x13
>
> What's the difference between values 0x3 and 0x13? It wasn't clear for
> me from the description and neither from the code.

0x3  : WOW in connected state and Deep sleep in
        disconnected state (default).
0x13 : WOW in connected state and Cut power in disconnected state.

>
>> To force wow in connected state and deep sleep
>> in disconnected state:
>>    suspend_mode=0x23
>
> I'm not sure if adding bits to suspend_mode is the best way. To me
> adding a separate parameter wow_mode looks easier from user's point of
> view. What do you think?
>
> And if you add a new module paratemer please use charp type so that can
> use strings like 'deepsleep' and 'cutpower'. I wish that we had used
> that already with suspend_mode but it's too late now :(

My initial idea was, to reuse existing suspend_mode module
parameter itself to avoid new module parameter.

I am okay to have a new module parameter wow_mode for that.

Having charp type for new module parameter wow_mode is fine.
But still suspend_mode parameter accepts value in uint.

Either we should have charp type for both suspend_mode and wow_mode
module parameters (or) keep uint type for both. Otherwise having charp
type for wow_mode and having uint for suspend_mode may create confusion
to the user.

I prefer uint type at this point. What do you say ?

>
>> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
>> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
>> @@ -2063,7 +2063,6 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
>>
>>   		ret = ath6kl_wow_suspend(ar, wow);
>>   		if (ret) {
>> -			ath6kl_err("wow suspend failed: %d\n", ret);
>>   			ar->state = prev_state;
>>   			return ret;
>>   		}
>
> Please convert this to a debug message, maybe using the suspend level.
> It might be useful when debugging something.

I moved this error statement to ath6kl_sdio_suspend func in the same
patch.

		if (ret && ret != -ENOTCONN)
			ath6kl_err("wow suspend failed: %d\n", ret);

I think it should error message, not a debug message. We want to
display wow suspend failures irrespective of debug mask level.

>
>> diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
>> index c4926cf..37c92a1 100644
>> --- a/drivers/net/wireless/ath/ath6kl/core.c
>> +++ b/drivers/net/wireless/ath/ath6kl/core.c
>> @@ -41,6 +41,7 @@ int ath6kl_core_init(struct ath6kl *ar)
>>   {
>>   	struct ath6kl_bmi_target_info targ_info;
>>   	struct net_device *ndev;
>> +	u16 pri_suspend_mode, wow2_suspend_mode;
>
> Why the number two? Why not just wow_suspend_mode?

Agree, can be renamed to wow_suspend_mode. I'll correct it V2.

>
> Kalle
