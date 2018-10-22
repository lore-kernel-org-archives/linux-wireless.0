Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55E6C004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECDC620652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 21:42:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECDC620652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbeJWGCq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 02:02:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35635 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728814AbeJWGCq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 02:02:46 -0400
Received: by mail-wm1-f67.google.com with SMTP id w186-v6so574946wmf.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 14:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B7G4e5MpyGJrE8KssxnW7cHrbGFjm0zZG41+p3IuR40=;
        b=Hsln+Dk+uZ9VR6k93TdlDidk6R7xp3Gl1hxoyxQKIS0bxeLS4IHN7VJxIf7mGCs8LB
         d5k+QwokRjL5jmSwvz6zefnssAaGJkCHgi2FXoOPzo1OJ+05716pWBVjceRxwMU8d2Ns
         0KeY9YXLtszJOaGhwOJIpQCORT2gcnH02I5WUilccu8IpbhrCDsL3D4iGgFACIgAoMJC
         y7D8PBvWFPMfez+G3TySiphSRDDVMb963m0dhw9S0aHKrZzYsLnYvWARyt7wkT9y8Vvy
         ZJHm2ZYecFsmdHMOYRxb0RdWTVKEkw68VpQKZyM8sVCetIvrlyorBzX5KyNWISNP5X8l
         kajw==
X-Gm-Message-State: ABuFfojfH+AY7a2euPdR4siCLzzEyGAjqrr0t+cYZGds+W6O6+2yTPkR
        mOdqj3jjM7kwd9Hh1QjWqrADwA==
X-Google-Smtp-Source: ACcGV60WJ0sp7irDRATFffCwbQtEHpehQtRVatR98/p+++t5z6t3Lloa01zQgZ9ZAFveK8NY8zweEA==
X-Received: by 2002:a1c:e08a:: with SMTP id x132-v6mr18193249wmg.60.1540244545502;
        Mon, 22 Oct 2018 14:42:25 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id l125-v6sm21857187wmb.1.2018.10.22.14.42.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Oct 2018 14:42:24 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt76x0: pci: add DFS support
Date:   Mon, 22 Oct 2018 23:42:13 +0200
Message-Id: <09ecfcd3dd14251b8dd72a72a51cab123925cb5e.1540243910.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540243910.git.lorenzo.bianconi@redhat.com>
References: <cover.1540243910.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce dfs support in mt76x0e driver and unlock radar channels

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/main.c  | 11 +++++--
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  4 +++
 .../net/wireless/mediatek/mt76/mt76x02_dfs.c  | 31 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt76x02_dfs.h  |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  5 +++
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  7 -----
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 23 +-------------
 7 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index cd1a1225ad8b..a803a9b6a4c5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -22,7 +22,10 @@ mt76x0_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
 	int ret;
 
 	cancel_delayed_work_sync(&dev->cal_work);
-	tasklet_disable(&dev->pre_tbtt_tasklet);
+	if (mt76_is_mmio(dev)) {
+		tasklet_disable(&dev->pre_tbtt_tasklet);
+		tasklet_disable(&dev->dfs_pd.dfs_tasklet);
+	}
 
 	mt76_set_channel(&dev->mt76);
 	ret = mt76x0_phy_set_channel(dev, chandef);
@@ -31,7 +34,11 @@ mt76x0_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
 	mt76_rr(dev, MT_CH_IDLE);
 	mt76_rr(dev, MT_CH_BUSY);
 
-	tasklet_enable(&dev->pre_tbtt_tasklet);
+	if (mt76_is_mmio(dev)) {
+		mt76x02_dfs_init_params(dev);
+		tasklet_enable(&dev->pre_tbtt_tasklet);
+		tasklet_enable(&dev->dfs_pd.dfs_tasklet);
+	}
 	mt76_txq_schedule_all(&dev->mt76);
 
 	return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index b33074b783dc..c734987a344c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -719,6 +719,10 @@ static void mt76x0_phy_set_gain_val(struct mt76x02_dev *dev)
 
 	mt76_wr(dev, MT_BBP(AGC, 8),
 		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain));
+
+	if ((dev->mt76.chandef.chan->flags & IEEE80211_CHAN_RADAR) &&
+	    !is_mt7630(dev))
+		mt76x02_phy_dfs_adjust_agc(dev);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
index 21e7b8c9f824..527e530d480a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
@@ -802,6 +802,35 @@ static void mt76x02_dfs_set_bbp_params(struct mt76x02_dev *dev)
 	mt76_wr(dev, 0x212c, 0x0c350001);
 }
 
