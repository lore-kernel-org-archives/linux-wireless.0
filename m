Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09749C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5B3A21580
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:37:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5B3A21580
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbeI0Oyr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 10:54:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49707 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbeI0Oyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 10:54:47 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD7C08830C;
        Thu, 27 Sep 2018 08:37:41 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AFA32010D57;
        Thu, 27 Sep 2018 08:37:39 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC 2/4] mt76x0: correct RF access via RF_CSR regiser.
Date:   Thu, 27 Sep 2018 10:37:28 +0200
Message-Id: <1538037450-18949-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1538037450-18949-1-git-send-email-sgruszka@redhat.com>
References: <1538037450-18949-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.25
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 27 Sep 2018 08:37:41 +0000 (UTC)
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
index ca0a693654a3..33e0ea9707e3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -37,7 +37,7 @@
 	bank = MT_RF_BANK(offset);
 	reg = MT_RF_REG(offset);
 
-	if (WARN_ON_ONCE(reg > 64) || WARN_ON_ONCE(bank) > 8)
+	if (WARN_ON_ONCE(reg > 127) || WARN_ON_ONCE(bank) > 8)
 		return -EINVAL;
 
 	mutex_lock(&dev->reg_atomic_mutex);
@@ -77,7 +77,7 @@
 	bank = MT_RF_BANK(offset);
 	reg = MT_RF_REG(offset);
 
-	if (WARN_ON_ONCE(reg > 64) || WARN_ON_ONCE(bank) > 8)
+	if (WARN_ON_ONCE(reg > 127) || WARN_ON_ONCE(bank) > 8)
 		return -EINVAL;
 
 	mutex_lock(&dev->reg_atomic_mutex);
@@ -120,7 +120,6 @@
 
 		return mt76_wr_rp(dev, MT_MCU_MEMMAP_RF, &pair, 1);
 	} else {
-		WARN_ON_ONCE(1);
 		return mt76x0_rf_csr_wr(dev, offset, val);
 	}
 }
@@ -139,7 +138,6 @@
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

