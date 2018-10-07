Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC831C65C30
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 624162084D
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:37:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 624162084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbeJGQog (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 12:44:36 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41324 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbeJGQof (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 12:44:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id x12-v6so17605200wru.8
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2018 02:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=extZaW2yg1COH176bQUirSM9XC1htSnlUUvRMTMDth0=;
        b=qQ1KAFlsVQNQ5hg7Puwsk3pXzgKAhrq5rPvSZq02PfASZACmzkWst6kKyP3aaZiije
         HlkM8IfjYF1gFFI1G5e/lEuQEITrrQvt7AfjqmNfI8yGMXzW8uK9dztQ8x5fb17683iI
         C6XGZ5RqtLd8DRxKhUJs7P65sq2s7cfctHkYTDN7LIH4i3hUCWRMwphExAk514RqWOrg
         qB31J2eKwVBRkWDgIgOFv1D68NfDr6/Z2Y5m1jkZ25PwbDHYGYH6boL17UHp4DAWG6+x
         5YoMMOmrEe29WSPBonH8N/36X0KoEgV39CKJaHKSuTclZNKGmeydyh6EsGWSYgXUGgXw
         3NhA==
X-Gm-Message-State: ABuFfohUjKmuzYFwAWJeOpRDUXOQiNpfqhralYitR+M2g+NsstDFyiyf
        gtu0eFG0O50VZdIdESEWQvax4A==
X-Google-Smtp-Source: ACcGV60cO1oTjtg/m7M967EmVefz6pAhgLD1kSlpPOc7my2cEyYZQFLuyyIRQ84XC70+lTPTt+cPNg==
X-Received: by 2002:a5d:40cd:: with SMTP id b13-v6mr13990887wrq.133.1538905072260;
        Sun, 07 Oct 2018 02:37:52 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id v14-v6sm3687724wrw.28.2018.10.07.02.37.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Oct 2018 02:37:51 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: phy: fix bank check in mt76x0_rf_csr_{wr,rr}
Date:   Sun,  7 Oct 2018 11:37:40 +0200
Message-Id: <20181007093740.11994-1-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix typo in bank check in mt76x0_rf_csr_{wr,rr} routines.
This issue has never been hit since mt76x0_rf_csr_{wr,rr}
are actually used just by pci code

Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index e2b62ce2306b..4419c0078a6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -37,7 +37,7 @@ mt76x0_rf_csr_wr(struct mt76x02_dev *dev, u32 offset, u8 value)
 	bank = MT_RF_BANK(offset);
 	reg = MT_RF_REG(offset);
 
-	if (WARN_ON_ONCE(reg > 127) || WARN_ON_ONCE(bank) > 8)
+	if (WARN_ON_ONCE(reg > 127) || WARN_ON_ONCE(bank > 8))
 		return -EINVAL;
 
 	mutex_lock(&dev->phy_mutex);
@@ -76,7 +76,7 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
 	bank = MT_RF_BANK(offset);
 	reg = MT_RF_REG(offset);
 
-	if (WARN_ON_ONCE(reg > 127) || WARN_ON_ONCE(bank) > 8)
+	if (WARN_ON_ONCE(reg > 127) || WARN_ON_ONCE(bank > 8))
 		return -EINVAL;
 
 	mutex_lock(&dev->phy_mutex);
-- 
2.19.0

