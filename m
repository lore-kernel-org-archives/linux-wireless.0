Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615DDC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3294F21904
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Zvl2FKD2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfBGNrf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 08:47:35 -0500
Received: from nbd.name ([46.4.11.11]:47496 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727002AbfBGNrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 08:47:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8Hcu07d8pWFNiSFaBvX8AQWE3nHuFp/rnBrZlAm1SRA=; b=Zvl2FKD22zF/+0mfkZZa0FdIWd
        7kAfxxZ2QKsExSfUQXhiRCJQPi9WZywadNAzYfuWmpYWlrdA7uIXMgOpekfuDsdoeMe2wc9oRfmz0
        YylGPDC7lkY24qnmV786GPj1YgRXNC9zZw4OPd/iNpoEoIe2zwyRnbW8TmRYpPUeVY+o=;
Received: by maeck.lan (Postfix, from userid 501)
        id 7F8614F0BF95; Thu,  7 Feb 2019 14:47:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] mt76: explicitly disable energy detect cca during scan
Date:   Thu,  7 Feb 2019 14:47:19 +0100
Message-Id: <20190207134723.59163-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190207134723.59163-1-nbd@nbd.name>
References: <20190207134723.59163-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Avoid reusing the previous channel's tx blocking state

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c     | 6 ++++--
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c    | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c    | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h    | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c | 6 ++++--
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 5a4c6f34267e..66b22bd7b4b4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -1006,14 +1006,16 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 
 	/* enable vco */
 	mt76x0_rf_set(dev, MT_RF(0, 4), BIT(7));
-	if (scan)
+	if (scan) {
+		mt76x02_edcca_init(dev, false);
 		return 0;
+	}
 
 	mt76x02_init_agc_gain(dev);
 	mt76x0_phy_calibrate(dev, false);
 	mt76x0_phy_set_txpower(dev);
 
-	mt76x02_edcca_init(dev);
+	mt76x02_edcca_init(dev, true);
 
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
index 19fdcab746a0..e4649103efd4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
@@ -886,7 +886,7 @@ mt76x02_dfs_set_domain(struct mt76x02_dev *dev,
 		tasklet_disable(&dfs_pd->dfs_tasklet);
 
 		dev->ed_monitor = region == NL80211_DFS_ETSI;
-		mt76x02_edcca_init(dev);
+		mt76x02_edcca_init(dev, true);
 
 		dfs_pd->region = region;
 		mt76x02_dfs_init_params(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 6bd7f87644a4..636e69a7a407 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -891,12 +891,12 @@ mt76x02_edcca_tx_enable(struct mt76x02_dev *dev, bool enable)
 	dev->ed_tx_blocked = !enable;
 }
 
-void mt76x02_edcca_init(struct mt76x02_dev *dev)
+void mt76x02_edcca_init(struct mt76x02_dev *dev, bool enable)
 {
 	dev->ed_trigger = 0;
 	dev->ed_silent = 0;
 
-	if (dev->ed_monitor) {
+	if (dev->ed_monitor && enable) {
 		struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 		u8 ed_th = chan->band == NL80211_BAND_5GHZ ? 0x0e : 0x20;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 3b04b1bd0abd..6b1f25d2f64c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -207,5 +207,5 @@ int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
 				   struct ieee80211_vif *vif, bool val);
 
-void mt76x02_edcca_init(struct mt76x02_dev *dev);
+void mt76x02_edcca_init(struct mt76x02_dev *dev, bool enable);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 65ed62229a5b..97ec575699d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -240,8 +240,10 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 	mt76_wr(dev, MT_BBP(AGC, 2), 0x00007070);
 	mt76_wr(dev, MT_TXOP_CTRL_CFG, 0x04101B3F);
 
-	if (scan)
+	if (scan) {
+		mt76x02_edcca_init(dev, false);
 		return 0;
+	}
 
 	mt76x2_phy_channel_calibrate(dev, true);
 	mt76x02_init_agc_gain(dev);
@@ -254,7 +256,7 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 			       0x38);
 	}
 
-	mt76x02_edcca_init(dev);
+	mt76x02_edcca_init(dev, true);
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
-- 
2.17.0

