Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC5AECDE44
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 00:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C41920827
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 00:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C41920827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbeJ2JXo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 05:23:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43505 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbeJ2JXo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 05:23:44 -0400
Received: by mail-wr1-f67.google.com with SMTP id t10-v6so6791726wrn.10
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2018 17:37:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SO4vYW6k096kch+9oiuJcvLjEZ68o8N59DqMrP0k+g0=;
        b=OnbP3hJLmdd+GlJYojfKG9IxL/gKDikobguZR2rBlfGqRgh229S3ly+bnG4nZY7Etb
         TH+CY2t8ncEvj6KQfPGDQGy8JX6LjsnoxvsEhhpNSXCkhatGwPuiaJPsjysi/fu/JwPb
         M93D5LIscKLeW04eNgJ03evtfiei83W/e/dX9y/3Oq3sHt+yizwq3+bRdQ0xlAU5RzX9
         2T5M96b+5l6w2I4UZGISn4XIgSON5MJfBaLbor37i1i1IOOGDKPfHKiurCrKd0/Ym2D0
         F4oXZO3IUAMwaWIhv0X2Yrd8XZI6BMnREG/415rZGDvS4uIRO98eW7X+ZgBh8VGEK74u
         eySQ==
X-Gm-Message-State: AGRZ1gLt4lHRFzyv/3AF1b38wWbaCrRKboWABMOSLrzqrDjW+AZl+nby
        FWye+yZ0AL71PGTWXw38lsRgMA==
X-Google-Smtp-Source: AJdET5drsX8y+4pqNvtrNbFVhZ36HNGBGtbzaJZ0jmoWwQHw6Pr12NC3dxzjcwoaWvcjg74hRGocQA==
X-Received: by 2002:adf:a447:: with SMTP id e7-v6mr12614596wra.190.1540773446252;
        Sun, 28 Oct 2018 17:37:26 -0700 (PDT)
Received: from localhost.localdomain ([151.66.52.234])
        by smtp.gmail.com with ESMTPSA id e5-v6sm12135545wru.88.2018.10.28.17.37.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Oct 2018 17:37:25 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mt76x2: move wcid_tx_rate conf at bootstrap
Date:   Mon, 29 Oct 2018 01:36:59 +0100
Message-Id: <5737ba4f70b3676e9808091ceb852322aaf3be45.1540772762.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540772762.git.lorenzo.bianconi@redhat.com>
References: <cover.1540772762.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move WCID tx rate configuration at device bootstrap since
the related register are always set to 0

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c     | 3 ---
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c | 5 ++++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 4fb9f095ffec..b0b04415703f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -106,9 +106,6 @@ void mt76x02_mac_wcid_setup(struct mt76x02_dev *dev, u8 idx,
 
 	mt76_wr(dev, MT_WCID_ATTR(idx), attr);
 
-	mt76_wr(dev, MT_WCID_TX_RATE(idx), 0);
-	mt76_wr(dev, MT_WCID_TX_RATE(idx) + 4, 0);
-
 	if (idx >= 128)
 		return;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index f6e8af6432c1..7b53b2be28c2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -129,8 +129,11 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 	for (i = 0; i < 256 / 32; i++)
 		mt76_wr(dev, MT_WCID_DROP_BASE + i * 4, 0);
 
-	for (i = 0; i < 256; i++)
+	for (i = 0; i < 256; i++) {
 		mt76x02_mac_wcid_setup(dev, i, 0, NULL);
+		mt76_wr(dev, MT_WCID_TX_RATE(i), 0);
+		mt76_wr(dev, MT_WCID_TX_RATE(i) + 4, 0);
+	}
 
 	for (i = 0; i < MT_MAX_VIFS; i++)
 		mt76x02_mac_wcid_setup(dev, MT_VIF_WCID(i), i, NULL);
-- 
2.19.1

