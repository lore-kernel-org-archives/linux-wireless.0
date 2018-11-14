Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5DBC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 02:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A4F62082A
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 02:51:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lf9nvdZN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BONZ1A2k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A4F62082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbeKNMwK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 07:52:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46592 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbeKNMwK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 07:52:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 022E460722; Wed, 14 Nov 2018 02:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542163858;
        bh=yQGr0fJeAliZ2O/8ZedwZLIqxfkoENv8K54gqZZeC44=;
        h=From:To:Cc:Subject:Date:From;
        b=lf9nvdZNi9WBvNckZZVEtebOnSOH61d1s9vcJCFUJC0aNuIqMRrK3Z7BU2G6c2XWg
         QeVFu9kzYetAurJBOY51TnucVPi2MJi/PhcMH32wZf50dvR1TinuUQ8QLcJGdbz6GK
         TqosnAKwz+P+Of26TRpzaf1yN2hcx3nfZCEurjYE=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F0C18601D4;
        Wed, 14 Nov 2018 02:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542163856;
        bh=yQGr0fJeAliZ2O/8ZedwZLIqxfkoENv8K54gqZZeC44=;
        h=From:To:Cc:Subject:Date:From;
        b=BONZ1A2kB2GsY7ZI3asazetcpG3ZUtIS0vdXewpztknoG3eKfrktt6tRcQ27RPk2g
         sSUZcqPqsUl4fXk48cZqNyNMs2Qcw7fzNXKUp6+6n4BOOWg042bNrcqlpYkgtJTyBx
         wR/7bBjzxAT6GzeooqECJpVkifoKGPcO0w+iL0EY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F0C18601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: support PCIe enter L1 state
Date:   Wed, 14 Nov 2018 10:50:48 +0800
Message-Id: <1542163848-837-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

QCA6174A/QCA9377 PCIe chips support PCIe L1 and L1SS, and indicate the
L1/L1SS capabilities in PCI configuration space. Currently ath10k driver
write target PCIe config flags to disallow HW enter into L1, this leads
some HW modules are still powered up even when both system PCIe RC and
QCA6174A/QCA9377 endpoint decides to enter into L1 or L1SS.

This cause ~12 mA power drain of bottom power consumption for all scenarios.
Fix this issue by removing the drive code to write PCIe config flags.

Tested with QCA6174 PCI with firmware
WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
It's not a regression with new firmware releases.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index af2cf55..549da7a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2301,7 +2301,6 @@ int ath10k_pci_init_config(struct ath10k *ar)
 	u32 pcie_state_targ_addr = 0;
 	u32 pipe_cfg_targ_addr = 0;
 	u32 svc_to_pipe_map = 0;
-	u32 pcie_config_flags = 0;
 	u32 ealloc_value;
 	u32 ealloc_targ_addr;
 	u32 flag2_value;
@@ -2374,26 +2373,6 @@ int ath10k_pci_init_config(struct ath10k *ar)
 		return ret;
 	}
 
-	ret = ath10k_pci_diag_read32(ar, (pcie_state_targ_addr +
-					  offsetof(struct pcie_state,
-						   config_flags)),
-				     &pcie_config_flags);
-	if (ret != 0) {
-		ath10k_err(ar, "Failed to get pcie config_flags: %d\n", ret);
-		return ret;
-	}
-
-	pcie_config_flags &= ~PCIE_CONFIG_FLAG_ENABLE_L1;
-
-	ret = ath10k_pci_diag_write32(ar, (pcie_state_targ_addr +
-					   offsetof(struct pcie_state,
-						    config_flags)),
-				      pcie_config_flags);
-	if (ret != 0) {
-		ath10k_err(ar, "Failed to write pcie config_flags: %d\n", ret);
-		return ret;
-	}
-
 	/* configure early allocation */
 	ealloc_targ_addr = host_interest_item_address(HI_ITEM(hi_early_alloc));
 
-- 
1.9.1

