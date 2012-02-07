Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49199 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2BGKOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 05:14:30 -0500
Message-ID: <4F30F980.9010206@qca.qualcomm.com> (sfid-20120207_111434_335960_AD7D72E5)
Date: Tue, 7 Feb 2012 15:44:24 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Check wow state before sending control and data
 pkt
References: <1328536613-17521-1-git-send-email-rmani@qca.qualcomm.com> <4F2FE044.2000106@qca.qualcomm.com>
In-Reply-To: <4F2FE044.2000106@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 February 2012 07:44 PM, Kalle Valo wrote:
> On 02/06/2012 03:56 PM, rmani@qca.qualcomm.com wrote:
>> From: Raja Mani<rmani@qca.qualcomm.com>
>>
>> * TX operation (ctrl tx and data tx) has to be controlled based on
>>    WOW suspend state. i.e, control packets are allowed to send from
>>    the host until the suspend state goes ATH6KL_STATE_WOW and
>>    the data packets are allowed until WOW suspend operation starts.
>>
>> * Similary, wow resume is NOT allowed if WOW suspend is in progress.
>>
>> Both of the above scenarios are taken care in this patch.
>>
>> Signed-off-by: Raja Mani<rmani@qca.qualcomm.com>
>
> [...]
>
>> +enum ath6kl_wow_state {
>> +	ATH6KL_WOW_STATE_NONE,
>> +	ATH6KL_WOW_STATE_SUSPENDING,
>> +	ATH6KL_WOW_STATE_SUSPENDED,
>> +};
>> +
>>   struct ath6kl {
>>   	struct device *dev;
>>   	struct wiphy *wiphy;
>>
>>   	enum ath6kl_state state;
>> +	enum ath6kl_wow_state wow_state;
>>   	unsigned int testmode;
>
> To be honest, adding a new state variable scares me. I don't see how we
> are able to maintain two different state variables, the end result would
> be a total mess.

ath6kl_wow_state is a just sub state of WOW. It roles over only in WOW
mode. However i understand your point.

>
> I recommend to look at this problem by adding a new state to enum
> ath6kl_state. That would make it a lot easier to handle all the
> different states.

The condition to stop ctrl and data pkt transfer are different.
Ctrl pkt should be stopped when wow_suspended (after sending
set_host_sleep_cmd_mode). Data pkt should be dropped before
the moment we configure set_ip_cmd().

This where we need a state WOW_SUSPENDING and WOW_SUSPENDED.
enum ath6kl_state has over all ath6kl suspend state (cut pwr, deep
sleep,wow). IMHO, mixing WOW sub states there is not good approach.

If you feel maintaining separate state is not good idea, i could think
of introducing two new flag WOW_SUSPENDING,  WOW_SUSPENDED in ar->flag.

I may be wrong, What do you say?

>
> (I haven't looked rest of your patch yet.)
>
> Kalle
