Return-Path: <SRS0=4wL/=7E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AF3C433DF
	for <linux-wireless@archiver.kernel.org>; Fri, 22 May 2020 14:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A71362054F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 May 2020 14:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590158784;
	bh=ye3nclsR7uSWC4P9+t5adbuuNtCeDZmeeSpzKSyy8xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ScGSDZpPqo1+btXI6qQeGZfW+NUB0TniHYYd8YUkXYrnE6NkpNcebxCBJZfMD3JLC
	 v6tZBY0kfRT0Oz09Epi2OdMamZjgm66KNw5nTFGCrg5xBErRsYr8kVJXSlA7Lo+uzN
	 g43kYlobkbaebVKd/Od8Uh7ybgi8bvtqtWoOTyRE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgEVOqG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 May 2020 10:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730381AbgEVOqD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 May 2020 10:46:03 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F7DB204EF;
        Fri, 22 May 2020 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590158762;
        bh=ye3nclsR7uSWC4P9+t5adbuuNtCeDZmeeSpzKSyy8xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkChRlczdOdI08bn6JmrTqB0hHPKi6knDknVJA0wcJzRcFQpPYgwccJ/S6aUPypGY
         qZtidpRlBISxgtHh1AbOHYLfLI0hpayMbnRrGZKGb1OVTdzzwLOdG/XFkttxm3qrEy
         gcMhq8pIIdy7nwnjs5ARl7RK9WFIERyQhkTKXOgc=
Received: by pali.im (Postfix)
        id D613951E; Fri, 22 May 2020 16:46:00 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        b43-dev@lists.infradead.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH 08/11] mmc: sdio: Move SDIO IDs from ath10k driver to common include file
Date:   Fri, 22 May 2020 16:44:09 +0200
Message-Id: <20200522144412.19712-9-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200522144412.19712-1-pali@kernel.org>
References: <20200522144412.19712-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Also replace generic MANUFACTURER macros by proper SDIO IDs macros.

Checks for device IDs are slightly modified to use SDIO device IDs.
This allows removal of all custom MANUFACTURER macros from ath10k.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 25 ++++++++++---------------
 drivers/net/wireless/ath/ath10k/sdio.h |  8 --------
 include/linux/mmc/sdio_ids.h           |  2 ++
 3 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 1f709b65c29b..59e725515041 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1083,10 +1083,10 @@ static void ath10k_sdio_set_mbox_info(struct ath10k *ar)
 
 	mbox_info->ext_info[0].htc_ext_addr = ATH10K_HIF_MBOX0_EXT_BASE_ADDR;
 
-	dev_id_base = FIELD_GET(QCA_MANUFACTURER_ID_BASE, device);
-	dev_id_chiprev = FIELD_GET(QCA_MANUFACTURER_ID_REV_MASK, device);
+	dev_id_base = (device & 0x0F00);
+	dev_id_chiprev = (device & 0x00FF);
 	switch (dev_id_base) {
-	case QCA_MANUFACTURER_ID_AR6005_BASE:
+	case (SDIO_DEVICE_ID_ATHEROS_AR6005 & 0x0F00):
 		if (dev_id_chiprev < 4)
 			mbox_info->ext_info[0].htc_ext_sz =
 				ATH10K_HIF_MBOX0_EXT_WIDTH;
@@ -1097,7 +1097,7 @@ static void ath10k_sdio_set_mbox_info(struct ath10k *ar)
 			mbox_info->ext_info[0].htc_ext_sz =
 				ATH10K_HIF_MBOX0_EXT_WIDTH_ROME_2_0;
 		break;
-	case QCA_MANUFACTURER_ID_QCA9377_BASE:
+	case (SDIO_DEVICE_ID_ATHEROS_QCA9377 & 0x0F00):
 		mbox_info->ext_info[0].htc_ext_sz =
 			ATH10K_HIF_MBOX0_EXT_WIDTH_ROME_2_0;
 		break;
@@ -2185,19 +2185,16 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 	skb_queue_head_init(&ar_sdio->rx_head);
 	INIT_WORK(&ar_sdio->async_work_rx, ath10k_rx_indication_async_work);
 
-	dev_id_base = FIELD_GET(QCA_MANUFACTURER_ID_BASE, id->device);
-	switch (dev_id_base) {
-	case QCA_MANUFACTURER_ID_AR6005_BASE:
-	case QCA_MANUFACTURER_ID_QCA9377_BASE:
-		ar->dev_id = QCA9377_1_0_DEVICE_ID;
-		break;
-	default:
+	dev_id_base = (id->device & 0x0F00);
+	if (dev_id_base != (SDIO_DEVICE_ID_ATHEROS_AR6005 & 0x0F00) &&
+	    dev_id_base != (SDIO_DEVICE_ID_ATHEROS_QCA9377 & 0x0F00)) {
 		ret = -ENODEV;
 		ath10k_err(ar, "unsupported device id %u (0x%x)\n",
 			   dev_id_base, id->device);
 		goto err_free_wq;
 	}
 
+	ar->dev_id = QCA9377_1_0_DEVICE_ID;
 	ar->id.vendor = id->vendor;
 	ar->id.device = id->device;
 
@@ -2246,10 +2243,8 @@ static void ath10k_sdio_remove(struct sdio_func *func)
 }
 
 static const struct sdio_device_id ath10k_sdio_devices[] = {
-	{SDIO_DEVICE(QCA_MANUFACTURER_CODE,
-		     (QCA_SDIO_ID_AR6005_BASE | 0xA))},
-	{SDIO_DEVICE(QCA_MANUFACTURER_CODE,
-		     (QCA_SDIO_ID_QCA9377_BASE | 0x1))},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_ATHEROS, SDIO_DEVICE_ID_ATHEROS_AR6005)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_ATHEROS, SDIO_DEVICE_ID_ATHEROS_QCA9377)},
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/sdio.h b/drivers/net/wireless/ath/ath10k/sdio.h
index 33195f49acab..e8951f9cdb5f 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.h
+++ b/drivers/net/wireless/ath/ath10k/sdio.h
@@ -10,14 +10,6 @@
 
 #define ATH10K_HIF_MBOX_BLOCK_SIZE              256
 
-#define QCA_MANUFACTURER_ID_BASE                GENMASK(11, 8)
-#define QCA_MANUFACTURER_ID_AR6005_BASE         0x5
-#define QCA_MANUFACTURER_ID_QCA9377_BASE        0x7
-#define QCA_SDIO_ID_AR6005_BASE                 0x500
-#define QCA_SDIO_ID_QCA9377_BASE                0x700
-#define QCA_MANUFACTURER_ID_REV_MASK            0x00FF
-#define QCA_MANUFACTURER_CODE                   0x271 /* Qualcomm/Atheros */
-
 #define ATH10K_SDIO_MAX_BUFFER_SIZE             4096 /*Unsure of this constant*/
 
 /* Mailbox address in SDIO address space */
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 95b67ab7d06a..2894f7739acc 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -33,6 +33,8 @@
 #define SDIO_DEVICE_ID_ATHEROS_AR6004_02	0x0402
 #define SDIO_DEVICE_ID_ATHEROS_AR6004_18	0x0418
 #define SDIO_DEVICE_ID_ATHEROS_AR6004_19	0x0419
+#define SDIO_DEVICE_ID_ATHEROS_AR6005		0x050A
+#define SDIO_DEVICE_ID_ATHEROS_QCA9377		0x0701
 
 #define SDIO_VENDOR_ID_BROADCOM			0x02d0
 #define SDIO_DEVICE_ID_BROADCOM_43143		0xa887
-- 
2.20.1

