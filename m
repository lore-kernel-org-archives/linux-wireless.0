Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59692 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3KHHEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 02:04:54 -0500
Received: by mail-ea0-f177.google.com with SMTP id f15so842388eak.36
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 23:04:53 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 12/13] ath10k: add and fix some PCI prints
Date: Fri,  8 Nov 2013 08:01:34 +0100
Message-Id: <1383894095-27998-13-git-send-email-michal.kazior@tieto.com> (sfid-20131108_080807_660949_746169B2)
In-Reply-To: <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
 <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing error reporting and adjust other
prints to make everything more consistent.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 69 ++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e552770..eaa9956 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -712,7 +712,7 @@ static int ath10k_pci_hif_send_head(struct ath10k *ar, u8 pipe_id,
 	ret = ath10k_ce_send(ce_hdl, nbuf, skb_cb->paddr, len, transfer_id,
 			     flags);
 	if (ret)
-		ath10k_warn("CE send failed: %p\n", nbuf);
+		ath10k_warn("failed to send sk_buff to CE: %p\n", nbuf);
 
 	return ret;
 }
@@ -739,9 +739,10 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 		   ar->fw_version_build);
 
 	host_addr = host_interest_item_address(HI_ITEM(hi_failure_state));
-	if (ath10k_pci_diag_read_mem(ar, host_addr,
-				     &reg_dump_area, sizeof(u32)) != 0) {
-		ath10k_warn("could not read hi_failure_state\n");
+	ret = ath10k_pci_diag_read_mem(ar, host_addr,
+				       &reg_dump_area, sizeof(u32));
+	if (ret) {
+		ath10k_err("failed to read FW dump area address: %d\n", ret);
 		return;
 	}
 
@@ -751,7 +752,7 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 				       &reg_dump_values[0],
 				       REG_DUMP_COUNT_QCA988X * sizeof(u32));
 	if (ret != 0) {
-		ath10k_err("could not dump FW Dump Area\n");
+		ath10k_err("failed to read FW dump area: %d\n", ret);
 		return;
 	}
 
@@ -973,8 +974,8 @@ static void ath10k_pci_process_ce(struct ath10k *ar)
 		case ATH10K_PCI_COMPL_RECV:
 			ret = ath10k_pci_post_rx_pipe(compl->pipe_info, 1);
 			if (ret) {
-				ath10k_warn("Unable to post recv buffer for pipe: %d\n",
-					    compl->pipe_info->pipe_num);
+				ath10k_warn("failed to post RX buffer for pipe %d: %d\n",
+					    compl->pipe_info->pipe_num, ret);
 				break;
 			}
 
