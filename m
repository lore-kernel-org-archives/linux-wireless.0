Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36714 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbeA2IAG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 03:00:06 -0500
From: Yu Wang <yyuwang@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: fix kernel panic issue during pci probe
Date: Mon, 29 Jan 2018 16:00:01 +0800
Message-Id: <1517212801-7523-2-git-send-email-yyuwang@codeaurora.org> (sfid-20180129_090014_311190_FDA01AC5)
In-Reply-To: <1517212801-7523-1-git-send-email-yyuwang@codeaurora.org>
References: <1517212801-7523-1-git-send-email-yyuwang@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If device gone during chip reset, ar->normal_mode_fw.board is not
initialized, but ath10k_debug_print_hwfw_info() will try to access its
member, which will cause 'kernel NULL pointer' issue. This was found
using a faulty device (pci link went down sometimes) in a random
insmod/rmmod/other-op test.
To fix it, check ar->normal_mode_fw.board before accessing the member.

pci 0000:02:00.0: BAR 0: assigned [mem 0xf7400000-0xf75fffff 64bit]
ath10k_pci 0000:02:00.0: enabling device (0000 -> 0002)
ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
ath10k_pci 0000:02:00.0: failed to read device register, device is gone
ath10k_pci 0000:02:00.0: failed to wait for target init: -5
ath10k_pci 0000:02:00.0: failed to warm reset: -5
ath10k_pci 0000:02:00.0: firmware crashed during chip reset
ath10k_pci 0000:02:00.0: firmware crashed! (uuid 5d018951-b8e1-404a-8fde-923078b4423a)
ath10k_pci 0000:02:00.0: (null) target 0x00000000 chip_id 0x00340aff sub 0000:0000
ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 1 testmode 1
ath10k_pci 0000:02:00.0: firmware ver  api 0 features  crc32 00000000
...
BUG: unable to handle kernel NULL pointer dereference at 00000004
...
Call Trace:
 [<fb4e7882>] ath10k_print_driver_info+0x12/0x20 [ath10k_core]
 [<fb62b7dd>] ath10k_pci_fw_crashed_dump+0x6d/0x4d0 [ath10k_pci]
 [<fb629f07>] ? ath10k_pci_sleep.part.19+0x57/0xc0 [ath10k_pci]
 [<fb62c8ee>] ath10k_pci_hif_power_up+0x14e/0x1b0 [ath10k_pci]
 [<c10477fb>] ? do_page_fault+0xb/0x10
 [<fb4eb934>] ath10k_core_register_work+0x24/0x840 [ath10k_core]
 [<c18a00d8>] ? netlbl_unlhsh_remove+0x178/0x410
 [<c10477f0>] ? __do_page_fault+0x480/0x480
 [<c1068e44>] process_one_work+0x114/0x3e0
 [<c1069d07>] worker_thread+0x37/0x4a0
 [<c106e294>] kthread+0xa4/0xc0
 [<c1069cd0>] ? create_worker+0x180/0x180
 [<c106e1f0>] ? kthread_park+0x50/0x50
 [<c18ab4f7>] ret_from_fork+0x1b/0x28
 Code: 78 80 b8 50 09 00 00 00 75 5d 8d 75 94 c7 44 24 08 aa d7 52 fb c7 44 24 04 64 00 00 00
 89 34 24 e8 82 52 e2 c5 8b 83 dc 08 00 00 <8b> 50 04 8b 08 31 c0 e8 20 57 e3 c5 89 44 24 10 8b 83 58 09 00
 EIP: [<fb4e7754>]-
 ath10k_debug_print_board_info+0x34/0xb0 [ath10k_core]
 SS:ESP 0068:f4921d90
 CR2: 0000000000000004

Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debug.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 6d836a2..554cd78 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -81,6 +82,8 @@ void ath10k_debug_print_hwfw_info(struct ath10k *ar)
 void ath10k_debug_print_board_info(struct ath10k *ar)
 {
 	char boardinfo[100];
+	const struct firmware *board;
+	u32 crc;
 
 	if (ar->id.bmi_ids_valid)
 		scnprintf(boardinfo, sizeof(boardinfo), "%d:%d",
@@ -88,11 +91,16 @@ void ath10k_debug_print_board_info(struct ath10k *ar)
 	else
 		scnprintf(boardinfo, sizeof(boardinfo), "N/A");
 
+	board = ar->normal_mode_fw.board;
+	if (!IS_ERR_OR_NULL(board))
+		crc = crc32_le(0, board->data, board->size);
+	else
+		crc = 0;
+
 	ath10k_info(ar, "board_file api %d bmi_id %s crc32 %08x",
 		    ar->bd_api,
 		    boardinfo,
-		    crc32_le(0, ar->normal_mode_fw.board->data,
-			     ar->normal_mode_fw.board->size));
+		    crc);
 }
 
 void ath10k_debug_print_boot_info(struct ath10k *ar)
-- 
1.9.1
