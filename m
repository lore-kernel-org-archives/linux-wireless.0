Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38558 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJ4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 05:56:21 -0400
Message-ID: <4EAE707D.6070806@qca.qualcomm.com> (sfid-20111031_105625_674581_20C420C1)
Date: Mon, 31 Oct 2011 15:25:09 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/7] ath6kl: Perform WOW resume in RX path in case of
 SDIO IRQ wakeup
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com> <1319539047-8756-7-git-send-email-rmani@qca.qualcomm.com> <4EAAABB8.3030309@qca.qualcomm.com>
In-Reply-To: <4EAAABB8.3030309@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 October 2011 06:48 PM, Kalle Valo wrote:
> On 10/25/2011 01:37 PM, rmani@qca.qualcomm.com wrote:
>> From: Raja Mani<rmani@qca.qualcomm.com>
>>
>> Signed-off-by: Raja Mani<rmani@qca.qualcomm.com>
>
> Empty commit log.

I'll add commit message here..

>
>> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
>> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
>> @@ -1081,6 +1081,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
>>   		return;
>>   	}
>>
>> +	ath6kl_pm_check_wow_status(ar);
>
> Now we resume from two places, cfg80211 resume handler and here. Why do
> we need to do that? Why isn't cfg80211 resume handler enough?

This path hits when the target wants to wake up the host. When given WOW 
pattern matches, the target will pull SDIO data line to wake up the 
host. During that time , the control will reach here (sdio irq handler 
-> ath6kl_rx function), not to cfg80211 resume.

>
> Kalle