+void mt76x02_phy_dfs_adjust_agc(struct mt76x02_dev *dev)
+{
+	u32 agc_r8, agc_r4, val_r8, val_r4, dfs_r31;
+
+	agc_r8 = mt76_rr(dev, MT_BBP(AGC, 8));
+	agc_r4 = mt76_rr(dev, MT_BBP(AGC, 4));
+
+	val_r8 = (agc_r8 & 0x00007e00) >> 9;
+	val_r4 = agc_r4 & ~0x1f000000;
+	val_r4 += (((val_r8 + 1) >> 1) << 24);
+	mt76_wr(dev, MT_BBP(AGC, 4), val_r4);
+
+	dfs_r31 = FIELD_GET(MT_BBP_AGC_LNA_HIGH_GAIN, val_r4);
+	dfs_r31 += val_r8;
+	dfs_r31 -= (agc_r8 & 0x00000038) >> 3;
+	dfs_r31 = (dfs_r31 << 16) | 0x00000307;
+	mt76_wr(dev, MT_BBP(DFS, 31), dfs_r31);
+
+	if (is_mt76x2(dev)) {
+		mt76_wr(dev, MT_BBP(DFS, 32), 0x00040071);
+	} else {
+		/* disable hw detector */
+		mt76_wr(dev, MT_BBP(DFS, 0), 0);
+		/* enable hw detector */
+		mt76_wr(dev, MT_BBP(DFS, 0), MT_DFS_CH_EN << 16);
+	}
+}
+EXPORT_SYMBOL_GPL(mt76x02_phy_dfs_adjust_agc);
+
 void mt76x02_dfs_init_params(struct mt76x02_dev *dev)
 {
 	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
@@ -841,7 +870,6 @@ void mt76x02_dfs_init_detector(struct mt76x02_dev *dev)
 	tasklet_init(&dfs_pd->dfs_tasklet, mt76x02_dfs_tasklet,
 		     (unsigned long)dev);
 }
-EXPORT_SYMBOL_GPL(mt76x02_dfs_init_detector);
 
 static void
 mt76x02_dfs_set_domain(struct mt76x02_dev *dev,
@@ -865,4 +893,3 @@ void mt76x02_regd_notifier(struct wiphy *wiphy,
 
 	mt76x02_dfs_set_domain(dev, request->dfs_region);
 }
-EXPORT_SYMBOL_GPL(mt76x02_regd_notifier);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h
index 59e1524ff98b..70b394e17340 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h
@@ -141,4 +141,5 @@ void mt76x02_dfs_init_params(struct mt76x02_dev *dev);
 void mt76x02_dfs_init_detector(struct mt76x02_dev *dev);
 void mt76x02_regd_notifier(struct wiphy *wiphy,
 			   struct regulatory_request *request);
+void mt76x02_phy_dfs_adjust_agc(struct mt76x02_dev *dev);
 #endif /* __MT76x02_DFS_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 4c3b8392b2b7..9f083008dbd4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -93,6 +93,9 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 					 MT_DMA_HDR_LEN;
 		wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	} else {
+		mt76x02_dfs_init_detector(dev);
+
+		wiphy->reg_notifier = mt76x02_regd_notifier;
 		wiphy->iface_combinations = mt76x02_if_comb;
 		wiphy->n_iface_combinations = ARRAY_SIZE(mt76x02_if_comb);
 		wiphy->interface_modes =
@@ -635,6 +638,8 @@ void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
 	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
 	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
 		       8 << 4);
+	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
+		       MT_DFS_GP_INTERVAL);
 	mt76_wr(dev, MT_INT_TIMER_EN, 0);
 
 	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xffff);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index b6144e03047f..f6e8af6432c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -122,9 +122,6 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(macaddr));
 	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(macaddr + 4));
 
-	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
-		       MT_DFS_GP_INTERVAL);
-
 	mt76x02_init_beacon_config(dev);
 	if (!hard)
 		return 0;
@@ -414,12 +411,8 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 	wiphy->addresses = dev->macaddr_list;
 	wiphy->n_addresses = ARRAY_SIZE(dev->macaddr_list);
 
-	wiphy->reg_notifier = mt76x02_regd_notifier;
-
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
-	mt76x02_dfs_init_detector(dev);
-
 	/* init led callbacks */
 	dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
 	dev->mt76.led_cdev.blink_set = mt76x2_led_set_blink;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index 0f9f54569147..bbeff9c19997 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -251,27 +251,6 @@ void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev, bool wait)
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_tssi_compensate);
 
-static void mt76x2_phy_dfs_adjust_agc(struct mt76x02_dev *dev)
-{
-	u32 agc_r8, agc_r4, val_r8, val_r4, dfs_r31;
-
-	agc_r8 = mt76_rr(dev, MT_BBP(AGC, 8));
-	agc_r4 = mt76_rr(dev, MT_BBP(AGC, 4));
-
-	val_r8 = (agc_r8 & 0x00007e00) >> 9;
-	val_r4 = agc_r4 & ~0x1f000000;
-	val_r4 += (((val_r8 + 1) >> 1) << 24);
-	mt76_wr(dev, MT_BBP(AGC, 4), val_r4);
-
-	dfs_r31 = FIELD_GET(MT_BBP_AGC_LNA_HIGH_GAIN, val_r4);
-	dfs_r31 += val_r8;
-	dfs_r31 -= (agc_r8 & 0x00000038) >> 3;
-	dfs_r31 = (dfs_r31 << 16) | 0x00000307;
-	mt76_wr(dev, MT_BBP(DFS, 31), dfs_r31);
-
-	mt76_wr(dev, MT_BBP(DFS, 32), 0x00040071);
-}
-
 static void
 mt76x2_phy_set_gain_val(struct mt76x02_dev *dev)
 {
@@ -294,7 +273,7 @@ mt76x2_phy_set_gain_val(struct mt76x02_dev *dev)
 		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain_val[1]));
 
 	if (dev->mt76.chandef.chan->flags & IEEE80211_CHAN_RADAR)
-		mt76x2_phy_dfs_adjust_agc(dev);
+		mt76x02_phy_dfs_adjust_agc(dev);
 }
 
 void mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
-- 
2.19.1

