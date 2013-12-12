Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:57443 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3LLO2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 09:28:33 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so233109eaj.0
        for <linux-wireless@vger.kernel.org>; Thu, 12 Dec 2013 06:28:32 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: zero device DRAM to avoid host hangs
Date: Thu, 12 Dec 2013 15:24:20 +0100
Message-Id: <1386858261-16037-3-git-send-email-michal.kazior@tieto.com> (sfid-20131212_152839_371848_61FD81C3)
In-Reply-To: <1386858261-16037-1-git-send-email-michal.kazior@tieto.com>
References: <1386858261-16037-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware has a bug that causes it to dereference
garbage from the DRAM into the host. This can lead
to host crashes, hangs, memory corruption or data
bus errors.

Apparently doing a cold reset in a tight loop
isn't enough to trigger the bug. The device must
be excercised with a regular workload (i.e. start
AP, etc). After that there's a chance cold reset
will break and hang the host.

A rough guess here is this is related to DRAM
contents. The patch tries to zero the DRAM when
tearing down the device to avoid subsequent cold
reset break the host.

Ideally DRAM should be also zeroed right before
a cold reset but current CE init code doesn't
allow that.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  |  1 +
 drivers/net/wireless/ath/ath10k/pci.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 2032737..3c60476 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -289,6 +289,7 @@ enum ath10k_mcast2ucast_mode {
 #define PCIE_INTR_CE_MASK_ALL			0x0007f800
 
 #define DRAM_BASE_ADDRESS			0x00400000
+#define DRAM_BASE_SIZE				(512*1024)
 
 #define MISSING 0
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 475b4da..2527004 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -617,6 +617,22 @@ static int ath10k_pci_diag_write_access(struct ath10k *ar, u32 address,
 	return 0;
 }
 
+static void ath10k_pci_zero_target_dram(struct ath10k *ar)
+{
+	int i;
+
+	/* Target device has a bug with cold reset. It can dereference garbage
+	 * and access host memory leading to data bus errors, memory corruption
+	 * on host and hangs.
+	 *
+	 * To avoid that try to zero target DRAM through the diagnostic CE. */
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "zeroing device DRAM\n");
+
+	for (i = 0; i < DRAM_BASE_SIZE; i += sizeof(u32))
+		ath10k_pci_diag_write_access(ar, DRAM_BASE_ADDRESS + i, 0);
+}
+
 static bool ath10k_pci_target_is_awake(struct ath10k *ar)
 {
 	void __iomem *mem = ath10k_pci_priv(ar)->mem;
@@ -1461,6 +1477,8 @@ static void ath10k_pci_ce_deinit(struct ath10k *ar)
 	struct ath10k_pci_pipe *pipe_info;
 	int pipe_num;
 
+	ath10k_pci_zero_target_dram(ar);
+
 	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
 		pipe_info = &ar_pci->pipe_info[pipe_num];
 		if (pipe_info->ce_hdl) {
-- 
1.8.4.rc3

