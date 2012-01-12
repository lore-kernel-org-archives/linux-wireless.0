Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10464 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2ALLpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 06:45:40 -0500
Message-ID: <4F0EC79E.3050807@qca.qualcomm.com> (sfid-20120112_124544_148282_7571360B)
Date: Thu, 12 Jan 2012 13:44:30 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/4] ath6kl: Fix SDIO error path
References: <20235.48443.85318.763205@gargle.gargle.HOWL>
In-Reply-To: <20235.48443.85318.763205@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2012 06:23 AM, Sujith Manoharan wrote:
> sdio_release_host() would be called twice if sdio_set_block_size()
> fails for some reason, which would result in the following warning.
> 
> WARNING: at /home/sujith/dev/wireless-testing/drivers/mmc/core/core.c:828 mmc_release_host+0x42/0x50 [mmc_core]()
> 
> Call Trace:
> [<ffffffff81064fdf>] warn_slowpath_common+0x7f/0xc0
> [<ffffffff8106503a>] warn_slowpath_null+0x1a/0x20
> [<ffffffffa03beb42>] mmc_release_host+0x42/0x50 [mmc_core]
> [<ffffffffa03c917e>] sdio_release_host+0x1e/0x30 [mmc_core]
> [<ffffffffa053fac7>] ath6kl_sdio_config+0xc7/0x110 [ath6kl_sdio]
> [<ffffffffa053fd2c>] ath6kl_sdio_probe+0x21c/0x320 [ath6kl_sdio]
> [<ffffffffa03beb2a>] ? mmc_release_host+0x2a/0x50 [mmc_core]
> [<ffffffffa03c7d2a>] sdio_bus_probe+0xfa/0x130 [mmc_core]
> [<ffffffff813015ae>] driver_probe_device+0x7e/0x1b0
> [<ffffffff8130178b>] __driver_attach+0xab/0xb0
> [<ffffffff813016e0>] ? driver_probe_device+0x1b0/0x1b0
> [<ffffffff813016e0>] ? driver_probe_device+0x1b0/0x1b0
> [<ffffffff81300504>] bus_for_each_dev+0x64/0xa0
> [<ffffffff8130123e>] driver_attach+0x1e/0x20
> [<ffffffff81300e80>] bus_add_driver+0x1b0/0x280
> [<ffffffffa0065000>] ? 0xffffffffa0064fff
> [<ffffffff81301d06>] driver_register+0x76/0x140
> [<ffffffffa0065000>] ? 0xffffffffa0064fff
> [<ffffffffa03c7b71>] sdio_register_driver+0x21/0x30 [mmc_core]
> [<ffffffffa0065012>] ath6kl_sdio_init+0x12/0x35 [ath6kl_sdio]
> [<ffffffff81002042>] do_one_initcall+0x42/0x180
> [<ffffffff810b025f>] sys_init_module+0x8f/0x200
> [<ffffffff81425ac2>] system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, all four patches applied. Patch 4 has caused two checkpatch
warnings, I fixed those. If my comment for patch 3 needs action (which I
doubt), please send a followup patch.

Kalle
