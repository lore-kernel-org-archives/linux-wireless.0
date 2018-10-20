Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3BDC67863
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22FA32150F
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22FA32150F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbeJTSYM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:24:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44018 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbeJTSYM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:24:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id n1-v6so39852258wrt.10
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ma9rpMeLvYyw44VtGjGEYRwhriYQ1DeVNzThaRaB5WY=;
        b=QB0tzVuzYzqhX1d5xOeFqTnRuhcHN4dvvvgOUft6lVQ6MwrBijFv6NEcIqJxt3QW11
         Qq7cGrrV8mvAJwctRjRnJ/OYA6qRujmERuRWvkNWDUiMLjxyCzCTSbBK7L7NYIqOVp76
         Iedf+MONVDQO/DrrOh24OkoV6tha5xERnpvy4CQWnNC1zJZXGpOmT4UTApS/414QKzLQ
         bKfKiz3K3vEdxe7o7SnZsZQBnruJbFP/9mkI9OShgJRBpmjhfaIRgXt4whplhPIwFJMQ
         JjzvWWwcbrEE/cwxsaPXBIXOU9rFP+/A2dKukPTp0TUkosIQadPsFJTMPOvGO7lXso+g
         NZQQ==
X-Gm-Message-State: ABuFfojD0TX9qP1ildv96tjzLjtXdDQboN4NMmWlOnjcAGAZ+cyeEjOB
        uR6q+n9jHXYmqHY+87N8XADA9+lRJzk=
X-Google-Smtp-Source: ACcGV62PUZpJ8BoR9rIWTyIcm+JfBi+9UCtEGl4YLT3Uflht5fPlf/yCWXBKOkycKz8eJiiDeV80NA==
X-Received: by 2002:adf:f44b:: with SMTP id f11-v6mr36421595wrp.305.1540030450825;
        Sat, 20 Oct 2018 03:14:10 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id c2-v6sm19548631wrt.77.2018.10.20.03.14.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:14:10 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 9/9] mt76x0: pci: enable AP support
Date:   Sat, 20 Oct 2018 12:13:32 +0200
Message-Id: <78c19ed61fd24b9d2fc8ba2cde3a05a7cb787462.1540029458.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
References: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
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
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 --
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 17 ++++++++++
 4 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index ded0ad623723..78d15cb006e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -75,23 +75,3 @@ void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
 	for (i = 0; i < 6; i++)
 		mt76_wr(dev, MT_CCK_PROT_CFG + i * 4, prot[i]);
 }
-
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
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 5747d72bd13a..3dff198bbccd 100644
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
index 2f3abbe491c5..5b4f30225dc1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -78,6 +78,4 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on);
 /* MAC */
 void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
 				int ht_mode);
-void mt76x0_mac_config_tsf(struct mt76x02_dev *dev, bool enable, int interval);
-
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 4deaf7f7c4f7..08412bbf7dcb 100644
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
2.19.1

