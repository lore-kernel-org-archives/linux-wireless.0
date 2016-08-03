Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19396 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbcHCNyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 09:54:14 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] ath9k: fix GPIO mask for AR9462 and AR9565
Date: Wed, 3 Aug 2016 13:54:08 +0000
Message-ID: <87r3a6556p.fsf@qca.qualcomm.com> (sfid-20160803_155432_797000_ECE0CA1F)
References: <1464932817-30988-1-git-send-email-miaoqing@codeaurora.org>
	<20160717230519.46e3a661@mir>
In-Reply-To: <20160717230519.46e3a661@mir> (Stefan Lippers-Hollmann's message
	of "Sun, 17 Jul 2016 23:05:19 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Lippers-Hollmann <s.l-h@gmx.de> writes:

> Hi
>
> On 2016-06-03, miaoqing@codeaurora.org wrote:
>> From: Miaoqing Pan <miaoqing@codeaurora.org>
>> 
>> The incorrect GPIO mask cause kernel warning, when AR9462 access GPIO11.
>> Also fix the mask for AR9565.
> [...]
>
> I think I'm seeing a very similar issue on AR5008/ AR5416+AR2133 and 
> 4.7-rc7 (mainline v4.7-rc7-92-g47ef4ad, to be exact).
>
> [    4.958874] ath9k 0000:02:02.0: enabling device (0000 -> 0002)
> [...]
> [    5.401086] ------------[ cut here ]------------
> [    5.401093] WARNING: CPU: 1 PID: 1159 at /build/linux-aptosid-4.7~rc7/drivers/net/wireless/ath/ath9k/hw.c:2776 ath9k_hw_gpio_get+0x148/0x1a0 [ath9k_hw]

[...]

> Reverting this, and the other patches depending on it, fixes the 
> problem for me:
>
> e024111f6946f45cf1559a8c6fd48d2d0f696d07 Revert "ath9k: fix GPIO mask for AR9462 and AR9565"
> db2221901fbded787daed153281ed875de489692 Revert "ath9k: free GPIO resource for SOC GPIOs"
> c7212b7136ba69efb9785df68b669381cb893920 Revert "ath9k: fix BTCoex configuration for SOC chips"
> dfcf02cd2998e2240b2bc7b4f4412578b8070bdb Revert "ath9k: fix BTCoex access invalid registers for SOC chips"
> 668ae0a3e48ac6811f431915b466514bf167e2f4 Revert "ath9k: add bits definition of BTCoex MODE2/3 for SOC chips"
> c8770bcf5cefa8cbfae21c07c4fe3428f5a9d42a Revert "ath9k: Allow platform override BTCoex pin"
> 79d4db1214a0c7b1818aaf64d0606b17ff1acea7 Revert "ath9k: cleanup led_pin initial"
> b2d70d4944c1789bc64376ad97a811f37e230c87 Revert "ath9k: make GPIO API to support both of WMAC and SOC"
> a01ab81b09c55025365c1de1345b941a18e05529 Revert "ath9k: define correct GPIO numbers and bits mask"
>
> AR9285 (168c:002b) is fine either way.

Miaoqing, have you looked at this? Looks like another regression which
should be fixed.

-- 
Kalle Valo