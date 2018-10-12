Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAEAC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2968120868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2968120868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbeJLRsg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:48:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40250 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbeJLRsf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:48:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id z204-v6so12419252wmc.5
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:16:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kjKB6H9HJ/zoIMHKpRNZavO57yiHcldgs3pURnwW1y4=;
        b=pnm/KJOfezyVMbajhF+1S8OcRNzPMCbzKht2/DBP3rBGYOFnltYZmdBkoLXwJ8LXRa
         y7GdNivejIlwAZgElaGayIUDA7ew+5Upyymc4USZlCo7fMgqyrsTUZ0vHjQc89vzB4b8
         UZqzvnVtMlYVty2sLwLnFO9reCHUGg5OVpYdiNFG+IWdHxZO4K5D4tvsWEeJqt26KWuj
         NAzZsMzXoSeLO61a04VFb8GJUMmD3GgT6eNuTLJv7sK2Z/U5mUO8O8o7Kz80So2+w4Jz
         6rW4tvirGtrSozICBsm5rDpzOqh/592skO9faDciK+9/qs1b2ndNVzzwYYF3nQ37dWh3
         LHdA==
X-Gm-Message-State: ABuFfohwAAOnZh7yI0NTBtYE2LFhy+iYG3+lxCkaREIrTd+W4csCoCv8
        sea07NqoN4gMD9gvpvXvjHlApg==
X-Google-Smtp-Source: ACcGV60rUXy7cv6TUpxtpOmN2O3e4Y+FHNVmcR6PTSO9BlU+wlkDXtYk8XtxPs1tFcfvqGjPgx0O6A==
X-Received: by 2002:a1c:7e57:: with SMTP id z84-v6mr5014086wmc.43.1539339412943;
        Fri, 12 Oct 2018 03:16:52 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r2-v6sm473179wrq.1.2018.10.12.03.16.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:16:52 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 11/13] mt76x0: phy: align channel gain logic to mt76x2 one
Date:   Fri, 12 Oct 2018 12:16:27 +0200
Message-Id: <0ac5553d54bce90cf9d466f3e53efc9edc558ab4.1539338611.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
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
index 7d29fd16342a..3d0fcf8c34b4 100644
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

