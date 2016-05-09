Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49996 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbcEIXL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 19:11:29 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 21/21] ath10k: Read dbglog buffers over register ping-pong.
Date: Mon,  9 May 2016 16:11:15 -0700
Message-Id: <1462835475-11079-22-git-send-email-greearb@candelatech.com> (sfid-20160510_011136_743596_B4F3CB6A)
In-Reply-To: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This gives much better debugging capability when debugging
crashes in the firmware that cause CE transport loss.

(Such as AXI errors).

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 47 ++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 330c150..4069e72 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1532,7 +1532,7 @@ static int ath10k_ct_fw_crash_regs_harder(struct ath10k *ar,
 	return -EBUSY;
 
 pingpong:
-	ath10k_warn(ar, "Trying to read crash dump over pingpong registers.\n");
+	ath10k_warn(ar, "Trying to read crash dump over pingpong registers, len %d\n", len);
 	/* Firmware is trying to send us info it seems. */
 	for (q = 0; q<len; q++) {
 		reg_dump_values[q] = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS + SCRATCH_2_ADDRESS);
@@ -1567,6 +1567,10 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 				      hi_failure_state,
 				      REG_DUMP_COUNT_QCA988X * sizeof(__le32));
 	if (ret) {
+		__le32 *buffer;
+		int len = 1500; /* length in bytes for firmware dbglog buffer */
+		struct ath10k_fw_dbglog_buf dbuf;
+
 		ath10k_err(ar, "failed to read firmware dump area: %d\n", ret);
 
 		/* Try to read this directly over registers...only works on new
@@ -1575,6 +1579,46 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
 		ret = ath10k_ct_fw_crash_regs_harder(ar, reg_dump_values, REG_DUMP_COUNT_QCA988X);
 		if (ret)
 			return;
+
+		/* Try to read the debug-log buffers as well. */
+		buffer = kzalloc(len, GFP_ATOMIC);
+
+		if (!buffer)
+			goto free_and_cont;
+
+		if (ath10k_ct_fw_crash_regs_harder(ar, (__le32 *)(&dbuf), sizeof(dbuf)/4))
+			goto free_and_cont;
+
+		/* wow, it worked! */
+		len = le32_to_cpu(dbuf.length);
+		if (len > 1500) {
+			ath10k_err(ar, "dbuf length is greater than 1500: %d\n", len);
+			len = 1500;
+		}
+		if (ath10k_ct_fw_crash_regs_harder(ar, buffer, len/4))
+			goto free_and_cont;
+
+		ath10k_dbg_save_fw_dbg_buffer(ar, buffer, len/4);
+		ath10k_dbg_print_fw_dbg_buffer(ar, buffer, len/4, KERN_ERR);
+
+		/* See if the second one is available */
+		if (ath10k_ct_fw_crash_regs_harder(ar, (__le32 *)(&dbuf), sizeof(dbuf)/4))
+			goto free_and_cont;
+
+		len = le32_to_cpu(dbuf.length);
+		if (len > 1500) {
+			ath10k_err(ar, "dbuf[2] length is greater than 1500: %d\n", len);
+			len = 1500;
+		}
+
+		if (ath10k_ct_fw_crash_regs_harder(ar, buffer, len/4))
+			goto free_and_cont;
+
+		ath10k_dbg_save_fw_dbg_buffer(ar, buffer, len/4);
+		ath10k_dbg_print_fw_dbg_buffer(ar, buffer, len/4, KERN_ERR);
+
+	free_and_cont:
+		kfree(buffer);
 	}
 
 	BUILD_BUG_ON(REG_DUMP_COUNT_QCA988X % 4);
@@ -1723,6 +1767,7 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 
 	spin_unlock_bh(&ar->data_lock);
 
+	/* ath10k_set_debug_mask(0);  // stop more log spam */
 	queue_work(ar->workqueue, &ar->restart_work);
 }
 
-- 
2.4.3

