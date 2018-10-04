Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7179AC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42F3420652
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42F3420652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbeJDQ5n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 12:57:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727569AbeJDQ5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 12:57:43 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68A1D3084033;
        Thu,  4 Oct 2018 10:05:11 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58B652CFFC;
        Thu,  4 Oct 2018 10:05:08 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 2/5] mt76x0: correct RF access via RF_CSR regiser.
Date:   Thu,  4 Oct 2018 12:04:52 +0200
Message-Id: <1538647495-15213-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1538647495-15213-1-git-send-email-sgruszka@redhat.com>
References: <1538647495-15213-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 04 Oct 2018 10:05:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

PCIe version don't use MCU for RF regsisters access. We need
to correct RF CSR method to support up to 127 RF registers.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c   | 6 ++----
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h | 4 ++--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index cbbfd5193d9c..da4569f00794 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -37,7 +37,7 @@
 	bank = MT_RF_BANK(offset);
 	reg = MT_RF_REG(offset);
 
-	if (WARN_ON_ONCE(reg > 64) || WARN_ON_ONCE(bank) > 8)
+	if (WARN_ON_ONCE(reg > 127) || WARN_ON_ONCE(bank) > 8)
 		return -EINVAL;
 
 	mutex_lock(&dev->phy_mutex);
@@ -76,7 +76,7 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
 	bank = MT_RF_BANK(offset);
 	reg = MT_RF_REG(offset);
 
-	if (WARN_ON_ONCE(reg > 64) || WARN_ON_ONCE(bank) > 8)
+	if (WARN_ON_ONCE(reg > 127) || WARN_ON_ONCE(bank) > 8)
 		return -EINVAL;
 
 	mutex_lock(&dev->phy_mutex);
@@ -119,7 +119,6 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
 
 		return mt76_wr_rp(dev, MT_MCU_MEMMAP_RF, &pair, 1);
 	} else {
-		WARN_ON_ONCE(1);
 		return mt76x0_rf_csr_wr(dev, offset, val);
 	}
 }
@@ -138,7 +137,6 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
 		ret = mt76_rd_rp(dev, MT_MCU_MEMMAP_RF, &pair, 1);
 		val = pair.value;
 	} else {
-		WARN_ON_ONCE(1);
 		ret = val = mt76x0_rf_csr_rr(dev, offset);
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
index 24d1e6d747dd..f7de77d09d28 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
@@ -205,8 +205,8 @@
 #define MT_TXQ_STA			0x0434
 #define	MT_RF_CSR_CFG			0x0500
 #define MT_RF_CSR_CFG_DATA		GENMASK(7, 0)
-#define MT_RF_CSR_CFG_REG_ID		GENMASK(13, 8)
-#define MT_RF_CSR_CFG_REG_BANK		GENMASK(17, 14)
+#define MT_RF_CSR_CFG_REG_ID		GENMASK(14, 8)
+#define MT_RF_CSR_CFG_REG_BANK		GENMASK(17, 15)
 #define MT_RF_CSR_CFG_WR		BIT(30)
 #define MT_RF_CSR_CFG_KICK		BIT(31)
 
-- 
1.9.3

