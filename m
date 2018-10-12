Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C352AC6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BAFD2087D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BAFD2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbeJLRs0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:48:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37176 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbeJLRsZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:48:25 -0400
Received: by mail-wr1-f65.google.com with SMTP id y11-v6so12804872wrd.4
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:16:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b5WwaW4si7bw34Y7AH9984pXepEksr2eQHK2C8Ct4Hs=;
        b=QTTnBIbi6A5NU/EVpd1C+bzFnS2jP68T718G738GAPgXxS9fMuxhbkHKF4wm2ZkEzt
         6uwZ6B1Ap2cExaQQTdjhrG8k+RGYcx4ngPgDNgV01vdaG6KFAIuE7KFjnXqY7KzJ4z8i
         Ea1DHrdhSr2eLeyA0yUO3RKkoqI7DlEI2XGw32WeQdbVKE4FG/nonWmJKnKyWd2AGw4i
         WJs5nXp3Q5a8zXoNaci5CA8OaHEczFADNBQQuOebVT6o2Fvj8LZEMH6fYohHz1JDaDSJ
         rFpSl8UMmMjWIDPrC4BJ5z1aluMt/UKeIaWCHD2/7ig+sxYN6HdWhaGpPEE4gt/9XkSx
         vhgA==
X-Gm-Message-State: ABuFfohrMK9/zj7hhPba1od5tOj5wReL13hcxus6tUEJNkE1x1FbMRoS
        GXirHMAImsvXa2tKtacXg8er31Ix9BA=
X-Google-Smtp-Source: ACcGV62j07/5v/sy3mFxfzY3tAFIG3GnQ/xT/3bLR62ni/pJdLKW1kevZG2JJvhKh8P6loC+gUPe6A==
X-Received: by 2002:adf:e784:: with SMTP id n4-v6mr5085933wrm.187.1539339402817;
        Fri, 12 Oct 2018 03:16:42 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r2-v6sm473179wrq.1.2018.10.12.03.16.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:16:42 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 01/13] mt76: move mt76x02_phy_set_bw in mt76x02-lib module
Date:   Fri, 12 Oct 2018 12:16:17 +0200
Message-Id: <ec79c2a7f1738715b4836867dd02c08fc1f98be9.1539338611.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_phy_set_bw routine in mt76x02_phy.c since
it is shared between mt76x0 and mt76x2 drivers and remove
duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 29 +------------------
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  | 26 +++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |  1 +
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 26 -----------------
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  2 +-
 7 files changed, 30 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 7c30ba47c7f4..3bc6d7b0914a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -214,33 +214,6 @@ int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev)
 	return 0;
 }
 
-static void
-mt76x0_bbp_set_ctrlch(struct mt76x02_dev *dev, enum nl80211_chan_width width,
-		      u8 ctrl)
-{
-	int core_val, agc_val;
-
-	switch (width) {
-	case NL80211_CHAN_WIDTH_80:
-		core_val = 3;
-		agc_val = 7;
-		break;
-	case NL80211_CHAN_WIDTH_40:
-		core_val = 2;
-		agc_val = 3;
-		break;
-	default:
-		core_val = 0;
-		agc_val = 1;
-		break;
-	}
-
-	mt76_rmw_field(dev, MT_BBP(CORE, 1), MT_BBP_CORE_R1_BW, core_val);
-	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_BW, agc_val);
-	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_CTRL_CHAN, ctrl);
-	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
-}
-
 static void mt76x0_vco_cal(struct mt76x02_dev *dev, u8 channel)
 {
 	u8 val;
@@ -681,7 +654,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	}
 
 	mt76x0_bbp_set_bw(dev, chandef->width);
-	mt76x0_bbp_set_ctrlch(dev, chandef->width, ch_group_index);
+	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 	mt76x0_mac_set_ctrlch(dev, ch_group_index & 1);
 	mt76x0_ant_select(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
index c398471b6376..3de7170db111 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -178,3 +178,29 @@ int mt76x02_phy_get_min_avg_rssi(struct mt76x02_dev *dev)
 	return min_rssi;
 }
 EXPORT_SYMBOL_GPL(mt76x02_phy_get_min_avg_rssi);
+
+void mt76x02_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl)
+{
+	int core_val, agc_val;
+
+	switch (width) {
+	case NL80211_CHAN_WIDTH_80:
+		core_val = 3;
+		agc_val = 7;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		core_val = 2;
+		agc_val = 3;
+		break;
+	default:
+		core_val = 0;
+		agc_val = 1;
+		break;
+	}
+
+	mt76_rmw_field(dev, MT_BBP(CORE, 1), MT_BBP_CORE_R1_BW, core_val);
+	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_BW, agc_val);
+	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_CTRL_CHAN, ctrl);
+	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
+}
+EXPORT_SYMBOL_GPL(mt76x02_phy_set_bw);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
index c370b4cc68ee..e0ca44ed5081 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
@@ -26,5 +26,6 @@ int mt76x02_get_max_rate_power(struct mt76_rate_power *r);
 void mt76x02_phy_set_rxpath(struct mt76x02_dev *dev);
 void mt76x02_phy_set_txdac(struct mt76x02_dev *dev);
 int mt76x02_phy_get_min_avg_rssi(struct mt76x02_dev *dev);
+void mt76x02_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl);
 
 #endif /* __MT76x02_PHY_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index cbec8c6f1b2d..8b18acafedb2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -100,7 +100,6 @@ void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 				 enum nl80211_band band);
 void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
 			       enum nl80211_band band, u8 bw);
-void mt76x2_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl);
 void mt76x2_phy_set_band(struct mt76x02_dev *dev, int band, bool primary_upper);
 void mt76x2_apply_gain_adj(struct mt76x02_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index dbb63d4c3bad..991db4f48d94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -338,7 +338,7 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x2_phy_set_txpower(dev);
 
 	mt76x2_phy_set_band(dev, chan->band, ch_group_index & 1);
-	mt76x2_phy_set_bw(dev, chandef->width, ch_group_index);
+	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
 		 (MT_EXT_CCA_CFG_CCA0 |
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index fd077e8d8dcb..dcb3381cab91 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -210,32 +210,6 @@ void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_configure_tx_delay);
 
-void mt76x2_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl)
-{
-	int core_val, agc_val;
-
-	switch (width) {
-	case NL80211_CHAN_WIDTH_80:
-		core_val = 3;
-		agc_val = 7;
-		break;
-	case NL80211_CHAN_WIDTH_40:
-		core_val = 2;
-		agc_val = 3;
-		break;
-	default:
-		core_val = 0;
-		agc_val = 1;
-		break;
-	}
-
-	mt76_rmw_field(dev, MT_BBP(CORE, 1), MT_BBP_CORE_R1_BW, core_val);
-	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_BW, agc_val);
-	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_CTRL_CHAN, ctrl);
-	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
-}
-EXPORT_SYMBOL_GPL(mt76x2_phy_set_bw);
-
 void mt76x2_phy_set_band(struct mt76x02_dev *dev, int band, bool primary_upper)
 {
 	switch (band) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index 422114de695a..ff2fd71a0c14 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -156,7 +156,7 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x2_phy_set_txpower(dev);
 
 	mt76x2_phy_set_band(dev, chan->band, ch_group_index & 1);
-	mt76x2_phy_set_bw(dev, chandef->width, ch_group_index);
+	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
 		 (MT_EXT_CCA_CFG_CCA0 |
-- 
2.17.2

