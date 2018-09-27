Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A43C004D5
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D99B22157C
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D99B22157C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbeI0PTj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44629 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbeI0PTi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id v16-v6so1678107wro.11
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Yu/iMGh0AXVhl1/KTgP1PAu+A2AnHosPds3F7wDWvzg=;
        b=MmXf9ZUrNdyk2fh1nwcSoNal69nbzH0n1IW/vCXfKfRToS5+EW6pEe31tNZGO+lAUJ
         sIwR/DBILaP/tCuHZIBl6oj4HK0xM5f3ffjhSSCyyUaycBr3K88jjmV2x5ErV/mns9Qr
         wZh/NDqyMmQF5F+bBotGF0v68dIyq3YodcwR05DujygXjBt2mXQ33os9hAvkvIb301VQ
         IFDv6BEouoYmr4SckxyJMJ6CKY2itZ3uzvNa+HNOiwCRciaEvXQHsOyVRevFaSn/eOYu
         4SpMzwhJdjW40UdOqN3K7BwCAUyxqNsHMiwxeh+asx+Tt2cKfO4JGDmWODmtqYh5Oi7V
         AneA==
X-Gm-Message-State: ABuFfogUQIs9xxYaUSMf/HcrDciXsVsyFvHTPLj119h3B6GNACfdpLDQ
        tQ1O+FZJGujRh4XngT0Ikx7qZfYeGcQ=
X-Google-Smtp-Source: ACcGV621tU967+QhYzNS0K0w4f5SU5gdn1frniL+hZeVDbLU/SrT3gagXQgVnfls/LaYJt94qjoLyg==
X-Received: by 2002:adf:d149:: with SMTP id b9-v6mr8259724wri.17.1538038945225;
        Thu, 27 Sep 2018 02:02:25 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:24 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 24/26] mt76x0: pci: add mt76x0e_stop callback
Date:   Thu, 27 Sep 2018 11:01:53 +0200
Message-Id: <4fa502576a4fe7f837383207eceaee8a15e51d50.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76x0e_stop mac80211 callback to stop
device mac closing the netdevice

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/pci_init.c    | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
index d2b98a773660..29751b6ee470 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
@@ -37,6 +37,23 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
 
 static void mt76x0e_stop(struct ieee80211_hw *hw)
 {
+	struct mt76x0_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	if (!mt76_poll(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_DMA_BUSY,
+		       0, 1000))
+		dev_warn(dev->mt76.dev, "TX DMA did not stop\n");
+	mt76_clear(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_DMA_EN);
+
+	mt76x0_stop(dev);
+
+	if (!mt76_poll(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_RX_DMA_BUSY,
+		       0, 1000))
+		dev_warn(dev->mt76.dev, "TX DMA did not stop\n");
+	mt76_clear(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_RX_DMA_EN);
+
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 const struct ieee80211_ops mt76x0e_ops = {
-- 
2.17.1

