Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7E8C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E6E421547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E6E421547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbeI1SDB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:03:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37108 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbeI1SDB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:03:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id u12-v6so6026769wrr.4
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=frAG/imtrV/s914oVOQR4Qj2UcyBcD/pCoemg9vl3NI=;
        b=HqkICtK59gzv2EIp/9G7iKachpl7QwzmqyrD0UPZe8nHNzBNxQqdseWZZ1PHN8H1fg
         guzle/ZrhYkBIVnrynrPnU5NYV91w6vhnT8QvtA/mJd5RrkfyeBMfgbNzr1d9or+f7jV
         l0TWg8DW2T8u/IfHs02Du4UMadg91yWeSomAv3kI3/S7qCfHNp41K2j9uuH+5XqrPoBN
         BQjHOIMNaJl0rGBkt1JmpRXl/PrdSJeq9oR/hvr8LNzkforEePB8i+xXkvU9hvNT8ysV
         6yGVgHlj0FHccrN7KN9JslvHlhn23VWW4nsvF9JTKjTW95YB7AXLyczCGBked2Kq1KCt
         URng==
X-Gm-Message-State: ABuFfogI2BJFKc42PukpzNGjiv5ohvTfxEeF51cjzv6RC9RPwFS4KNfT
        rMHkXoAYXcHGMi80NKaZuCIV/ekbuSk=
X-Google-Smtp-Source: ACcGV60Lhhe3L2/1U+jTvUFUEmJuq8rv6EN9MLlPhPz3r+XcZ9RUoIJkOc9EFdr4AhsLdDuTeqwCTw==
X-Received: by 2002:adf:fe48:: with SMTP id m8-v6mr12352511wrs.171.1538134776371;
        Fri, 28 Sep 2018 04:39:36 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:35 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 20/24] mt76: move set_{tx,rx}_path routines in mt76x02-lib module
