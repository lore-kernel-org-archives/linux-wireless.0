Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D035ECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 12:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEB4120644
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 12:56:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEB4120644
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbeJSVCj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 17:02:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39893 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbeJSVCj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 17:02:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id 61-v6so37325396wrb.6
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2018 05:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gYio9bI0uLzpYALshvTExZYsM0/50yKHN3Zh8+cOVIA=;
        b=i9uNEUwxy/aL5qt/cvvAtqMLTJqICq21+6Xmn6GzRRVIS7vmX6oKr4LuZREfeJJkCc
         /6j39n5FVOBjKTu+09+p4geU7A61JlO1elBVXbct8JDCtTaOxfuJAeEo3/KCWrfmtGmJ
         XkdP2QT/JDuhjE/464OU9/K2xmHA7FP35YCFDkFoekaxQT1nJVQHXlQ/P1N+fcJbnobH
         JEg3zc0OmctupUYyoy2y4PCJ/BnVEYBr0nGQjwx2I+4YOCaqamdMdTrB0efo9elgcqMU
         mps/CSGiyFmp0l9ArhgxhQE0Dqsn9OO5pe5iWR899O06DT79MLsgs93cLKSECIHYWDz6
         cgpA==
X-Gm-Message-State: ABuFfojWRl53wXbTdcMx+w40c4TBZ/2r6FKm5XcbQEps0307xr1bh+Lq
        r5bwZ16K8Xxz5jOyF5efvRYhWg==
X-Google-Smtp-Source: ACcGV63tRSD9V1fwZst7fig9+l8ru6CYcqjeQOsEGE4QSq5xyHVvOZmZZA/zDZcDwXtiTXMrJGT6LA==
X-Received: by 2002:adf:f712:: with SMTP id r18-v6mr33850242wrp.85.1539953797389;
        Fri, 19 Oct 2018 05:56:37 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x17-v6sm21036277wrs.84.2018.10.19.05.56.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Oct 2018 05:56:36 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: move mt76x02_mac_set_short_preamble in mt76x02_mac.c
Date:   Fri, 19 Oct 2018 14:56:24 +0200
Message-Id: <764e18b4b109bafa9bb0cc1f270cad61b3509817.1539953578.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539953578.git.lorenzo.bianconi@redhat.com>
References: <cover.1539953578.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_mac_set_short_preamble routine in mt76x02-lib module
since it is shared between mt76x0 and mt76x2 drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 8 --------
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 9 +++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   | 1 +
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 57e15c8ced7e..ded0ad623723 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -76,14 +76,6 @@ void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
 		mt76_wr(dev, MT_CCK_PROT_CFG + i * 4, prot[i]);
 }
 
-void mt76x0_mac_set_short_preamble(struct mt76x02_dev *dev, bool short_preamb)
-{
-	if (short_preamb)
-		mt76_set(dev, MT_AUTO_RSP_CFG, MT_AUTO_RSP_PREAMB_SHORT);
-	else
-		mt76_clear(dev, MT_AUTO_RSP_CFG, MT_AUTO_RSP_PREAMB_SHORT);
-}
-
 void mt76x0_mac_config_tsf(struct mt76x02_dev *dev, bool enable, int interval)
 {
 	u32 val = mt76_rr(dev, MT_BEACON_TIME_CFG);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index fdffbdf90e59..a61b23239cb2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -112,7 +112,7 @@ void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 					   info->ht_operation_mode);
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE)
-		mt76x0_mac_set_short_preamble(dev, info->use_short_preamble);
+		mt76x02_mac_set_short_preamble(dev, info->use_short_preamble);
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		int slottime = info->use_short_slot ? 9 : 20;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 282814cbcc12..9cdecb9bfc64 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -82,7 +82,6 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on);
 /* MAC */
 void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
 				int ht_mode);
-void mt76x0_mac_set_short_preamble(struct mt76x02_dev *dev, bool short_preamb);
 void mt76x0_mac_config_tsf(struct mt76x02_dev *dev, bool enable, int interval);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index ccc7f532ceba..f21bf0af8937 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -213,6 +213,15 @@ void mt76x02_mac_wcid_set_rate(struct mt76x02_dev *dev, struct mt76_wcid *wcid,
 	spin_unlock_bh(&dev->mt76.lock);
 }
 
+void mt76x02_mac_set_short_preamble(struct mt76x02_dev *dev, bool enable)
+{
+	if (enable)
+		mt76_set(dev, MT_AUTO_RSP_CFG, MT_AUTO_RSP_PREAMB_SHORT);
+	else
+		mt76_clear(dev, MT_AUTO_RSP_CFG, MT_AUTO_RSP_PREAMB_SHORT);
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_set_short_preamble);
+
 bool mt76x02_mac_load_tx_status(struct mt76x02_dev *dev,
 				struct mt76x02_tx_status *stat)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 81c16aef6a94..55b3a49ba77a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -200,6 +200,7 @@ mt76x02_skb_tx_info(struct sk_buff *skb)
 
 void mt76x02_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq);
 
+void mt76x02_mac_set_short_preamble(struct mt76x02_dev *dev, bool enable);
 int mt76x02_mac_shared_key_setup(struct mt76x02_dev *dev, u8 vif_idx,
 				 u8 key_idx, struct ieee80211_key_conf *key);
 int mt76x02_mac_wcid_set_key(struct mt76x02_dev *dev, u8 idx,
-- 
2.17.2

