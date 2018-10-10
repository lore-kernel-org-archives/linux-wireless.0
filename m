Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A358EC00449
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 09:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68CE9214DA
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 09:14:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68CE9214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbeJJQfw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 12:35:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50818 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbeJJQfw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 12:35:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id i8-v6so4596479wmg.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 02:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mT8eGMTQ/bXUU9CWYZxJdIn/xV9DdZwqe1PloPWP0/s=;
        b=czpGoXlp66/izNV7QLXibjGDvjrV80vbRH2E6Fz4xO8YL5ebNK1JvNYZqRADquc6q0
         8pgCFwa6CYsgbJOGxvmPpxV0c8qVT1bGsn990PqldvS7vKKxpUlT2OtDUO79OdXYNWz2
         f7d+T1jxH1gLnxDDB6b1L3cJXYursQOwrAY7Lq0h1cVECSWoXR0HyZ74zkGvBi1YJyNw
         7TuhB3tnKHm3qpOY0/0AH6TNaCbD06aTNevjiAeWPPF9BBOMg216eKKKo+8lVD5hXStL
         43yXmwd8IslBvQSgbPFx6xPbet4fjm4ramUbJTb6Ode0V0kIBOR1gd/bA8Ou3WmLSqNQ
         oBvw==
X-Gm-Message-State: ABuFfojkP+OtAuwC7e7AiTd5+kQDoWmCQbccnGLSCwKpH9Gh4F3SeoAN
        cdAcWdBuZIU1wPR8PBmDt8CORw==
X-Google-Smtp-Source: ACcGV60pCBSuYdqdvcNyM2w2N0vCY/20ag2ZB+0W4cmphKMIwyScL1UqRkhrleuSkWEEE+Qpf6JkoA==
X-Received: by 2002:a1c:d9cc:: with SMTP id q195-v6mr130537wmg.23.1539162875619;
        Wed, 10 Oct 2018 02:14:35 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 65-v6sm17715106wmm.36.2018.10.10.02.14.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Oct 2018 02:14:34 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt76x0: phy: fix mt76x0_temp_sensor routine
Date:   Wed, 10 Oct 2018 11:14:22 +0200
Message-Id: <81232baeddb434362a3474842890ee9f316bfd67.1539162246.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1539162246.git.lorenzo.bianconi@redhat.com>
References: <cover.1539162246.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix configuration of register 67 on bank0 during temperature
reading and use mt76_poll utility routine to poll core34
register. Moreover temperature compensation need to be disabled
if the device supports tssi compensation.
This issue has never been hit since temperature reading is not
actually used by usb code.

Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 43 +++++++++----------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 29bc4e4623cd..e9254452c7f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -763,48 +763,41 @@ void mt76x0_agc_restore(struct mt76x02_dev *dev)
 	mt76_rmw_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN, dev->agc_save);
 }
 
-static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
+static int mt76x0_temp_sensor(struct mt76x02_dev *dev, int *temp)
 {
 	u8 rf_b7_73, rf_b0_66, rf_b0_67;
-	int cycle, temp;
-	u32 val;
-	s32 sval;
+	int val, err = 0;
 
 	rf_b7_73 = rf_rr(dev, MT_RF(7, 73));
 	rf_b0_66 = rf_rr(dev, MT_RF(0, 66));
-	rf_b0_67 = rf_rr(dev, MT_RF(0, 73));
+	rf_b0_67 = rf_rr(dev, MT_RF(0, 67));
 
 	rf_wr(dev, MT_RF(7, 73), 0x02);
 	rf_wr(dev, MT_RF(0, 66), 0x23);
-	rf_wr(dev, MT_RF(0, 73), 0x01);
+	rf_wr(dev, MT_RF(0, 67), 0x01);
 
 	mt76_wr(dev, MT_BBP(CORE, 34), 0x00080055);
 
-	for (cycle = 0; cycle < 2000; cycle++) {
-		val = mt76_rr(dev, MT_BBP(CORE, 34));
-		if (!(val & 0x10))
-			break;
-		udelay(3);
-	}
-
-	if (cycle >= 2000) {
-		val &= 0x10;
-		mt76_wr(dev, MT_BBP(CORE, 34), val);
+	if (!mt76_poll(dev, MT_BBP(CORE, 34), BIT(4), 0, 2000)) {
+		mt76_clear(dev, MT_BBP(CORE, 34), BIT(4));
+		err = -ETIMEDOUT;
 		goto done;
 	}
 
-	sval = mt76_rr(dev, MT_BBP(CORE, 35)) & 0xff;
-	if (!(sval & 0x80))
-		sval &= 0x7f; /* Positive */
+	val = mt76_rr(dev, MT_BBP(CORE, 35)) & 0xff;
+	if (!(val & BIT(7)))
+		val &= 0x7f; /* Positive */
 	else
-		sval |= 0xffffff00; /* Negative */
+		val |= 0xffffff00; /* Negative */
 
-	temp = (35 * (sval - dev->cal.rx.temp_offset)) / 10 + 25;
+	*temp = (35 * (val - dev->cal.rx.temp_offset)) / 10 + 25;
 
 done:
 	rf_wr(dev, MT_RF(7, 73), rf_b7_73);
 	rf_wr(dev, MT_RF(0, 66), rf_b0_66);
-	rf_wr(dev, MT_RF(0, 73), rf_b0_67);
+	rf_wr(dev, MT_RF(0, 67), rf_b0_67);
+
+	return err;
 }
 
 static void mt76x0_dynamic_vga_tuning(struct mt76x02_dev *dev)
@@ -832,7 +825,11 @@ static void mt76x0_phy_calibrate(struct work_struct *work)
 					       cal_work.work);
 
 	mt76x0_dynamic_vga_tuning(dev);
-	mt76x0_temp_sensor(dev);
+	if (!mt76x0_tssi_enabled(dev)) {
+		int temp;
+
+		mt76x0_temp_sensor(dev, &temp);
+	}
 
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
-- 
2.17.1

