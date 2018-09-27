Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A74C04E87
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA5C2156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFA5C2156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbeI0PTe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40955 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbeI0PTe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id y8-v6so1693938wrh.7
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h2mOFCvgTfcSOge/NVVUhF7/Qk1RRgKKmQtAt49NRxo=;
        b=tRgsn7Xa4whdKUi6BJ0OQL59k84tsf36yGj7x/bBluyd94QIwELXy1JoaHiiIHiJT/
         7USX6vXWB+z0xj7pO4XaqkMjVOUaO6ahM/b4UFeaOrxLYupeUZFsTQSndAV1EHjLKB6Q
         LdXhJPLjJBrOg/+Yvg1EEwDzBUKRwyxYjkO19z9Zdd7flYs+GBbnPvBx3knacrea1btn
         J/d5LJp1dSdxeLFEnG7C8iHgo3c40SrnY5pI5jE5Oc9Cp+PpAorRMd6hHCNuNGcv6Pqf
         yCj4mq7DctqHDupMV6NzxAF2ro4tfqNj/t2pQOVhG+s8GDXbSJUaz/bEe79w0tH/IVp0
         +24Q==
X-Gm-Message-State: ABuFfoih2V7sHTBkvMvYWR6nIfheXH0zvv4qY6aqN6bZOpR6QLZpQSXE
        2CglEozU96MZr222miumV8enby1H8Po=
X-Google-Smtp-Source: ACcGV608595K4TiYY/aPqx8PKwn4+yzsrmTGwy5BSCJB47azZSrpjTfnKmF3/OX6G/6m0tJwd31E0Q==
X-Received: by 2002:adf:f681:: with SMTP id v1-v6mr7982205wrp.201.1538038941355;
        Thu, 27 Sep 2018 02:02:21 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:20 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 20/26] mt76x0: phy: set antenna parameter according to wireless band
Date:   Thu, 27 Sep 2018 11:01:49 +0200
Message-Id: <ee8b0f6e71d6483d89d79a3d0c8315d74c1289b6.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
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
2.17.1

