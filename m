Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196FEC282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E70792148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfA1MV6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 07:21:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbfA1MV5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 07:21:57 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A253C369A0;
        Mon, 28 Jan 2019 12:21:57 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D7CE611D4;
        Mon, 28 Jan 2019 12:21:53 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v2 1/7] mt76x02: use mask for vifs
Date:   Mon, 28 Jan 2019 13:21:42 +0100
Message-Id: <1548678108-9526-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 28 Jan 2019 12:21:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use vif_mask to count interfaces to allow to set mac address in HW
if there is only one interface and report error if we create
interface with wrong BSSID resulting in already used index.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v2:
- do not change vif index calculation
- return error for already used index

 drivers/net/wireless/mediatek/mt76/mt76x02.h      |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

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
index 062614ad0d51..2e805d5493de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -292,7 +292,6 @@ mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	if (vif->addr[0] & BIT(1))
 		idx = 1 + (((dev->mt76.macaddr[0] ^ vif->addr[0]) >> 2) & 7);
-
 	/*
 	 * Client mode typically only has one configurable BSSID register,
 	 * which is used for bssidx=0. This is linked to the MAC address.
@@ -309,6 +308,15 @@ mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	if (vif->type == NL80211_IFTYPE_STATION)
 		idx += 8;
 
+	if (dev->vif_mask & BIT(idx))
+		return -EBUSY;
+ 
+	/* Allow to change address in HW if we create first interface. */
+	if (!dev->vif_mask && !ether_addr_equal(dev->mt76.macaddr, vif->addr))
+                mt76x02_mac_setaddr(dev, vif->addr);
+
+	dev->vif_mask |= BIT(idx);
+
 	mt76x02_vif_init(dev, vif, idx);
 	return 0;
 }
@@ -318,8 +326,10 @@ void mt76x02_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif)
 {
 	struct mt76x02_dev *dev = hw->priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 
 	mt76_txq_remove(&dev->mt76, vif->txq);
+	dev->vif_mask &= ~BIT(mvif->idx);
 }
 EXPORT_SYMBOL_GPL(mt76x02_remove_interface);
 
-- 
2.19.2

