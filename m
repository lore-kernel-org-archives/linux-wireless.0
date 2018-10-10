Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A09C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB29521479
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ivMsMk5m";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ivMsMk5m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB29521479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbeJJS4Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 14:56:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33832 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbeJJS4Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 14:56:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D720360C4D; Wed, 10 Oct 2018 11:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539171278;
        bh=6JYG/8IyJN8/xMQC3V8MECD9l2ytzppV/tTrG6CQ5z8=;
        h=From:To:Cc:Subject:Date:From;
        b=ivMsMk5mxiE4Rjla4w9bThELAo8Oz+VDLrYVjXm1K03Ijfgazvz5Plcjg2TIXR5X4
         WDhnH0n6W0bc/qbPqM5BoNwfVACXBKDXnlimWw9YLiYBtoZnL5KftNZ/ba0KDgLIaT
         6L5IHAYFw3qffdclmtUMk/dLDwxdQpLRmRBdsbc8=
Received: from cjhuang-station.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cjhuang@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8825A605A2;
        Wed, 10 Oct 2018 11:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539171278;
        bh=6JYG/8IyJN8/xMQC3V8MECD9l2ytzppV/tTrG6CQ5z8=;
        h=From:To:Cc:Subject:Date:From;
        b=ivMsMk5mxiE4Rjla4w9bThELAo8Oz+VDLrYVjXm1K03Ijfgazvz5Plcjg2TIXR5X4
         WDhnH0n6W0bc/qbPqM5BoNwfVACXBKDXnlimWw9YLiYBtoZnL5KftNZ/ba0KDgLIaT
         6L5IHAYFw3qffdclmtUMk/dLDwxdQpLRmRBdsbc8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8825A605A2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cjhuang@codeaurora.org
From:   Carl Huang <cjhuang@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH V2] ath10k: allocate small size dma memory in ath10k_pci_diag_write_mem
Date:   Wed, 10 Oct 2018 19:34:29 +0800
Message-Id: <1539171269-23944-1-git-send-email-cjhuang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ath10k_pci_diag_write_mem may allocate big size of the dma memory
based on the parameter nbytes. Take firmware diag download as
example, the biggest size is about 500K. In some systems, the
allocation is likely to fail because it can't acquire such a large
contiguous dma memory.

The fix is to allocate a small size dma memory. In the loop,
driver copies the data to the allocated dma memory and writes to
the destination until all the data is written.

Tested with QCA6174 PCI with
firmware-6.bin_WLAN.RM.4.4.1-00119-QCARMSWP-1, this also affects
QCA9377 PCI.

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
Reviewed-by: Brian Norris <briannorris@chomium.org>
---
V2:
  *addressed Brian's comment. Removed ce_data variable.

 drivers/net/wireless/ath/ath10k/pci.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 873dbb6..a269077 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1071,10 +1071,9 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	struct ath10k_ce *ce = ath10k_ce_priv(ar);
 	int ret = 0;
 	u32 *buf;
-	unsigned int completed_nbytes, orig_nbytes, remaining_bytes;
+	unsigned int completed_nbytes, alloc_nbytes, remaining_bytes;
 	struct ath10k_ce_pipe *ce_diag;
 	void *data_buf = NULL;
-	u32 ce_data;	/* Host buffer address in CE space */
 	dma_addr_t ce_data_base = 0;
 	int i;
 
@@ -1088,9 +1087,10 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	 *   1) 4-byte alignment
 	 *   2) Buffer in DMA-able space
 	 */
-	orig_nbytes = nbytes;
+	alloc_nbytes = min_t(unsigned int, nbytes, DIAG_TRANSFER_LIMIT);
+
 	data_buf = (unsigned char *)dma_alloc_coherent(ar->dev,
-						       orig_nbytes,
+						       alloc_nbytes,
 						       &ce_data_base,
 						       GFP_ATOMIC);
 	if (!data_buf) {
@@ -1098,9 +1098,6 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		goto done;
 	}
 
-	/* Copy caller's data to allocated DMA buf */
-	memcpy(data_buf, data, orig_nbytes);
-
 	/*
 	 * The address supplied by the caller is in the
 	 * Target CPU virtual address space.
@@ -1113,12 +1110,14 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	 */
 	address = ath10k_pci_targ_cpu_to_ce_addr(ar, address);
 
-	remaining_bytes = orig_nbytes;
-	ce_data = ce_data_base;
+	remaining_bytes = nbytes;
 	while (remaining_bytes) {
 		/* FIXME: check cast */
 		nbytes = min_t(int, remaining_bytes, DIAG_TRANSFER_LIMIT);
 
+		/* Copy caller's data to allocated DMA buf */
+		memcpy(data_buf, data, nbytes);
+
 		/* Set up to receive directly into Target(!) address */
 		ret = ce_diag->ops->ce_rx_post_buf(ce_diag, &address, address);
 		if (ret != 0)
@@ -1128,7 +1127,7 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		 * Request CE to send caller-supplied data that
 		 * was copied to bounce buffer to Target(!) address.
 		 */
-		ret = ath10k_ce_send_nolock(ce_diag, NULL, (u32)ce_data,
+		ret = ath10k_ce_send_nolock(ce_diag, NULL, (u32)ce_data_base,
 					    nbytes, 0, 0);
 		if (ret != 0)
 			goto done;
@@ -1171,12 +1170,12 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 
 		remaining_bytes -= nbytes;
 		address += nbytes;
-		ce_data += nbytes;
+		data += nbytes;
 	}
 
 done:
 	if (data_buf) {
-		dma_free_coherent(ar->dev, orig_nbytes, data_buf,
+		dma_free_coherent(ar->dev, alloc_nbytes, data_buf,
 				  ce_data_base);
 	}
 
-- 
2.7.4

