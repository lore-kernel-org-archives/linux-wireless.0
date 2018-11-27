Return-Path: <SRS0=Otg8=OG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04380C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C49642086B
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C49642086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbeK1JUy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 04:20:54 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39472 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbeK1JUy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 04:20:54 -0500
Received: by mail-wm1-f68.google.com with SMTP id n133so590903wmd.4
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2018 14:21:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lLKcb/dymw4IB1miLLQVpvbaLD6dtDDBdL4yRV/de0I=;
        b=CMPb6UzYS5wDRDxwwJHfWlUVsXdOAKvo2E21mGZ6kf+MTkzgseIxgvKANLegfhAHZA
         1YeUx7iphkEbzr4eLEnY8IN5wnwwj+zJ07g4eiCoJbz1sDYZAFEmIa79w77/Ff5+Xe+s
         RU4L2tA/f+VfyrO5f1xTdYXVy8Q8Hx5uKCOhtCeF/VAj05QrWM7N+1K+yRFlQZfb8uAa
         MGyDg8TTk/88lKm+mcRkyg9pZ3INkDJ0gT159TY732FSLYwT3sWYuD/v5vvRCL3DVcWq
         AgJrZUh0nYlmQPVsn3jiaWxu4Hmt2YMnPt0tqjjiJquFC6wvch0VwuHUR8El2DAb1IqI
         THTA==
X-Gm-Message-State: AA+aEWZO39accXt0Ao1i3tHa+RgyPPSF0OMbqgyDYx8kYoiJarz06cPW
        Dyi4btcGnak//Jas4dVjGoR5RThgmjI=
X-Google-Smtp-Source: AFSGD/XEX5tMiJ9K6iEw0dAriLeoA77VxpEQ0frsgQMdz05+yUYdq0scM+RDzmyrCwrz0X0FToAgDQ==
X-Received: by 2002:a1c:aa92:: with SMTP id t140mr571649wme.36.1543357291390;
        Tue, 27 Nov 2018 14:21:31 -0800 (PST)
Received: from localhost.lan ([151.21.135.68])
        by smtp.gmail.com with ESMTPSA id 142sm866245wmw.27.2018.11.27.14.21.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 14:21:30 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name
Subject: [RFC 4/5] mt76: make mt76x02_vif_init return int
Date:   Tue, 27 Nov 2018 23:21:11 +0100
Message-Id: <413e8a1835934ac1aa1e02b7ecbdb4718592e5bb.1543343124.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a preliminary patch to add xdp support to mt76 driver
since mt76x02_vif_init will be used to xdp_rxq_info data structure
and can return an error code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h         | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c    | 9 +++++----
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 3 +--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index b1d83dd34204..3922854ffa06 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -116,8 +116,8 @@ void mt76x02_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta);
 
 void mt76x02_config_mac_addr_list(struct mt76x02_dev *dev);
-void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
-		      unsigned int idx);
+int mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
+		     unsigned int idx);
 int mt76x02_add_interface(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif);
 void mt76x02_remove_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 3a70e5bf7d42..87195076cf62 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -207,8 +207,8 @@ void mt76x02_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_remove);
 
-void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
-		      unsigned int idx)
+int mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
+		     unsigned int idx)
 {
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 	struct mt76_txq *mtxq;
@@ -220,6 +220,8 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 	mtxq->wcid = &mvif->group_wcid;
 
 	mt76_txq_init(&dev->mt76, vif->txq);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_vif_init);
 
@@ -248,8 +250,7 @@ mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	if (vif->type == NL80211_IFTYPE_STATION)
 		idx += 8;
 
-	mt76x02_vif_init(dev, vif, idx);
-	return 0;
+	return mt76x02_vif_init(dev, vif, idx);
 }
 EXPORT_SYMBOL_GPL(mt76x02_add_interface);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 2b48cc51a30d..61768c76e5d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -55,8 +55,7 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
 		mt76x02_mac_setaddr(dev, vif->addr);
 
-	mt76x02_vif_init(dev, vif, idx);
-	return 0;
+	return mt76x02_vif_init(dev, vif, idx);
 }
 
 static int
-- 
2.19.1

