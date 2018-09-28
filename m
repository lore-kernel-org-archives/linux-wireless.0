Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC8CC04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7897521566
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7897521566
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbeI1SCz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38632 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbeI1SCz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id j8-v6so6039962wrw.5
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tx9ODB3/MIgFy/PIkl3uni9VyqUd91JyAtiUxtaa6cQ=;
        b=r53ma7Mx/s9y1RApXwckZsHCaA/SUzd4G2u7vDO8QXKYMj7G216nfBXXaY4AQ4ZaJy
         TIf7DZmbPkfrC/t6ekqtpZD7o9hzP2fkRGUAJR8Kj/efwMCfbkc0tz7xpVaahwgmM3DI
         AUr4ootD78PKebis/d9t3owSgGugzMMR8q/Tza4hxd3jvzvOWdONScKroFipamYH1XX7
         f9HoPso9nKIX1QNYG7Le2HBkT00gntQ8MFTP93+qhUb3nI1QEss/jSgDKlmKZkFgXfxL
         KhlcFm9TQ8rbtCwSOHwb0wMYyGLU+W+DeiYVzGQBV0uBQExUpQx1NEQz7uaUPJeG+H+Z
         z4Vg==
X-Gm-Message-State: ABuFfohXRMR7XtXwAfZlyFlz5gfUP6CkURvVDKDlaLkEivdz/LMFwYsR
        JtLWKAOkFxyp99hus5yvos3fVw==
X-Google-Smtp-Source: ACcGV62dd/3Cniim5/b63ZOqIavJqgB03P2S3Q8mGHyxZvWSxgIz8mcwpjM8keCqkDjp53JxXMUjzA==
X-Received: by 2002:adf:f043:: with SMTP id t3-v6mr2306516wro.92.1538134771269;
        Fri, 28 Sep 2018 04:39:31 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:30 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 15/24] mt76x0: init rx filter in mt76x0_init_hardware
Date:   Fri, 28 Sep 2018 13:38:58 +0200
Message-Id: <24ee78131f74153558f63ecd4ca9936ea1e755b3.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
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
index a53d25e826f1..0fd4b4ca8227 100644
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
2.17.1

