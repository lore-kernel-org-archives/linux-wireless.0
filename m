Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E70FC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E31452084D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:28:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WmyiMSA7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OYKrTBpH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfDLN2s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:28:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41260 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfDLN2s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 09:28:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8AF2D61783; Fri, 12 Apr 2019 13:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075726;
        bh=nsnvU3lPYJpM9h16jP2Mq8aGetDJICeUt3QinjyT3oc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WmyiMSA7Mp6WWP5sg1SWj+pIhpWnMX8EpmZTc9dlSPrWhXqz9Rj8H4nNxoE0R8290
         Kb7mR4ikZOhDN5BER6I1Cevta9oaqCQy61ykUxWwNi54/m9ULB4tUD7F6wyoF2jxTn
         ld0NINgFNoVq5FiqyX7OSE1LyZk++t8cobn1N30g=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4408561576;
        Fri, 12 Apr 2019 13:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075725;
        bh=nsnvU3lPYJpM9h16jP2Mq8aGetDJICeUt3QinjyT3oc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OYKrTBpHcvZ/7JsiFS1K40Ncd2Tmu5iSdnowwW0j3TzJHPERCSnIKBc/xRsw9audD
         kEpPaAsIajbqZWtQNZnqdHR8mn0YP+c9JWpKHXNeyffgFfE6NxYXq7x25yvUKgJusS
         I/5GAmw4qfO56TnabG/FaQmZ9dk+vSJ7CVttrVv4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4408561576
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Subject: [PATCH 4/6] ath10k: initialise struct ath10k_bus params to zero
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 12 Apr 2019 16:28:43 +0300
Message-ID: <155507572259.32018.5435832600956812976.stgit@potku.adurom.net>
In-Reply-To: <155507569645.32018.15231567732563770250.stgit@potku.adurom.net>
References: <155507569645.32018.15231567732563770250.stgit@potku.adurom.net>
User-Agent: StGit/0.17.1-17-ge4e0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This way we don't need to set every variable and give them to default, which is
zero. This is also safer in case we forgot to initalise a new field in some of
the bus modules.

Compile tested only.

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/ahb.c  |    2 +-
 drivers/net/wireless/ath/ath10k/pci.c  |    2 +-
 drivers/net/wireless/ath/ath10k/sdio.c |    2 +-
 drivers/net/wireless/ath/ath10k/snoc.c |    2 +-
 drivers/net/wireless/ath/ath10k/usb.c  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 0bf726c55736..f80854180e21 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -740,7 +740,7 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 	enum ath10k_hw_rev hw_rev;
 	size_t size;
 	int ret;
-	struct ath10k_bus_params bus_params;
+	struct ath10k_bus_params bus_params = {};
 
 	of_id = of_match_device(ath10k_ahb_of_match, &pdev->dev);
 	if (!of_id) {
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 271f92c24d44..13c24cd977d2 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3478,7 +3478,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	struct ath10k *ar;
 	struct ath10k_pci *ar_pci;
 	enum ath10k_hw_rev hw_rev;
-	struct ath10k_bus_params bus_params;
+	struct ath10k_bus_params bus_params = {};
 	bool pci_ps;
 	int (*pci_soft_reset)(struct ath10k *ar);
 	int (*pci_hard_reset)(struct ath10k *ar);
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index d573d24624c0..bbfdc4d7cf5f 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1954,7 +1954,7 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 	struct ath10k *ar;
 	enum ath10k_hw_rev hw_rev;
 	u32 dev_id_base;
-	struct ath10k_bus_params bus_params;
+	struct ath10k_bus_params bus_params = {};
 	int ret, i;
 
 	/* Assumption: All SDIO based chipsets (so far) are QCA6174 based.
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 873cb4ce419b..845914f2eaf8 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1249,7 +1249,7 @@ static int ath10k_snoc_resource_init(struct ath10k *ar)
 int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
-	struct ath10k_bus_params bus_params;
+	struct ath10k_bus_params bus_params = {};
 	int ret;
 
 	if (test_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags))
diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index 970cf69ac35f..2fb0fb40e86d 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -973,7 +973,7 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 	struct usb_device *dev = interface_to_usbdev(interface);
 	int ret, vendor_id, product_id;
 	enum ath10k_hw_rev hw_rev;
-	struct ath10k_bus_params bus_params;
+	struct ath10k_bus_params bus_params = {};
 
 	/* Assumption: All USB based chipsets (so far) are QCA9377 based.
 	 * If there will be newer chipsets that does not use the hw reg

