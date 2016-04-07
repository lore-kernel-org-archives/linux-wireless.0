Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34144 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbcDGNC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 09:02:58 -0400
Received: by mail-wm0-f67.google.com with SMTP id n3so21314326wmn.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2016 06:02:57 -0700 (PDT)
Date: Thu, 7 Apr 2016 15:02:53 +0200
From: Vishal Thanki <vishalthanki@gmail.com>
To: akarwar@marvell.com, nishants@marvell.com, afenkart@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: mwifiex: kernel WARN_ON during system suspend
Message-ID: <20160407130251.GA19696@c50.bag.software> (sfid-20160407_150301_632711_3576ABEA)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi All,

I noticed that sometime I see the kernel trace while system enters into
suspend. The trace log is attached with this email.

>From the kernel trace it appears that mwifiex_cancel_all_pending_cmd()
function tries to cancel the current command by invoking
mwifiex_complete_cmd(). Just before calling this routine, the
adapter->curr_cmd->wait_q_enabled is set to false. And there is a
WARN_ON() in the mwifiex_complete_cmd() routine on this variable being
false, because this condition will always evaluate to true.

I think by setting the wait_q_enabled flag to false after calling the
mwifiex_complete_cmd() should fix this problem. I have attached the
patch for the same, however I am not sure if that is the right way to
fix this issue. If there is any better way to fix it, please suggest.

Thanks,
Vishal

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kernel-warn.log"

[  110.386260] Freezing user space processes ... (elapsed 0.005 seconds) done.
[  110.399756] Freezing remaining freezable tasks ... (elapsed 0.003 seconds) done.
[  110.430861] mwifiex_sdio mmc0:0001:1: info: successfully disconnected from 60:e3:27:60:3e:2c: reason code 3
[  110.441467] mwifiex_sdio mmc0:0001:1: info: successfully disconnected from 00:00:00:00:00:00:        reason code 3
[  110.451854] mwifiex_sdio mmc0:0001:1: None of the WOWLAN triggers enabled
[  110.463479] ------------[ cut here ]------------
[  110.468551] WARNING: CPU: 0 PID: 270 at drivers/net/wireless/mwifiex/util.c:503 mwifiex_complete_cmd+0x6c/0x70 [mwifiex]()
[  110.480143] Modules linked in: snd_soc_s800 uinput mwifiex_sdio mwifiex snd_soc_cs4271_i2c snd_soc_cs4271 snd_soc_davinci_mcasp snda
[  110.494825] CPU: 0 PID: 270 Comm: master-process Not tainted 4.4.6 #1
[  110.501580] Hardware name: Generic AM33XX (Flattened Device Tree)
[  110.508017] [<c0015b88>] (unwind_backtrace) from [<c0013500>] (show_stack+0x10/0x14)
[  110.516167] [<c0013500>] (show_stack) from [<c0030c10>] (warn_slowpath_common+0x84/0xb0)
[  110.524667] [<c0030c10>] (warn_slowpath_common) from [<c0030cd8>] (warn_slowpath_null+0x1c/0x24)
[  110.533941] [<c0030cd8>] (warn_slowpath_null) from [<bf0221b0>] (mwifiex_complete_cmd+0x6c/0x70 [mwifiex])
[  110.544265] [<bf0221b0>] (mwifiex_complete_cmd [mwifiex]) from [<bf0203e8>] (mwifiex_cancel_all_pending_cmd+0x20c/0x210 [mwifiex])
[  110.556671] [<bf0203e8>] (mwifiex_cancel_all_pending_cmd [mwifiex]) from [<bf02dbb4>] (mwifiex_enable_hs+0x8c/0x248 [mwifiex])
[  110.568690] [<bf02dbb4>] (mwifiex_enable_hs [mwifiex]) from [<bf0621fc>] (mwifiex_sdio_suspend+0x44/0xe4 [mwifiex_sdio])
[  110.580111] [<bf0621fc>] (mwifiex_sdio_suspend [mwifiex_sdio]) from [<c03331a8>] (dpm_run_callback+0x2c/0xc8)
[  110.590521] [<c03331a8>] (dpm_run_callback) from [<c0334180>] (__device_suspend+0x118/0x398)
[  110.599383] [<c0334180>] (__device_suspend) from [<c0335514>] (dpm_suspend+0x128/0x23c)
[  110.607797] [<c0335514>] (dpm_suspend) from [<c006c9f8>] (suspend_devices_and_enter+0xac/0x4cc)
[  110.616930] [<c006c9f8>] (suspend_devices_and_enter) from [<c006d0a4>] (pm_suspend+0x28c/0x308)
[  110.626062] [<c006d0a4>] (pm_suspend) from [<c006bce0>] (state_store+0x6c/0xbc)
[  110.633746] [<c006bce0>] (state_store) from [<c0164c3c>] (kernfs_fop_write+0xbc/0x1c0)
[  110.642068] [<c0164c3c>] (kernfs_fop_write) from [<c00f5214>] (__vfs_write+0x20/0xd8)
[  110.650290] [<c00f5214>] (__vfs_write) from [<c00f5ae4>] (vfs_write+0x90/0x198)
[  110.657964] [<c00f5ae4>] (vfs_write) from [<c00f63b8>] (SyS_write+0x44/0x9c)
[  110.665367] [<c00f63b8>] (SyS_write) from [<c000f620>] (ret_fast_syscall+0x0/0x1c)
[  110.673310] ---[ end trace f6f801508b181dde ]---
[  110.679845] mwifiex_sdio mmc0:0001:1: deleting the crypto keys
[  110.686099] mwifiex_sdio mmc0:0001:1: PREP_CMD: host entering sleep state
[  110.693267] mwifiex_sdio mmc0:0001:1: deleting the crypto keys
[  110.699394] mwifiex_sdio mmc0:0001:1: PREP_CMD: host entering sleep state
[  110.706549] mwifiex_sdio mmc0:0001:1: deleting the crypto keys
[  110.842680] PM: suspend of devices complete after 425.214 msecs
[  110.857314] PM: late suspend of devices complete after 8.359 msecs
[  110.873589] PM: noirq suspend of devices complete after 9.631 msecs


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-mwifiex-fix-the-incorrect-WARN_ON-during-suspend.patch"

>From 17d9d9444d1c5d88396d9d65c10d4c01ed35e3bf Mon Sep 17 00:00:00 2001
From: Vishal Thanki <vishalthanki@gmail.com>
Date: Thu, 7 Apr 2016 13:48:10 +0200
Subject: [PATCH] mwifiex: fix the incorrect WARN_ON during suspend

During system suspend, there is a kernel WARNING issued if there
is a pending command present. By marking the wait queue disabled
after calling the command completion routine fixes it.

Signed-off-by: Vishal Thanki <vishalthanki@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index a12adee..6f047064 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1009,9 +1009,9 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 	/* Cancel current cmd */
 	if ((adapter->curr_cmd) && (adapter->curr_cmd->wait_q_enabled)) {
-		adapter->curr_cmd->wait_q_enabled = false;
 		adapter->cmd_wait_q.status = -1;
 		mwifiex_complete_cmd(adapter, adapter->curr_cmd);
+		adapter->curr_cmd->wait_q_enabled = false;
 		/* no recycle probably wait for response */
 	}
 	/* Cancel all pending command */
-- 
2.4.11


--u3/rZRmxL6MmkK24--
