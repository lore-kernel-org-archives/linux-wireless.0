Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBACC67863
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2547A214C4
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2547A214C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbeJTSvI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:51:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39770 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbeJTSvH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:51:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id 61-v6so39904222wrb.6
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:41:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sZJRHKG4rcwYMAIsMkacZWKspW8vBqCxEv5cnoOkiMw=;
        b=lL/OBpeKTTc6i49d0jvdjjhYmVgu+w/8NJJfV3oXMhIJkw7OmPGOdmME6e4fGZnip0
         cOFY9x3YYrz0yNsVOsmXbDrKayCtPCFAxyEZ2YZ3KQPJoOkGGY8lHPmTV49JhMzghPlv
         qbpvLrUp3DGBfewK5LKr3LZrky1FZiqWAlYzD6AfHrN9koPE0T0MYFTXB0M+mQ3WULdc
         52bT4X9/ZX+pnhJfH3lEYqCD0ZpHDGpsCsQEnnWXnXQbCTZTMouA73HUm0Nh+CgE/+SY
         F1iQJ63wSw3kp0/tgzm0WnDTAK28cCn4aQbQoPMzdFA33AbiPj6a2idTESC9quwljeLN
         fi5w==
X-Gm-Message-State: ABuFfohevHRuYBTCZZxf83EAX5IpVtf5eul3DP1Q7ftr1dFG1GstpKWI
        hbA2qKH2mzbcsrR/yX0iAMY7QQ==
X-Google-Smtp-Source: ACcGV61wN44+LjBX3U7kRP7yRBximm7H2YEEIAOpmqa3hbjvs6N8MNz+WfRhM12YGspxIuOkmk8RRA==
X-Received: by 2002:adf:9c0a:: with SMTP id f10-v6mr38599414wrc.93.1540032065591;
        Sat, 20 Oct 2018 03:41:05 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id x17-v6sm23205207wrs.84.2018.10.20.03.41.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:41:05 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mt76: move mt76x02_set_tx_ackto in mt76x02-lib module
Date:   Sat, 20 Oct 2018 12:40:52 +0200
Message-Id: <3af5f7d9074f884974a4623a2c8d4b5011b571ae.1540031637.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540031637.git.lorenzo.bianconi@redhat.com>
References: <cover.1540031637.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_set_tx_ackto and mt76x02_set_coverage_class routines
in mt76x02-lib module in order to be reused by mt76x0 driver.
This is a preliminary patch to unify drv_bss_info_changed mac80211
callback between mt76x0 and mt76x2 drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  4 +--
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  3 ++
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 30 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 19 +-----------
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  | 15 ++--------
 7 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 3dff198bbccd..8de19fe534a3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -117,8 +117,8 @@ void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		int slottime = info->use_short_slot ? 9 : 20;
 
-		mt76_rmw_field(dev, MT_BKOFF_SLOT_CFG,
-			       MT_BKOFF_SLOT_CFG_SLOTTIME, slottime);
+		dev->slottime = slottime;
+		mt76x02_set_tx_ackto(dev);
 	}
 
 	mutex_unlock(&dev->mt76.mutex);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 08412bbf7dcb..b16227fdbdc4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -104,6 +104,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.flush = mt76x0e_flush,
 	.set_tim = mt76x0e_set_tim,
 	.release_buffered_frames = mt76_release_buffered_frames,
