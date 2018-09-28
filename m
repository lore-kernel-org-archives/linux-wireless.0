Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0260BC004D1
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2BF521547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2BF521547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbeI1SC7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34841 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729595AbeI1SC6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id o18-v6so1882170wmc.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h2mOFCvgTfcSOge/NVVUhF7/Qk1RRgKKmQtAt49NRxo=;
        b=i8G6kqBIysQwMcCUC+5Cltw2rZP/BPy+W1ektRhFiIUHx6fTm9WgIReUCSqcvNly0D
         5izmuBUvm/JBjqC5en0gDSweu85/kZ0RcVOB6M66US0KzYI0Tzwn3AyVThTEDfgEDI7z
         e4WEs2iizTVD+Zlch/wkjWzxYGGzVFxgFKV7fXV1ZLP2kDNlRAe3Z7+1mSmcH/4tPrmb
         QAHmmO9YYixpiNazRkxDFGAwB/PiKwqjShm7nPBHQWWQQqAu21UeUXjHSVFyw43zGsL2
         Q5wPjClDIOZ8CbdTfNyeoJNGhsqA64+d4M/vN88RI2Th9ZLXUOXyrm4c9d+PLZDCHFH1
         HILw==
X-Gm-Message-State: ABuFfoj7ONlEiLuxhgySLJhXLlmfmbSblPxZ8kl9X/6qwn3ZfTDSmOsB
        1tKRgBXdFYGWKY29ESz6y2tcyg==
X-Google-Smtp-Source: ACcGV61YazE4URvZlROx1CD4wysAUl86/5TAdABj5PqW0AqT3Yz2lqkMyyMLYqysRTeALmVkVeZD8A==
X-Received: by 2002:a1c:790:: with SMTP id 138-v6mr492043wmh.122.1538134775163;
        Fri, 28 Sep 2018 04:39:35 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:34 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 19/24] mt76x0: phy: set antenna parameter according to wireless band
Date:   Fri, 28 Sep 2018 13:39:02 +0200
Message-Id: <2d63110da50e50c9acbe458b50e085e1b15065c1.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
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

