Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42550 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbJ1S7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 14:59:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wcn36xx: Remove warning message when dev is NULL for arm64
 dma_alloc.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1445826982-4023-1-git-send-email-fengwei.yin@linaro.org>
To: yfw <fengwei.yin@linaro.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	me@bobcopeland.com, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com, fengwei.yin@linaro.org
Message-Id: <20151028185940.99B6C14158D@smtp.codeaurora.org> (sfid-20151028_195944_333427_88E1D94D)
Date: Wed, 28 Oct 2015 18:59:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> arm64 has requirement that all the dma operations have actual device.
> Otherwise, following warnning message shown and dma allocation fails:
> 
> WARNING: CPU: 0 PID: 954 at arch/arm64/mm/dma-mapping.c:106 __dma_alloc+0x24c/0x258()
> Use an actual device structure for DMA allocation
> Modules linked in: wcn36xx wcn36xx_platform
> CPU: 0 PID: 954 Comm: ifconfig Not tainted 4.0.0+ #14
> Hardware name: Qualcomm Technologies, Inc. MSM 8916 MTP (DT)
> Call trace:
> [<ffffffc000089904>] dump_backtrace+0x0/0x124
> [<ffffffc000089a38>] show_stack+0x10/0x1c
> [<ffffffc000627114>] dump_stack+0x80/0xc4
> [<ffffffc0000b2e64>] warn_slowpath_common+0x98/0xd0
> [<ffffffc0000b2ee8>] warn_slowpath_fmt+0x4c/0x58
> [<ffffffc00009487c>] __dma_alloc+0x248/0x258
> [<ffffffbffc009270>] wcn36xx_dxe_allocate_mem_pools+0xc4/0x108 [wcn36xx]
> [<ffffffbffc0079c4>] wcn36xx_start+0x38/0x240 [wcn36xx]
> [<ffffffc0005f161c>] ieee80211_do_open+0x1b0/0x9a4
> [<ffffffc0005f1e68>] ieee80211_open+0x58/0x68
> [<ffffffc00051693c>] __dev_open+0xb0/0x120
> [<ffffffc000516c10>] __dev_change_flags+0x88/0x150
> [<ffffffc000516cf4>] dev_change_flags+0x1c/0x5c
> [<ffffffc000570950>] devinet_ioctl+0x644/0x6f0
> 
> Signed-off-by: Yin, Fengwei <fengwei.yin@linaro.org>
> Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
