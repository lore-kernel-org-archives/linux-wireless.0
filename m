Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27493 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2D0Ge1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 02:34:27 -0400
Message-ID: <4F9A3DEE.207@qca.qualcomm.com> (sfid-20120427_083431_316829_01E3BC3B)
Date: Fri, 27 Apr 2012 09:34:22 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Complete failed tx packet in ath6kl_htc_tx_from_queue()
References: <1335452174-7093-1-git-send-email-vthiagar@qca.qualcomm.com> <1335452174-7093-2-git-send-email-vthiagar@qca.qualcomm.com> <4F999235.3060007@qca.qualcomm.com> <4F9A1C0F.2090303@qca.qualcomm.com>
In-Reply-To: <4F9A1C0F.2090303@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/27/2012 07:09 AM, Vasanthakumar Thiagarajan wrote:

>>>   	bus_req = ath6kl_sdio_alloc_busreq(ar_sdio);
>>>
>>> -	if (!bus_req)
>>> +	if (!bus_req) {
>>> +		ath6kl_err("Ran out of bus request buffer for tx\n");
>>>   		return -ENOMEM;
>>> +	}
>>
>> I'm not sure about this one. There's a risk that this will spam the log.
>> Should it be a debug message instead? Or should we have instead
>> ath6kl_err_ratelimit()?
> 
> This condition is very rare, I found it only through code review. I'm 
> pretty sure we don't hit this very often.

I'm not worried how often it happens, I'm just worried that _when_ it
happens the warning might make things worse. For example, I personally
saw a case where flood of warnings prevented watchdog heartbeat from
happening which caused the whole system to reboot. Without the warnings
system would have worked just fine, just a bit more slowly.

Is it ok for you if I change the ath6kl_err() to WARN_ON_ONCE() (or
WARN_ONCE() if you prefer to keep the warning message)? This should be a
rare event anyway.

Kalle
