Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB79C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 156372147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="lb68gvkr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfBZJ3s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:29:48 -0500
Received: from nbd.name ([46.4.11.11]:60900 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727565AbfBZJ3r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:29:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QIbCWuHND1tfWXkAFn4p2fPi/dEsc/u2KiZWEC/MWn8=; b=lb68gvkrJTxDzpqsinfI+vbde6
        MvhiiK6RHMRc9eHtD0ZgR1UYzkeiW5XpzzJxCWClusDbAOrjMmy3ydtpZSjGrY+26fzS+kqwdK6Er
        f69yaZVOR3K4FfhYpf6gMaM1Xp3y1VF5AvSE7qusuKnkaEniuud+rHVIdxempnBIm8ns=;
Received: by maeck.lan (Postfix, from userid 501)
        id B76765047CF3; Tue, 26 Feb 2019 10:29:45 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] mt76: mt76x2: unify mt76x2[u]_mac_resume
Date:   Tue, 26 Feb 2019 10:29:44 +0100
Message-Id: <20190226092945.54738-7-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190226092945.54738-1-nbd@nbd.name>
References: <20190226092945.54738-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

They are now the same and short enough to be turned into an inline function

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.h      | 8 +++++++-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h  | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c | 7 -------
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c  | 7 -------
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c  | 2 +-
 6 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
index 4c8e20bce920..42ff221d7706 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
@@ -25,6 +25,12 @@ struct mt76x02_vif;
 
 int mt76x2_mac_start(struct mt76x02_dev *dev);
 void mt76x2_mac_stop(struct mt76x02_dev *dev, bool force);
-void mt76x2_mac_resume(struct mt76x02_dev *dev);
+
+static inline void mt76x2_mac_resume(struct mt76x02_dev *dev)
+{
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_ENABLE_TX |
+		MT_MAC_SYS_CTRL_ENABLE_RX);
+}
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
index 787cdfdf5db5..76cb1f84eff5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
@@ -35,7 +35,6 @@ void mt76x2u_cleanup(struct mt76x02_dev *dev);
 void mt76x2u_stop_hw(struct mt76x02_dev *dev);
 
 int mt76x2u_mac_reset(struct mt76x02_dev *dev);
-void mt76x2u_mac_resume(struct mt76x02_dev *dev);
 int mt76x2u_mac_start(struct mt76x02_dev *dev);
 int mt76x2u_mac_stop(struct mt76x02_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index d4e3d7c11d74..984d9c4c2e1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -173,13 +173,6 @@ int mt76x2_mac_start(struct mt76x02_dev *dev)
 	return 0;
 }
 
-void mt76x2_mac_resume(struct mt76x02_dev *dev)
-{
-	mt76_wr(dev, MT_MAC_SYS_CTRL,
-		MT_MAC_SYS_CTRL_ENABLE_TX |
-		MT_MAC_SYS_CTRL_ENABLE_RX);
-}
-
 static void
 mt76x2_power_on_rf_patch(struct mt76x02_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
index 361eb4fb979d..5e84b4535cb1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
@@ -211,10 +211,3 @@ int mt76x2u_mac_stop(struct mt76x02_dev *dev)
 
 	return 0;
 }
-
-void mt76x2u_mac_resume(struct mt76x02_dev *dev)
-{
-	mt76_wr(dev, MT_MAC_SYS_CTRL,
-		MT_MAC_SYS_CTRL_ENABLE_TX |
-		MT_MAC_SYS_CTRL_ENABLE_RX);
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 9b438adfc56c..2ac78e4dc41a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -61,7 +61,7 @@ mt76x2u_set_channel(struct mt76x02_dev *dev,
 
 	err = mt76x2u_phy_set_channel(dev, chandef);
 
-	mt76x2u_mac_resume(dev);
+	mt76x2_mac_resume(dev);
 	mt76x02_edcca_init(dev, true);
 
 	clear_bit(MT76_RESET, &dev->mt76.state);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index c8b4a17302da..07f67cb6854c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -43,7 +43,7 @@ mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev, bool mac_stopped)
 	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_SHAPING, 0);
 
 	if (!mac_stopped)
-		mt76x2u_mac_resume(dev);
+		mt76x2_mac_resume(dev);
 	mt76x2_apply_gain_adj(dev);
 	mt76x02_edcca_init(dev, true);
 
-- 
2.17.0

