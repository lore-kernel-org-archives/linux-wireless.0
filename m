Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE53C0044C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E165020827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:20:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E165020827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbeKIUAo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 15:00:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbeKIUAn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 15:00:43 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4D06C307D844;
        Fri,  9 Nov 2018 10:20:47 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10103104C529;
        Fri,  9 Nov 2018 10:20:43 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 3/5] mt76x2u: use common mt76x02_add_interface
Date:   Fri,  9 Nov 2018 11:20:12 +0100
Message-Id: <1541758814-2046-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 09 Nov 2018 10:20:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is no need anymore to use custom add interface function
for mt76x02u.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h         |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c    |  6 +++---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 12 +-----------
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index a8c5fdd903b9..f8e998ef8716 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -115,8 +115,6 @@ int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta);
 
-void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
-		      unsigned int idx);
 int mt76x02_add_interface(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif);
 void mt76x02_remove_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 2aa3f4b15fd9..dbf9d89dd328 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -228,8 +228,9 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_remove);
 
-void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
-		      unsigned int idx)
+static void
+mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
+		 unsigned int idx)
 {
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 
@@ -238,7 +239,6 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 	mvif->group_wcid.hw_key_idx = -1;
 	mt76x02_txq_init(dev, vif->txq);
 }
-EXPORT_SYMBOL_GPL(mt76x02_vif_init);
 
 int
 mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 977e74091a27..6b51dd749491 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -46,16 +46,6 @@ static void mt76x2u_stop(struct ieee80211_hw *hw)
 	mutex_unlock(&dev->mt76.mutex);
 }
 
-static int mt76x2u_add_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_vif *vif)
-{
-	struct mt76x02_dev *dev = hw->priv;
-	unsigned int idx = 8;
-
-	mt76x02_vif_init(dev, vif, idx);
-	return 0;
-}
-
 static int
 mt76x2u_set_channel(struct mt76x02_dev *dev,
 		    struct cfg80211_chan_def *chandef)
@@ -122,7 +112,7 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 	.tx = mt76x02_tx,
 	.start = mt76x2u_start,
 	.stop = mt76x2u_stop,
-	.add_interface = mt76x2u_add_interface,
+	.add_interface = mt76x02_add_interface,
 	.remove_interface = mt76x02_remove_interface,
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
-- 
1.9.3

