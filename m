Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46595 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbcHOKRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 06:17:04 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"s.l-h@gmx.de" <s.l-h@gmx.de>
Subject: Re: [PATCH] ath9k: fix AR5416 access GPIO warning
Date: Mon, 15 Aug 2016 10:16:50 +0000
Message-ID: <877fbicp67.fsf@kamboji.qca.qualcomm.com> (sfid-20160815_121709_482897_AB1D6CE5)
References: <1470296914-9152-1-git-send-email-miaoqing@codeaurora.org>
In-Reply-To: <1470296914-9152-1-git-send-email-miaoqing@codeaurora.org>
	(miaoqing@codeaurora.org's message of "Thu, 4 Aug 2016 15:48:34	+0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<miaoqing@codeaurora.org> writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> The warning was seen on AR5416 chip, which invoke ath9k_hw_gio_get()
> before the GPIO initialized correctly.
>
>     WARNING: CPU: 1 PID: 1159 at ~/drivers/net/wireless/ath/ath9k/hw.c:2776 ath9k_hw_gpio_get+0x148/0x1a0 [ath9k_hw]
>     ...
>     CPU: 1 PID: 1159 Comm: systemd-udevd Not tainted 4.7.0-rc7-aptosid-amd64 #1 aptosid 4.7~rc7-1~git92.slh.3
>     Hardware name:                  /DH67CL, BIOS BLH6710H.86A.0160.2012.1204.1156 12/04/2012
>       0000000000000286 00000000f912d633 ffffffff81290fd3 0000000000000000
>       0000000000000000 ffffffff81063fd4 ffff88040c6dc018 0000000000000000
>       0000000000000002 0000000000000000 0000000000000100 ffff88040c6dc018
>     Call Trace:
>       [<ffffffff81290fd3>] ? dump_stack+0x5c/0x79
>       [<ffffffff81063fd4>] ? __warn+0xb4/0xd0
>       [<ffffffffa0668fb8>] ? ath9k_hw_gpio_get+0x148/0x1a0 [ath9k_hw]
>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

As discussed in the previous thread I'll add:

Reported-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: <stable@vger.kernel.org> # 4.7+

I'm also planning to queue this to 4.8.

-- 
Kalle Valo