Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793DEC1B0E3
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E4FD2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E4FD2172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbeI1NCu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46460 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbeI1NCu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id z3-v6so5039391wrr.13
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lxmBu97M1pwPYsl1rH1K0WRD19UzQZTrgrj+bLRJN3g=;
        b=M0fAWZDdO2CqcBSiPcduvuSKiI5e/GX3qFxVniTlyhhAQk3mKL6+BkXkGbXRrqVbc/
         QIxj6heFsIhTOcJmk/vMoJ1kXVNuxv1vyyXVzixqJAcBz1UWNGvKHICN2bughGfxRLwO
         IcQsezkrxNAThLVQOvFk7nfDItWwB1ez6DOTLI6hUbRfuA/hbLUA/Bwec4sVmBSxosfu
         ABRt7+RHlAsMX06QngGAmMuiLICl2su5nmVPkmSYOWi8veGfpIwsu4o9vWjZ1lsSwe4p
         3XyKJ68j4ZdjvhgJYPQIJLCTvvPb23TVaaO/L3oJ+AWPAuRWroXpVGtmjiymX6qQU2KN
         u7Iw==
X-Gm-Message-State: ABuFfohsditPMbofXBCpoaP3cFCtYkbnGtjImB9VSTBvOriT7tmtou6K
        AvpPYh6uX0UZogD5ZhNIccdS9A==
X-Google-Smtp-Source: ACcGV60464EgFrqm0BnD58GwdE2nvBfEZWJsz2HakiTHmsvnOlEtL+OyXFpcIeh9UmO8ni6Oha30Ng==
X-Received: by 2002:a05:6000:108c:: with SMTP id y12mr6004858wrw.226.1538116835798;
        Thu, 27 Sep 2018 23:40:35 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:35 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 08/24] mt76: move mt76x2_wait_for_bbp in mt76x02-lib module
Date:   Fri, 28 Sep 2018 08:40:01 +0200
Message-Id: <20180928064017.26870-9-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x2_wait_for_bbp utility routine in mt76x02_util.h
in order to be resued by mt76x0 driver. Morover rename it in
mt76x02_wait_for_txrx_active

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h | 8 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h       | 7 -------
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c | 2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 479e7ffcc951..432c725da62f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -66,4 +66,12 @@ static inline void mt76x02_irq_disable(struct mt76_dev *dev, u32 mask)
 	mt76x02_set_irq_mask(dev, mask, 0);
 }
 
+static inline bool
+mt76x02_wait_for_txrx_active(struct mt76_dev *dev)
+{
+	return __mt76_poll_msec(dev, MT_MAC_STATUS,
+				MT_MAC_STATUS_TX | MT_MAC_STATUS_RX,
+				0, 100);
+}
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index c51d6e2a64ce..9bf8be5ea1cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -124,13 +124,6 @@ static inline bool mt76x2_channel_silent(struct mt76x2_dev *dev)
 		chan->dfs_state != NL80211_DFS_AVAILABLE);
 }
 
-static inline bool mt76x2_wait_for_bbp(struct mt76x2_dev *dev)
-{
-	return mt76_poll_msec(dev, MT_MAC_STATUS,
-			      MT_MAC_STATUS_TX | MT_MAC_STATUS_RX,
-			      0, 100);
-}
-
 extern const struct ieee80211_ops mt76x2_ops;
 
 struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index 4eb3fe657bd2..ecaafbb3eabe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -209,7 +209,7 @@ int mt76x2u_init_hardware(struct mt76x2_dev *dev)
 
 	mt76x2u_init_beacon_offsets(dev);
 
-	if (!mt76x2_wait_for_bbp(dev))
+	if (!mt76x02_wait_for_txrx_active(&dev->mt76))
 		return -ETIMEDOUT;
 
 	/* reset wcid table */
-- 
2.19.0

