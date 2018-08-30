Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbeH3G3p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 02:29:45 -0400
From: Carl Huang <cjhuang@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath10k: optimize pci diag mem read & write operations
Date: Thu, 30 Aug 2018 10:29:40 +0800
Message-Id: <1535596182-18038-2-git-send-email-cjhuang@codeaurora.org> (sfid-20180830_042957_800259_D993CD92)
In-Reply-To: <1535596182-18038-1-git-send-email-cjhuang@codeaurora.org>
References: <1535596182-18038-1-git-send-email-cjhuang@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Delay 1ms is too long for both diag read and write operations.
This is observed when writing a big memory buffer to target or
reading a big memory buffer from target. Take writing/reading
512k bytes as example, the delay itself is 256ms as the maximum
length of every write/read is 2k size.

Reduce the delay to 50us for read and write operations.

Take the ath10k_pci_targ_cpu_to_ce_addr() out of loop and put it
in the beginning of the loop for ath10k_pci_diag_read_mem().

The ath10k_pci_targ_cpu_to_ce_addr() is to convert the address
from target cpu's perspective to CE's perspective, so it makes
no sense to convert a CE's perspective address again in the loop.
It's a wrong implementation but happens to work.

If the target address is below 1M space, then the convert in the loop
from the second time becomes wrong because the previously converted address
is larger than 1M. The counterpart ath10k_pci_diag_write_mem() has the
correct implementation.

With this change, ath10k_pci_diage_read_mem() works correctly no matter
the target address is below 1M or above 1M.

It's tested with QCA6174 hw3.2 and
firmware-6.bin_WLAN.RM.4.4.1-00111-QCARMSWP-1. QCA9377 is also affected.

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 40 +++++++++++++++++++----------------
 drivers/net/wireless/ath/ath10k/pci.h |  3 ++-
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index af2cf55..7edbfe5 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -931,6 +931,15 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		goto done;
 	}
 
+	/* The address supplied by the caller is in the
+	 * Target CPU virtual address space.
+	 *
+	 * In order to use this address with the diagnostic CE,
+	 * convert it from Target CPU virtual address space
+	 * to CE address space
+	 */
+	address = ath10k_pci_targ_cpu_to_ce_addr(ar, address);
+
 	remaining_bytes = nbytes;
 	ce_data = ce_data_base;
 	while (remaining_bytes) {
@@ -942,16 +951,6 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 			goto done;
 
 		/* Request CE to send from Target(!) address to Host buffer */
-		/*
-		 * The address supplied by the caller is in the
-		 * Target CPU virtual address space.
-		 *
-		 * In order to use this address with the diagnostic CE,
-		 * convert it from Target CPU virtual address space
-		 * to CE address space
-		 */
-		address = ath10k_pci_targ_cpu_to_ce_addr(ar, address);
-
 		ret = ath10k_ce_send_nolock(ce_diag, NULL, (u32)address, nbytes, 0,
 					    0);
 		if (ret)
@@ -960,8 +959,10 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		i = 0;
 		while (ath10k_ce_completed_send_next_nolock(ce_diag,
 							    NULL) != 0) {
-			mdelay(1);
-			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
+			udelay(DIAG_ACCESS_CE_WAIT_US);
+			i += DIAG_ACCESS_CE_WAIT_US;
+
+			if (i > DIAG_ACCESS_CE_TIMEOUT_US) {
 				ret = -EBUSY;
 				goto done;
 			}
@@ -972,9 +973,10 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 							    (void **)&buf,
 							    &completed_nbytes)
 								!= 0) {
-			mdelay(1);
+			udelay(DIAG_ACCESS_CE_WAIT_US);
+			i += DIAG_ACCESS_CE_WAIT_US;
 
-			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
+			if (i > DIAG_ACCESS_CE_TIMEOUT_US) {
 				ret = -EBUSY;
 				goto done;
 			}
@@ -1119,9 +1121,10 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		i = 0;
 		while (ath10k_ce_completed_send_next_nolock(ce_diag,
 							    NULL) != 0) {
-			mdelay(1);
+			udelay(DIAG_ACCESS_CE_WAIT_US);
+			i += DIAG_ACCESS_CE_WAIT_US;
 
-			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
+			if (i > DIAG_ACCESS_CE_TIMEOUT_US) {
 				ret = -EBUSY;
 				goto done;
 			}
@@ -1132,9 +1135,10 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 							    (void **)&buf,
 							    &completed_nbytes)
 								!= 0) {
-			mdelay(1);
+			udelay(DIAG_ACCESS_CE_WAIT_US);
+			i += DIAG_ACCESS_CE_WAIT_US;
 
-			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
+			if (i > DIAG_ACCESS_CE_TIMEOUT_US) {
 				ret = -EBUSY;
 				goto done;
 			}
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 0ed4366..e8d8633 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -207,7 +207,8 @@ static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
 #define CDC_WAR_DATA_CE     4
 
 /* Wait up to this many Ms for a Diagnostic Access CE operation to complete */
-#define DIAG_ACCESS_CE_TIMEOUT_MS 10
+#define DIAG_ACCESS_CE_TIMEOUT_US 10000 /* 10 ms */
+#define DIAG_ACCESS_CE_WAIT_US	50
 
 void ath10k_pci_write32(struct ath10k *ar, u32 offset, u32 value);
 void ath10k_pci_soc_write32(struct ath10k *ar, u32 addr, u32 val);
-- 
2.7.4
