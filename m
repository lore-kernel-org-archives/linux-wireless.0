Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54848 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbdASMsE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 07:48:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: remove redundant dma padding in AMSDU
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1484151084-7241-1-git-send-email-akarwar@marvell.com>
References: <1484151084-7241-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20170119124804.2F9E5607F6@smtp.codeaurora.org> (sfid-20170119_134808_187510_E5B69BBB)
Date: Thu, 19 Jan 2017 12:48:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> We already ensure 64 bytes alignment and add padding if required
> during skb_aggr allocation.
> 
> Alignment and padding in mwifiex_11n_form_amsdu_txpd() is redundant.
> We may end up accessing more data than allocated size with this.
> 
> This patch fixes following issue by removing redundant padding.
> 
> [  370.241338] skbuff: skb_over_panic: text:ffffffffc046946a len:3550
> put:72 head:ffff880000110000 data:ffff8800001100e4 tail:0xec2 end:0xec0 dev:<NULL>
> [  370.241374] ------------[ cut here ]------------
> [  370.241382] kernel BUG at net/core/skbuff.c:104!
>   370.244032] Call Trace:
> [  370.244041]  [<ffffffff8c3df5ec>] skb_put+0x44/0x45
> [  370.244055]  [<ffffffffc046946a>]
> mwifiex_11n_aggregate_pkt+0x1e9/0xa50 [mwifiex]
> [  370.244067]  [<ffffffffc0467c16>] mwifiex_wmm_process_tx+0x44a/0x6b7
> [mwifiex]
> [  370.244074]  [<ffffffffc0411eb8>] ? 0xffffffffc0411eb8
> [  370.244084]  [<ffffffffc046116b>] mwifiex_main_process+0x476/0x5a5
> [mwifiex]
> [  370.244098]  [<ffffffffc0461298>] mwifiex_main_process+0x5a3/0x5a5
> [mwifiex]
> [  370.244113]  [<ffffffff8be7e9ff>] process_one_work+0x1a4/0x309
> [  370.244123]  [<ffffffff8be7f4ca>] worker_thread+0x20c/0x2ee
> [  370.244130]  [<ffffffff8be7f2be>] ? rescuer_thread+0x383/0x383
> [  370.244136]  [<ffffffff8be7f2be>] ? rescuer_thread+0x383/0x383
> [  370.244143]  [<ffffffff8be83742>] kthread+0x11c/0x124
> [  370.244150]  [<ffffffff8be83626>] ? kthread_parkme+0x24/0x24
> [  370.244157]  [<ffffffff8c4da1ef>] ret_from_fork+0x3f/0x70
> [  370.244168]  [<ffffffff8be83626>] ? kthread_parkme+0x24/0x24
> 
> Fixes: 84b313b35f8158d ("mwifiex: make tx packet 64 byte DMA aligned")
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

5f0a221f59ad mwifiex: remove redundant dma padding in AMSDU

-- 
https://patchwork.kernel.org/patch/9510541/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
