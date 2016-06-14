Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44532 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbcFNNYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 09:24:17 -0400
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qualcomm.com>,
	<sudipm.mukherjee@gmail.com>,
	Miaoqing Pan <miaoqing@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: fix GPIO mask for AR9462 and AR9565
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1464932817-30988-1-git-send-email-miaoqing@codeaurora.org>
To: miaoqing pan <miaoqing@codeaurora.org>
Message-ID: <616d5559952d4328b0dfb8596d2dc6e4@euamsexm01a.eu.qualcomm.com> (sfid-20160614_152421_935032_F8B4BA33)
Date: Tue, 14 Jun 2016 15:24:01 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing pan <miaoqing@codeaurora.org> wrote:
> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> The incorrect GPIO mask cause kernel warning, when AR9462 access GPIO11.
> Also fix the mask for AR9565.
> 
> WARNING: CPU: 1 PID: 199 at ../drivers/net/wireless/ath/ath9k/hw.c:2778 ath9k_hw_gpio_get+0x1a9/0x1b0 [ath9k_hw]
> CPU: 1 PID: 199 Comm: kworker/u16:9 Not tainted 4.7.0-rc1-next-20160530+ #5
> Hardware name: Acer TravelMate P243/BA40_HC, BIOS V1.01 04/20/2012
> Workqueue: events_power_efficient rfkill_poll
>  0000000000000000 ffff88002cf73d28 ffffffff813b8ddc 0000000000000000
>  0000000000000000 ffff88002cf73d68 ffffffff8107a331 00000ada00000086
>  ffff880148d9c018 000000000000000b ffff880147e68720 0000000000000200
> Call Trace:
>  [<ffffffff813b8ddc>] dump_stack+0x63/0x87
>  [<ffffffff8107a331>] __warn+0xd1/0xf0
>  [<ffffffff8107a41d>] warn_slowpath_null+0x1d/0x20
>  [<ffffffffc0775b19>] ath9k_hw_gpio_get+0x1a9/0x1b0 [ath9k_hw]
>  [<ffffffffc047f3e4>] ath9k_rfkill_poll_state+0x34/0x60 [ath9k]
>  [<ffffffffc06dbb53>] ieee80211_rfkill_poll+0x33/0x40 [mac80211]
>  [<ffffffffc03ad65a>] cfg80211_rfkill_poll+0x2a/0xc0 [cfg80211]
>  [<ffffffff817c5514>] rfkill_poll+0x24/0x50
>  [<ffffffff81093183>] process_one_work+0x153/0x3f0
>  [<ffffffff8109393b>] worker_thread+0x12b/0x4b0
>  [<ffffffff81093810>] ? rescuer_thread+0x340/0x340
>  [<ffffffff81099129>] kthread+0xc9/0xe0
>  [<ffffffff817d8f1f>] ret_from_fork+0x1f/0x40
>  [<ffffffff81099060>] ? kthread_park+0x60/0x60
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Thanks, 1 patch applied to ath-current branch of ath.git:

e024111f6946 ath9k: fix GPIO mask for AR9462 and AR9565

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9151847/