@@ -1113,7 +1114,7 @@ static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 	for (i = 0; i < num; i++) {
 		skb = dev_alloc_skb(pipe_info->buf_sz);
 		if (!skb) {
-			ath10k_warn("could not allocate skbuff for pipe %d\n",
+			ath10k_warn("failed to allocate skbuff for pipe %d\n",
 				    num);
 			ret = -ENOMEM;
 			goto err;
@@ -1126,7 +1127,7 @@ static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 					 DMA_FROM_DEVICE);
 
 		if (unlikely(dma_mapping_error(ar->dev, ce_data))) {
-			ath10k_warn("could not dma map skbuff\n");
+			ath10k_warn("failed to DMA map sk_buff\n");
 			dev_kfree_skb_any(skb);
 			ret = -EIO;
 			goto err;
@@ -1141,7 +1142,7 @@ static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 		ret = ath10k_ce_recv_buf_enqueue(ce_state, (void *)skb,
 						 ce_data);
 		if (ret) {
-			ath10k_warn("could not enqueue to pipe %d (%d)\n",
+			ath10k_warn("failed to enqueue to pipe %d: %d\n",
 				    num, ret);
 			goto err;
 		}
@@ -1171,8 +1172,8 @@ static int ath10k_pci_post_rx(struct ath10k *ar)
 		ret = ath10k_pci_post_rx_pipe(pipe_info,
 					      attr->dest_nentries - 1);
 		if (ret) {
-			ath10k_warn("Unable to replenish recv buffers for pipe: %d\n",
-				    pipe_num);
+			ath10k_warn("failed to post RX buffer for pipe %d: %d\n",
+				    pipe_num, ret);
 
 			for (; pipe_num >= 0; pipe_num--) {
 				pipe_info = &ar_pci->pipe_info[pipe_num];
@@ -1192,14 +1193,15 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 
 	ret = ath10k_pci_start_ce(ar);
 	if (ret) {
-		ath10k_warn("could not start CE (%d)\n", ret);
+		ath10k_warn("failed to start CE: %d\n", ret);
 		return ret;
 	}
 
 	/* Post buffers once to start things off. */
 	ret = ath10k_pci_post_rx(ar);
 	if (ret) {
-		ath10k_warn("could not post rx pipes (%d)\n", ret);
+		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
+			    ret);
 		return ret;
 	}
 
@@ -1593,7 +1595,7 @@ static int ath10k_pci_wake_target_cpu(struct ath10k *ar)
 					      CORE_CTRL_ADDRESS,
 					  &core_ctrl);
 	if (ret) {
-		ath10k_warn("Unable to read core ctrl\n");
+		ath10k_warn("failed to read core_ctrl: %d\n", ret);
 		return ret;
 	}
 
@@ -1603,10 +1605,13 @@ static int ath10k_pci_wake_target_cpu(struct ath10k *ar)
 	ret = ath10k_pci_diag_write_access(ar, SOC_CORE_BASE_ADDRESS |
 					       CORE_CTRL_ADDRESS,
 					   core_ctrl);
-	if (ret)
-		ath10k_warn("Unable to set interrupt mask\n");
+	if (ret) {
+		ath10k_warn("failed to set target CPU interrupt mask: %d\n",
+			    ret);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int ath10k_pci_init_config(struct ath10k *ar)
@@ -1765,7 +1770,7 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
 
 		pipe_info->ce_hdl = ath10k_ce_init(ar, pipe_num, attr);
 		if (pipe_info->ce_hdl == NULL) {
-			ath10k_err("Unable to initialize CE for pipe: %d\n",
+			ath10k_err("failed to initialize CE for pipe: %d\n",
 				   pipe_num);
 
 			/* It is safe to call it here. It checks if ce_hdl is
@@ -1832,6 +1837,8 @@ static void ath10k_pci_start_bmi(struct ath10k *ar)
 
 	pipe = &ar_pci->pipe_info[BMI_CE_NUM_TO_HOST];
 	ath10k_ce_recv_cb_register(pipe->ce_hdl, ath10k_pci_bmi_recv_data);
+
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot start bmi\n");
 }
 
 static int ath10k_pci_hif_power_up(struct ath10k *ar)
@@ -1860,8 +1867,10 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 		ath10k_do_pci_wake(ar);
 
 	ret = ath10k_pci_ce_init(ar);
-	if (ret)
+	if (ret) {
+		ath10k_err("failed to initialize CE: %d\n", ret);
 		goto err_ps;
+	}
 
 	ret = ath10k_ce_disable_interrupts(ar);
 	if (ret) {
@@ -1895,7 +1904,7 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 
 	ret = ath10k_pci_wake_target_cpu(ar);
 	if (ret) {
-		ath10k_err("could not wake up target CPU (%d)\n", ret);
+		ath10k_err("could not wake up target CPU: %d\n", ret);
 		goto err_irq;
 	}
 
@@ -2397,7 +2406,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	ar = ath10k_core_create(ar_pci, ar_pci->dev, &ath10k_pci_hif_ops);
 	if (!ar) {
-		ath10k_err("ath10k_core_create failed!\n");
+		ath10k_err("failed to create driver core\n");
 		ret = -EINVAL;
 		goto err_ar_pci;
 	}
@@ -2416,20 +2425,20 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	 */
 	ret = pci_assign_resource(pdev, BAR_NUM);
 	if (ret) {
-		ath10k_err("cannot assign PCI space: %d\n", ret);
+		ath10k_err("failed to assign PCI space: %d\n", ret);
 		goto err_ar;
 	}
 
 	ret = pci_enable_device(pdev);
 	if (ret) {
-		ath10k_err("cannot enable PCI device: %d\n", ret);
+		ath10k_err("failed to enable PCI device: %d\n", ret);
 		goto err_ar;
 	}
 
 	/* Request MMIO resources */
 	ret = pci_request_region(pdev, BAR_NUM, "ath");
 	if (ret) {
-		ath10k_err("PCI MMIO reservation error: %d\n", ret);
+		ath10k_err("failed to request MMIO region: %d\n", ret);
 		goto err_device;
 	}
 
@@ -2439,13 +2448,13 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	 */
 	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
-		ath10k_err("32-bit DMA not available: %d\n", ret);
+		ath10k_err("failed to set DMA mask to 32-bit: %d\n", ret);
 		goto err_region;
 	}
 
 	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
-		ath10k_err("cannot enable 32-bit consistent DMA\n");
+		ath10k_err("failed to set consistent DMA mask to 32-bit\n");
 		goto err_region;
 	}
 
@@ -2462,7 +2471,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	/* Arrange for access to Target SoC registers. */
 	mem = pci_iomap(pdev, BAR_NUM, 0);
 	if (!mem) {
-		ath10k_err("PCI iomap error\n");
+		ath10k_err("failed to perform IOMAP for BAR%d\n", BAR_NUM);
 		ret = -EIO;
 		goto err_master;
 	}
@@ -2485,7 +2494,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
-		ath10k_err("could not register driver core (%d)\n", ret);
+		ath10k_err("failed to register driver core: %d\n", ret);
 		goto err_iomap;
 	}
 
@@ -2551,7 +2560,7 @@ static int __init ath10k_pci_init(void)
 
 	ret = pci_register_driver(&ath10k_pci_driver);
 	if (ret)
-		ath10k_err("pci_register_driver failed [%d]\n", ret);
+		ath10k_err("failed to register PCI driver: %d\n", ret);
 
 	return ret;
 }
-- 
1.8.4.rc3

