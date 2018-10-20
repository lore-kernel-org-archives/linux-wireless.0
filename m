Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04722ECDE45
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0BF221529
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0BF221529
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbeJTSvN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:51:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43973 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbeJTSvM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:51:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id n1-v6so39895141wrt.10
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:41:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bCLY34yAL/qI7D0BspZFmNQkeTaTfGlqENNMlMp1G7A=;
        b=a9Pzopo/dZPtEUGZeWbuhSRCTvakqpSqu/nQgF6ce0vjOoB8dSYdLVvt1YS/hH0WXO
         uF+8ObZCts/Jqc5k1uWh9QRL2e+XrqgHoEze/mL2aIa0ZYlT/FR+4RQw8/sLihQn2uAO
         Bf5nNuYl+pCZYH92aqszFGENM3KIaSvcBH3vcEDlDN8dt0mSpdUM4ZK7AZieWqFS//F9
         mDR7h4QkhlSQfi1wX91tL6GXi5wL0//cJFN/JqkuS5T7gBeelvTu/ApeZYRQZyX5PKPg
         W4Hj4m9I6Oe3XC5fI8kFRGA11nNwwLn5JWOK4mgtmbqP9z7PVDveRJkx5JZcsoL5Ssf9
         r0bA==
X-Gm-Message-State: AGRZ1gI9SJ546tXkdjUHE4mNKPY+1FHw4EjRHTWZWhrR1hjU6VDN94jq
        aY9/UVt0pHcp13d80CcRisO8iQ==
X-Google-Smtp-Source: AJdET5eLcIWIEmmWaRkmxRY51EGeSv/Ynif5Ql3f+cBAVrJF0FZjByAjjNzaFLu3pxazjjD8FmWUVQ==
X-Received: by 2002:adf:ef09:: with SMTP id e9-v6mr6882475wro.292.1540032070852;
        Sat, 20 Oct 2018 03:41:10 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id x17-v6sm23205207wrs.84.2018.10.20.03.41.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:41:10 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mt76: move mt76x02_bss_info_changed in mt76x02-lib module
Date:   Sat, 20 Oct 2018 12:40:55 +0200
Message-Id: <0867233fbca5845e8dcb2165a9db23cdce9a0df5.1540031637.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540031637.git.lorenzo.bianconi@redhat.com>
References: <cover.1540031637.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Unify drv_bss_info_changed mac80211 callback and remove duplicated
code in mt76x0 and mt76x2 drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/main.c  | 49 -------------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  3 --
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  3 ++
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 42 ++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  | 39 +--------------
 7 files changed, 48 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index b8eba511d0f3..cd1a1225ad8b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -71,52 +71,3 @@ int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mt76x0_config);
-
-void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif,
-			     struct ieee80211_bss_conf *info, u32 changed)
-{
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
-	struct mt76x02_dev *dev = hw->priv;
-
-	mutex_lock(&dev->mt76.mutex);
-
-	if (changed & BSS_CHANGED_BSSID)
-		mt76x02_mac_set_bssid(dev, mvif->idx, info->bssid);
-
-	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		tasklet_disable(&dev->pre_tbtt_tasklet);
-		mt76x02_mac_set_beacon_enable(dev, mvif->idx,
-					      info->enable_beacon);
-		tasklet_enable(&dev->pre_tbtt_tasklet);
-	}
-
-	if (changed & BSS_CHANGED_BASIC_RATES) {
-		mt76_wr(dev, MT_LEGACY_BASIC_RATE, info->basic_rates);
-		mt76_wr(dev, MT_VHT_HT_FBK_CFG0, 0x65432100);
-		mt76_wr(dev, MT_VHT_HT_FBK_CFG1, 0xedcba980);
-		mt76_wr(dev, MT_LG_FBK_CFG0, 0xedcba988);
-		mt76_wr(dev, MT_LG_FBK_CFG1, 0x00002100);
-	}
-
-	if (changed & BSS_CHANGED_BEACON_INT) {
-		mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
-			       MT_BEACON_TIME_CFG_INTVAL,
-			       info->beacon_int << 4);
-		dev->beacon_int = info->beacon_int;
-		dev->tbtt_count = 0;
-	}
-
-	if (changed & BSS_CHANGED_ERP_PREAMBLE)
-		mt76x02_mac_set_short_preamble(dev, info->use_short_preamble);
-
-	if (changed & BSS_CHANGED_ERP_SLOT) {
-		int slottime = info->use_short_slot ? 9 : 20;
-
-		dev->slottime = slottime;
-		mt76x02_set_tx_ackto(dev);
-	}
-
-	mutex_unlock(&dev->mt76.mutex);
-}
-EXPORT_SYMBOL_GPL(mt76x0_bss_info_changed);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 14ca5937ed97..46629f61673b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -62,9 +62,6 @@ int mt76x0_mac_start(struct mt76x02_dev *dev);
 void mt76x0_mac_stop(struct mt76x02_dev *dev);
 
 int mt76x0_config(struct ieee80211_hw *hw, u32 changed);