Date:   Fri, 28 Sep 2018 13:39:03 +0200
Message-Id: <9a649b69b45b241b7663155741ae6490b08f4f9a.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_phy_set_rxpath and mt76x02_phy_tx_dac routines in
mt76x02_phy.c since they are shared between mt76x2 and mt76x0 drivers.
Moreover move chainmask variable from mt76x2/mt76x0 to mt76_dev data
structure

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  2 +-
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  1 -
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 31 +--------------
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  | 38 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |  2 -
 .../mediatek/mt76/mt76x2_init_common.c        |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_main.c  |  2 +-
 .../mediatek/mt76/mt76x2_mcu_common.c         |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u.h  |  2 -
 .../net/wireless/mediatek/mt76/mt76x2u_init.c |  5 ++-
 .../net/wireless/mediatek/mt76/mt76x2u_phy.c  | 33 ----------------
 13 files changed, 50 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 9b800f009e6e..f2dd4d87e355 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -404,6 +404,7 @@ struct mt76_dev {
 	unsigned long state;
 
 	u8 antenna_mask;
+	u16 chainmask;
 
 	struct mt76_sband sband_2g;
 	struct mt76_sband sband_5g;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 3d712f6d7078..ef9c3df6a169 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -313,7 +313,7 @@ int mt76x0_eeprom_init(struct mt76x0_dev *dev)
 	mt76x0_set_freq_offset(dev);
 	mt76x0_set_temp_offset(dev);
 
-	dev->chainmask = 0x0101;
+	dev->mt76.chainmask = 0x0101;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index e2e23df1b40a..08e081e32852 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -104,7 +104,6 @@ struct mt76x0_dev {
 	int avg_rssi; /* starts at 0 and converges */
 
 	u8 agc_save;
-	u16 chainmask;
 
 	bool no_2ghz;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index fe754fe039cc..4fd2c65e196a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -855,32 +855,6 @@ void mt76x0_phy_con_cal_onoff(struct mt76x0_dev *dev,
 	spin_unlock_bh(&dev->con_mon_lock);
 }
 
-static void
-mt76x0_set_rx_chains(struct mt76x0_dev *dev)
-{
-	u32 val;
-
-	val = mt76_rr(dev, MT_BBP(AGC, 0));
-	val &= ~(BIT(3) | BIT(4));
-
-	if (dev->chainmask & BIT(1))
-		val |= BIT(3);
-
-	mt76_wr(dev, MT_BBP(AGC, 0), val);
-
-	mb();
-	val = mt76_rr(dev, MT_BBP(AGC, 0));
-}
-
-static void
-mt76x0_set_tx_dac(struct mt76x0_dev *dev)
-{
-	if (dev->chainmask & BIT(1))
-		mt76_set(dev, MT_BBP(TXBE, 5), 3);
-	else
-		mt76_clear(dev, MT_BBP(TXBE, 5), 3);
-}
-
 static void
 mt76x0_rf_init(struct mt76x0_dev *dev)
 {
@@ -940,7 +914,6 @@ void mt76x0_phy_init(struct mt76x0_dev *dev)
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibrate);
 
 	mt76x0_rf_init(dev);
-
-	mt76x0_set_rx_chains(dev);
-	mt76x0_set_tx_dac(dev);
+	mt76x02_phy_set_rxpath(&dev->mt76);
+	mt76x02_phy_set_txdac(&dev->mt76);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
index 969854b69981..e29914d78b72 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -20,6 +20,44 @@
 #include "mt76.h"
 #include "mt76x02_phy.h"
 
+void mt76x02_phy_set_rxpath(struct mt76_dev *dev)
+{
+	u32 val;
+
+	val = __mt76_rr(dev, MT_BBP(AGC, 0));
+	val &= ~BIT(4);
+
+	switch (dev->chainmask & 0xf) {
+	case 2:
+		val |= BIT(3);
+		break;
+	default:
+		val &= ~BIT(3);
+		break;
+	}
+
+	__mt76_wr(dev, MT_BBP(AGC, 0), val);
+	mb();
+	val = __mt76_rr(dev, MT_BBP(AGC, 0));
+}
+EXPORT_SYMBOL_GPL(mt76x02_phy_set_rxpath);
+
+void mt76x02_phy_set_txdac(struct mt76_dev *dev)
+{
+	int txpath;
+
+	txpath = (dev->chainmask >> 8) & 0xf;
+	switch (txpath) {
+	case 2:
+		__mt76_set(dev, MT_BBP(TXBE, 5), 0x3);
+		break;
+	default:
+		__mt76_clear(dev, MT_BBP(TXBE, 5), 0x3);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(mt76x02_phy_set_txdac);
+
 static u32
 mt76x02_tx_power_mask(u8 v1, u8 v2, u8 v3, u8 v4)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
index 25567f9f5070..df69f8fade75 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
@@ -23,5 +23,7 @@ void mt76x02_add_rate_power_offset(struct mt76_rate_power *r, int offset);
 void mt76x02_phy_set_txpower(struct mt76_dev *dev, int txp_0, int txp_2);
 void mt76x02_limit_rate_power(struct mt76_rate_power *r, int limit);
 int mt76x02_get_max_rate_power(struct mt76_rate_power *r);
+void mt76x02_phy_set_rxpath(struct mt76_dev *dev);
+void mt76x02_phy_set_txdac(struct mt76_dev *dev);
 
 #endif /* __MT76x02_PHY_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 9bf8be5ea1cd..d6ccab06a594 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -97,8 +97,6 @@ struct mt76x2_dev {
 	u8 tbtt_count;
 	u16 beacon_int;
 
-	u16 chainmask;
-
 	struct mt76x2_calibration cal;
 
 	s8 target_power;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
index 4eacc681de49..f4c4cde9301e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
@@ -177,7 +177,7 @@ void mt76x2_init_device(struct mt76x2_dev *dev)
 	dev->mt76.sband_2g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
 	dev->mt76.sband_5g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
 
-	dev->chainmask = 0x202;
+	dev->mt76.chainmask = 0x202;
 	dev->mt76.global_wcid.idx = 255;
 	dev->mt76.global_wcid.hw_key_idx = -1;
 	dev->slottime = 9;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 24b13eeba8af..63691b68a436 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -241,7 +241,7 @@ static int mt76x2_set_antenna(struct ieee80211_hw *hw, u32 tx_ant,
 
 	mutex_lock(&dev->mt76.mutex);
 
-	dev->chainmask = (tx_ant == 3) ? 0x202 : 0x101;
+	dev->mt76.chainmask = (tx_ant == 3) ? 0x202 : 0x101;
 	dev->mt76.antenna_mask = tx_ant;
 
 	mt76_set_stream_caps(&dev->mt76, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c
index a3669c00ddd5..eff483333183 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c
@@ -42,7 +42,7 @@ int mt76x2_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
 		.idx = channel,
 		.scan = scan,
 		.bw = bw,
-		.chainmask = cpu_to_le16(dev->chainmask),
+		.chainmask = cpu_to_le16(dev->mt76.chainmask),
 	};
 
 	/* first set the channel without the extension channel info */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
index 74fde9f107e1..5d2ebdf42c63 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
@@ -45,8 +45,6 @@ int mt76x2u_phy_set_channel(struct mt76x2_dev *dev,
 			    struct cfg80211_chan_def *chandef);
 void mt76x2u_phy_calibrate(struct work_struct *work);
 void mt76x2u_phy_channel_calibrate(struct mt76x2_dev *dev);
-void mt76x2u_phy_set_txdac(struct mt76x2_dev *dev);
-void mt76x2u_phy_set_rxpath(struct mt76x2_dev *dev);
 
 void mt76x2u_mcu_complete_urb(struct urb *urb);
 int mt76x2u_mcu_set_dynamic_vga(struct mt76x2_dev *dev, u8 channel, bool ap,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index 788c36aa0f7d..5759a72d7ef6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -18,6 +18,7 @@
 
 #include "mt76x2u.h"
 #include "mt76x02_util.h"
+#include "mt76x02_phy.h"
 #include "mt76x2_eeprom.h"
 
 static void mt76x2u_init_dma(struct mt76x2_dev *dev)
@@ -236,8 +237,8 @@ int mt76x2u_init_hardware(struct mt76x2_dev *dev)
 	if (err < 0)
 		return err;
 
-	mt76x2u_phy_set_rxpath(dev);
-	mt76x2u_phy_set_txdac(dev);
+	mt76x02_phy_set_rxpath(&dev->mt76);
+	mt76x02_phy_set_txdac(&dev->mt76);
 
 	return mt76x2u_mac_stop(dev);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
index b3ec56d35e7f..06362d3487be 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
@@ -17,39 +17,6 @@
 #include "mt76x2u.h"
 #include "mt76x2_eeprom.h"
 
-void mt76x2u_phy_set_rxpath(struct mt76x2_dev *dev)
-{
-	u32 val;
-
-	val = mt76_rr(dev, MT_BBP(AGC, 0));
-	val &= ~BIT(4);
-
-	switch (dev->chainmask & 0xf) {
-	case 2:
-		val |= BIT(3);
-		break;
-	default:
-		val &= ~BIT(3);
-		break;
-	}
-	mt76_wr(dev, MT_BBP(AGC, 0), val);
-}
-
-void mt76x2u_phy_set_txdac(struct mt76x2_dev *dev)
-{
-	int txpath;
-
-	txpath = (dev->chainmask >> 8) & 0xf;
-	switch (txpath) {
-	case 2:
-		mt76_set(dev, MT_BBP(TXBE, 5), 0x3);
-		break;
-	default:
-		mt76_clear(dev, MT_BBP(TXBE, 5), 0x3);
-		break;
-	}
-}
-
 void mt76x2u_phy_channel_calibrate(struct mt76x2_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
-- 
2.17.1

