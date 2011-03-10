Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58289 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab1CJNUb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 08:20:31 -0500
Message-ID: <4D78D01C.3020406@openwrt.org>
Date: Thu, 10 Mar 2011 14:20:28 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mark Mentovai <mark@moxienet.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 2/4] ath9k: fix stopping tx dma on reset
References: <5AF19632-CBB6-497C-8B47-1522BA6EA9F9@moxienet.com>
In-Reply-To: <5AF19632-CBB6-497C-8B47-1522BA6EA9F9@moxienet.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-10 5:21 AM, Mark Mentovai wrote:
>> --- a/drivers/net/wireless/ath/ath9k/mac.c
> [...]
>> +bool ath9k_hw_abort_tx_dma(struct ath_hw *ah)
> [...]
>> +	for (q = 0; q < AR_NUM_QCU; q++) {
>> +		for (i = 1000; i > 0; i--) {
>> +			if (!ath9k_hw_numtxpending(ah, q))
>> +				break;
>> +
>> +			udelay(5);
>> +		}
>> +	}
>> +	if (!i)
>> +		return false;
> 
> Awesome-looking patch set.
> 
> What’s the return value of this function supposed to mean? As
> written, it only returns false there’s anything left pending on the
> final queue. Notably, if the inner loop ran for all 999 iterations
> and ath9k_hw_numtxpending never returned false, the code above would
> effectively ignore that condition.
Makes sense

> I’m less concerned about the return value (because it actually seems
> that the function could be declared void, you don’t use the return
> value anywhere) than I am about the REG_CLR_BIT and REG_WRITE
> operations that follow. It seems that you might be either missing
> those in cases where they should happen, or performing them in cases
> where they shouldn’t. Did you mean to leave AR_Q_TXD set when
> something is left pending on the final hardware queue?
I'll drop the return code and make the clearing of AR_Q_TXD and the
other bits unconditional.

- Felix
