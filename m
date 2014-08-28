Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:63252 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaH1NNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 09:13:45 -0400
Received: by mail-lb0-f180.google.com with SMTP id w7so853554lbi.39
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 06:13:43 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: remove diag_*_access functions
Date: Thu, 28 Aug 2014 15:03:56 +0200
Message-Id: <1409231036-16137-1-git-send-email-michal.kazior@tieto.com> (sfid-20140828_151349_311928_78DB48C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the ugly _access functions. Being explicit
is a good thing.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 109 ++++++++--------------------------
 1 file changed, 24 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1ff2f34..5e7c88c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -64,9 +64,6 @@ static DEFINE_PCI_DEVICE_TABLE(ath10k_pci_id_table) = {
 	{0}
 };
 
-static int ath10k_pci_diag_read_access(struct ath10k *ar, u32 address,
-				       u32 *data);
-
 static void ath10k_pci_buffer_cleanup(struct ath10k *ar);
 static int ath10k_pci_cold_reset(struct ath10k *ar);
 static int ath10k_pci_warm_reset(struct ath10k *ar);
@@ -487,25 +484,6 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 	void *data_buf = NULL;
 	int i;
 
-	/*
-	 * This code cannot handle reads to non-memory space. Redirect to the
-	 * register read fn but preserve the multi word read capability of
-	 * this fn
-	 */
-	if (address < DRAM_BASE_ADDRESS) {
-		if (!IS_ALIGNED(address, 4) ||
-		    !IS_ALIGNED((unsigned long)data, 4))
-			return -EIO;
-
-		while ((nbytes >= 4) &&  ((ret = ath10k_pci_diag_read_access(
-					   ar, address, (u32 *)data)) == 0)) {
-			nbytes -= sizeof(u32);
-			address += sizeof(u32);
-			data += sizeof(u32);
-		}
-		return ret;
-	}
-
 	ce_diag = ar_pci->ce_diag;
 
 	/*
@@ -654,18 +632,6 @@ static int __ath10k_pci_diag_read_hi(struct ath10k *ar, void *dest,
 #define ath10k_pci_diag_read_hi(ar, dest, src, len)		\
 	__ath10k_pci_diag_read_hi(ar, dest, HI_ITEM(src), len);
 
-/* Read 4-byte aligned data from Target memory or register */
-static int ath10k_pci_diag_read_access(struct ath10k *ar, u32 address,
-				       u32 *data)
-{
-	/* Assume range doesn't cross this boundary */
-	if (address >= DRAM_BASE_ADDRESS)
-		return ath10k_pci_diag_read32(ar, address, data);
-
-	*data = ath10k_pci_read32(ar, address);
-	return 0;
-}
-
 static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 				     const void *data, int nbytes)
 {
@@ -803,18 +769,6 @@ static int ath10k_pci_diag_write32(struct ath10k *ar, u32 address, u32 value)
 	return ath10k_pci_diag_write_mem(ar, address, &val, sizeof(val));
 }
 
-/* Write 4B data to Target memory or register */
-static int ath10k_pci_diag_write_access(struct ath10k *ar, u32 address,
-					u32 data)
-{
-	/* Assume range doesn't cross this boundary */
-	if (address >= DRAM_BASE_ADDRESS)
-		return ath10k_pci_diag_write32(ar, address, data);
-
-	ath10k_pci_write32(ar, address, data);
-	return 0;
-}
-
 static bool ath10k_pci_is_awake(struct ath10k *ar)
 {
 	u32 val = ath10k_pci_reg_read32(ar, RTC_STATE_ADDRESS);
@@ -1472,28 +1426,12 @@ static int ath10k_pci_bmi_wait(struct ath10k_ce_pipe *tx_pipe,
  */
 static int ath10k_pci_wake_target_cpu(struct ath10k *ar)
 {
-	int ret;
-	u32 core_ctrl;
+	u32 addr, val;
 
-	ret = ath10k_pci_diag_read_access(ar, SOC_CORE_BASE_ADDRESS |
-					      CORE_CTRL_ADDRESS,
-					  &core_ctrl);
-	if (ret) {
-		ath10k_warn(ar, "failed to read core_ctrl: %d\n", ret);
-		return ret;
-	}
-
-	/* A_INUM_FIRMWARE interrupt to Target CPU */
-	core_ctrl |= CORE_CTRL_CPU_INTR_MASK;
-
-	ret = ath10k_pci_diag_write_access(ar, SOC_CORE_BASE_ADDRESS |
-					       CORE_CTRL_ADDRESS,
-					   core_ctrl);
-	if (ret) {
-		ath10k_warn(ar, "failed to set target CPU interrupt mask: %d\n",
-			    ret);
-		return ret;
-	}
+	addr = SOC_CORE_BASE_ADDRESS | CORE_CTRL_ADDRESS;
+	val = ath10k_pci_read32(ar, addr);
+	val |= CORE_CTRL_CPU_INTR_MASK;
+	ath10k_pci_write32(ar, addr, val);
 
 	return 0;
 }
@@ -1516,8 +1454,8 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 		host_interest_item_address(HI_ITEM(hi_interconnect_state));
 
 	/* Supply Target-side CE configuration */
-	ret = ath10k_pci_diag_read_access(ar, interconnect_targ_addr,
-					  &pcie_state_targ_addr);
+	ret = ath10k_pci_diag_read32(ar, interconnect_targ_addr,
+				     &pcie_state_targ_addr);
 	if (ret != 0) {
 		ath10k_err(ar, "Failed to get pcie state addr: %d\n", ret);
 		return ret;
@@ -1529,10 +1467,10 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 		return ret;
 	}
 
-	ret = ath10k_pci_diag_read_access(ar, pcie_state_targ_addr +
+	ret = ath10k_pci_diag_read32(ar, (pcie_state_targ_addr +
 					  offsetof(struct pcie_state,
-						   pipe_cfg_addr),
-					  &pipe_cfg_targ_addr);
+						   pipe_cfg_addr)),
+				     &pipe_cfg_targ_addr);
 	if (ret != 0) {
 		ath10k_err(ar, "Failed to get pipe cfg addr: %d\n", ret);
 		return ret;
@@ -1553,10 +1491,10 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 		return ret;
 	}
 
-	ret = ath10k_pci_diag_read_access(ar, pcie_state_targ_addr +
+	ret = ath10k_pci_diag_read32(ar, (pcie_state_targ_addr +
 					  offsetof(struct pcie_state,
-						   svc_to_pipe_map),
-					  &svc_to_pipe_map);
+						   svc_to_pipe_map)),
+				     &svc_to_pipe_map);
 	if (ret != 0) {
 		ath10k_err(ar, "Failed to get svc/pipe map: %d\n", ret);
 		return ret;
@@ -1576,10 +1514,10 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 		return ret;
 	}
 
