Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38783 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbcFDOh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 10:37:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Pan\, Miaoqing" <miaoqing@qti.qualcomm.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	ath9k-devel <ath9k-devel@qualcomm.com>,
	"linux-next\@vger.kernel.org" <linux-next@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	Miaoqing Pan <miaoqing@codeaurora.org>
Subject: Re: ath9k gpio request
References: <20160530132225.4d297678@canb.auug.org.au>
	<574C4851.9090201@gmail.com>
	<87fusy3cqx.fsf_-_@kamboji.qca.qualcomm.com>
	<574D3EAA.3060102@gmail.com> <1464764036580.70506@qti.qualcomm.com>
	<574EC331.1080901@gmail.com> <574ED297.4080004@gmail.com>
	<1464854569880.79341@qti.qualcomm.com> <57501AE4.7080104@gmail.com>
	<8760tqn8fc.fsf@purkki.adurom.net>
	<1464932944074.85131@qti.qualcomm.com>
Date: Sat, 04 Jun 2016 17:37:50 +0300
In-Reply-To: <1464932944074.85131@qti.qualcomm.com> (Miaoqing Pan's message of
	"Fri, 3 Jun 2016 05:49:06 +0000")
Message-ID: <87d1nxt3y9.fsf@kamboji.qca.qualcomm.com> (sfid-20160604_163812_953507_D48B6E59)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Fixing top posting)

"Pan, Miaoqing" <miaoqing@qti.qualcomm.com> writes:

>>> --- a/drivers/net/wireless/ath/ath9k/reg.h
>>> +++ b/drivers/net/wireless/ath/ath9k/reg.h
>>> @@ -1122,8 +1122,8 @@ enum {
>>>   #define AR9300_NUM_GPIO                          16
>>>   #define AR9330_NUM_GPIO                                 16
>>>   #define AR9340_NUM_GPIO                                 23
>>> -#define AR9462_NUM_GPIO                                 10
>>> -#define AR9485_NUM_GPIO                                 12
>>> +#define AR9462_NUM_GPIO                                 14
>>> +#define AR9485_NUM_GPIO                                 11
>>>   #define AR9531_NUM_GPIO                                 18
>>>   #define AR9550_NUM_GPIO                                 24
>>>   #define AR9561_NUM_GPIO                                 23
>>> @@ -1139,8 +1139,8 @@ enum {
>>>   #define AR9300_GPIO_MASK                        0x0000F4FF
>>>   #define AR9330_GPIO_MASK                        0x0000F4FF
>>>   #define AR9340_GPIO_MASK                        0x0000000F
>>> -#define AR9462_GPIO_MASK                        0x000003FF
>>> -#define AR9485_GPIO_MASK                        0x00000FFF
>>> +#define AR9462_GPIO_MASK                        0x00003FFF
>>> +#define AR9485_GPIO_MASK                        0x000007FF
>>>   #define AR9531_GPIO_MASK                        0x0000000F
>>>   #define AR9550_GPIO_MASK                        0x0000000F
>>>   #define AR9561_GPIO_MASK                        0x0000000F
>>
>> solves the problem.
>>
>> Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>
> Done, https://patchwork.kernel.org/patch/9151847/

But the patch 9151847 is different from what Sudip tested above? Why?

And if you modify something _after_ the reporter has tested the patch
clearly document what you changed and why. I do not want find hidden
changes like this, even more so when the patch is going to a 4.7-rc
release.

Sudip, could you also test patch 9151847, please? You can download the
patch from the patchwork link above.

-- 
Kalle Valo