+	.set_coverage_class = mt76x02_set_coverage_class,
 };
 
 static int mt76x0e_register_device(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index a4141265d7a9..95af2b1c7eed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -133,6 +133,9 @@ s8 mt76x02_tx_get_max_txpwr_adj(struct mt76x02_dev *dev,
 s8 mt76x02_tx_get_txpwr_adj(struct mt76x02_dev *dev, s8 txpwr,
 			    s8 max_txpwr_adj);
 void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr);
+void mt76x02_set_tx_ackto(struct mt76x02_dev *dev);
+void mt76x02_set_coverage_class(struct ieee80211_hw *hw,
+				s16 coverage_class);
 int mt76x02_insert_hdr_pad(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
 void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 2a81d2fc5d4d..c485f6600ae9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -438,6 +438,36 @@ int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_conf_tx);
 
+void mt76x02_set_tx_ackto(struct mt76x02_dev *dev)
+{
+	u8 ackto, sifs, slottime = dev->slottime;
+
+	/* As defined by IEEE 802.11-2007 17.3.8.6 */
+	slottime += 3 * dev->coverage_class;
+	mt76_rmw_field(dev, MT_BKOFF_SLOT_CFG,
+		       MT_BKOFF_SLOT_CFG_SLOTTIME, slottime);
+
+	sifs = mt76_get_field(dev, MT_XIFS_TIME_CFG,
+			      MT_XIFS_TIME_CFG_OFDM_SIFS);
+
+	ackto = slottime + sifs;
+	mt76_rmw_field(dev, MT_TX_TIMEOUT_CFG,
+		       MT_TX_TIMEOUT_CFG_ACKTO, ackto);
+}
+EXPORT_SYMBOL_GPL(mt76x02_set_tx_ackto);
+
+void mt76x02_set_coverage_class(struct ieee80211_hw *hw,
+				s16 coverage_class)
+{
+	struct mt76x02_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mt76.mutex);
+	dev->coverage_class = coverage_class;
+	mt76x02_set_tx_ackto(dev);
+	mutex_unlock(&dev->mt76.mutex);
+}
+EXPORT_SYMBOL_GPL(mt76x02_set_coverage_class);
+
 void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 0c323a0762e8..3f0b9c78625d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -58,7 +58,6 @@ int mt76x2_init_hardware(struct mt76x02_dev *dev);
 void mt76x2_stop_hardware(struct mt76x02_dev *dev);
 int mt76x2_eeprom_init(struct mt76x02_dev *dev);
 int mt76x2_apply_calibration_data(struct mt76x02_dev *dev, int channel);
-void mt76x2_set_tx_ackto(struct mt76x02_dev *dev);
 
 void mt76x2_phy_set_antenna(struct mt76x02_dev *dev);
 int mt76x2_phy_start(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index f561f5916625..41c0cb62a919 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -153,7 +153,7 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 		MT_CH_TIME_CFG_EIFS_AS_BUSY |
 		FIELD_PREP(MT_CH_TIME_CFG_CH_TIMER_CLR, 1));
 
-	mt76x2_set_tx_ackto(dev);
+	mt76x02_set_tx_ackto(dev);
 
 	return 0;
 }
@@ -260,23 +260,6 @@ mt76x2_power_on(struct mt76x02_dev *dev)
 	mt76x2_power_on_rf(dev, 1);
 }
 
-void mt76x2_set_tx_ackto(struct mt76x02_dev *dev)
-{
-	u8 ackto, sifs, slottime = dev->slottime;
-
-	/* As defined by IEEE 802.11-2007 17.3.8.6 */
-	slottime += 3 * dev->coverage_class;
-	mt76_rmw_field(dev, MT_BKOFF_SLOT_CFG,
-		       MT_BKOFF_SLOT_CFG_SLOTTIME, slottime);
-
-	sifs = mt76_get_field(dev, MT_XIFS_TIME_CFG,
-			      MT_XIFS_TIME_CFG_OFDM_SIFS);
-
-	ackto = slottime + sifs;
-	mt76_rmw_field(dev, MT_TX_TIMEOUT_CFG,
-		       MT_TX_TIMEOUT_CFG_ACKTO, ackto);
-}
-
 int mt76x2_init_hardware(struct mt76x02_dev *dev)
 {
 	int ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index b2c599d4d670..f984bb0f9aa1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -158,7 +158,7 @@ mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		int slottime = info->use_short_slot ? 9 : 20;
 
 		dev->slottime = slottime;
-		mt76x2_set_tx_ackto(dev);
+		mt76x02_set_tx_ackto(dev);
 	}
 
 	mutex_unlock(&dev->mt76.mutex);
@@ -170,17 +170,6 @@ mt76x2_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 }
 
-static void mt76x2_set_coverage_class(struct ieee80211_hw *hw,
-				      s16 coverage_class)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	mutex_lock(&dev->mt76.mutex);
-	dev->coverage_class = coverage_class;
-	mt76x2_set_tx_ackto(dev);
-	mutex_unlock(&dev->mt76.mutex);
-}
-
 static int
 mt76x2_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
 {
@@ -257,7 +246,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.release_buffered_frames = mt76_release_buffered_frames,
-	.set_coverage_class = mt76x2_set_coverage_class,
+	.set_coverage_class = mt76x02_set_coverage_class,
 	.get_survey = mt76_get_survey,
 	.set_tim = mt76x2_set_tim,
 	.set_antenna = mt76x2_set_antenna,
-- 
2.19.1

