Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7402CECDE3D
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C85B2150F
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C85B2150F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbeJTSYB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:24:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39684 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbeJTSYB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:24:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id y144-v6so5817658wmd.4
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/waZ3Dz6g3gfncL0FSy8ALuVp33X2jkn+QsV0vHy7mc=;
        b=XlKQKGUlvJQHyj+fMYzi6R7Z3YLpQ0kZCwoSeLf1gGOZUVIBvo1BSwgHqkNd2aFHpZ
         jzDXlEanPQJvARWQzT/7YAOBE2wlXQfFsxTg+mMgIYZ/H21jgcchhnkpD+UWFYma5a/R
         ETzsa7+mMp99UuHVC5UUSDoUvlCrTZGz/nGbvXlPtYLqvN4Hz5THpwOR4+H7zizykCUa
         yGxbLW3JbaHig1QVEoT9Z84ec3uqHh5+LF0wTHULpHOFdIdIljsUeu5DVqcQMAaMgIbe
         /yY+9yt8+yvZYIQVZXe4SCg+6JnwSPBr+SiwBm2dw87OiYvsYnyQUfJu5Bwqmidnd73q
         GC6w==
X-Gm-Message-State: ABuFfohJXDyWB2NYcPfR1qb49aVn8OBep5oGDBpAShexJQ5TdtkvoI7N
        76/M2m2eaWFYVa+l3CELPeqDnfd6lo8=
X-Google-Smtp-Source: ACcGV60BQiMygM6gbTmqkxwGfAYAdIuS3OV8VQQykyrRZYoLW56fvKN7iHs42+9zmmPtWPiKsEyrKQ==
X-Received: by 2002:a1c:ce47:: with SMTP id e68-v6mr8090475wmg.45.1540030444022;
        Sat, 20 Oct 2018 03:14:04 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id c2-v6sm19548631wrt.77.2018.10.20.03.14.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:14:03 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 5/9] mt76: move mt76x02_sw_scan and mt76x02_sw_scan_complete in mt76x02-lib module
Date:   Sat, 20 Oct 2018 12:13:28 +0200
Message-Id: <7ead0076cb358923bfd7723676ca6cf3b53f4e1a.1540029458.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
References: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
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
index da98382bdb5a..5747d72bd13a 100644
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
index 9cdecb9bfc64..2f3abbe491c5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -65,10 +65,6 @@ int mt76x0_config(struct ieee80211_hw *hw, u32 changed);
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
index f15f9bf14900..7f506975c9b9 100644
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
index 245eb4aa9764..8640ddf0e594 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -150,8 +150,8 @@ static const struct ieee80211_ops mt76x0u_ops = {
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
2.19.1

