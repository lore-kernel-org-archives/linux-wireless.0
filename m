Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96181C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 14:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56F612145D
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 14:16:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="qvjUpEm9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56F612145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbeJRWSB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 18:18:01 -0400
Received: from nbd.name ([46.4.11.11]:34794 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbeJRWSB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 18:18:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=efx7r/v6/Z5cublz7oTcml2AE0JnDRfjkwufbB3qepI=; b=qvjUpEm9I3dNF1D349TewqRd6b
        jtWCGygiuQ8s2myX3qlIDS3lJUa9qfOpdU9xq3gdeQ47qOFMBClq7sFtAcxEZa/2xJVZstMdziMft
        0qoBp+MC92CdzJIfSLSspVNwZafRm65RucEPmQ9JGwxH/ubmi5o8bJpdTb7xW/6+pWQY=;
Received: by maeck.lan (Postfix, from userid 501)
        id DCA14401BB76; Thu, 18 Oct 2018 16:16:45 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     sgruszka@redhat.com, lorenzo.bianconi@redhat.com
Subject: [PATCH 2/2] mt76: mt76x0: handle chip specific initval differences
Date:   Thu, 18 Oct 2018 16:16:45 +0200
Message-Id: <20181018141645.31484-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181018141645.31484-1-nbd@nbd.name>
References: <20181018141645.31484-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some RF registers need different values for various chips.
For at least mt76x0_rf_central_tab registers, overwriting them later does
not work, as the wrong values can cause the entire system to hang on some
devices with MT7610E

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  6 ++-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 47 ++++++++++++++++++-
 2 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 33475788bc26..989ed00c0b7a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -33,8 +33,10 @@
 
 static inline bool is_mt7610e(struct mt76x02_dev *dev)
 {
-	/* TODO */
-	return false;
+	if (!mt76_is_mmio(dev))
+		return false;
+
+	return mt76_chip(&dev->mt76) == 0x7610;
 }
 
 static inline bool is_mt7630(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 10041e673c31..d294325221f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -775,13 +775,56 @@ static void mt76x0_phy_calibration_work(struct work_struct *work)
 				     MT_CALIBRATE_INTERVAL);
 }
 
+static void mt76x0_rf_patch_reg_array(struct mt76x02_dev *dev,
+				      const struct mt76_reg_pair *rp, int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++) {
+		u32 reg = rp[i].reg;
+		u8 val = rp[i].value;
+
+		switch (reg) {
+		case MT_RF(0, 3):
+			if (mt76_is_mmio(dev)) {
+				if (is_mt7630(dev))
+					val = 0x70;
+				else
+					val = 0x63;
+			} else {
+				val = 0x73;
+			}
+			break;
+		case MT_RF(0, 21):
+			if (is_mt7610e(dev))
+				val = 0x10;
+			else
+				val = 0x12;
+			break;
+		case MT_RF(5, 2):
+			if (is_mt7630(dev))
+				val = 0x1d;
+			else if (is_mt7610e(dev))
+				val = 0x00;
+			else
+				val = 0x0c;
+			break;
+		default:
+			break;
+		}
+		mt76x0_rf_wr(dev, reg, val);
+	}
+}
+
 static void mt76x0_phy_rf_init(struct mt76x02_dev *dev)
 {
 	int i;
 	u8 val;
 
-	RF_RANDOM_WRITE(dev, mt76x0_rf_central_tab);
-	RF_RANDOM_WRITE(dev, mt76x0_rf_2g_channel_0_tab);
+	mt76x0_rf_patch_reg_array(dev, mt76x0_rf_central_tab,
+				  ARRAY_SIZE(mt76x0_rf_central_tab));
+	mt76x0_rf_patch_reg_array(dev, mt76x0_rf_2g_channel_0_tab,
+				  ARRAY_SIZE(mt76x0_rf_2g_channel_0_tab));
 	RF_RANDOM_WRITE(dev, mt76x0_rf_5g_channel_0_tab);
 	RF_RANDOM_WRITE(dev, mt76x0_rf_vga_channel_0_tab);
 	mt76x0_phy_rf_switch_band(dev, NULL);
-- 
2.17.0

