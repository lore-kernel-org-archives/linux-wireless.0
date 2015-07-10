Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37072 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbbGJJBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 05:01:40 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V2] ath10k: Delay device access after cold reset
Date: Fri, 10 Jul 2015 14:31:20 +0530
Message-ID: <1436518880-9638-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150710_110146_799571_269338AA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is observed that during cold reset pcie access right
after a write operation to SOC_GLOBAL_RESET_ADDRESS causes
Data Bus Error and system hard lockup. The reason
for bus error is that pcie needs some time to get
back to stable state for any transaction during cold reset. Add
delay of 20 msecs after write of SOC_GLOBAL_RESET_ADDRESS
to fix this issue. This patch is tested on QCA988X. This is
also tested on QCA99X0 which is WIP.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---

V2:
	- Include tested hw in commit log.

 drivers/net/wireless/ath/ath10k/pci.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1b4634a..130746b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2761,7 +2761,6 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 
 static int ath10k_pci_cold_reset(struct ath10k *ar)
 {
-	int i;
 	u32 val;
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot cold reset\n");
@@ -2777,23 +2776,18 @@ static int ath10k_pci_cold_reset(struct ath10k *ar)
 	val |= 1;
 	ath10k_pci_reg_write32(ar, SOC_GLOBAL_RESET_ADDRESS, val);
 
-	for (i = 0; i < ATH_PCI_RESET_WAIT_MAX; i++) {
-		if (ath10k_pci_reg_read32(ar, RTC_STATE_ADDRESS) &
-					  RTC_STATE_COLD_RESET_MASK)
-			break;
-		msleep(1);
-	}
+	/* After writing into SOC_GLOBAL_RESET to put device into
+	 * reset and pulling out of reset pcie may not be stable
+	 * for any immediate pcie register access and cause bus error,
+	 * add delay before any pcie access request to fix this issue.
+	 */
+	msleep(20);
 
 	/* Pull Target, including PCIe, out of RESET. */
 	val &= ~1;
 	ath10k_pci_reg_write32(ar, SOC_GLOBAL_RESET_ADDRESS, val);
 
-	for (i = 0; i < ATH_PCI_RESET_WAIT_MAX; i++) {
-		if (!(ath10k_pci_reg_read32(ar, RTC_STATE_ADDRESS) &
-					    RTC_STATE_COLD_RESET_MASK))
-			break;
-		msleep(1);
-	}
+	msleep(20);
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot cold reset complete\n");
 
-- 
1.9.1

