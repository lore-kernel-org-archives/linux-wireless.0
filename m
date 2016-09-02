Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39110 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932338AbcIBQeY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 12:34:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: fix AR5416 access GPIO warning
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1470296914-9152-1-git-send-email-miaoqing@codeaurora.org>
To: miaoqing pan <miaoqing@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <s.l-h@gmx.de>, Miaoqing Pan <miaoqing@codeaurora.org>
Message-ID: <2aadf0cff733477699f84d35641e9b56@euamsexm01a.eu.qualcomm.com> (sfid-20160902_183428_156305_6A90B88E)
Date: Fri, 2 Sep 2016 18:34:16 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing pan <miaoqing@codeaurora.org> wrote:
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
> Reported-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
> Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

Thanks, 1 patch applied to ath-current branch of ath.git:

db7b542e4a78 ath9k: fix AR5416 access GPIO warning

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9262875/
