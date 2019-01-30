Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E50C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 391C32087F
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731795AbfA3QCZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:02:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42077 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731658AbfA3QCZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 11:02:25 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A226ED4E56;
        Wed, 30 Jan 2019 16:02:24 +0000 (UTC)
Received: from localhost (ovpn-204-66.brq.redhat.com [10.40.204.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31590452C;
        Wed, 30 Jan 2019 16:02:23 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v3 2/7] mt76x02: use commmon add interface for mt76x2u
Date:   Wed, 30 Jan 2019 17:02:14 +0100
Message-Id: <1548864139-27729-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548864139-27729-1-git-send-email-sgruszka@redhat.com>
References: <1548864139-27729-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 30 Jan 2019 16:02:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since we now support mt76x2u feature to allow set mac address
when creating interface in common code we can use it for
mt76x2u.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h      |  3 +--
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c |  6 +++---
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c  | 15 +--------------
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index be077443bdb0..6d9d9ddacc32 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -130,8 +130,7 @@ void mt76x02_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta);
 
 void mt76x02_config_mac_addr_list(struct mt76x02_dev *dev);
-void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
-		      unsigned int idx);
+
 int mt76x02_add_interface(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif);
 void mt76x02_remove_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index c9340096c187..18434b06e706 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -268,8 +268,9 @@ void mt76x02_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_remove);
 
-void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
-		      unsigned int idx)
+static void
+mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
+		 unsigned int idx)
 {
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 	struct mt76_txq *mtxq;
@@ -282,7 +283,6 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 
 	mt76_txq_init(&dev->mt76, vif->txq);
 }
-EXPORT_SYMBOL_GPL(mt76x02_vif_init);
 
 int
 mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 286c7f451090..5256c6f879a7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -46,19 +46,6 @@ static void mt76x2u_stop(struct ieee80211_hw *hw)
 	mutex_unlock(&dev->mt76.mutex);
 }
 
-static int mt76x2u_add_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_vif *vif)
-{
-	struct mt76x02_dev *dev = hw->priv;
-	unsigned int idx = 8;
-
-	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
-		mt76x02_mac_setaddr(dev, vif->addr);
-
-	mt76x02_vif_init(dev, vif, idx);
-	return 0;
-}
-
 static int
 mt76x2u_set_channel(struct mt76x02_dev *dev,
 		    struct cfg80211_chan_def *chandef)
@@ -125,7 +112,7 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.tx = mt76x02_tx,
 	.start = mt76x2u_start,
 	.stop = mt76x2u_stop,
-	.add_interface = mt76x2u_add_interface,
+	.add_interface = mt76x02_add_interface,
 	.remove_interface = mt76x02_remove_interface,
 	.sta_state = mt76_sta_state,
 	.set_key = mt76x02_set_key,
-- 
2.19.2

