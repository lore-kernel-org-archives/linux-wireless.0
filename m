Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19075 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2CGGq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 01:46:28 -0500
Message-ID: <4F57043F.10605@qca.qualcomm.com> (sfid-20120307_074657_441626_00D92C5D)
Date: Wed, 7 Mar 2012 08:46:23 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2] ath6kl: Add provision to define suspend policy in
 disconnected state.
References: <1331026439-7822-1-git-send-email-rmani@qca.qualcomm.com> <4F563776.8090000@qca.qualcomm.com> <4F56F023.1090201@qca.qualcomm.com>
In-Reply-To: <4F56F023.1090201@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2012 07:20 AM, Raja Mani wrote:
> On Tuesday 06 March 2012 09:42 PM, Kalle Valo wrote:
>
>>> +		if (ret&&  (!ar->wow_suspend_mode ||
>>> +		    ar->wow_suspend_mode == WLAN_POWER_STATE_DEEP_SLEEP))
>>> +				try_deepsleep = true;
>>
>> I don't get this part. If the wow_mode parameter is set to 0 or 2 the
>> functionality is the same, right? So what's the point with 0x2 the
>> commit log? Deep sleep will be the default in disconnected anyway.
>> Unless I misunderstood something, of course.
> 
> Yes, the functionality is the same for both cases (0 or 2).
> passing 2 to wow_mode is an explicitly option.
> The value 0 is the default case.
> 
> Should we remove option 2 in wow_mode and keep only
> option 1 ?

Thanks, now I understand. No need to change anything, I'll just clarify
in the commit log that option 2 is the default as well.

Kalle
