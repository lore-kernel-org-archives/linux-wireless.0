Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31895 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2A3GM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 01:12:27 -0500
Message-ID: <4F2634C2.2070305@qca.qualcomm.com> (sfid-20120130_071253_776572_1DCC9460)
Date: Mon, 30 Jan 2012 11:42:18 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 0/8] Allow the user to define suspend mode
References: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com> <4F1E9A52.7070202@qca.qualcomm.com>
In-Reply-To: <4F1E9A52.7070202@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 January 2012 05:17 PM, Kalle Valo wrote:
> Hi Raja,
>
> On 01/20/2012 03:35 PM, rmani@qca.qualcomm.com wrote:
>
>> This series of patch enables the user to specify the suspend mode
>> via module parameter (suspend_mode) while doing insmod of the driver.
>>
>>     To select Cut Power mode:
>>        insmod ath6kl_sdio.ko suspend_mode = 1
>>
>>     To select Deep Sleep mode:
>>        insmod ath6kl_sdio.ko suspend_mode = 2
>>
>>     To select WOW suspend mode:
>>        insmod ath6kl_sdio.ko suspend_mode = 3
>>
>> Existing module param 'suspend_cutpower' variable is renamed to
>> 'suspend_mode' for this purspose.
>>
>> Additionally, If the user doesn't provide any WOW patterns,
>> the default WOW patterns will be configured while going to
>> WOW suspend mode.
>>
>> V2 changes:
>>
>>   * Existing automatic suspend mode selection logic is retained.
>>   * Suspend mode retry logic is improved without using loop.
>>   * Small patches are folded with appropriate patches as per Kalle's comments.
>>   * New wmi function is added to process set host sleep mode cmd processed event.
>
> Thanks, this is much better now. I reviewed the patches and found only
> minor issues.

Thanks for your review. I'll take care your comments in V3.

>
> Kalle
