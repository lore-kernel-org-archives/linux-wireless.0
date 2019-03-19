Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9630C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 19:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6B532075C
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 19:59:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O4H7Kc/k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfCST7s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 15:59:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36679 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfCST7r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 15:59:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id y13so244199wrd.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2019 12:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=23qtHAJ0cu40+beu5dSkqJ+/hV6sDIXp8ujFf6+i+kI=;
        b=O4H7Kc/k5XX39ZqkwmhUqEJbQS5v/iNPEtRsxANQm8GwzWz2PKEmhe1KB0PCTT61hH
         Ky/QpFvG6gC20X6rhESSj8Ir0YtzBqwYEitEJtu8nnFi73VXwq5byMPvfUdvSELtFCMe
         6+8MsaY2olwzRdXmNrm0/0knOFcHxrCVsyHK90YEzoOkuVeG1FDC/OPXfdjOC+PYjlIW
         11CNDL+e1ZccAQlkN54PyjBjoDM/vubYT9ggnl0/T27Z3gCN9mqdKVBeG+syRHrT4c8Q
         RGiOF5Vm8+OYYJ31RDAdl5fuHLwbOhLMZPTySdG/OA/f5OamxFipUAjlNZdtJs8wVcnx
         382w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=23qtHAJ0cu40+beu5dSkqJ+/hV6sDIXp8ujFf6+i+kI=;
        b=gDjSqB2Li4ans1eUSThfsWSiJwUs+tzR/AlSJcBEvoGkEYAlaBXQhnoYTBzRyUrFln
         E5+MAv5JtmIvluoV7pv91qRtj1Zp5klMLPbK5eSdSyYfkVX0b+W1mmubTwqv334BNUJ3
         p8a3i2ZhNz4flLKYBJReo4MbHuF9SDH1JblUIaq+R6TLMdGb70/FPCGpCu34znSFDUtW
         xgZvYlui72cfQOnyFU8FqHGGgETiRMwSXJc/w9RyQvSj4w2vPgrdTOFzUfb/l4kX5o9t
         yCptVFOgq1ygytncMrRRfYEm6J4YFnm81crQtv3dZ7Esc1MyN/Wa2/swClVB8Zvb4OBR
         TQEw==
X-Gm-Message-State: APjAAAV373pyBsqb60UcJJHZsYwNtKEY94Bcjly9tcg7zk//Y2IvaOtp
        zLDWTdLoAFd5JKSUqDd/Rj9g7ep44/c=
X-Google-Smtp-Source: APXvYqz4h63YwIknfsMprUTazpzgN1oWVLhgvBx1rZ18rR19C3TSl/AkDtHEj2vHBpKEa7XLR56qHQ==
X-Received: by 2002:adf:b64e:: with SMTP id i14mr19360400wre.10.1553025585896;
        Tue, 19 Mar 2019 12:59:45 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id k11sm1622562wmk.45.2019.03.19.12.59.44
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 19 Mar 2019 12:59:45 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: [PATCH] ath10k: Fix ASPM L1 state on QCA988X
Date:   Tue, 19 Mar 2019 20:59:40 +0100
Message-Id: <1553025580-6118-1-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On some systems there are heavy crashes if the kernel config
option CONFIG_PCIEASPM_PERFORMANCE is not set. Patch provided by
Sujith for ath9k fixes this issue and the card operates without
crashes with kernel default CONFIG_PCIEASPM_DEFAULT option that uses
BIOS provided ASPM settings. Tested with QCA9862 mPCIe card.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 271f92c..e24403c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2787,14 +2787,25 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar,
 				   enum ath10k_firmware_mode fw_mode)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct pci_dev *pdev = ar_pci->pdev;
 	int ret;
+	u32 val;
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power up\n");
 
-	pcie_capability_read_word(ar_pci->pdev, PCI_EXP_LNKCTL,
+	if (ar->dev_id == QCA988X_2_0_DEVICE_ID) {
+		pci_read_config_dword(pdev, 0x70c, &val);
+		if ((val & 0xff000000) == 0x17000000) {
+			val &= 0x00ffffff;
+			val |= 0x27000000;
+			pci_write_config_dword(pdev, 0x570c, val);
+		}
+	} else {
+		pcie_capability_read_word(ar_pci->pdev, PCI_EXP_LNKCTL,
 				  &ar_pci->link_ctl);
-	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
+		pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
 				   ar_pci->link_ctl & ~PCI_EXP_LNKCTL_ASPMC);
+	}
 
 	/*
 	 * Bring the target up cleanly.
-- 
1.7.0.4

