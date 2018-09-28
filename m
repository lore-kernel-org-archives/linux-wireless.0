Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B06C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F8332172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F8332172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbeI1NDC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:03:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38435 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbeI1NDC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:03:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id z16-v6so1002064wmi.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=75FKtXrNhmZvl4WlQ3D2RcsuqczGby9OztvwXNKdlyo=;
        b=TNSReUnxi0aS4V+Zk5ePKZSx0t99sYMBi9KIwb9183OY46UNTXBwrrVfmO2HCFDHJb
         cg9CUcHLBWw5wREkoan6QQI/dViYQ2qRLOMpFSSOmt7VJNkr50mb7hcMLREoRtlqv7ZA
         rC9lNEvRJ7GwWH/hVWib1bU4IjBsVB1vuuT3KSV08ZW2Yxw8HNLbMnzeaWIP17oCV1d9
         KEP9K5XE/vzF8ghT7poBxa9xxHV+JSy4Hv6g5ac6YgPKExVYDylGRyHHkDDVR93kcofS
         N+lxAID6he1+54lrPD7exmzgpHTRvb8HfmInxlL7au61ovWiqoGD+/KmsZG90+9/XRql
         rtNQ==
X-Gm-Message-State: ABuFfoj+FhCpldx3EzfADZTSYQBkxvn27kdIAQNXxrMYAj4edEPy1J8R
        1Al4NWdBGhBUa+WO+iD0kaQ2K3LVJoY=
X-Google-Smtp-Source: ACcGV60/ggLwAMdAUAXM7/PM8pLEmHtK8xLvO2T0ItRBL67j5bahr8v0BsDXRPEA7QNkAKL6PWl4Ng==
X-Received: by 2002:a1c:3581:: with SMTP id c123-v6mr651374wma.50.1538116847419;
        Thu, 27 Sep 2018 23:40:47 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:46 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 19/24] mt76x0: phy: set antenna parameter according to wireless band
Date:   Fri, 28 Sep 2018 08:40:12 +0200
Message-Id: <20180928064017.26870-20-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x0_ant_select routine in __mt76x0_phy_set_channel in order to
configure antenna parameters according to the current wireless channel

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 31 ++++++++++++-------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index d11fcf6c8967..fe754fe039cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -548,6 +548,25 @@ mt76x0_phy_set_chan_bbp_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_ban
 	}
 }
 
+static void mt76x0_ant_select(struct mt76x0_dev *dev)
+{
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+
+	/* single antenna mode */
+	if (chan->band == NL80211_BAND_2GHZ) {
+		mt76_rmw(dev, MT_COEXCFG3,
+			 BIT(5) | BIT(4) | BIT(3) | BIT(2), BIT(1));
+		mt76_rmw(dev, MT_WLAN_FUN_CTRL, BIT(5), BIT(6));
+	} else {
+		mt76_rmw(dev, MT_COEXCFG3, BIT(5) | BIT(2),
+			 BIT(4) | BIT(3));
+		mt76_clear(dev, MT_WLAN_FUN_CTRL,
+			   BIT(6) | BIT(5));
+	}
+	mt76_clear(dev, MT_CMB_CTRL, BIT(14) | BIT(12));
+	mt76_clear(dev, MT_COEXCFG0, BIT(2));
+}
+
 static void
 mt76x0_bbp_set_bw(struct mt76x0_dev *dev, enum nl80211_chan_width width)
 {
@@ -658,6 +677,7 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 	mt76x0_bbp_set_bw(dev, chandef->width);
 	mt76x0_bbp_set_ctrlch(dev, chandef->width, ch_group_index);
 	mt76x0_mac_set_ctrlch(dev, ch_group_index & 1);
+	mt76x0_ant_select(dev);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
 		 (MT_EXT_CCA_CFG_CCA0 |
@@ -915,21 +935,10 @@ mt76x0_rf_init(struct mt76x0_dev *dev)
 	rf_set(dev, MT_RF(0, 4), 0x80);
 }
 
-static void mt76x0_ant_select(struct mt76x0_dev *dev)
-{
-	/* Single antenna mode. */
-	mt76_rmw(dev, MT_WLAN_FUN_CTRL, BIT(5), BIT(6));
-	mt76_clear(dev, MT_CMB_CTRL, BIT(14) | BIT(12));
-	mt76_clear(dev, MT_COEXCFG0, BIT(2));
-	mt76_rmw(dev, MT_COEXCFG3, BIT(5) | BIT(4) | BIT(3) | BIT(2), BIT(1));
-}
-
 void mt76x0_phy_init(struct mt76x0_dev *dev)
 {
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibrate);
 
-	mt76x0_ant_select(dev);
-
 	mt76x0_rf_init(dev);
 
 	mt76x0_set_rx_chains(dev);
-- 
2.19.0

