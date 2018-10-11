Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A392C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3AB02087D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3AB02087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbeJKQSy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:18:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35705 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbeJKQSx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 12:18:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id e187-v6so8527449wmf.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 01:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HdygsfnZfX3xfCyJ+WybS9S7vbYIpKlgIM5mvLi0rjk=;
        b=pubp18sIAhc2rAPFqv4/UwaMkpV+pmSpr4GsirSTxKWa8DIrfKdyBarptFpg/XbCQW
         WoWDmDuTfjEUgofzwVrKWI+tp2Ffb5BWYqb/2fAMbSHZPAjgERVfszqSHin5JxiM5e4x
         uB0aekf+aGhGocgfultNhCeR8TMheA66IzUr/iBRiW1PKycnFwCZW1Q6+veHaiYYapLl
         k5TgcQMHAAZXsc3kNuhS379FXlrU1YQwmh97MgpoWO/Mi/YNRmoAwA1L2SC6v0/Z/Pfr
         74y2LH19/uICSK/bakG+MDDQaB2Tq7bpYNId3vPgSXFeHCxqJliCNmwRzO3o2c/Z2k7I
         V90A==
X-Gm-Message-State: ABuFfogwGxkcpN0zx2opoYRzfU9g3njg+KBiAHBmAij/unuw0IVKEInL
        3WLvzxAxAuHmNhxmwrFlMClV+Q==
X-Google-Smtp-Source: ACcGV61NfjzrbR6WjU5nh6s45lV26i0ZoTXVXJBS9Nu5PP0m5XP5gFwWwgk7sax6DIg4dQSqWqz6pA==
X-Received: by 2002:a1c:a696:: with SMTP id p144-v6mr892992wme.14.1539247953291;
        Thu, 11 Oct 2018 01:52:33 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v184-v6sm950839wme.3.2018.10.11.01.52.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 01:52:32 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 11/12] mt76x0: phy: align channel gain logic to mt76x2 one
Date:   Thu, 11 Oct 2018 10:52:08 +0200
Message-Id: <a1c5503b6c39de977fe04f6ad77535edc207bd72.1539247493.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
References: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Update vga tuning algorithm to the one used in mt76x2 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 56 +++++++++++++------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 5c155a3c1c77..22ef733cacd6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -719,6 +719,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 
 	mt76x0_read_rx_gain(dev);
 	mt76x0_phy_set_chan_bbp_params(dev, rf_bw_band);
+	mt76x02_init_agc_gain(dev);
 
 	if (mt76_is_usb(dev)) {
 		mt76x0_vco_cal(dev, channel);
@@ -820,23 +821,44 @@ static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
 	rf_wr(dev, MT_RF(0, 67), rf_b0_67);
 }
 
-static void mt76x0_dynamic_vga_tuning(struct mt76x02_dev *dev)
+static void mt76x0_phy_set_gain_val(struct mt76x02_dev *dev)
 {
-	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
-	u32 val, init_vga;
-	int avg_rssi;
-
-	init_vga = chandef->chan->band == NL80211_BAND_5GHZ ? 0x54 : 0x4E;
-	avg_rssi = mt76x02_phy_get_min_avg_rssi(dev);
-	if (avg_rssi > -60)
-		init_vga -= 0x20;
-	else if (avg_rssi > -70)
-		init_vga -= 0x10;
-
-	val = mt76_rr(dev, MT_BBP(AGC, 8));
-	val &= 0xFFFF80FF;
-	val |= init_vga << 8;
-	mt76_wr(dev, MT_BBP(AGC,8), val);
+	u8 gain = dev->cal.agc_gain_cur[0] - dev->cal.agc_gain_adjust;
+	u32 val = 0x122c << 16 | 0xf2;
+
+	mt76_wr(dev, MT_BBP(AGC, 8),
+		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain));
+}
+
+static void
+mt76x0_phy_update_channel_gain(struct mt76x02_dev *dev)
+{
+	bool gain_change;
+	u8 gain_delta;
+	int low_gain;
+
+	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(dev);
+
+	low_gain = (dev->cal.avg_rssi_all > mt76x02_get_rssi_gain_thresh(dev)) +
+		   (dev->cal.avg_rssi_all > mt76x02_get_low_rssi_gain_thresh(dev));
+
+	gain_change = (dev->cal.low_gain & 2) ^ (low_gain & 2);
+	dev->cal.low_gain = low_gain;
+
+	if (!gain_change) {
+		if (mt76x02_phy_adjust_vga_gain(dev))
+			mt76x0_phy_set_gain_val(dev);
+		return;
+	}
+
+	dev->cal.agc_gain_adjust = (low_gain == 2) ? 0 : 10;
+	gain_delta = (low_gain == 2) ? 10 : 0;
+
+	dev->cal.agc_gain_cur[0] = dev->cal.agc_gain_init[0] - gain_delta;
+	mt76x0_phy_set_gain_val(dev);
+
+	/* clear false CCA counters */
+	mt76_rr(dev, MT_RX_STAT_1);
 }
 
 static void mt76x0_phy_calibration_work(struct work_struct *work)
@@ -844,7 +866,7 @@ static void mt76x0_phy_calibration_work(struct work_struct *work)
 	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
 					       cal_work.work);
 
-	mt76x0_dynamic_vga_tuning(dev);
+	mt76x0_phy_update_channel_gain(dev);
 	if (!mt76x0_tssi_enabled(dev))
 		mt76x0_temp_sensor(dev);
 
-- 
2.17.2

