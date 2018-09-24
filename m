Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE03C43382
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F002B204EC
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:16:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F002B204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbeIYEUf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:20:35 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46851 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1728582AbeIYETq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:46 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOB012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 01/11] qtnfmac_pcie: do not store FW name in driver state structure
Date:   Mon, 24 Sep 2018 15:15:04 -0700
Message-Id: <20180924221514.4273-2-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Firmware name is only needed at probe stage, no point in keeping it in
driver state structure.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h        | 1 -
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wireless/quantenna/qtnfmac/bus.h
index 323e47c..2beca5b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -57,7 +57,6 @@ struct qtnf_bus {
 	struct qtnf_wmac *mac[QTNF_MAX_MAC];
 	struct qtnf_qlink_transport trans;
 	struct qtnf_hw_info hw_info;
-	char fwname[32];
 	struct napi_struct mux_napi;
 	struct net_device mux_dev;
 	struct completion firmware_init_complete;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 3120d49..97cc7f2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -1177,13 +1177,14 @@ static void qtnf_fw_work_handler(struct work_struct *work)
 	const struct firmware *fw;
 	int ret;
 	u32 state = QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK;
+	const char *fwname = QTN_PCI_PEARL_FW_NAME;
 
 	if (flashboot) {
 		state |= QTN_RC_FW_FLASHBOOT;
 	} else {
-		ret = request_firmware(&fw, bus->fwname, &pdev->dev);
+		ret = request_firmware(&fw, fwname, &pdev->dev);
 		if (ret < 0) {
-			pr_err("failed to get firmware %s\n", bus->fwname);
+			pr_err("failed to get firmware %s\n", fwname);
 			goto fw_load_fail;
 		}
 	}
@@ -1205,7 +1206,7 @@ static void qtnf_fw_work_handler(struct work_struct *work)
 	if (flashboot) {
 		pr_info("booting firmware from flash\n");
 	} else {
-		pr_info("starting firmware upload: %s\n", bus->fwname);
+		pr_info("starting firmware upload: %s\n", fwname);
 
 		ret = qtnf_ep_fw_load(priv, fw->data, fw->size);
 		release_firmware(fw);
@@ -1290,7 +1291,6 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	bus->fw_state = QTNF_FW_STATE_RESET;
 	pcie_priv->pdev = pdev;
 
-	strcpy(bus->fwname, QTN_PCI_PEARL_FW_NAME);
 	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
 	spin_lock_init(&pcie_priv->tx0_lock);
-- 
2.9.5

