Return-Path: <SRS0=r36G=NP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27039C32789
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 23:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA4C92082D
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 23:18:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA4C92082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730688AbeKEIfT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 03:35:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37636 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730390AbeKEIfS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 03:35:18 -0500
Received: by mail-wr1-f68.google.com with SMTP id o15-v6so3842856wrv.4
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2018 15:18:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ZEC6LIDiRHU7nSEssce8s/6avhX8bbzXOom4It5cXY=;
        b=pXz9v+tD6ChbATYq8BFlWjr1o9jbd5r05wj9No1d7QnqFLkwvsDz9VVEB4dZnLn1i0
         9lEh6S6JHreSUAZoMNCbpO9ermYQ955Fy0UOxkuOAd/iWb6fZa7N8eA+yVDuCoOK/Uwa
         bHM9oQX7qStV6/9sWrujx+XA0TJQhNhvpp/bLcrt6sTpmOK0JvyvEPPJXBXzbNtrfGbT
         pR+rNRGOi4JE8tWCfrAb9HOETLbgBAtcAq4Y/Y9/4Aqt2TANZ58juGqCU8rupb9KkBDU
         +ZkCMSBlJMaxeVSfNrDNeryE28YZqiwrGz7fDaVEJT0czcG/roTZR1Bb26NSQLIoafim
         hFkA==
X-Gm-Message-State: AGRZ1gKyXNKsFAfUGNht+m8Bk6idVL3Hh6+EVxdkxjuPzKLcfZJuraco
        XQ972UNcjtopNpXsGmCmDM8nXQ==
X-Google-Smtp-Source: AJdET5dlZCiAlMJMi6Wjp1mt2nxrlZtPqdpycTC7luhJ9xmYsi6+K2zKaH8cTcLt3NZ17TP02xIP4A==
X-Received: by 2002:a5d:4dc2:: with SMTP id f2-v6mr18649669wru.45.1541373517318;
        Sun, 04 Nov 2018 15:18:37 -0800 (PST)
Received: from localhost.localdomain ([151.66.25.206])
        by smtp.gmail.com with ESMTPSA id n67-v6sm28739043wmd.41.2018.11.04.15.18.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Nov 2018 15:18:36 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: dfs: fix IBI_R11 configuration on non-radar channels
Date:   Mon,  5 Nov 2018 00:18:26 +0100
Message-Id: <607b51c990e053ccce045ed4a52ae98cd1dfb332.1541373198.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541373198.git.lorenzo.bianconi@redhat.com>
References: <cover.1541373198.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix IBI_R11 configuration on non-radar channels for mt76x0e
driver. This patch improve system stability under heavy load.
Moreover use IBI_R11 name and remove magic numbers for
0x212c register

Fixes: 0c3b3abc9251 ("mt76x0: pci: add DFS support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
index 527e530d480a..054609c634a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
@@ -799,7 +799,7 @@ static void mt76x02_dfs_set_bbp_params(struct mt76x02_dev *dev)
 
 	/* enable detection*/
 	mt76_wr(dev, MT_BBP(DFS, 0), MT_DFS_CH_EN << 16);
-	mt76_wr(dev, 0x212c, 0x0c350001);
+	mt76_wr(dev, MT_BBP(IBI, 11), 0x0c350001);
 }
 
 void mt76x02_phy_dfs_adjust_agc(struct mt76x02_dev *dev)
@@ -850,7 +850,11 @@ void mt76x02_dfs_init_params(struct mt76x02_dev *dev)
 		mt76_wr(dev, MT_BBP(DFS, 0), 0);
 		/* clear detector status */
 		mt76_wr(dev, MT_BBP(DFS, 1), 0xf);
-		mt76_wr(dev, 0x212c, 0);
+		if (mt76_chip(&dev->mt76) == 0x7610 ||
+		    mt76_chip(&dev->mt76) == 0x7630)
+			mt76_wr(dev, MT_BBP(IBI, 11), 0xfde8081);
+		else
+			mt76_wr(dev, MT_BBP(IBI, 11), 0);
 
 		mt76x02_irq_disable(dev, MT_INT_GPTIMER);
 		mt76_rmw_field(dev, MT_INT_TIMER_EN,
-- 
2.19.1

