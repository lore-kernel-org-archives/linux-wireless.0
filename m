Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9D1C5CFFE
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 11:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65F7E20821
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 11:54:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65F7E20821
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbeLJLyY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 06:54:24 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33995 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727545AbeLJLyX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 06:54:23 -0500
Received: by mail-wr1-f65.google.com with SMTP id j2so10197241wrw.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2018 03:54:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6Z4DTYUUv0AqCXQYCMre7SpoeYv0Kx2j4qLo2oG74Q=;
        b=iL2jU39jl7VHfwTV8icjq3ITS3wyb9RY2CbOF9gLipLpeFU1CYmveTLxZ257Xtc+vK
         0lYwu1M09Q8pCyNkEPJrk6LCawejwyH8tMQ40ai0Cik+5HVZogTXCEfCfe/PtdHLgbrh
         i4yh/B8IiURiMsWKOCRDOm5dthksrYTrXz12LpXYAm5SEQVm6Pm212UJNZKT1kF/IupW
         xNtrGE/1R3A//EavvhbSgN3a++xCCiZy6peDZjGUE9KTRHsVSYvycvhQZu1+RNAjLFry
         OFAGILjcC0ZzFtCcyi/DxLwv4vKhkeSh+LU+JN/qUzkZSpIHjW1K/t4RqLkaHGphLZWO
         nPFQ==
X-Gm-Message-State: AA+aEWYPdq5FPPOJgDG1huAUq1L1a80zFf/gjpb4IhO1wyZrGV4xweGJ
        GLfkMFme/N8rNv3PXdW1wfh35h4sK8A=
X-Google-Smtp-Source: AFSGD/U65fteTQ+7jHwPHP3Ng0NgQ/RVf0rXY4jE9tv7Se8TYnONDhnHf/CYRND/FWZoGuz3jtD1pQ==
X-Received: by 2002:adf:eb45:: with SMTP id u5mr9014753wrn.102.1544442861342;
        Mon, 10 Dec 2018 03:54:21 -0800 (PST)
Received: from localhost.localdomain ([151.66.36.11])
        by smtp.gmail.com with ESMTPSA id h127sm12127623wmd.31.2018.12.10.03.54.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Dec 2018 03:54:20 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: add static qualifier to mt76x2_init_hardware
Date:   Mon, 10 Dec 2018 12:54:05 +0100
Message-Id: <9412eb449b559061a73a7a6fd075c9b510bade7a.1544442714.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1544442714.git.lorenzo.bianconi@redhat.com>
References: <cover.1544442714.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add static qualifier to mt76x2_init_hardware routine since it is
used just in pci_init.c

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h   | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index b259e4b50f1e..28ec19acf9db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -53,7 +53,6 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev);
 int mt76x2_register_device(struct mt76x02_dev *dev);
 
 void mt76x2_phy_power_on(struct mt76x02_dev *dev);
-int mt76x2_init_hardware(struct mt76x02_dev *dev);
 void mt76x2_stop_hardware(struct mt76x02_dev *dev);
 int mt76x2_eeprom_init(struct mt76x02_dev *dev);
 int mt76x2_apply_calibration_data(struct mt76x02_dev *dev, int channel);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 6eaab156387a..41c60208f175 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -260,7 +260,7 @@ mt76x2_power_on(struct mt76x02_dev *dev)
 	mt76x2_power_on_rf(dev, 1);
 }
 
-int mt76x2_init_hardware(struct mt76x02_dev *dev)
+static int mt76x2_init_hardware(struct mt76x02_dev *dev)
 {
 	int ret;
 
-- 
2.19.2

