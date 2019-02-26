Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2184AC10F16
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA6AA2147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="tYhDXevp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfBZJ3u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:29:50 -0500
Received: from nbd.name ([46.4.11.11]:60906 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbfBZJ3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:29:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kJ+qNvHmnTBGtVQm8xqqC31HjshjbS02NBd8BjwyD0Q=; b=tYhDXevp4jAqDpJni06i5OFtEN
        Jaz/tMLjBIG8HVa7SRAwH7CUBGSxAfUEIm5kMq+Tkr5ptjTzr8JW52YjOHTZXEyPAK7L2gG+hj5h3
        42NhVOlOK3kTp1DDcgTOQK1fLSpsk9QKYR7b4WFfnvWPAD9nJLKjn/z5bqZjS7A9abQI=;
Received: by maeck.lan (Postfix, from userid 501)
        id BDC985047CF8; Tue, 26 Feb 2019 10:29:45 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] mt76: mt76x02: fix ED/CCA enabling/disabling
Date:   Tue, 26 Feb 2019 10:29:43 +0100
Message-Id: <20190226092945.54738-6-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190226092945.54738-1-nbd@nbd.name>
References: <20190226092945.54738-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ED/CCA needs to be disable before stopping the MAC to avoid hangs from tx
being blocked. It must only be enabled again after the MAC has been started
again.
In many places this wasn't done properly, so fix this by always clearing
the relevant ED/CCA bits in mt76x2_mac_stop and set it up again after
channel change or calibration is done

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c     | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c     | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c      | 6 +-----
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.c      | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c  | 7 ++-----
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c  | 6 ++----
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 3 +--
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c  | 1 +
 8 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index a529ce111c20..bcb72e019fd2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -187,6 +187,8 @@ void mt76x0_mac_stop(struct mt76x02_dev *dev)
 {
 	int i = 200, ok = 0;
 
+	mt76_clear(dev, MT_TXOP_CTRL_CFG, MT_TXOP_ED_CCA_EN);
+
 	/* Page count on TxQ */
 	while (i-- && ((mt76_rr(dev, 0x0438) & 0xffffffff) ||
 		       (mt76_rr(dev, 0x0a30) & 0x000000ff) ||
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index a803a9b6a4c5..fee16ab21edb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -34,6 +34,8 @@ mt76x0_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
 	mt76_rr(dev, MT_CH_IDLE);
 	mt76_rr(dev, MT_CH_BUSY);
 
+	mt76x02_edcca_init(dev, true);
+
 	if (mt76_is_mmio(dev)) {
 		mt76x02_dfs_init_params(dev);
 		tasklet_enable(&dev->pre_tbtt_tasklet);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 3467a32f5fda..1fd22eb841c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -1007,17 +1007,13 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 
 	/* enable vco */
 	mt76x0_rf_set(dev, MT_RF(0, 4), BIT(7));
-	if (scan) {
-		mt76x02_edcca_init(dev, false);
+	if (scan)
 		return 0;
-	}
 
 	mt76x02_init_agc_gain(dev);
 	mt76x0_phy_calibrate(dev, false);
 	mt76x0_phy_set_txpower(dev);
 
-	mt76x02_edcca_init(dev, true);
-
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
index e25905c91ee2..e99d4c9bd428 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
@@ -23,6 +23,9 @@ void mt76x2_mac_stop(struct mt76x02_dev *dev, bool force)
 	u32 rts_cfg;
 	int i;
 
+	mt76_clear(dev, MT_TXOP_CTRL_CFG, MT_TXOP_ED_CCA_EN);
+	mt76_clear(dev, MT_TXOP_HLDR_ET, MT_TXOP_HLDR_TX40M_BLK_EN);
+
 	mt76_wr(dev, MT_MAC_SYS_CTRL, 0);
 
 	rts_cfg = mt76_rr(dev, MT_TX_RTS_CFG);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 97ec575699d0..cc1aebcb0696 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -74,6 +74,7 @@ mt76x2_phy_channel_calibrate(struct mt76x02_dev *dev, bool mac_stopped)
 		mt76x2_mac_resume(dev);
 
 	mt76x2_apply_gain_adj(dev);
+	mt76x02_edcca_init(dev, true);
 
 	dev->cal.channel_cal_done = true;
 }
@@ -240,10 +241,8 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 	mt76_wr(dev, MT_BBP(AGC, 2), 0x00007070);
 	mt76_wr(dev, MT_TXOP_CTRL_CFG, 0x04101B3F);
 
-	if (scan) {
-		mt76x02_edcca_init(dev, false);
+	if (scan)
 		return 0;
-	}
 
 	mt76x2_phy_channel_calibrate(dev, true);
 	mt76x02_init_agc_gain(dev);
@@ -256,8 +255,6 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 			       0x38);
 	}
 
-	mt76x02_edcca_init(dev, true);
-
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
index db2194a92e67..361eb4fb979d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
@@ -143,8 +143,8 @@ int mt76x2u_mac_stop(struct mt76x02_dev *dev)
 	rts_cfg = mt76_rr(dev, MT_TX_RTS_CFG);
 	mt76_wr(dev, MT_TX_RTS_CFG, rts_cfg & ~MT_TX_RTS_CFG_RETRY_LIMIT);
 
-	mt76_clear(dev, MT_TXOP_CTRL_CFG, BIT(20));
-	mt76_clear(dev, MT_TXOP_HLDR_ET, BIT(1));
+	mt76_clear(dev, MT_TXOP_CTRL_CFG, MT_TXOP_ED_CCA_EN);
+	mt76_clear(dev, MT_TXOP_HLDR_ET, MT_TXOP_HLDR_TX40M_BLK_EN);
 
 	/* wait tx dma to stop */
 	for (i = 0; i < 2000; i++) {
@@ -217,6 +217,4 @@ void mt76x2u_mac_resume(struct mt76x02_dev *dev)
 	mt76_wr(dev, MT_MAC_SYS_CTRL,
 		MT_MAC_SYS_CTRL_ENABLE_TX |
 		MT_MAC_SYS_CTRL_ENABLE_RX);
-	mt76_set(dev, MT_TXOP_CTRL_CFG, BIT(20));
-	mt76_set(dev, MT_TXOP_HLDR_ET, BIT(1));
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 10633b8de8e8..9b438adfc56c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -57,13 +57,12 @@ mt76x2u_set_channel(struct mt76x02_dev *dev,
 
 	mt76_set_channel(&dev->mt76);
 
-	mt76_clear(dev, MT_TXOP_CTRL_CFG, BIT(20));
-	mt76_clear(dev, MT_TXOP_HLDR_ET, BIT(1));
 	mt76x2_mac_stop(dev, false);
 
 	err = mt76x2u_phy_set_channel(dev, chandef);
 
 	mt76x2u_mac_resume(dev);
+	mt76x02_edcca_init(dev, true);
 
 	clear_bit(MT76_RESET, &dev->mt76.state);
 	mt76_txq_schedule_all(&dev->mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index 11d414d86c68..c8b4a17302da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -45,6 +45,7 @@ mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev, bool mac_stopped)
 	if (!mac_stopped)
 		mt76x2u_mac_resume(dev);
 	mt76x2_apply_gain_adj(dev);
+	mt76x02_edcca_init(dev, true);
 
 	dev->cal.channel_cal_done = true;
 }
-- 
2.17.0

