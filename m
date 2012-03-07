Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28466 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2CGFUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 00:20:42 -0500
Message-ID: <4F56F023.1090201@qca.qualcomm.com> (sfid-20120307_062047_123714_80C71C91)
Date: Wed, 7 Mar 2012 10:50:35 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2] ath6kl: Add provision to define suspend policy in
 disconnected state.
References: <1331026439-7822-1-git-send-email-rmani@qca.qualcomm.com> <4F563776.8090000@qca.qualcomm.com>
In-Reply-To: <4F563776.8090000@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 March 2012 09:42 PM, Kalle Valo wrote:
> On 03/06/2012 11:33 AM, rmani@qca.qualcomm.com wrote:
>> From: Raja Mani<rmani@qca.qualcomm.com>
>>
>> It gives flexibility to the user to define suspend policy
>> when the suspend mode is set to WOW and the device is in
>> disconnected state at the time of suspend.
>>
>> New module parameter wow_mode is added to get the choice
>> from the user. This parameter is valid only if the module
>> parameter suspend_mode is set to WOW.
>>
>> To force WOW in connected state and cut power
>> in disconnected state:
>>    suspend_mode=0x3 wow_mode=0x1
>>
>> To force WOW in connected state and deep sleep
>> in disconnected state:
>>     suspend_mode=0x3 wow_mode=0x2
>>
>> If there is no value specified to wow_mode during insmod,
>> deep sleep mode will be tried in the disconnected state.
>>
>> Signed-off-by: Raja Mani<rmani@qca.qualcomm.com>
>
> [...]
>
>> +		if (ret&&  (!ar->wow_suspend_mode ||
>> +		    ar->wow_suspend_mode == WLAN_POWER_STATE_DEEP_SLEEP))
>> +				try_deepsleep = true;
>
> I don't get this part. If the wow_mode parameter is set to 0 or 2 the
> functionality is the same, right? So what's the point with 0x2 the
> commit log? Deep sleep will be the default in disconnected anyway.
> Unless I misunderstood something, of course.

Yes, the functionality is the same for both cases (0 or 2).
passing 2 to wow_mode is an explicitly option.
The value 0 is the default case.

Should we remove option 2 in wow_mode and keep only
option 1 ?

>
> Kalle
