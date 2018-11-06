Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C94C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C66412081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C66412081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389495AbeKGC0Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:26:24 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38607 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389285AbeKGC0X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:26:23 -0500
Received: by mail-wm1-f66.google.com with SMTP id l2-v6so12862204wmh.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 09:00:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JynL7O12bknstPoP9n4LYotMSCHrMx0BQnxUnYeAqa0=;
        b=WYZgEhT+UXkQ3T53O8O94VXOixw/Z4ve8d3o5HeXsr+iSVsS36OrVnrafMbRQ7v6hv
         njn5Q0DbNjNOcHNW5WPsm5/3OhHMCXRzMF+58Nle8+2XnHuJyJTXulbp87GQsE8yuIyy
         qqnn/IfX62ylmbKugrZyLK9AtRLjyc4A5vWv9C/AifdmcP0H/fP0gZ39edNLL1G7Alxb
         TV8bYPYZ80WGMb2SewoXd3mlN/oING3V6J5bA6vj1itYueZhheIqCSLyx5FZ0Dg+KoL1
         xrOLa6uAYHePgE30gnr5Wc8e0nk7AGFgPsMP/VeDGnz2xW4GsV+/0RE1rsUb4pwRCA2u
         GoIA==
X-Gm-Message-State: AGRZ1gJ11Msj9hbZS3LrM2Y2Ycj7397P2ZIB06pO4EndnNizVkUnvX/0
        Rrmy3RP98g1zR2/PPdUDPE1lZw==
X-Google-Smtp-Source: AJdET5eDRi8s/ovZeHqpFzOXyTSdoJpZlgvZ8PA46Xl0yCHJbN/wIrCWvZYZsSjN7fZD8ZZIsddTzw==
X-Received: by 2002:a1c:5788:: with SMTP id l130-v6mr2603946wmb.60.1541523614885;
        Tue, 06 Nov 2018 09:00:14 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x142-v6sm649271wmd.20.2018.11.06.09.00.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Nov 2018 09:00:14 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mt76x2u: init: remove mt76x2u_init_beacon_offsets routine
Date:   Tue,  6 Nov 2018 17:59:48 +0100
Message-Id: <76835f131fa51259fcbf79df7b7073f808aa7cd2.1541522368.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1541522368.git.lorenzo.bianconi@redhat.com>
References: <cover.1541522368.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mt76x2u_init_beacon_offsets routine since the driver supports
just STA mode

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 8b280a4ea792..de0fbdb02c4d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -156,14 +156,6 @@ struct mt76x02_dev *mt76x2u_alloc_device(struct device *pdev)
 	return dev;
 }
 
-static void mt76x2u_init_beacon_offsets(struct mt76x02_dev *dev)
-{
-	mt76_wr(dev, MT_BCN_OFFSET(0), 0x18100800);
-	mt76_wr(dev, MT_BCN_OFFSET(1), 0x38302820);
-	mt76_wr(dev, MT_BCN_OFFSET(2), 0x58504840);
-	mt76_wr(dev, MT_BCN_OFFSET(3), 0x78706860);
-}
-
 int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 {
 	int i, k, err;
@@ -200,8 +192,6 @@ int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 	mt76x02_mac_setaddr(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
 	dev->mt76.rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
 
-	mt76x2u_init_beacon_offsets(dev);
-
 	if (!mt76x02_wait_for_txrx_idle(&dev->mt76))
 		return -ETIMEDOUT;
 
-- 
2.17.2

