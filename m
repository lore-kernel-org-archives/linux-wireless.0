Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D024FC04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A66362172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A66362172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbeI1NC6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52221 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbeI1NC5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id y25-v6so1044289wmi.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E4w1m73q06hNK6IHGU6juA50mXGrSdvuMpei/8krOUQ=;
        b=H0hIqYuvXOZKJjjnjKCSD7M/LHwB+Tb6AGeq7PKrEwWuJaGLDNEg3MGPP2FfL9s8Jf
         gBHJjll+pGCy4PAV/bljH3PrrNPfrgKqjW7ctD8U1LrXPND/yjgPNW0WCmsy/IaEgqO1
         DI1v2rVGmobOYxpVjSaqhwxbSd2gj3I/wUtGjl6MiRTJjOOx/pOKT3+Lv2Sse0Cs1ORH
         mg7txAzapkXmnb2iYn/uij67luk9kDj7DVCPP1EMw35oXvKULliyEDdmbStMnw71gxCc
         F9bDuUdEnJzmUjxGwwDZr4SO3qC8dgYYcGTC87i5MkZzo2+Js0pGEOjulf9Iz6Q1lbJ1
         /Y5w==
X-Gm-Message-State: ABuFfogLNXziEdpxfbBP6i4MnvAufkIgqOPxxl1F0dfdRFhF4/wuLnXU
        vwvMLVPcQGVdCHjQrzZBTe3B0YxkNTk=
X-Google-Smtp-Source: ACcGV63L8vZKiux+fOX0Vci7OPvsU2xyKxkJNksNwUKE7/LbfjNkcjMld6gnEcNvkm8iqOTqKFGbHg==
X-Received: by 2002:a1c:c5cc:: with SMTP id v195-v6mr627743wmf.29.1538116843573;
        Thu, 27 Sep 2018 23:40:43 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:43 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 15/24] mt76x0: init rx filter in mt76x0_init_hardware
Date:   Fri, 28 Sep 2018 08:40:08 +0200
Message-Id: <20180928064017.26870-16-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Initialize rxfilter mask at bootstrap an not at mac start.
This is a preliminary patch to share mt76x2_mac_start routine
between mt76x2e and mt76x0e drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 10 ++--------
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c |  9 +++++++++
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index b0e067114dce..f5a1c5fb739c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -271,15 +271,7 @@ int mt76x0_mac_start(struct mt76x0_dev *dev)
 	if (!mt76x02_wait_for_wpdma(&dev->mt76, 200000))
 		return -ETIMEDOUT;
 
-	dev->mt76.rxfilter = MT_RX_FILTR_CFG_CRC_ERR |
-		MT_RX_FILTR_CFG_PHY_ERR | MT_RX_FILTR_CFG_PROMISC |
-		MT_RX_FILTR_CFG_VER_ERR | MT_RX_FILTR_CFG_DUP |
-		MT_RX_FILTR_CFG_CFACK | MT_RX_FILTR_CFG_CFEND |
-		MT_RX_FILTR_CFG_ACK | MT_RX_FILTR_CFG_CTS |
-		MT_RX_FILTR_CFG_RTS | MT_RX_FILTR_CFG_PSPOLL |
-		MT_RX_FILTR_CFG_BA | MT_RX_FILTR_CFG_CTRL_RSV;
 	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
-
 	mt76_wr(dev, MT_MAC_SYS_CTRL,
 		MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
 
@@ -370,6 +362,8 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 	if (ret)
 		return ret;
 
+	dev->mt76.rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
+
 	ret = mt76x0_init_wcid_mem(dev);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 66e12802953c..e0fc691ce78e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -73,6 +73,15 @@ static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 			mt76x0_phy_set_txpower(dev);
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		if (!(hw->conf.flags & IEEE80211_CONF_MONITOR))
+			dev->mt76.rxfilter |= MT_RX_FILTR_CFG_PROMISC;
+		else
+			dev->mt76.rxfilter &= ~MT_RX_FILTR_CFG_PROMISC;
+
+		mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
+	}
+
 	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
-- 
2.19.0

