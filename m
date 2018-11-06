Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5A4C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 22:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4D372081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 22:49:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4D372081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbeKGIQw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 03:16:52 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46400 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbeKGIQw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 03:16:52 -0500
Received: by mail-wr1-f67.google.com with SMTP id 74-v6so15350921wrb.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 14:49:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F0pGCJnFuqzsN6rK5u4L9tRDmUD56q6WjS/lVys/9pU=;
        b=XuqrZLyHHvDoyC3bRjlCZa+w66ZCjVfyayhtO9/YSnGLfZgn8pgOuJBdVtSbwxLT3f
         /lyciO8ZqbovKjYWPwbVVxWPILFwPE3YWuetlY6cJzjTFAkUwiomKh9xmr/ZOoYMZUFw
         7pZCkPR5ZIsLAISYu746diPN5/FfMbLqK/VDgNaevrOYxYHnh9jGb6OihVpBoWf1eT+d
         s2BcKUhl4a4nLsKutt37pziL+Ln6iSwd5/dnpz+lS7vBNquUC9Ca7NdeghJ1I4y+Amvh
         w6TdC8FCCKbxt/k7pWKUb6T5dXZsrtARm4WeQZlksb7CHhTF/+TqCPQX7dEOhspivz3B
         PU7A==
X-Gm-Message-State: AGRZ1gJktb4wWv0/QFIEY+Kr2xCzJhiCvyhxkANSBn3Oer/UAXqr0HSS
        SVKdA3MbPIk/dLdpcRskG9NzbQ==
X-Google-Smtp-Source: AJdET5eCvJWJmEhiR050luaqu+ZUISWwOYdCA0tq2/bcrWTE2++Dc4d6svbIH49mAavUv9D4X9refw==
X-Received: by 2002:adf:83a4:: with SMTP id 33-v6mr24542475wre.13.1541544559152;
        Tue, 06 Nov 2018 14:49:19 -0800 (PST)
Received: from localhost.localdomain ([151.66.25.206])
        by smtp.gmail.com with ESMTPSA id 134-v6sm3784530wmp.6.2018.11.06.14.49.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Nov 2018 14:49:18 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: introduce mt76x02_config_mac_addr_list routine
Date:   Tue,  6 Nov 2018 23:49:12 +0100
Message-Id: <c9e89034e9d421bd1f2b159050c95fb1d6c236e8.1541544212.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541544212.git.lorenzo.bianconi@redhat.com>
References: <cover.1541544212.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x02_config_mac_addr_list routine in order to set
the mac address list supported by the driver. Initialize
wiphy->addresses/n_addresses for mt76x0e driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 22 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 17 ++------------
 4 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index e74d476eca24..87b575fe1c74 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -289,6 +289,8 @@ int mt76x0_register_device(struct mt76x02_dev *dev)
 	int ret;
 
 	mt76x02_init_device(dev);
+	mt76x02_config_mac_addr_list(dev);
+
 	ret = mt76_register_device(&dev->mt76, true, mt76x02_rates,
 				   ARRAY_SIZE(mt76x02_rates));
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index a8c5fdd903b9..65daa3d3c289 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -115,6 +115,7 @@ int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta);
 
+void mt76x02_config_mac_addr_list(struct mt76x02_dev *dev);
 void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 		      unsigned int idx);
 int mt76x02_add_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 87ce6a51fb05..a52db63c3c68 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -700,4 +700,26 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x02_bss_info_changed);
 
+void mt76x02_config_mac_addr_list(struct mt76x02_dev *dev)
+{
+	struct ieee80211_hw *hw = mt76_hw(dev);
+	struct wiphy *wiphy = hw->wiphy;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->macaddr_list); i++) {
+		u8 *addr = dev->macaddr_list[i].addr;
+
+		memcpy(addr, dev->mt76.macaddr, ETH_ALEN);
+
+		if (!i)
+			continue;
+
+		addr[0] |= BIT(1);
+		addr[0] ^= ((i - 1) << 2);
+	}
+	wiphy->addresses = dev->macaddr_list;
+	wiphy->n_addresses = ARRAY_SIZE(dev->macaddr_list);
+}
+EXPORT_SYMBOL_GPL(mt76x02_config_mac_addr_list);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 076b7479ba99..80b4e11ea28e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -390,7 +390,7 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct wiphy *wiphy = hw->wiphy;
-	int i, ret;
+	int ret;
 
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
 
@@ -400,20 +400,7 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < ARRAY_SIZE(dev->macaddr_list); i++) {
-		u8 *addr = dev->macaddr_list[i].addr;
-
-		memcpy(addr, dev->mt76.macaddr, ETH_ALEN);
-
-		if (!i)
-			continue;
-
-		addr[0] |= BIT(1);
-		addr[0] ^= ((i - 1) << 2);
-	}
-	wiphy->addresses = dev->macaddr_list;
-	wiphy->n_addresses = ARRAY_SIZE(dev->macaddr_list);
-
+	mt76x02_config_mac_addr_list(dev);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
 	/* init led callbacks */
-- 
2.19.1

