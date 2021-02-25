Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD08AC433DB
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Feb 2021 07:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7827464E85
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Feb 2021 07:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhBYHGV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:06:21 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:21868 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232403AbhBYHFe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Feb 2021 02:05:34 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614236702; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=jeOdVFlDiszL8H7p1XC0HdBnkmqIUHHc8qG4WUD0lx0=; b=b1XXonNoOPb2mJfYtxtlCg7g4joJ6DEfePMBWNwuCjtK7C3wasywbPJsipa1vON1LSU60s6s
 tY24Jv4WuB+ieAP5qE4wP+we1o9s8LqajQPuxiqIxhUHAR8u74wDk+D69RF9ZX8l9xrlJ6FJ
 7T8biKIBEB2FHUAmX0fj9ID5Prk=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60374bfbe9080d5ff796c6d2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 25 Feb 2021 07:04:27
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E06BAC43462; Thu, 25 Feb 2021 07:04:26 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C99A3C433C6;
        Thu, 25 Feb 2021 07:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C99A3C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     linux-wireless@vger.kernel.org
Cc:     rdunlap@infradead.org, luciano.coelho@intel.com
Subject: [PATCH 5.12] iwlwifi: pcie: fix iwl_so_trans_cfg link error when CONFIG_IWLMVM is disabled
Date:   Thu, 25 Feb 2021 09:04:21 +0200
Message-Id: <1614236661-20274-1-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Randy reported an error on his randconfig builds:

ERROR: modpost: "iwl_so_trans_cfg" [drivers/net/wireless/intel/iwlwifi/iwlwifi.ko] undefined!

The problem was that when CONFIG_IWLMVM was disabled we were still accessing
iwl_so_trans_cfg. Fix it by moving IS_ENABLED() check before the access.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 314fec4a89ad..ffaf973dae94 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1106,6 +1106,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
+#if IS_ENABLED(CONFIG_IWLMVM)
+
 	/*
 	 * Workaround for problematic SnJ device: sometimes when
 	 * certain RF modules are connected to SnJ, the device ID
@@ -1116,7 +1118,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (CSR_HW_REV_TYPE(iwl_trans->hw_rev) == IWL_CFG_MAC_TYPE_SNJ)
 		iwl_trans->trans_cfg = &iwl_so_trans_cfg;
 
-#if IS_ENABLED(CONFIG_IWLMVM)
 	/*
 	 * special-case 7265D, it has the same PCI IDs.
 	 *
-- 
2.7.4

