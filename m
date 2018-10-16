Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B6FC5ACCC
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9BC22145D
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:24:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9BC22145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbeJQFQ2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 01:16:28 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:40139 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbeJQFQ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 01:16:27 -0400
Received: by mail-wr1-f49.google.com with SMTP id d2-v6so27244962wro.7
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 14:24:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=99bKQ7Vd7zNrmmZZ8z0xyJLGmHgGtN5kN9clPAsZZ2Q=;
        b=ifDuzzFKZmwHODoPsZNs+uP6azwhbFMbti4M2GU+FXjVltXDh+xjFo/UuVXRIPuipO
         fTWVp9EKqWOtThLQemTV9Dsl8t4ftOkVqrtIQppswSJM6fge8hg8mMTddjoGzcrQ2Kij
         aG8HD/kLmJBNCC9lin7scFGgKwWf7oda+AqMycOEOfSBR+e4rrYLLvpI3RHUdP/+HHUE
         TL5RpAmmd030UzBrxw58wZDz3Vx+E8KXbYtbg+wFliNwhWXRz/CmS6khl1FmnFiBppSv
         5P8bfyZDExo1fK2g7VEkMmqft7oxkILqY4IX8dEA64VCx20KP8OMinOoLpnddFhVAW6U
         GVAw==
X-Gm-Message-State: ABuFfojaHK6ak2LDWTk2ACdzIfK1mxZm37V0Gqc2D4cUaes28rI96E1n
        R4sQSpIw9vnLm9JUjpPPK8p5X3279SE=
X-Google-Smtp-Source: ACcGV62JmdM3C1GUIr97VVSHuu2QBQe8L5Lv5ayFFCjYWmeHTRoOBhYeMUCnx9ZXZKVa4JRzgf/vrQ==
X-Received: by 2002:a5d:4dd2:: with SMTP id f18-v6mr22088690wru.80.1539725048308;
        Tue, 16 Oct 2018 14:24:08 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id 193-v6sm14390046wmj.21.2018.10.16.14.24.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Oct 2018 14:24:07 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 9/9] mt76x0: pci: enable AP support
Date:   Tue, 16 Oct 2018 23:23:31 +0200
Message-Id: <a69d12d28c6f9ed69ba6f41a36b364320f726488.1539723134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
References: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add missing mac80211 callbacks to mt76x0e_ops data structure
and add mt76x02_beacon utility routines in mt76x0_bss_info_changed
in order to enable/disable beacon transmission

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   | 20 ------------
 .../net/wireless/mediatek/mt76/mt76x0/main.c  | 32 +++++++++----------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  1 -
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 17 ++++++++++
 4 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 98d4a97f0a72..fa7f59a14a77 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -85,26 +85,6 @@ void mt76x0_mac_set_short_preamble(struct mt76x02_dev *dev, bool short_preamb)
 		mt76_clear(dev, MT_AUTO_RSP_CFG, MT_AUTO_RSP_PREAMB_SHORT);
 }
 
-void mt76x0_mac_config_tsf(struct mt76x02_dev *dev, bool enable, int interval)
-{
-	u32 val = mt76_rr(dev, MT_BEACON_TIME_CFG);
-
-	val &= ~(MT_BEACON_TIME_CFG_TIMER_EN |
-		 MT_BEACON_TIME_CFG_SYNC_MODE |
-		 MT_BEACON_TIME_CFG_TBTT_EN);
-
-	if (!enable) {
-		mt76_wr(dev, MT_BEACON_TIME_CFG, val);
-		return;
-	}
-
-	val &= ~MT_BEACON_TIME_CFG_INTVAL;
-	val |= FIELD_PREP(MT_BEACON_TIME_CFG_INTVAL, interval << 4) |
-		MT_BEACON_TIME_CFG_TIMER_EN |
-		MT_BEACON_TIME_CFG_SYNC_MODE |
-		MT_BEACON_TIME_CFG_TBTT_EN;
-}
-
 void mt76x0_mac_set_ampdu_factor(struct mt76x02_dev *dev)
 {
 	struct ieee80211_sta *sta;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 4435d8e65a00..50ef97444b58 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -72,30 +72,23 @@ int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 }
 EXPORT_SYMBOL_GPL(mt76x0_config);
 
