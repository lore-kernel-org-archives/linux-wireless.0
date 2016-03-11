Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43782 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbcCKMV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 07:21:29 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: fix reg dump data bus error
Date: Fri, 11 Mar 2016 12:21:23 +0000
Message-ID: <87mvq5mcho.fsf@kamboji.qca.qualcomm.com> (sfid-20160311_132133_041914_1C607982)
References: <1457407177-11438-1-git-send-email-miaoqing@codeaurora.org>
In-Reply-To: <1457407177-11438-1-git-send-email-miaoqing@codeaurora.org>
	(miaoqing@codeaurora.org's message of "Tue, 8 Mar 2016 11:19:37	+0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@codeaurora.org writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> Changes:
>  - restrict only dump MAC registers
>  - skip the register memory holes
>
> Data bus error, epc == 831d4040, ra == 831d403c
> Oops[#1]:
> CPU: 0 PID: 1536 Comm: cat Not tainted 3.14.0 #3
> task: 82f87840 ti: 82f88000 task.ti: 82f88000
> $ 0   : 00000000 00000001 deadc0de 1000fc03
> $ 4   : b8100200 00000200 831e0000 80218788
> $ 8   : 00000030 00000003 00000001 09524547
> $12   : 00000000 810594f4 00000000 3a206d61
> $16   : 831dd3c0 00000081 00000a00 c05ff000
> $20   : 00005af6 00000200 00071b39 00071139
> $24   : 00000001 80217760
> $28   : 82f88000 82f89c60 c05ffa00 831d403c
> Hi    : 00000000
> Lo    : 453c0000
> epc   : 831d4040 ath_ahb_exit+0x2198/0x2904 [ath9k]
> 	Not tainted
> ra    : 831d403c ath_ahb_exit+0x2194/0x2904 [ath9k]
> Status: 1000fc03	KERNEL EXL IE
> Cause : 4080801c
> PrId  : 00019374 (MIPS 24Kc)
> Stack : 00000001 00000000 0000000e 80475c60 0000000e 800a8ebc 00000000 00000000
> 	00000001 00000007 00000000 800a9678 00000000 00000004 00000002 00000010
> 	00000000 00000000 00000000 00000000 80475c60 0000000e 000009ec c05ff000
> 	831dd3c0 00000080 00000a00 c05ff000 00005af6 00000200 00071b39 0007114d
> 	c05ff9ec 800a9904 831dd3c0 82f89d10 00000001 81082194 831d8f0c 82f89d14
> 	...
> 	Call Trace:
> 	[<831d4040>] ath_ahb_exit+0x2198/0x2904 [ath9k]
> 	[<831d403c>] ath_ahb_exit+0x2194/0x2904 [ath9k]
>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Applied to ath.git, thanks.

-- 
Kalle Valo