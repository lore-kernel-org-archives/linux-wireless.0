Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0D3C6786C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08F3520868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08F3520868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbeJLRs1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:48:27 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45706 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbeJLRs0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:48:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id q5-v6so12816409wrw.12
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:16:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pTc7z/Wu0FMDOE0vA7b+wH80oda7TWl6z1kOzZ2czZc=;
        b=sNxhRBK0PVY3gfilgPyLn+N73lkcnC6caePhOT38gCI96yNo9eXgueSNhO7MP++sg5
         ojaSGTzY/YqZnSxNGZ9/OoNFoqmpbb1OP1aMPT3nI9L2XdahtJdtWqqn+daIDAacptRP
         CCK1VkUjIpBPGziE9BzqLiZ6szpWvmU1jYnAQbSYzcHcuvS9cOLGAUr5ReREHhXVdV+Z
         bfcflhxPojL+q3nf7AOVFd6PusbvdeMmLgaa98sL/xrBT+vwRjsdXIdjhAMgHT1JFxWg
         smzEx1W17pHeIE5hk2P7CdOo5UBYwUmoJWXZdTBw4KBUiGUCPP9WWYjXyKQITz8MCv7v
         SR5Q==
X-Gm-Message-State: ABuFfoi0UYMkDoRPxGrZgCXh+5L3UA9Bd5sjl28tt3LpqKVBKZ6d8DO7
        rclYwQN2KnwfZmmpVzLpe6mBhg==
X-Google-Smtp-Source: ACcGV61jAlS7bzrhJsQKV+XWc7gIQHVJUBvXDgmuRoO2ImVM1kVvkWNf4CSRei92gRIn4SA6wzKs+Q==
X-Received: by 2002:adf:a706:: with SMTP id c6-v6mr5082851wrd.56.1539339403830;
        Fri, 12 Oct 2018 03:16:43 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r2-v6sm473179wrq.1.2018.10.12.03.16.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:16:43 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 02/13] mt76: move mt76x02_phy_set_band in mt76x02-lib module
Date:   Fri, 12 Oct 2018 12:16:18 +0200
Message-Id: <19adde6f543ab610f9d78070c034c17aa4e1deb9.1539338611.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_phy_set_band routine in mt76x02_phy.c since
it is shared between mt76x0 and mt76x2 drivers and remove
duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 16 ++--------------
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  | 19 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |  2 ++
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 18 ------------------
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  2 +-
 7 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 3bc6d7b0914a..638a2bca5cff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -270,13 +270,6 @@ static void mt76x0_vco_cal(struct mt76x02_dev *dev, u8 channel)
 	msleep(2);
 }
 
-static void
-mt76x0_mac_set_ctrlch(struct mt76x02_dev *dev, bool primary_upper)
-{
-	mt76_rmw_field(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_UPPER_40M,
-		       primary_upper);
-}
-
 static void
 mt76x0_phy_set_band(struct mt76x02_dev *dev, enum nl80211_band band)
 {
@@ -287,9 +280,6 @@ mt76x0_phy_set_band(struct mt76x02_dev *dev, enum nl80211_band band)
 		rf_wr(dev, MT_RF(5, 0), 0x45);
 		rf_wr(dev, MT_RF(6, 0), 0x44);
 
-		mt76_set(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_2G);
-		mt76_clear(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_5G);
-
 		mt76_wr(dev, MT_TX_ALC_VGA3, 0x00050007);
 		mt76_wr(dev, MT_TX0_RF_GAIN_CORR, 0x003E0002);
 		break;
@@ -299,9 +289,6 @@ mt76x0_phy_set_band(struct mt76x02_dev *dev, enum nl80211_band band)
 		rf_wr(dev, MT_RF(5, 0), 0x44);
 		rf_wr(dev, MT_RF(6, 0), 0x45);
 
-		mt76_clear(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_2G);
-		mt76_set(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_5G);
-
 		mt76_wr(dev, MT_TX_ALC_VGA3, 0x00000005);
 		mt76_wr(dev, MT_TX0_RF_GAIN_CORR, 0x01010102);
 		break;
@@ -655,7 +642,8 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 
 	mt76x0_bbp_set_bw(dev, chandef->width);
 	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
-	mt76x0_mac_set_ctrlch(dev, ch_group_index & 1);
+	mt76x02_phy_set_band(dev, chandef->chan->band,
+			     ch_group_index & 1);
 	mt76x0_ant_select(dev);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
index 3de7170db111..b0c78ab97ad7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -204,3 +204,22 @@ void mt76x02_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl)
 	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
 }
 EXPORT_SYMBOL_GPL(mt76x02_phy_set_bw);
+
+void mt76x02_phy_set_band(struct mt76x02_dev *dev, int band,
+			  bool primary_upper)
+{
+	switch (band) {
+	case NL80211_BAND_2GHZ:
+		mt76_set(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_2G);
+		mt76_clear(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_5G);
+		break;
+	case NL80211_BAND_5GHZ:
+		mt76_clear(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_2G);
+		mt76_set(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_5G);
+		break;
+	}
+
+	mt76_rmw_field(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_UPPER_40M,
+		       primary_upper);
+}
+EXPORT_SYMBOL_GPL(mt76x02_phy_set_band);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
index e0ca44ed5081..1a20c1852dbf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
@@ -27,5 +27,7 @@ void mt76x02_phy_set_rxpath(struct mt76x02_dev *dev);
 void mt76x02_phy_set_txdac(struct mt76x02_dev *dev);
 int mt76x02_phy_get_min_avg_rssi(struct mt76x02_dev *dev);
 void mt76x02_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl);
+void mt76x02_phy_set_band(struct mt76x02_dev *dev, int band,
+			  bool primary_upper);
 
 #endif /* __MT76x02_PHY_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 8b18acafedb2..ab93125f46de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -100,7 +100,6 @@ void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 				 enum nl80211_band band);
 void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
 			       enum nl80211_band band, u8 bw);
-void mt76x2_phy_set_band(struct mt76x02_dev *dev, int band, bool primary_upper);
 void mt76x2_apply_gain_adj(struct mt76x02_dev *dev);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 991db4f48d94..5942cc7a98a3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -337,7 +337,7 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x2_configure_tx_delay(dev, band, bw);
 	mt76x2_phy_set_txpower(dev);
 
-	mt76x2_phy_set_band(dev, chan->band, ch_group_index & 1);
+	mt76x02_phy_set_band(dev, chan->band, ch_group_index & 1);
 	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index dcb3381cab91..e9fff5b7f125 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -210,24 +210,6 @@ void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_configure_tx_delay);
 
-void mt76x2_phy_set_band(struct mt76x02_dev *dev, int band, bool primary_upper)
-{
-	switch (band) {
-	case NL80211_BAND_2GHZ:
-		mt76_set(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_2G);
-		mt76_clear(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_5G);
-		break;
-	case NL80211_BAND_5GHZ:
-		mt76_clear(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_2G);
-		mt76_set(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_5G);
-		break;
-	}
-
-	mt76_rmw_field(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_UPPER_40M,
-		       primary_upper);
-}
-EXPORT_SYMBOL_GPL(mt76x2_phy_set_band);
-
 void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev, bool wait)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index ff2fd71a0c14..c0c8c0ad1912 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -155,7 +155,7 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x2_configure_tx_delay(dev, chan->band, bw);
 	mt76x2_phy_set_txpower(dev);
 
-	mt76x2_phy_set_band(dev, chan->band, ch_group_index & 1);
+	mt76x02_phy_set_band(dev, chan->band, ch_group_index & 1);
 	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
-- 
2.17.2

