Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70EDC43612
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6EF220855
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="IMelsVAh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfAQNvg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:51:36 -0500
Received: from nbd.name ([46.4.11.11]:56456 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfAQNvg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ia7mmuzA/VksBcYMdSY06Iw/EwpfL7+8mbckPzTyuWw=; b=IMelsVAh0sCORHIFm9YF7GCg3K
        mbFYGxdFon9RMJ6ly0lmKxmqY50oo1ALCjULrWyCJRMLu7BnHCGjlihNo0TUX3qqgCKAMliNrKruV
        tG0NMKIl2kfw5fIEfLTalzDEveRC9VHv4T5hWqQZGPblRjBowlISg7AUiNqmXEn03W0o=;
Received: by maeck.lan (Postfix, from userid 501)
        id 35E554C6F050; Thu, 17 Jan 2019 14:51:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 7/7] mt76: add channel switch announcement support
Date:   Thu, 17 Jan 2019 14:51:33 +0100
Message-Id: <20190117135133.2753-7-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190117135133.2753-1-nbd@nbd.name>
References: <20190117135133.2753-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use the appropriate mac80211 callbacks after beacon transmission

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 39 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  5 +++
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 13 ++++++-
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 +
 4 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 3b09d4560ae2..ee3b65a14870 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -734,3 +734,42 @@ int mt76_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76_get_txpower);
+
+static void
+__mt76_csa_finish(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	if (vif->csa_active && ieee80211_csa_is_complete(vif))
+	    ieee80211_csa_finish(vif);
+}
+
+void mt76_csa_finish(struct mt76_dev *dev)
+{
+	if (!dev->csa_complete)
+		return;
+
+	ieee80211_iterate_active_interfaces_atomic(dev->hw,
+		IEEE80211_IFACE_ITER_RESUME_ALL,
+		__mt76_csa_finish, dev);
+
+	dev->csa_complete = 0;
+}
+EXPORT_SYMBOL_GPL(mt76_csa_finish);
+
+static void
+__mt76_csa_check(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt76_dev *dev = priv;
+
+	if (!vif->csa_active)
+		return;
+
+	dev->csa_complete |= ieee80211_csa_is_complete(vif);
+}
+
+void mt76_csa_check(struct mt76_dev *dev)
+{
+	ieee80211_iterate_active_interfaces_atomic(dev->hw,
+		IEEE80211_IFACE_ITER_RESUME_ALL,
+		__mt76_csa_check, dev);
+}
+EXPORT_SYMBOL_GPL(mt76_csa_check);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 0435d623e9ad..2bb9db4ed80a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -463,6 +463,8 @@ struct mt76_dev {
 	bool led_al;
 	u8 led_pin;
 
+	u8 csa_complete;
+
 	u32 rxfilter;
 
 	union {
@@ -691,6 +693,9 @@ int mt76_get_min_avg_rssi(struct mt76_dev *dev);
 int mt76_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		     int *dbm);
 
+void mt76_csa_check(struct mt76_dev *dev);
+void mt76_csa_finish(struct mt76_dev *dev);
+
 /* internal */
 void mt76_tx_free(struct mt76_dev *dev);
 struct mt76_txwi_cache *mt76_get_txwi(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 6236c6121c01..374bc9d91f12 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -116,6 +116,11 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 		IEEE80211_IFACE_ITER_RESUME_ALL,
 		mt76x02_update_beacon_iter, dev);
 
+	mt76_csa_check(&dev->mt76);
+
+	if (dev->mt76.csa_complete)
+		return;
+
 	do {
 		nframes = skb_queue_len(&data.q);
 		ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
@@ -309,8 +314,12 @@ irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance)
 		tasklet_schedule(&dev->pre_tbtt_tasklet);
 
 	/* send buffered multicast frames now */
-	if (intr & MT_INT_TBTT)
-		mt76_queue_kick(dev, &dev->mt76.q_tx[MT_TXQ_PSD]);
+	if (intr & MT_INT_TBTT) {
+		if (dev->mt76.csa_complete)
+			mt76_csa_finish(&dev->mt76);
+		else
+			mt76_queue_kick(dev, &dev->mt76.q_tx[MT_TXQ_PSD]);
+	}
 
 	if (intr & MT_INT_TX_STAT) {
 		mt76x02_mac_poll_tx_status(dev, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 0bd23d64db24..062614ad0d51 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -160,6 +160,8 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 #endif
 			BIT(NL80211_IFTYPE_ADHOC);
 
+		wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
+
 		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
 		/* init led callbacks */
-- 
2.17.0

