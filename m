Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B47FC282C5
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 15:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0378D21872
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 15:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbfAXPoR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 10:44:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727649AbfAXPoQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 10:44:16 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF1622D7E1;
        Thu, 24 Jan 2019 15:44:16 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC5071000049;
        Thu, 24 Jan 2019 15:44:12 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 1/7] mt76x02: use mask for vifs
Date:   Thu, 24 Jan 2019 16:44:03 +0100
Message-Id: <1548344649-10404-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 24 Jan 2019 15:44:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use vif_mask to count interfaces to allow to set mac address
if there is only one interface and support more STA vifs in
the future.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h      |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 18 +++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 6d96766a6ed3..be077443bdb0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -73,6 +73,8 @@ struct mt76x02_dev {
 
 	struct mutex phy_mutex;
 
+	u16 vif_mask;
+
 	u8 txdone_seq;
 	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 062614ad0d51..1a949453dc25 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -288,10 +288,7 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct mt76x02_dev *dev = hw->priv;
-	unsigned int idx = 0;
-
-	if (vif->addr[0] & BIT(1))
-		idx = 1 + (((dev->mt76.macaddr[0] ^ vif->addr[0]) >> 2) & 7);
+	unsigned int idx, offset = 0;
 
 	/*
 	 * Client mode typically only has one configurable BSSID register,
@@ -307,7 +304,16 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 	 * The resulting bssidx mismatch for unicast frames is ignored by hw.
 	 */
 	if (vif->type == NL80211_IFTYPE_STATION)
-		idx += 8;
+		offset = 8;
+
+	idx = ffs(~(dev->vif_mask >> offset)) - 1;
+	idx += offset;
+
+	/* Allow to change address is only one interface. */
+	if (!dev->vif_mask && (!ether_addr_equal(dev->mt76.macaddr, vif->addr)))
+                mt76x02_mac_setaddr(dev, vif->addr);
+
+	dev->vif_mask |= BIT(idx);
 
 	mt76x02_vif_init(dev, vif, idx);
 	return 0;
@@ -318,8 +324,10 @@ void mt76x02_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif)
 {
 	struct mt76x02_dev *dev = hw->priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 
 	mt76_txq_remove(&dev->mt76, vif->txq);
+	dev->vif_mask &= ~BIT(mvif->idx);
 }
 EXPORT_SYMBOL_GPL(mt76x02_remove_interface);
 
-- 
1.9.3

