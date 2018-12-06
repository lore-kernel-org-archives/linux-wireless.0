Return-Path: <SRS0=7mY+=OP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C02C04EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 16:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E3B620838
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 16:07:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E3B620838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbeLFQHw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 11:07:52 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40846 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbeLFQHw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 11:07:52 -0500
Received: by mail-wr1-f68.google.com with SMTP id p4so1020145wrt.7
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2018 08:07:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KO8alHgWQKvOahiCxAEFRSKnwgWpInaDVHxJRKdLyOc=;
        b=UzQIqCIF3cK3SLHIX6lD0i33Ifrx2fW7l/Sw9hNSZirnh3iK3Sgf+HKFkSGQlDiCU9
         m+LTaedvhzyE53XOmoWoo/eJiLty9vPDANGzshspEah/GVYPndoxssxAfNSlZX1XeSDQ
         MUl2tI+7RJTBERF3rzn1hfbxUbYi76jFnLR1of9gj0r94688kvwBpSzfcyxIh48ZZahK
         Peeh/c/9phaXMRIYmb7g8+O9MPwhN/KZYDE7LZQBZVcU4BYRh0Zf5nr2EDA1YysxVKNy
         on02FaqkL3hYsQGdGzPO8oP0a5YgZQBKXLyNtJ5tFR05Yo2y5iRkqp9AX10azcga1SZ+
         zABA==
X-Gm-Message-State: AA+aEWZZ8SirNYjMD/nwhi2ohG9cVMY5/DrFLCXT6xzho8SvhPNwJSpA
        aWHN8qYH40FOFA5wpBmBQ4/SHg==
X-Google-Smtp-Source: AFSGD/VvtCYXqFsvSqN8bmZx2Tn/P5o5ErHB4AKBYkiT7aJgqqarVhOwCaZU5uXNAIEDX3Q+9o6KRg==
X-Received: by 2002:adf:a58a:: with SMTP id g10mr16231317wrc.3.1544112470423;
        Thu, 06 Dec 2018 08:07:50 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id o8sm1027649wrx.15.2018.12.06.08.07.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Dec 2018 08:07:49 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: mac: run mt76x02_mac_work routine atomically
Date:   Thu,  6 Dec 2018 17:07:39 +0100
Message-Id: <247b18445443568012e3620025c22b5ca7b98653.1544112379.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1544112379.git.lorenzo.bianconi@redhat.com>
References: <cover.1544112379.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Grab mt76_dev mutex in mt76x02_mac_work handler since it runs
concurrently with mt76x{0,2}_set_channel routines

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 490368dc9325..64841f40cdcf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -784,6 +784,8 @@ void mt76x02_mac_work(struct work_struct *work)
 					       mac_work.work);
 	int i, idx;
 
+	mutex_lock(&dev->mt76.mutex);
+
 	mt76x02_update_channel(&dev->mt76);
 	for (i = 0, idx = 0; i < 16; i++) {
 		u32 val = mt76_rr(dev, MT_TX_AGG_CNT(i));
@@ -796,6 +798,8 @@ void mt76x02_mac_work(struct work_struct *work)
 	if (!dev->beacon_mask)
 		mt76x02_check_mac_err(dev);
 
+	mutex_unlock(&dev->mt76.mutex);
+
 	mt76_tx_status_check(&dev->mt76, NULL, false);
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
-- 
2.19.2

