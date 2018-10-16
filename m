Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CDBC5ACCD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28AFB2145D
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:24:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28AFB2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbeJQFQT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 01:16:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45331 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbeJQFQT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 01:16:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id q5-v6so27243418wrw.12
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 14:24:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=89nyYQ9DfLmgCotmh9SSxmoRtm1CbR6vKVFXN5cML04=;
        b=JTpBXCxjKb9pQSrIF9yMvzj+W0On2wGF80hxOHEPXzuWme1zBHbfN5WP6Zx43bs8rU
         4aXIKR+cbNtYzOVKq9z/3G18rAHCIytSRhpZ+hsZUTJSZPJuPTVB/RozyUEb00bUuA5Y
         ur2egvqch0E32j2LVU1OF+t1BxfbvYbizKE6sjGQP+CMgQHi2k1lcDBVz1ES6GnH3WaG
         wpc4+tPlTcithr0JddOX6lzht5LXBsF+7Ca3cSJoXyU9Dx1qvDs7OIe2VoimcSiHsk78
         B1Yx8vlYdZaX/uw+uI0MEoeNlQ8Mj9OukWKYm67er7eJvjyig6n5c9H1LEUG3gCVqUO9
         ffZA==
X-Gm-Message-State: ABuFfojJFAuiUSaDvyohDB7DUV8PKUuThzRycIRmALoo7kcCbdga3gwj
        JhqXOiRXmbwXqmWiv9ZGzEj0kw==
X-Google-Smtp-Source: ACcGV63XBG824hrBV3fZ8LnaLE1+yEWQY6Q3fNDbcIniUzkQ3S9LPWcODVC8kyhtbZalWS5n4iPdnA==
X-Received: by 2002:adf:e886:: with SMTP id d6-v6mr21472762wrm.7.1539725040032;
        Tue, 16 Oct 2018 14:24:00 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id 193-v6sm14390046wmj.21.2018.10.16.14.23.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Oct 2018 14:23:59 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 5/9] mt76: move mt76x02_sw_scan and mt76x02_sw_scan_complete in mt76x02-lib module
Date:   Tue, 16 Oct 2018 23:23:27 +0200
Message-Id: <23cdac4e7e73a779a300f98ad5321a78dc370e02.1539723134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
References: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_sw_scan and mt76x02_sw_scan_complete utility routines
in mt76x02_util.c in order to be reused by mt76x0 and mt76x2u drivers
and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/main.c  | 18 ---------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  4 ----
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  4 ++--
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  4 ++++
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 22 ++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  | 23 ++-----------------
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  | 21 ++---------------
 8 files changed, 34 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 6fa57cd1c337..4435d8e65a00 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -127,24 +127,6 @@ void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x0_bss_info_changed);
 
-void mt76x0_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		    const u8 *mac_addr)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	set_bit(MT76_SCANNING, &dev->mt76.state);
-}
-EXPORT_SYMBOL_GPL(mt76x0_sw_scan);
-
-void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	clear_bit(MT76_SCANNING, &dev->mt76.state);
-}
-EXPORT_SYMBOL_GPL(mt76x0_sw_scan_complete);
-
 int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
 	struct mt76x02_dev *dev = hw->priv;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 17ad3fa0858b..79c70c74d5d4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -53,10 +53,6 @@ int mt76x0_config(struct ieee80211_hw *hw, u32 changed);
 void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_bss_conf *info, u32 changed);
-void mt76x0_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		    const u8 *mac_addr);
-void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif);
 int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
 
 /* PHY */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 39e1f87c3d2c..5e9160348433 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -80,8 +80,8 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x02_set_key,
 	.conf_tx = mt76x02_conf_tx,
-	.sw_scan_start = mt76x0_sw_scan,
-	.sw_scan_complete = mt76x0_sw_scan_complete,
+	.sw_scan_start = mt76x02_sw_scan,
+	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.ampdu_action = mt76x02_ampdu_action,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.wake_tx_queue = mt76_wake_tx_queue,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index ea517864186b..f7e39b5405fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -151,8 +151,8 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x02_set_key,
 	.conf_tx = mt76x02_conf_tx,
