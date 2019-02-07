Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D1EC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 337E121904
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="fLG271tO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfBGNrc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 08:47:32 -0500
Received: from nbd.name ([46.4.11.11]:47498 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727057AbfBGNr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 08:47:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+qYHljwSK1tyjP8jvcA4rsCc4To8pIWmiBtEJogA+Po=; b=fLG271tOPA3QyCISXuZ2vLCEI2
        zjuxVQc+2FX4D9sQVscVtHByYQdFhgPkwJLEBMhLXsr0E+4AiNw5/ryGfizC7AGunYe8ejt0jYw8q
        QDGdt4sMbdIKc0++jJIMvRvXphksjZRzQ1lZ0uVseuYu4KNj63p1JbI72H9dVMi/tEEg=;
Received: by maeck.lan (Postfix, from userid 501)
        id 8467B4F0BF98; Thu,  7 Feb 2019 14:47:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] mt76: run MAC work every 100ms
Date:   Thu,  7 Feb 2019 14:47:20 +0100
Message-Id: <20190207134723.59163-4-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190207134723.59163-1-nbd@nbd.name>
References: <20190207134723.59163-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ED/CCA Tx blocking checks need to be run every 100 ms in order to avoid
triggering too late and keeping tx blocking on for too long

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c      | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h         | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c     | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 2 +-
 6 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 1472c8699b29..6992b3d7dfec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -30,7 +30,7 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
 	mt76x02_mac_start(dev);
 	mt76x0_phy_calibrate(dev, true);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
+				     MT_MAC_WORK_INTERVAL);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index f66e1b2f0980..a271d81c3338 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -118,7 +118,7 @@ static int mt76x0u_start(struct ieee80211_hw *hw)
 
 	mt76x0_phy_calibrate(dev, true);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
+				     MT_MAC_WORK_INTERVAL);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 6d9d9ddacc32..7e405297028f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -27,6 +27,7 @@
 #include "mt76x02_dma.h"
 
 #define MT_CALIBRATE_INTERVAL	HZ
+#define MT_MAC_WORK_INTERVAL	(HZ / 10)
 
 #define MT_WATCHDOG_TIME	(HZ / 10)
 #define MT_TX_HANG_TH		10
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 636e69a7a407..89c7368cbd52 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -929,7 +929,7 @@ static void mt76x02_edcca_check(struct mt76x02_dev *dev)
 	u32 val, busy;
 
 	val = mt76_rr(dev, MT_ED_CCA_TIMER);
-	busy = (val * 100) / jiffies_to_usecs(MT_CALIBRATE_INTERVAL);
+	busy = (val * 100) / jiffies_to_usecs(MT_MAC_WORK_INTERVAL);
 	busy = min_t(u32, busy, 100);
 
 	if (busy > MT_EDCCA_TH) {
@@ -975,7 +975,7 @@ void mt76x02_mac_work(struct work_struct *work)
 	mt76_tx_status_check(&dev->mt76, NULL, false);
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
+				     MT_MAC_WORK_INTERVAL);
 }
 
 void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 06a26a152ba4..878ce92405ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -33,7 +33,7 @@ mt76x2_start(struct ieee80211_hw *hw)
 		goto out;
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
+				     MT_MAC_WORK_INTERVAL);
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->wdt_work,
 				     MT_WATCHDOG_TIME);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 5256c6f879a7..10633b8de8e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -28,7 +28,7 @@ static int mt76x2u_start(struct ieee80211_hw *hw)
 		goto out;
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
+				     MT_MAC_WORK_INTERVAL);
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 
 out:
-- 
2.17.0

