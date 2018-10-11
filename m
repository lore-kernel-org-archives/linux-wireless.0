Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89FBC46464
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACF2D2085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACF2D2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbeJKQSt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:18:49 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56270 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbeJKQSt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 12:18:49 -0400
Received: by mail-wm1-f67.google.com with SMTP id 206-v6so8137798wmb.5
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 01:52:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qGb1DR+QPgU5aR00GLP50ZidPTeR1dnNpAag/8KzNv4=;
        b=AdY1ks0T4BqRNqlFMOaXzbME+a0K37Ky3hy35+/E1IESf0c/CE3H1sjZKD/OAGYUK2
         e2RzrQPPbU6R4EIRe6qbqMcAPxWBxkq6QnJh09NrHyCYRYX1T1ZsbBjYHEah+tB2vThv
         y8U1Cv4EDIPz4/fOSgWqFnewiSonKAEyet4ao/MtPk32AMhzbAu/xRWTD+3DpmlisPmp
         DtvCqUhW8AjlhK5m1Z5967kmrlvm/Amjw3n1nruu7Ty66kiOZfr4CeXUQu0hBlE/2ZU3
         8e1JTjJ+e01RKipTp4DrTOYxc27gRC1XSuPgBH00NdUOdMPO29NuyWnMRcvYdYdFIwft
         cKWg==
X-Gm-Message-State: ABuFfogw6WUQ8ln6mlgNMI/AtsygXp5NfpfnGFdiLDT7Y3yPtxk46Xga
        3C2NcQ2S7w7qAjyxJD5SQfzkTg==
X-Google-Smtp-Source: ACcGV63rYCZc9I9N7cI/dQD1izwBn3dKDBbtZV7z88jN7ATohZf55/e3IK7/qXQJj1kd4rXsGBsPwg==
X-Received: by 2002:a1c:e583:: with SMTP id c125-v6mr903249wmh.134.1539247949128;
        Thu, 11 Oct 2018 01:52:29 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v184-v6sm950839wme.3.2018.10.11.01.52.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 01:52:28 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 07/12] mt76x0: phy: add phy/vco temperature compensation
Date:   Thu, 11 Oct 2018 10:52:04 +0200
Message-Id: <2dacecd91e016933bab4036b0adf325178da56bd.1539247493.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
References: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce phy/vco temperature calibration.
Moreover fix configuration of register 67 on bank0
during temperature reading and use mt76_poll utility routine
to poll core34 register.
Furthermore temperature compensation needs to be disabled
if the device supports tssi compensation.
This issue has never been hit since temperature reading is not
actually used by usb code.

Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 50 +++++++++----------
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  3 +-
 2 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 049e750457e6..5c155a3c1c77 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -14,6 +14,9 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/kernel.h>
+#include <linux/etherdevice.h>
+
 #include "mt76x0.h"
 #include "mcu.h"
 #include "eeprom.h"
@@ -23,8 +26,6 @@
 #include "initvals_phy.h"
 #include "../mt76x02_phy.h"
 
-#include <linux/etherdevice.h>
-
 static int
 mt76x0_rf_csr_wr(struct mt76x02_dev *dev, u32 offset, u8 value)
 {
@@ -781,46 +782,42 @@ void mt76x0_agc_restore(struct mt76x02_dev *dev)
 
 static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
 {
-	u8 rf_b7_73, rf_b0_66, rf_b0_67;
-	int cycle, temp;
-	u32 val;
-	s32 sval;
+	u32 rf_b7_73, rf_b0_66, rf_b0_67;
+	s8 val;
 
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
 		goto done;
 	}
 
-	sval = mt76_rr(dev, MT_BBP(CORE, 35)) & 0xff;
-	if (!(sval & 0x80))
-		sval &= 0x7f; /* Positive */
-	else
-		sval |= 0xffffff00; /* Negative */
+	val = mt76_rr(dev, MT_BBP(CORE, 35));
+	val = (35 * (val - dev->cal.rx.temp_offset)) / 10 + 25;
 
-	temp = (35 * (sval - dev->cal.rx.temp_offset)) / 10 + 25;
+	if (abs(val - dev->cal.temp_vco) > 20) {
+		mt76x02_mcu_calibrate(dev, MCU_CAL_VCO,
+				      dev->mt76.chandef.chan->hw_value,
+				      false);
+		dev->cal.temp_vco = val;
+	}
+	if (abs(val - dev->cal.temp) > 30) {
+		mt76x0_phy_calibrate(dev, false);
+		dev->cal.temp = val;
+	}
 
 done:
 	rf_wr(dev, MT_RF(7, 73), rf_b7_73);
 	rf_wr(dev, MT_RF(0, 66), rf_b0_66);
-	rf_wr(dev, MT_RF(0, 73), rf_b0_67);
+	rf_wr(dev, MT_RF(0, 67), rf_b0_67);
 }
 
 static void mt76x0_dynamic_vga_tuning(struct mt76x02_dev *dev)
@@ -848,7 +845,8 @@ static void mt76x0_phy_calibration_work(struct work_struct *work)
 					       cal_work.work);
 
 	mt76x0_dynamic_vga_tuning(dev);
-	mt76x0_temp_sensor(dev);
+	if (!mt76x0_tssi_enabled(dev))
+		mt76x0_temp_sensor(dev);
 
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index fe731529144c..f375fdcbd2bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -55,7 +55,8 @@ struct mt76x02_calibration {
 	s8 agc_gain_adjust;
 	s8 low_gain;
 
-	u8 temp;
+	s8 temp_vco;
+	s8 temp;
 
 	bool init_cal_done;
 	bool tssi_cal_done;
-- 
2.17.2

