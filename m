Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D98C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE73A2156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE73A2156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbeI0PTb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37289 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbeI0PTb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id u12-v6so1703531wrr.4
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9xSaSwwiLy0xgAhOOOBgXHpC6bN7OJoQCtYW+/q22mE=;
        b=SrKmhAtEWfTndrka+5mg5qeJlMcvbyZ91z1ykWbYSxRh1QrFY91OVEXh/BzmiC+clf
         2avnDPlhud3mGn4PnB61AKePAiM92FN3l9domrd9mfH4EnvZlcCueVxBC+hJFkqD82k/
         tnRdtTq5dLNiCpODbh60FCQ2YG7jvIVhBm4OvTIDJA48l3e2r+zqazclBTDOHbEUVXhN
         /Pu12mmly31KaYUTfAvOZ2XuA/0i28jKKI/uJm58sMXG3suwj984a9J6Vdap8L2Iamvy
         zzQDNREfiM9JEmMg1zIlv0eP1Lpsi6VAzgrXgXUsqMdfwVhNDModzLqH+osXdMefioFA
         mcjA==
X-Gm-Message-State: ABuFfoiJjZiwzLRwIdkQ1CJaIScSmvp5zqs0rTlSAtnfn0GJAzfXFoEG
        62nNvatl8c35Ym7Ju/XAS/eqo+O3ga8=
X-Google-Smtp-Source: ACcGV613hc/PEAjmFLYWVWOXEtAAk/kzW6j1iu2o/KirbKlMxJCE3Ild3GXnmkUJffGbrNmj+hT+Qw==
X-Received: by 2002:adf:9e8f:: with SMTP id a15-v6mr8128903wrf.70.1538038937525;
        Thu, 27 Sep 2018 02:02:17 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:16 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 16/26] mt76x0: init rx filter in mt76x0_init_hardware
Date:   Thu, 27 Sep 2018 11:01:45 +0200
Message-Id: <88319fc87f6083af28b3a2d462901532e66d4498.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
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
index 6600ee046800..a5529616cb8d 100644
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

