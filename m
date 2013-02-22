Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:26478 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab3BVOuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 09:50:54 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Ryan Hsu <ryanhsu@qca.qualcomm.com>
Subject: [PATCH v2 5/5] ath6kl: Fix a debugfs crash for USB devices
Date: Fri, 22 Feb 2013 20:20:46 +0530
Message-ID: <1361544646-9059-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20130222_155111_266188_CB090129)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Credit distribution stats is currently implemented
only for SDIO. This fixes a crash in debugfs for
USB interface.

BUG: unable to handle kernel NULL pointer dereference at   (null)
IP: [<f91c2048>] read_file_credit_dist_stats+0x38/0x330 [ath6kl_core]
*pde = b62bd067
Oops: 0000 [#1] SMP

EIP: 0060:[<f91c2048>] EFLAGS: 00210246 CPU: 0
EIP is at read_file_credit_dist_stats+0x38/0x330 [ath6kl_core]
EAX: 00000000 EBX: e6f7a9c0 ECX: e7b148b8 EDX: 00000000
ESI: 000000c8 EDI: e7b14000 EBP: e6e09f64 ESP: e6e09f30
DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process cat (pid: 4058, ti=e6e08000 task=e50cf230 task.ti=e6e08000)
Stack:
00008000 00000000 e6e09f64 c1132d3c 00004e71 e50cf230 00008000 089e4000
e7b148b8 00000000 e6f7a9c0 00008000 089e4000 e6e09f8c c11331fc e6e09f98
00000001 e6e09f7c f91c2010 e6e09fac e6f7a9c0 089e4877 089e4000 e6e09fac

	Call Trace:
	[<c1132d3c>] ? rw_verify_area+0x6c/0x120
	[<c11331fc>] vfs_read+0x8c/0x160
	[<f91c2010>] ? read_file_war_stats+0x130/0x130 [ath6kl_core]
	[<c113330d>] sys_read+0x3d/0x70
	[<c15755b4>] syscall_call+0x7/0xb
	[<c1570000>] ? fill_powernow_table_pstate+0x127/0x127

Cc: Ryan Hsu <ryanhsu@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 15cfe30..c557367 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1752,8 +1752,10 @@ int ath6kl_debug_init_fs(struct ath6kl *ar)
 	debugfs_create_file("tgt_stats", S_IRUSR, ar->debugfs_phy, ar,
 			    &fops_tgt_stats);
 
-	debugfs_create_file("credit_dist_stats", S_IRUSR, ar->debugfs_phy, ar,
-			    &fops_credit_dist_stats);
+	if (ar->hif_type != ATH6KL_HIF_TYPE_SDIO)
+		debugfs_create_file("credit_dist_stats", S_IRUSR,
+				    ar->debugfs_phy, ar,
+				    &fops_credit_dist_stats);
 
 	debugfs_create_file("endpoint_stats", S_IRUSR | S_IWUSR,
 			    ar->debugfs_phy, ar, &fops_endpoint_stats);
-- 
1.7.9.5