-	.sw_scan_start = mt76x0_sw_scan,
-	.sw_scan_complete = mt76x0_sw_scan_complete,
+	.sw_scan_start = mt76x02_sw_scan,
+	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.ampdu_action = mt76x02_ampdu_action,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.set_rts_threshold = mt76x0_set_rts_threshold,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 1cd0f758587d..0890794c92d7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -147,6 +147,10 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 			   struct sk_buff *skb, struct mt76_queue *q,
 			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			   u32 *tx_info);
+void mt76x02_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		     const u8 *mac);
+void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif);
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 208c76d40afa..bbc2cab4ffdc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -486,6 +486,28 @@ void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len)
 }
 EXPORT_SYMBOL_GPL(mt76x02_remove_hdr_pad);
 
+void mt76x02_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		     const u8 *mac)
+{
+	struct mt76x02_dev *dev = hw->priv;
+
+	if (mt76_is_mmio(dev))
+		tasklet_disable(&dev->pre_tbtt_tasklet);
+	set_bit(MT76_SCANNING, &dev->mt76.state);
+}
+EXPORT_SYMBOL_GPL(mt76x02_sw_scan);
+
+void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif)
+{
+	struct mt76x02_dev *dev = hw->priv;
+
+	clear_bit(MT76_SCANNING, &dev->mt76.state);
+	if (mt76_is_mmio(dev))
+		tasklet_enable(&dev->pre_tbtt_tasklet);
+}
+EXPORT_SYMBOL_GPL(mt76x02_sw_scan_complete);
+
 const u16 mt76x02_beacon_offsets[16] = {
 	/* 1024 byte per beacon */
 	0xc000,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 1b3b9594c2a2..36042331e4b2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -175,25 +175,6 @@ mt76x2_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	mt76x02_mac_wcid_set_drop(dev, idx, ps);
 }
 
-static void
-mt76x2_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-	       const u8 *mac)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	tasklet_disable(&dev->pre_tbtt_tasklet);
-	set_bit(MT76_SCANNING, &dev->mt76.state);
-}
-
-static void
-mt76x2_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	clear_bit(MT76_SCANNING, &dev->mt76.state);
-	tasklet_enable(&dev->pre_tbtt_tasklet);
-}
-
 static void
 mt76x2_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	     u32 queues, bool drop)
@@ -292,8 +273,8 @@ const struct ieee80211_ops mt76x2_ops = {
 	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x02_set_key,
 	.conf_tx = mt76x02_conf_tx,
-	.sw_scan_start = mt76x2_sw_scan,
-	.sw_scan_complete = mt76x2_sw_scan_complete,
+	.sw_scan_start = mt76x02_sw_scan,
+	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.flush = mt76x2_flush,
 	.ampdu_action = mt76x02_ampdu_action,
 	.get_txpower = mt76x2_get_txpower,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 25c43175e6e5..5187a5f4832a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -143,23 +143,6 @@ mt76x2u_config(struct ieee80211_hw *hw, u32 changed)
 	return err;
 }
 
-static void
-mt76x2u_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		const u8 *mac)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	set_bit(MT76_SCANNING, &dev->mt76.state);
-}
-
-static void
-mt76x2u_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	clear_bit(MT76_SCANNING, &dev->mt76.state);
-}
-
 const struct ieee80211_ops mt76x2u_ops = {
 	.tx = mt76x02_tx,
 	.start = mt76x2u_start,
@@ -175,7 +158,7 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.bss_info_changed = mt76x2u_bss_info_changed,
 	.configure_filter = mt76x02_configure_filter,
 	.conf_tx = mt76x02_conf_tx,
-	.sw_scan_start = mt76x2u_sw_scan,
-	.sw_scan_complete = mt76x2u_sw_scan_complete,
+	.sw_scan_start = mt76x02_sw_scan,
+	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 };
-- 
2.19.0

