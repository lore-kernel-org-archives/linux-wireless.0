Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22CF0C6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA5A620868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA5A620868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbeJLRsd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:48:33 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33955 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbeJLRsb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:48:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id z25-v6so17717153wmf.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XcphxZV7G8+kGnH7VVGVuTVDJeyCnUZyh8mK2HO6WGM=;
        b=aeBiFfEeSDn6RGkxcvuMjZy5ohkvxeWtyBh0W46pa3vSZRp8gPVvcIh8gs7TxVwVMz
         6LPoRD3bp9SdbvyLZxWpYcrH7fzwpYS3LU4SoQRTVxOttEsmb6MqDHkeg3Z6jaDg4ZOO
         eAoPJLUIGAyzKnfkj8qC4aaKE7r2yG7+7SDFWsuw9jMqoS+s53Qk0PMB6X/InqpSh9W0
         ExYIz/yY+X9cM9rBVynqOkTshcGXrbKtloEdunLmyAWVtkime9BDlFXbtPcZGOQVWFzL
         f/GDc/HQ61PJbQFjqDwpj9XHlmD92muHr2+oJ8f15JxaEoKZh4rjhQ1jTVq50h204amX
         rqng==
X-Gm-Message-State: ABuFfogBmY+tFGm/wmBg2UfWI7cmnr3m8G/pC68t+XUS850dcmsua3lU
        jvXDzs633GQOjTPltRmpwM6NUQ==
X-Google-Smtp-Source: ACcGV63f6ptUH+vxEu9JsPq+MJ1e/KoTLgXviuVg4+Md5FGeiTHj33t+oNsvP+gYPNYDeo5dKx3voQ==
X-Received: by 2002:a1c:e717:: with SMTP id e23-v6mr4740935wmh.145.1539339408725;
        Fri, 12 Oct 2018 03:16:48 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r2-v6sm473179wrq.1.2018.10.12.03.16.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:16:48 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 07/13] mt76x0: phy: add phy/vco temperature compensation
Date:   Fri, 12 Oct 2018 12:16:23 +0200
Message-Id: <7efacc28a7a4d1c157d387eba21040c34b0d1806.1539338611.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
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
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 48 +++++++++----------
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  3 +-
 2 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index fddfdb1e1756..7d29fd16342a 100644
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
@@ -782,45 +783,41 @@ void mt76x0_agc_restore(struct mt76x02_dev *dev)
 static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
 {
 	u8 rf_b7_73, rf_b0_66, rf_b0_67;
-	int cycle, temp;
-	u32 val;
-	s32 sval;
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

