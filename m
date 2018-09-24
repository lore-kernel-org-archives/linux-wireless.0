Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 279B0C004D1
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB0BD204EC
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB0BD204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbeIYETt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:19:49 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46858 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1728653AbeIYETr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:47 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOK012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 10/11] qtnfmac: wait for FW load work to finish at PCIe remove
Date:   Mon, 24 Sep 2018 15:15:13 -0700
Message-Id: <20180924221514.4273-11-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Waiting for "completion" to be set in FW load thread can not be used
in case PCIe remove is called before FW load work was scheduled.
Just wait for work completion instead to avoid problems.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h       | 1 -
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wireless/quantenna/qtnfmac/bus.h
index 7c4f856..528ca7f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -62,7 +62,6 @@ struct qtnf_bus {
 	struct qtnf_hw_info hw_info;
 	struct napi_struct mux_napi;
 	struct net_device mux_dev;
-	struct completion firmware_init_complete;
 	struct workqueue_struct *workqueue;
 	struct work_struct fw_work;
 	struct work_struct event_work;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
index f83951c..d1637f2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -130,7 +130,6 @@ void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool boot_success,
 		bus->fw_state = QTNF_FW_STATE_DETACHED;
 	}
 
-	complete(&bus->firmware_init_complete);
 	put_device(&pdev->dev);
 }
 
@@ -304,7 +303,6 @@ int qtnf_pcie_probe(struct pci_dev *pdev, size_t priv_size,
 	pcie_priv->pdev = pdev;
 	pcie_priv->tx_stopped = 0;
 
-	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
 	spin_lock_init(&pcie_priv->tx_lock);
 	spin_lock_init(&pcie_priv->tx_reclaim_lock);
@@ -376,7 +374,7 @@ static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus_priv *priv)
 
 void qtnf_pcie_remove(struct qtnf_bus *bus, struct qtnf_pcie_bus_priv *priv)
 {
-	wait_for_completion(&bus->firmware_init_complete);
+	cancel_work_sync(&bus->fw_work);
 
 	if (bus->fw_state == QTNF_FW_STATE_ACTIVE ||
 	    bus->fw_state == QTNF_FW_STATE_EP_DEAD)
-- 
2.9.5