-static void
-mt76x0_addr_wr(struct mt76x02_dev *dev, const u32 offset, const u8 *addr)
-{
-	mt76_wr(dev, offset, get_unaligned_le32(addr));
-	mt76_wr(dev, offset + 4, addr[4] | addr[5] << 8);
-}
-
 void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_bss_conf *info, u32 changed)
 {
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 	struct mt76x02_dev *dev = hw->priv;
 
 	mutex_lock(&dev->mt76.mutex);
 
-	if (changed & BSS_CHANGED_BSSID) {
-		mt76x0_addr_wr(dev, MT_MAC_BSSID_DW0, info->bssid);
+	if (changed & BSS_CHANGED_BSSID)
+		mt76x02_mac_set_bssid(dev, mvif->idx, info->bssid);
 
-		/* Note: this is a hack because beacon_int is not changed
-		 *	 on leave nor is any more appropriate event generated.
-		 *	 rt2x00 doesn't seem to be bothered though.
-		 */
-		if (is_zero_ether_addr(info->bssid))
-			mt76x0_mac_config_tsf(dev, false, 0);
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+		tasklet_disable(&dev->pre_tbtt_tasklet);
+		mt76x02_mac_set_beacon_enable(dev, mvif->idx,
+					      info->enable_beacon);
+		tasklet_enable(&dev->pre_tbtt_tasklet);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
@@ -106,8 +99,13 @@ void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 		mt76_wr(dev, MT_LG_FBK_CFG1, 0x00002100);
 	}
 
-	if (changed & BSS_CHANGED_BEACON_INT)
-		mt76x0_mac_config_tsf(dev, true, info->beacon_int);
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
+			       MT_BEACON_TIME_CFG_INTVAL,
+			       info->beacon_int << 4);
+		dev->beacon_int = info->beacon_int;
+		dev->tbtt_count = 0;
+	}
 
 	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
 		mt76x0_mac_set_protection(dev, info->use_cts_prot,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 79c70c74d5d4..33d5ed47b5de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -67,7 +67,6 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on);
 void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
 				int ht_mode);
 void mt76x0_mac_set_short_preamble(struct mt76x02_dev *dev, bool short_preamb);
-void mt76x0_mac_config_tsf(struct mt76x02_dev *dev, bool enable, int interval);
 void mt76x0_mac_set_ampdu_factor(struct mt76x02_dev *dev);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 3e51c92c212b..33b6af55b6ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -68,6 +68,19 @@ static void mt76x0e_stop(struct ieee80211_hw *hw)
 	mutex_unlock(&dev->mt76.mutex);
 }
 
+static void
+mt76x0e_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+	      u32 queues, bool drop)
+{
+}
+
+static int
+mt76x0e_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		bool set)
+{
+	return 0;
+}
+
 static const struct ieee80211_ops mt76x0e_ops = {
 	.tx = mt76x02_tx,
 	.start = mt76x0e_start,
@@ -76,6 +89,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.remove_interface = mt76x02_remove_interface,
 	.config = mt76x0_config,
 	.configure_filter = mt76x02_configure_filter,
+	.bss_info_changed = mt76x0_bss_info_changed,
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x02_set_key,
@@ -87,6 +101,9 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.get_survey = mt76_get_survey,
 	.get_txpower = mt76x02_get_txpower,
+	.flush = mt76x0e_flush,
+	.set_tim = mt76x0e_set_tim,
+	.release_buffered_frames = mt76_release_buffered_frames,
 };
 
 static int mt76x0e_register_device(struct mt76x02_dev *dev)
-- 
2.19.0

