Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3205 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2D0EKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 00:10:11 -0400
Message-ID: <4F9A1C0F.2090303@qca.qualcomm.com> (sfid-20120427_061016_176203_0CEC1646)
Date: Fri, 27 Apr 2012 09:39:51 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Complete failed tx packet in ath6kl_htc_tx_from_queue()
References: <1335452174-7093-1-git-send-email-vthiagar@qca.qualcomm.com> <1335452174-7093-2-git-send-email-vthiagar@qca.qualcomm.com> <4F999235.3060007@qca.qualcomm.com>
In-Reply-To: <4F999235.3060007@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Thursday 26 April 2012 11:51 PM, Kalle Valo wrote:
> On 04/26/2012 05:56 PM, Vasanthakumar Thiagarajan wrote:
>> Return status of ath6kl_htc_tx_issue() is ignored in
>> ath6kl_htc_tx_from_queue(), but failed tx packet is
>> is not cleaned up. To fix memory leak in this case, call
>> completion with error. Also, throw an error debug message
>> when tx fails in ath6kl_sdio_write_async() due to shortage
>> in bus request buffer.
>>
>> Signed-off-by: Vasanthakumar Thiagarajan<vthiagar@qca.qualcomm.com>
>
> [...]
>
>>   	bus_req = ath6kl_sdio_alloc_busreq(ar_sdio);
>>
>> -	if (!bus_req)
>> +	if (!bus_req) {
>> +		ath6kl_err("Ran out of bus request buffer for tx\n");
>>   		return -ENOMEM;
>> +	}
>
> I'm not sure about this one. There's a risk that this will spam the log.
> Should it be a debug message instead? Or should we have instead
> ath6kl_err_ratelimit()?

This condition is very rare, I found it only through code review. I'm 
pretty sure we don't hit this very often.

Vasanth
