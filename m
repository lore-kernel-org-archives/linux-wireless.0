Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E481C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1259120878
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:49:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KH94Tpjd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XF5eaftI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1259120878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbeJHRAn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 13:00:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36698 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbeJHRAn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 13:00:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0CB646076A; Mon,  8 Oct 2018 09:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538992191;
        bh=zwx0K1kI8NWkDCgcMScYqi+qXwnTFNUfxmpO9niiEi0=;
        h=From:To:Cc:Subject:Date:From;
        b=KH94Tpjd3RheumxtF6s2g9vSXugdTFIhI/+1ahuCbImYF1GiqRdehUbD44cDCSyAm
         qQG2S+VBCw31ZzWLzW0onxVv2P+dEnIsUvCOGDYqv0D8CwBp/SGQXXHeta+dqeFOYF
         lCgYTbabtcxS1/vV1hVryo2csxODYkC/uVBh0EW8=
Received: from cjhuang-station.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cjhuang@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F4149601D2;
        Mon,  8 Oct 2018 09:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538992190;
        bh=zwx0K1kI8NWkDCgcMScYqi+qXwnTFNUfxmpO9niiEi0=;
        h=From:To:Cc:Subject:Date:From;
        b=XF5eaftIFAITUJtnv+yyJH2eXkE3yhEfakUmh0Qw+/hdpILe5QgEwt3j0OEMEkDaR
         zj/TVmKdjS6XZ0UBXvJtNrqy/+z2zQQ5Jx0uEdDuCK6xQxJCyROfX8NCsbOcF0lTAp
         KsI/+I2aHFABzZOwXB72Ld07ZJX8hhcbx6783rPU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F4149601D2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cjhuang@codeaurora.org
From:   Carl Huang <cjhuang@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: allocate small size dma memory in ath10k_pci_diag_write_mem
Date:   Mon,  8 Oct 2018 17:49:42 +0800
Message-Id: <1538992182-3717-1-git-send-email-cjhuang@codeaurora.org>
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
---
 drivers/net/wireless/ath/ath10k/pci.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 873dbb6..1872671 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1071,7 +1071,7 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	struct ath10k_ce *ce = ath10k_ce_priv(ar);
 	int ret = 0;
 	u32 *buf;
-	unsigned int completed_nbytes, orig_nbytes, remaining_bytes;
+	unsigned int completed_nbytes, alloc_nbytes, remaining_bytes;
 	struct ath10k_ce_pipe *ce_diag;
 	void *data_buf = NULL;
 	u32 ce_data;	/* Host buffer address in CE space */
@@ -1088,9 +1088,10 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
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
@@ -1098,9 +1099,6 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		goto done;
 	}
 
-	/* Copy caller's data to allocated DMA buf */
-	memcpy(data_buf, data, orig_nbytes);
-
 	/*
 	 * The address supplied by the caller is in the
 	 * Target CPU virtual address space.
@@ -1113,12 +1111,15 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	 */
 	address = ath10k_pci_targ_cpu_to_ce_addr(ar, address);
 
-	remaining_bytes = orig_nbytes;
+	remaining_bytes = nbytes;
 	ce_data = ce_data_base;
 	while (remaining_bytes) {
 		/* FIXME: check cast */
 		nbytes = min_t(int, remaining_bytes, DIAG_TRANSFER_LIMIT);
 
+		/* Copy caller's data to allocated DMA buf */
+		memcpy(data_buf, data, nbytes);
+
 		/* Set up to receive directly into Target(!) address */
 		ret = ce_diag->ops->ce_rx_post_buf(ce_diag, &address, address);
 		if (ret != 0)
@@ -1171,12 +1172,12 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 
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

