Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE451C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9159521580
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:38:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9159521580
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbeI0OzW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 10:55:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbeI0OzW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 10:55:22 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77A1D3082134;
        Thu, 27 Sep 2018 08:38:16 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C258C3091390;
        Thu, 27 Sep 2018 08:37:44 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC 4/4] mt76x0: correct RF reg pairs write for PCIe
Date:   Thu, 27 Sep 2018 10:37:30 +0200
Message-Id: <1538037450-18949-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1538037450-18949-1-git-send-email-sgruszka@redhat.com>
References: <1538037450-18949-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.26
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 27 Sep 2018 08:38:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We have to use RF CSR method for PCIe.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 33e0ea9707e3..4d4f8e7e5fe5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -174,9 +174,22 @@
 }
 #endif
 
-#define RF_RANDOM_WRITE(dev, tab)		\
-	mt76_wr_rp(dev, MT_MCU_MEMMAP_RF,	\
-		   tab, ARRAY_SIZE(tab))
+static void
+mt76x0_rf_csr_wr_rp(struct mt76x0_dev *dev, const struct mt76_reg_pair *data,
+		    int n)
+{
+	while (n-- > 0) {
+		mt76x0_rf_csr_wr(dev, data->reg, data->value);
+		data++;
+	}
+}
+
+#define RF_RANDOM_WRITE(dev, tab) do {					\
+	if (mt76_is_mmio(dev))						\
+		mt76x0_rf_csr_wr_rp(dev, tab, ARRAY_SIZE(tab));		\
+	else								\
+		mt76_wr_rp(dev, MT_MCU_MEMMAP_RF, tab, ARRAY_SIZE(tab));\
+} while (0)
 
 int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
 {
-- 
1.9.3

