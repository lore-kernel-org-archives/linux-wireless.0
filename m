Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45538 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2CATaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 14:30:46 -0500
Message-ID: <4F4FCE4E.8080809@qca.qualcomm.com> (sfid-20120301_203050_711907_45F3FF6B)
Date: Thu, 1 Mar 2012 21:30:22 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Add provision to define suspend policy in disconnected
 state.
References: <1329308528-2925-1-git-send-email-rmani@qca.qualcomm.com> <4F4BC77F.2010400@qca.qualcomm.com> <4F4DCA37.4090000@qca.qualcomm.com>
In-Reply-To: <4F4DCA37.4090000@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/29/2012 08:48 AM, Raja Mani wrote:
> On Monday 27 February 2012 11:42 PM, Kalle Valo wrote:
>
>> I'm not sure if adding bits to suspend_mode is the best way. To me
>> adding a separate parameter wow_mode looks easier from user's point of
>> view. What do you think?
>>
>> And if you add a new module paratemer please use charp type so that can
>> use strings like 'deepsleep' and 'cutpower'. I wish that we had used
>> that already with suspend_mode but it's too late now :(
> 
> My initial idea was, to reuse existing suspend_mode module
> parameter itself to avoid new module parameter.
> 
> I am okay to have a new module parameter wow_mode for that.

I think having a new module parameter is easier for everyone.

> Having charp type for new module parameter wow_mode is fine.
> But still suspend_mode parameter accepts value in uint.
> 
> Either we should have charp type for both suspend_mode and wow_mode
> module parameters (or) keep uint type for both. Otherwise having charp
> type for wow_mode and having uint for suspend_mode may create confusion
> to the user.
> 
> I prefer uint type at this point. What do you say ?

You have a point. uint in both parameters is better for now as we can't
change suspend_mode without breaking existing setups.

>>> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
>>> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
>>> @@ -2063,7 +2063,6 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
>>>
>>>   		ret = ath6kl_wow_suspend(ar, wow);
>>>   		if (ret) {
>>> -			ath6kl_err("wow suspend failed: %d\n", ret);
>>>   			ar->state = prev_state;
>>>   			return ret;
>>>   		}
>>
>> Please convert this to a debug message, maybe using the suspend level.
>> It might be useful when debugging something.
> 
> I moved this error statement to ath6kl_sdio_suspend func in the same
> patch.
> 
> 		if (ret && ret != -ENOTCONN)
> 			ath6kl_err("wow suspend failed: %d\n", ret);
> 
> I think it should error message, not a debug message. We want to
> display wow suspend failures irrespective of debug mask level.

Yes, that's a good aproach.

>>> diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
>>> index c4926cf..37c92a1 100644
>>> --- a/drivers/net/wireless/ath/ath6kl/core.c
>>> +++ b/drivers/net/wireless/ath/ath6kl/core.c
>>> @@ -41,6 +41,7 @@ int ath6kl_core_init(struct ath6kl *ar)
>>>   {
>>>   	struct ath6kl_bmi_target_info targ_info;
>>>   	struct net_device *ndev;
>>> +	u16 pri_suspend_mode, wow2_suspend_mode;
>>
>> Why the number two? Why not just wow_suspend_mode?
> 
> Agree, can be renamed to wow_suspend_mode. I'll correct it V2.

Thanks.

Kalle
