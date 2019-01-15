Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B42C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 06:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5816720656
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 06:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fwN+GCyt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PK8PXOPR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfAOGd5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 01:33:57 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46118 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbfAOGd5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 01:33:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3E3DD6055C; Tue, 15 Jan 2019 06:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547534036;
        bh=5/J9fr22DksbDPxQY3rjDXo8aLkdx1I0dzAF6Fa7iok=;
        h=From:To:Cc:Subject:Date:From;
        b=fwN+GCytinzrmTktT0ZNIXki+VwkUWXWXgYBmzU4E97Qm/aXNvjlm9rMcIXAOc8T0
         gmiyejicnYVDaAgbMSEfHYU2sdo693FHhLsiU7A/Barq1j+uNS31koJy8f5nW68Fxz
         oPM94cLDK7LZpb+xNvcvJzxpJFaL8eYggsWgrHI0=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: yyuwang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9DC026074C;
        Tue, 15 Jan 2019 06:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547534035;
        bh=5/J9fr22DksbDPxQY3rjDXo8aLkdx1I0dzAF6Fa7iok=;
        h=From:To:Cc:Subject:Date:From;
        b=PK8PXOPRW5ssYaoZozcEM3x8TtzGW8Ofm+wMFhQdA5n1GqpNCNle+1rdAvUOIIrNT
         +1PsON0B5mNOkWm4ynvooFpuXQ5RWovgwaMIi4XRmFKk/pe4M4OxHUCQ1vTNLbUwiP
         9yJ2FJTulTBglSqA+szWw4kRZAMeiNxyt4HxWFn4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9DC026074C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=yyuwang@codeaurora.org
From:   Yu Wang <yyuwang@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Yu Wang <yyuwang@codeaurora.org>
Subject: [PATCH] ath10k: fix S5 power consumption issue for QCA9377
Date:   Tue, 15 Jan 2019 14:31:07 +0800
Message-Id: <1547533867-15131-1-git-send-email-yyuwang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

After system entering S5 (shut down but system still
providing power to QCA9377) on Ubuntu platform, power
consumption of QCA9377 is 69mA, which is too high.
The root cause is pci_soft_reset is not set for QCA9377
during pci probe.
To fix this issue, set 'pci_soft_reset' to 'th10k_pci_warm_reset',
and then the power consumption drops to a normal value(10mA).
Verified on Dell Ubuntu platform with firmware:
WLAN.TF.1.0-00002-QCATFSWPZ-5

Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 01b4edb..0a4ce98 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3554,7 +3554,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	case QCA9377_1_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA9377;
 		pci_ps = true;
-		pci_soft_reset = NULL;
+		pci_soft_reset = ath10k_pci_warm_reset;
 		pci_hard_reset = ath10k_pci_qca6174_chip_reset;
 		targ_cpu_to_ce_addr = ath10k_pci_qca6174_targ_cpu_to_ce_addr;
 		break;
-- 
1.9.1