-	ret = ath10k_pci_diag_read_access(ar, pcie_state_targ_addr +
+	ret = ath10k_pci_diag_read32(ar, (pcie_state_targ_addr +
 					  offsetof(struct pcie_state,
-						   config_flags),
-					  &pcie_config_flags);
+						   config_flags)),
+				     &pcie_config_flags);
 	if (ret != 0) {
 		ath10k_err(ar, "Failed to get pcie config_flags: %d\n", ret);
 		return ret;
@@ -1587,9 +1525,10 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 
 	pcie_config_flags &= ~PCIE_CONFIG_FLAG_ENABLE_L1;
 
-	ret = ath10k_pci_diag_write_access(ar, pcie_state_targ_addr +
-				 offsetof(struct pcie_state, config_flags),
-				 pcie_config_flags);
+	ret = ath10k_pci_diag_write32(ar, (pcie_state_targ_addr +
+					   offsetof(struct pcie_state,
+						    config_flags)),
+				      pcie_config_flags);
 	if (ret != 0) {
 		ath10k_err(ar, "Failed to write pcie config_flags: %d\n", ret);
 		return ret;
@@ -1598,7 +1537,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 	/* configure early allocation */
 	ealloc_targ_addr = host_interest_item_address(HI_ITEM(hi_early_alloc));
 
-	ret = ath10k_pci_diag_read_access(ar, ealloc_targ_addr, &ealloc_value);
+	ret = ath10k_pci_diag_read32(ar, ealloc_targ_addr, &ealloc_value);
 	if (ret != 0) {
 		ath10k_err(ar, "Faile to get early alloc val: %d\n", ret);
 		return ret;
@@ -1610,7 +1549,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 	ealloc_value |= ((1 << HI_EARLY_ALLOC_IRAM_BANKS_SHIFT) &
 			 HI_EARLY_ALLOC_IRAM_BANKS_MASK);
 
-	ret = ath10k_pci_diag_write_access(ar, ealloc_targ_addr, ealloc_value);
+	ret = ath10k_pci_diag_write32(ar, ealloc_targ_addr, ealloc_value);
 	if (ret != 0) {
 		ath10k_err(ar, "Failed to set early alloc val: %d\n", ret);
 		return ret;
@@ -1619,7 +1558,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 	/* Tell Target to proceed with initialization */
 	flag2_targ_addr = host_interest_item_address(HI_ITEM(hi_option_flag2));
 
-	ret = ath10k_pci_diag_read_access(ar, flag2_targ_addr, &flag2_value);
+	ret = ath10k_pci_diag_read32(ar, flag2_targ_addr, &flag2_value);
 	if (ret != 0) {
 		ath10k_err(ar, "Failed to get option val: %d\n", ret);
 		return ret;
@@ -1627,7 +1566,7 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 
 	flag2_value |= HI_OPTION_EARLY_CFG_DONE;
 
-	ret = ath10k_pci_diag_write_access(ar, flag2_targ_addr, flag2_value);
+	ret = ath10k_pci_diag_write32(ar, flag2_targ_addr, flag2_value);
 	if (ret != 0) {
 		ath10k_err(ar, "Failed to set option val: %d\n", ret);
 		return ret;
-- 
1.8.5.3

