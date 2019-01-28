Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E6DC282CB
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD5F120880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfA1Jbm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:31:42 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44680 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfA1Jbm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 04:31:42 -0500
Received: by mail-wr1-f65.google.com with SMTP id z5so17146533wrt.11
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 01:31:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wOXaRFmBUUI8cu55oXiuftYoelWJKYGuSmkGwXAnod0=;
        b=sEoDLyhWiY4oO5hjeuUA9F+bWWqitI0viZMpB6MbAqxEyG/WgpsXCBP4uxuKbXX2aX
         QwJ6OU8PZQs+CaesNdGh0SWEFXJCwAWWa4ZNKPhf5/5R4US1Bhat9f0o1DZoUIlYmYFx
         bdHX50qOoCbr+8fxmbDoIg/XysUsvcbvuKIWGufGV0r6k5DlEjyUo4n4no8+8GrtXZLP
         Co1YF7H2AdQYO1VTBkNPpRDP6SJMt2GHSrhA05uwpvalveToISmhol+TDpsVC3BQD+ET
         LIZBne63MbPWd1SJswDhlm1r70ik2WwLxVJLSDj0o5OxHaQWG1Uq1ZHIHOLKriD4IiOA
         JiBA==
X-Gm-Message-State: AJcUukf67GFHONm8zmwQz5cYJkIVq99+PQ9sPEfZf6vbnxvvIEIuJ7cO
        Neledv2SNt5cEqsyEVw1hALXOQ==
X-Google-Smtp-Source: ALg8bN66Fow9bCFulzllTl+t5ge1+uxQz1FpPDg2GbsfG49HpoubE9vdrRSsjVXTXQTg2i2sKbXwcA==
X-Received: by 2002:a5d:65ce:: with SMTP id e14mr19976981wrw.150.1548667900158;
        Mon, 28 Jan 2019 01:31:40 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id h16sm231765642wrb.62.2019.01.28.01.31.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 28 Jan 2019 01:31:39 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 2/2] mt76x0: init: introduce mt76x0_init_txpower routine
Date:   Mon, 28 Jan 2019 10:31:13 +0100
Message-Id: <bba7187b1bcf4df8e07be20f7b1dc3edf77451fb.1548667362.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548667362.git.lorenzo.bianconi@redhat.com>
References: <cover.1548667362.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x0_init_txpower in order to initialize max_power per channel
at device bootstrap. Modify mt76x0_get_tx_power_per_rate and
mt76x0_get_power_info signature in order to compute tx power for
non-operating channels

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 10 +++----
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  7 +++--
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 29 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  4 +--
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index b2cabce1d74d..952d20b8353a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -152,11 +152,11 @@ static s8 mt76x0_get_delta(struct mt76x02_dev *dev)
 	return mt76x02_rate_power_val(val);
 }
 
-void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev)
+void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev,
+				  struct ieee80211_channel *chan,
+				  struct mt76_rate_power *t)
 {
-	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	bool is_2ghz = chan->band == NL80211_BAND_2GHZ;
-	struct mt76_rate_power *t = &dev->mt76.rate_power;
 	u16 val, addr;
 	s8 delta;
 
@@ -212,7 +212,8 @@ void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev)
 	mt76x02_add_rate_power_offset(t, delta);
 }
 
-void mt76x0_get_power_info(struct mt76x02_dev *dev, s8 *tp)
+void mt76x0_get_power_info(struct mt76x02_dev *dev,
+			   struct ieee80211_channel *chan, s8 *tp)
 {
 	struct mt76x0_chan_map {
 		u8 chan;
@@ -226,7 +227,6 @@ void mt76x0_get_power_info(struct mt76x02_dev *dev, s8 *tp)
 		{ 140, 26 }, { 151, 28 }, { 157, 30 }, { 161, 32 },
 		{ 167, 34 }, { 171, 36 }, { 175, 38 },
 	};
-	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	u8 offset, addr;
 	int i, idx = 0;
 	u16 data;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index 42b259f90b6d..7f73034a23b1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -25,8 +25,11 @@ struct mt76x02_dev;
 
 int mt76x0_eeprom_init(struct mt76x02_dev *dev);
 void mt76x0_read_rx_gain(struct mt76x02_dev *dev);
-void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev);
-void mt76x0_get_power_info(struct mt76x02_dev *dev, s8 *tp);
+void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev,
+				  struct ieee80211_channel *chan,
+				  struct mt76_rate_power *t);
+void mt76x0_get_power_info(struct mt76x02_dev *dev,
+			   struct ieee80211_channel *chan, s8 *tp);
 
 static inline s8 s6_to_s8(u32 val)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 87b575fe1c74..9ef61f197303 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -18,6 +18,7 @@
 #include "eeprom.h"
 #include "mcu.h"
 #include "initvals.h"
+#include "../mt76x02_phy.h"
 
 static void mt76x0_vht_cap_mask(struct ieee80211_supported_band *sband)
 {
@@ -284,6 +285,25 @@ mt76x0_alloc_device(struct device *pdev,
 }
 EXPORT_SYMBOL_GPL(mt76x0_alloc_device);
 
+static void
+mt76x0_init_txpower(struct mt76x02_dev *dev,
+		    struct ieee80211_supported_band *sband)
+{
+	struct ieee80211_channel *chan;
+	struct mt76_rate_power t;
+	s8 tp;
+	int i;
+
+	for (i = 0; i < sband->n_channels; i++) {
+		chan = &sband->channels[i];
+
+		mt76x0_get_tx_power_per_rate(dev, chan, &t);
+		mt76x0_get_power_info(dev, chan, &tp);
+
+		chan->max_power = (mt76x02_get_max_rate_power(&t) + tp) / 2;
+	}
+}
+
 int mt76x0_register_device(struct mt76x02_dev *dev)
 {
 	int ret;
@@ -296,9 +316,14 @@ int mt76x0_register_device(struct mt76x02_dev *dev)
 	if (ret)
 		return ret;
 
-	/* overwrite unsupported features */
-	if (dev->mt76.cap.has_5ghz)
+	if (dev->mt76.cap.has_5ghz) {
+		/* overwrite unsupported features */
 		mt76x0_vht_cap_mask(&dev->mt76.sband_5g.sband);
+		mt76x0_init_txpower(dev, &dev->mt76.sband_5g.sband);
+	}
+
+	if (dev->mt76.cap.has_2ghz)
+		mt76x0_init_txpower(dev, &dev->mt76.sband_2g.sband);
 
 	mt76x02_init_debugfs(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 3fe2e1e28404..e08411497a99 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -847,8 +847,8 @@ void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
 	struct mt76_rate_power *t = &dev->mt76.rate_power;
 	s8 info;
 
-	mt76x0_get_tx_power_per_rate(dev);
-	mt76x0_get_power_info(dev, &info);
+	mt76x0_get_tx_power_per_rate(dev, dev->mt76.chandef.chan, t);
+	mt76x0_get_power_info(dev, dev->mt76.chandef.chan, &info);
 
 	mt76x02_add_rate_power_offset(t, info);
 	mt76x02_limit_rate_power(t, dev->mt76.txpower_conf);
-- 
2.20.1

