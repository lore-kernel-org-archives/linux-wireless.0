Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED363C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B816920835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:52:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B816920835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbeJCRki (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:40:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50881 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbeJCRki (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:40:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id s12-v6so5256707wmc.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 03:52:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TSEv2vUvKB9r0vVrv7TCSAr6fVWwxOkn09lQHCUCYF8=;
        b=A6odrBWTgJYVn4ATXa0nM/f4JhHtPIiwPESxuZrnJ9eNmXegltbQy5skt9wUqioUFV
         6p3SLPJGsLJxhAQDLwUYPYl19x2pWaX/DgBPQpImNJzTlwLBho0091wauXwhds690mOQ
         NT+8Q6Y+wMmYwIsv0YGXNhNu4wqXQriwLpfvUz4hHrBhIp7Q9YBSM6LaEykHliKfhbFK
         ccsZ2ywUQIlGoyS6XhSjZ/B6iPYhZoBxiBiEKKMrko93uhVUHseF5o1uIuRdBiNNvbnA
         YDHfOVoutV7CZNI+bmSik/0eAkRNTkWeDeHyurcCmZnTIYpnDcNB7Nj4zjkDo0aXcXUt
         X69Q==
X-Gm-Message-State: ABuFfoiJKJztBX5cC8OSKTYSHcnm9qGexwqiK2UhWSLvmwdaobHU7gaq
        HMkmx1UYYL8Bzmoq7FOlrnHKS4Vp1KA=
X-Google-Smtp-Source: ACcGV63gDjrzGTcYBupDl6rILTceDM6jq4tm5wSDlWMOys6loDjcwFDd3D/+DblAqC/tH0KeGlgSMg==
X-Received: by 2002:a1c:3795:: with SMTP id e143-v6mr1095552wma.9.1538563965731;
        Wed, 03 Oct 2018 03:52:45 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e67-v6sm1782486wmd.41.2018.10.03.03.52.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 03:52:45 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mt76: usb: fix hw initialization sequence
Date:   Wed,  3 Oct 2018 12:52:25 +0200
Message-Id: <33c6a1ce2525c59fd90c01e7af19a9f0e0b462a8.1538563675.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538563675.git.lorenzo.bianconi@redhat.com>
References: <cover.1538563675.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

mt76u_alloc_queues need to be called before mt76u_mcu_init_rx
since it initializes rx_page_lock spinlock used in mt76u_buf_alloc
routine.

Fixes: b11e19694dc9 ("mt76x0: add ieee80211_ops ops pointer to
mt76x0_alloc_device signature")

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/usb.c    | 18 +++++++++---------
 .../wireless/mediatek/mt76/mt76x2/usb_init.c   |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index a76043213f55..dd437e77009f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -179,28 +179,28 @@ static int mt76x0u_register_device(struct mt76x0_dev *dev)
 	struct ieee80211_hw *hw = dev->mt76.hw;
 	int err;
 
-	err = mt76u_mcu_init_rx(&dev->mt76);
+	err = mt76u_alloc_queues(&dev->mt76);
 	if (err < 0)
-		return err;
+		goto out_err;
 
-	err = mt76u_alloc_queues(&dev->mt76);
+	err = mt76u_mcu_init_rx(&dev->mt76);
 	if (err < 0)
-		return err;
+		goto out_err;
 
 	mt76x0_chip_onoff(dev, true, true);
 	if (!mt76x02_wait_for_mac(&dev->mt76)) {
 		err = -ETIMEDOUT;
-		goto err;
+		goto out_err;
 	}
 
 	err = mt76x0u_mcu_init(dev);
 	if (err < 0)
-		goto err;
+		goto out_err;
 
 	mt76x0_init_usb_dma(dev);
 	err = mt76x0_init_hardware(dev);
 	if (err < 0)
-		goto err;
+		goto out_err;
 
 	mt76_rmw(dev, MT_US_CYC_CFG, MT_US_CYC_CNT, 0x1e);
 	mt76_wr(dev, MT_TXOP_CTRL_CFG,
@@ -209,7 +209,7 @@ static int mt76x0u_register_device(struct mt76x0_dev *dev)
 
 	err = mt76x0_register_device(dev);
 	if (err < 0)
-		goto err;
+		goto out_err;
 
 	/* check hw sg support in order to enable AMSDU */
 	if (mt76u_check_sg(&dev->mt76))
@@ -221,7 +221,7 @@ static int mt76x0u_register_device(struct mt76x0_dev *dev)
 
 	return 0;
 
-err:
+out_err:
 	mt76x0u_cleanup(dev);
 	return err;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 55e0dea568b8..a8222447d805 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -262,7 +262,7 @@ int mt76x2u_register_device(struct mt76x2_dev *dev)
 
 	err = mt76u_mcu_init_rx(&dev->mt76);
 	if (err < 0)
-		return err;
+		goto fail;
 
 	err = mt76x2u_init_hardware(dev);
 	if (err < 0)
-- 
2.17.1

