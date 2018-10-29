Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC647ECDE46
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 00:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD57C20843
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 00:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD57C20843
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbeJ2JXx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 05:23:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39561 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbeJ2JXw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 05:23:52 -0400
Received: by mail-wr1-f65.google.com with SMTP id r10-v6so6806804wrv.6
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2018 17:37:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bC+tNRo8OAUX1LaHE3sa0wQOr9sPlqczPqMz5bKzhpU=;
        b=blnlNx5mLdHEDBGWopSq7SYYJtxLHNQtV2Cn8FOXX1M4LvrVleCf7L07SnPGiw6MEJ
         uX4jieuhyn7Ce6N2PdnqygDnn2+YMgQmLZjjiegCN50MoDvtW5UR8uq+L3Mse01ldwfz
         v/Yobb7OKTzTUHyrBed3zunzTzRgetJV1n8r0sIwJNj4h7Ye1qh8+o9A/oswJh/LIVbc
         ND6Zon89dQj7cAiQIYFLctluV7PLZMDe0zaiBPqwpDnmR4hlnDP2I/eWrPG9/XJXAcC/
         /ttzG1MeZohDA2oB2Rx6wJyhC68VbZ8pEl2HAVxKgTIdj68+5oiHhgqqFNb5WicKLRHX
         5EvQ==
X-Gm-Message-State: AGRZ1gJSToiR3MKMPE/k6/3rEi8p48LMrx3I3d+zbRI0y+fWd1nhIfSv
        6GsTUzfiogMoyItw/5PX+p/u0w==
X-Google-Smtp-Source: AJdET5dpenXzfAQpDnKH5uIgpmnzQxf44lpnz22cWPg9BBZ90Z+NZeeS5br9V137JdMo2gpfW7ZBTg==
X-Received: by 2002:a5d:4dc2:: with SMTP id f2-v6mr2211840wru.45.1540773455082;
        Sun, 28 Oct 2018 17:37:35 -0700 (PDT)
Received: from localhost.localdomain ([151.66.52.234])
        by smtp.gmail.com with ESMTPSA id e5-v6sm12135545wru.88.2018.10.28.17.37.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Oct 2018 17:37:34 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt76x0: init: use mt76x02_mac_wcid_setup for wcid configuration
Date:   Mon, 29 Oct 2018 01:37:00 +0100
Message-Id: <4b83d461caedff525e9988db435465d63dad3c75.1540772762.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540772762.git.lorenzo.bianconi@redhat.com>
References: <cover.1540772762.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_mac_wcid_setup utility routine for wcid init configuration
and remove duplicated code. This patch fixes a mt76x0 AP issue since
hw key table selection was set to pairwise by default

Fixes: dbad2adcb2c7 ("mt76x0: pci: enable AP support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 45 +------------------
 1 file changed, 2 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 23ff29990ff7..55db5a15410e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -157,42 +157,6 @@ static void mt76x0_init_mac_registers(struct mt76x02_dev *dev)
 	mt76_rmw(dev, MT_WMM_CTRL, 0x3ff, 0x201);
 }
 
-static int mt76x0_init_wcid_mem(struct mt76x02_dev *dev)
-{
-	u32 *vals;
-	int i;
-
-	vals = kmalloc(sizeof(*vals) * MT76_N_WCIDS * 2, GFP_KERNEL);
-	if (!vals)
-		return -ENOMEM;
-
-	for (i = 0; i < MT76_N_WCIDS; i++)  {
-		vals[i * 2] = 0xffffffff;
-		vals[i * 2 + 1] = 0x00ffffff;
-	}
-
-	mt76_wr_copy(dev, MT_WCID_ADDR_BASE, vals, MT76_N_WCIDS * 2);
-	kfree(vals);
-	return 0;
-}
-
-static int mt76x0_init_wcid_attr_mem(struct mt76x02_dev *dev)
-{
-	u32 *vals;
-	int i;
-
-	vals = kmalloc(sizeof(*vals) * MT76_N_WCIDS * 2, GFP_KERNEL);
-	if (!vals)
-		return -ENOMEM;
-
-	for (i = 0; i < MT76_N_WCIDS * 2; i++)
-		vals[i] = 1;
-
-	mt76_wr_copy(dev, MT_WCID_ATTR_BASE, vals, MT76_N_WCIDS * 2);
-	kfree(vals);
-	return 0;
-}
-
 static void mt76x0_reset_counters(struct mt76x02_dev *dev)
 {
 	mt76_rr(dev, MT_RX_STAT_0);
@@ -278,17 +242,12 @@ int mt76x0_init_hardware(struct mt76x02_dev *dev)
 
 	dev->mt76.rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
 
-	ret = mt76x0_init_wcid_mem(dev);
-	if (ret)
-		return ret;
-
 	for (i = 0; i < 16; i++)
 		for (k = 0; k < 4; k++)
 			mt76x02_mac_shared_key_setup(dev, i, k, NULL);
 
-	ret = mt76x0_init_wcid_attr_mem(dev);
-	if (ret)
-		return ret;
+	for (i = 0; i < 256; i++)
+		mt76x02_mac_wcid_setup(dev, i, 0, NULL);
 
 	mt76x0_reset_counters(dev);
 
-- 
2.19.1

