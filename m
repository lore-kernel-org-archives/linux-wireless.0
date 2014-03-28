Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6545 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744AbaC1EFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 00:05:44 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix spinlock bad magic bug
Date: Thu, 27 Mar 2014 21:05:26 -0700
Message-ID: <1395979526-2181-1-git-send-email-bzhao@marvell.com> (sfid-20140328_050548_194905_B17177F6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

[ 6630.450908] BUG: spinlock bad magic on CPU#1,
               ksdioirqd/mmc1/355
[ 6630.450914] Unable to handle kernel NULL pointer dereference
               at virtual address 0000004f
[ 6630.450919] pgd = ecbd8000
[ 6630.450926] [0000004f] *pgd=00000000
[ 6630.450936]  lock: 0xeea4ab08, .magic: 00000000,
               .owner: <none>/-1, .owner_cpu: 0
[ 6630.450939] Backtrace:
[ 6630.450956] [<c010d354>] (unwind_backtrace+0x0/0x118) from
               [<c060c238>] (dump_stack+0x28/0x30)
[ 6630.450960] Internal error: Oops: 5 [#1] SMP ARM
[ 6630.450964] Modules linked in: uvcvideo videobuf2_vmalloc
[ 6630.450980] [<c060c238>] (dump_stack+0x28/0x30) from
               [<c0315ab4>] (spin_dump+0x80/0x94)
[ 6630.450988] [<c0315ab4>] (spin_dump+0x80/0x94) from
               [<c0315af4>] (spin_bug+0x2c/0x30)
[ 6630.450996] [<c0315af4>] (spin_bug+0x2c/0x30) from
               [<c0315b80>] (do_raw_spin_lock+0x28/0x15c)
[ 6630.451004] [<c0315b80>] (do_raw_spin_lock+0x28/0x15c) from
               [<c0610c24>] (_raw_spin_lock_irqsave+0x20/0x28)
[ 6630.451016] [<c0610c24>] (_raw_spin_lock_irqsave+0x20/0x28)
               from [<bf07a7f4>] (mwifiex_exec_next_cmd
                                  +0x6c/0x45c [mwifiex])
[ 6630.451030] [<bf07a7f4>] (mwifiex_exec_next_cmd+0x6c/0x45c
               [mwifiex]) from [<bf07834c>]
               (mwifiex_main_process+0x2c8/0x464 [mwifiex])
[ 6630.451047] [<bf07834c>] (mwifiex_main_process+0x2c8/0x464
               [mwifiex]) from [<bf0a093c>]
               (mwifiex_sdio_interrupt+0xc8/0x1cc [mwifiex_sdio]
[ 6630.451064] [<bf0a093c>] (mwifiex_sdio_interrupt+0xc8/0x1cc
               [mwifiex_sdio]) from [<c04bbde0>]
               (sdio_irq_thread+0x178/0x31c)
[ 6630.451079] [<c04bbde0>] (sdio_irq_thread+0x178/0x31c) from
               [<c0145514>] (kthread+0xc8/0xd8)
[ 6630.451095] [<c0145514>] (kthread+0xc8/0xd8) from
               [<c0106118>] (ret_from_fork+0x14/0x20)

This bug has introduced/exposed due to recent patch in which we
cancel pending commands before suspend (using hs_enabling flag).
The NULL pointer is dereferenced when both
mwifiex_cancel_all_pending_cmd() and mwifiex_exec_next_cmd()
try to access cmd pending queue simultaneously.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index a23791d..1062c91 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -981,11 +981,10 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 	struct mwifiex_private *priv;
 	int i;
 
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 	/* Cancel current cmd */
 	if ((adapter->curr_cmd) && (adapter->curr_cmd->wait_q_enabled)) {
-		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd->wait_q_enabled = false;
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 		adapter->cmd_wait_q.status = -1;
 		mwifiex_complete_cmd(adapter, adapter->curr_cmd);
 	}
@@ -1005,6 +1004,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
 	}
 	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 
 	/* Cancel all pending scan command */
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
-- 
1.8.2.3