-void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif,
-			     struct ieee80211_bss_conf *info, u32 changed);
 
 /* PHY */
 void mt76x0_phy_init(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 0a5b499061e9..757816d2b1ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -89,7 +89,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.remove_interface = mt76x02_remove_interface,
 	.config = mt76x0_config,
 	.configure_filter = mt76x02_configure_filter,
-	.bss_info_changed = mt76x0_bss_info_changed,
+	.bss_info_changed = mt76x02_bss_info_changed,
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x02_set_key,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 690c2e6abaeb..35b98661632a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -145,7 +145,7 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.remove_interface = mt76x02_remove_interface,
 	.config = mt76x0_config,
 	.configure_filter = mt76x02_configure_filter,
-	.bss_info_changed = mt76x0_bss_info_changed,
+	.bss_info_changed = mt76x02_bss_info_changed,
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x02_set_key,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 3b698f0e8b28..d599b7dddac7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -158,6 +158,9 @@ void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
 int mt76x02_get_txpower(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif, int *dbm);
 void mt76x02_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
+void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_bss_conf *info, u32 changed);
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_init_beacon_config(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 65eed824d9c8..4c3b8392b2b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -647,4 +647,46 @@ void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x02_init_beacon_config);
 
+void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_bss_conf *info,
+			      u32 changed)
+{
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
+	struct mt76x02_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	if (changed & BSS_CHANGED_BSSID)
+		mt76x02_mac_set_bssid(dev, mvif->idx, info->bssid);
+
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+		tasklet_disable(&dev->pre_tbtt_tasklet);
+		mt76x02_mac_set_beacon_enable(dev, mvif->idx,
+					      info->enable_beacon);
+		tasklet_enable(&dev->pre_tbtt_tasklet);
+	}
+
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
+			       MT_BEACON_TIME_CFG_INTVAL,
+			       info->beacon_int << 4);
+		dev->beacon_int = info->beacon_int;
+		dev->tbtt_count = 0;
+	}
+
+	if (changed & BSS_CHANGED_ERP_PREAMBLE)
+		mt76x02_mac_set_short_preamble(dev, info->use_short_preamble);
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		int slottime = info->use_short_slot ? 9 : 20;
+
+		dev->slottime = slottime;
+		mt76x02_set_tx_ackto(dev);
+	}
+
+	mutex_unlock(&dev->mt76.mutex);
+}
+EXPORT_SYMBOL_GPL(mt76x02_bss_info_changed);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index f1bd36c46036..ec585b92d6c0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -127,43 +127,6 @@ mt76x2_config(struct ieee80211_hw *hw, u32 changed)
 	return ret;
 }
 
-static void
-mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			struct ieee80211_bss_conf *info, u32 changed)
-{
-	struct mt76x02_dev *dev = hw->priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
-
-	mutex_lock(&dev->mt76.mutex);
-
-	if (changed & BSS_CHANGED_BSSID)
-		mt76x02_mac_set_bssid(dev, mvif->idx, info->bssid);
-
-	if (changed & BSS_CHANGED_BEACON_INT) {
-		mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
-			       MT_BEACON_TIME_CFG_INTVAL,
-			       info->beacon_int << 4);
-		dev->beacon_int = info->beacon_int;
-		dev->tbtt_count = 0;
-	}
-
-	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		tasklet_disable(&dev->pre_tbtt_tasklet);
-		mt76x02_mac_set_beacon_enable(dev, mvif->idx,
-					      info->enable_beacon);
-		tasklet_enable(&dev->pre_tbtt_tasklet);
-	}
-
-	if (changed & BSS_CHANGED_ERP_SLOT) {
-		int slottime = info->use_short_slot ? 9 : 20;
-
-		dev->slottime = slottime;
-		mt76x02_set_tx_ackto(dev);
-	}
-
-	mutex_unlock(&dev->mt76.mutex);
-}
-
 static void
 mt76x2_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	     u32 queues, bool drop)
@@ -218,7 +181,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.remove_interface = mt76x02_remove_interface,
 	.config = mt76x2_config,
 	.configure_filter = mt76x02_configure_filter,
-	.bss_info_changed = mt76x2_bss_info_changed,
+	.bss_info_changed = mt76x02_bss_info_changed,
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x02_set_key,
-- 
2.19.1

