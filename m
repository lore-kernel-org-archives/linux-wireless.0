Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5273FC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 12:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03AE12087C
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 12:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ogkvde4M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03AE12087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbeKPWuA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 17:50:00 -0500
Received: from nbd.name ([46.4.11.11]:37676 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbeKPWuA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 17:50:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WxD7M4sHy5KA9XQ+VEPnb0lrPkZXcS7dTWwAlVsqnxo=; b=ogkvde4M9UWDdW7TPdHaKRxIPP
        ETNBHoMKNummTpIv9+Xx48fk1+Yz3EOyfeXrFxzTMFJNxvFTNzWxhIlrFeNeGhlOOd6xZfwtbqSea
        NQ1FDdZ7Y0yCWcz2fAUQBLQeYcSg/J9oGXCbxlrdLGBi0zGAiaC112tXJh/fEqEDTsQw=;
Received: by maeck.local (Postfix, from userid 501)
        id BC19446414D8; Fri, 16 Nov 2018 13:37:45 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH v3 7/7] mt76: replace sta_add/remove ops with common sta_state function
Date:   Fri, 16 Nov 2018 13:37:45 +0100
Message-Id: <20181116123745.12802-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181116111235.86347-7-nbd@nbd.name>
References: <20181116111235.86347-7-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allows adding unassociated stations from mac80211

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
v3: fix typo in mt76x2u

 drivers/net/wireless/mediatek/mt76/mac80211.c | 61 ++++++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h     | 12 +++-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  5 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  8 +--
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 40 +++---------
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  3 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  2 +
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  3 +-
 10 files changed, 92 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 1098919f5498..d3f94163ef8e 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -631,8 +631,40 @@ void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q,
 }
 EXPORT_SYMBOL_GPL(mt76_rx_poll_complete);
 
-void mt76_sta_remove(struct mt76_dev *dev, struct ieee80211_vif *vif,
-		     struct ieee80211_sta *sta)
+static int
+mt76_sta_add(struct mt76_dev *dev, struct ieee80211_vif *vif,
+	     struct ieee80211_sta *sta)
+{
+	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
+	int ret;
+	int i;
+
+	mutex_lock(&dev->mutex);
+
+	ret = dev->drv->sta_add(dev, vif, sta);
+	if (ret)
+		goto out;
+
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
+		struct mt76_txq *mtxq;
+
+		mtxq = (struct mt76_txq *)sta->txq[i]->drv_priv;
+		mtxq->wcid = wcid;
+
+		mt76_txq_init(dev, sta->txq[i]);
+	}
+
+	rcu_assign_pointer(dev->wcid[wcid->idx], wcid);
+
+out:
+	mutex_unlock(&dev->mutex);
+
+	return ret;
+}
+
+static void
+mt76_sta_remove(struct mt76_dev *dev, struct ieee80211_vif *vif,
+	        struct ieee80211_sta *sta)
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
 	int idx = wcid->idx;
@@ -642,10 +674,33 @@ void mt76_sta_remove(struct mt76_dev *dev, struct ieee80211_vif *vif,
 	synchronize_rcu();
 
 	mutex_lock(&dev->mutex);
+
+	if (dev->drv->sta_remove)
+		dev->drv->sta_remove(dev, vif, sta);
+
 	mt76_tx_status_check(dev, wcid, true);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76_txq_remove(dev, sta->txq[i]);
 	mt76_wcid_free(dev->wcid_mask, idx);
+
 	mutex_unlock(&dev->mutex);
 }
-EXPORT_SYMBOL_GPL(mt76_sta_remove);
+
+int mt76_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta,
+		   enum ieee80211_sta_state old_state,
+		   enum ieee80211_sta_state new_state)
+{
+	struct mt76_dev *dev = hw->priv;
+
+	if (old_state == IEEE80211_STA_NOTEXIST &&
+	    new_state == IEEE80211_STA_NONE)
+		return mt76_sta_add(dev, vif, sta);
+
+	if (old_state == IEEE80211_STA_NONE &&
+		 new_state == IEEE80211_STA_NOTEXIST)
+		mt76_sta_remove(dev, vif, sta);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76_sta_state);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 878836fe80d3..5cd508a68609 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -288,6 +288,12 @@ struct mt76_driver_ops {
 
 	void (*sta_ps)(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		       bool ps);
+
+	int (*sta_add)(struct mt76_dev *dev, struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta);
+
+	void (*sta_remove)(struct mt76_dev *dev, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta);
 };
 
 struct mt76_channel_state {
@@ -664,8 +670,10 @@ void mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb,
 void mt76_tx_complete_skb(struct mt76_dev *dev, struct sk_buff *skb);
 void mt76_tx_status_check(struct mt76_dev *dev, struct mt76_wcid *wcid,
 			  bool flush);
-void mt76_sta_remove(struct mt76_dev *dev, struct ieee80211_vif *vif,
-		     struct ieee80211_sta *sta);
+int mt76_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta,
+		   enum ieee80211_sta_state old_state,
+		   enum ieee80211_sta_state new_state);
 
 struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 757816d2b1ab..d895b6f3dc44 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -90,8 +90,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.config = mt76x0_config,
 	.configure_filter = mt76x02_configure_filter,
 	.bss_info_changed = mt76x02_bss_info_changed,
-	.sta_add = mt76x02_sta_add,
-	.sta_remove = mt76x02_sta_remove,
+	.sta_state = mt76_sta_state,
 	.set_key = mt76x02_set_key,
 	.conf_tx = mt76x02_conf_tx,
 	.sw_scan_start = mt76x02_sw_scan,
@@ -162,6 +161,8 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		.rx_skb = mt76x02_queue_rx_skb,
 		.rx_poll_complete = mt76x02_rx_poll_complete,
 		.sta_ps = mt76x02_sta_ps,
+		.sta_add = mt76x02_sta_add,
+		.sta_remove = mt76x02_sta_remove,
 	};
 	struct mt76x02_dev *dev;
 	int ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 35b98661632a..0e6b43bb4678 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -146,8 +146,7 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.config = mt76x0_config,
 	.configure_filter = mt76x02_configure_filter,
 	.bss_info_changed = mt76x02_bss_info_changed,
-	.sta_add = mt76x02_sta_add,
-	.sta_remove = mt76x02_sta_remove,
+	.sta_state = mt76_sta_state,
 	.set_key = mt76x02_set_key,
 	.conf_tx = mt76x02_conf_tx,
 	.sw_scan_start = mt76x02_sw_scan,
@@ -219,6 +218,8 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 		.tx_complete_skb = mt76x02u_tx_complete_skb,
 		.tx_status_data = mt76x02_tx_status_data,
 		.rx_skb = mt76x02_queue_rx_skb,
+		.sta_add = mt76x02_sta_add,
+		.sta_remove = mt76x02_sta_remove,
 	};
 	struct usb_device *usb_dev = interface_to_usbdev(usb_intf);
 	struct mt76x02_dev *dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 65daa3d3c289..b1d83dd34204 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -110,10 +110,10 @@ void mt76x02_init_device(struct mt76x02_dev *dev);
 void mt76x02_configure_filter(struct ieee80211_hw *hw,
 			     unsigned int changed_flags,
 			     unsigned int *total_flags, u64 multicast);
-int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   struct ieee80211_sta *sta);
-int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		      struct ieee80211_sta *sta);
+int mt76x02_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		    struct ieee80211_sta *sta);
+void mt76x02_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta);
 
 void mt76x02_config_mac_addr_list(struct mt76x02_dev *dev);
 void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index f5ebed75b939..3a70e5bf7d42 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -167,23 +167,17 @@ void mt76x02_configure_filter(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x02_configure_filter);
 
-int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+int mt76x02_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		    struct ieee80211_sta *sta)
 {
-	struct mt76x02_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct mt76x02_sta *msta = (struct mt76x02_sta *)sta->drv_priv;
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
-	int ret = 0;
 	int idx = 0;
-	int i;
-
-	mutex_lock(&dev->mt76.mutex);
 
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, ARRAY_SIZE(dev->mt76.wcid));
-	if (idx < 0) {
-		ret = -ENOSPC;
-		goto out;
-	}
+	if (idx < 0)
+		return -ENOSPC;
 
 	msta->vif = mvif;
 	msta->wcid.sta = 1;
@@ -191,43 +185,25 @@ int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	msta->wcid.hw_key_idx = -1;
 	mt76x02_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
 	mt76x02_mac_wcid_set_drop(dev, idx, false);
-	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
-		struct mt76_txq *mtxq;
-
-		mtxq = (struct mt76_txq *) sta->txq[i]->drv_priv;
-		mtxq->wcid = &msta->wcid;
-		mt76_txq_init(&dev->mt76, sta->txq[i]);
-	}
 
 	if (vif->type == NL80211_IFTYPE_AP)
 		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
 
 	ewma_signal_init(&msta->rssi);
 
-	rcu_assign_pointer(dev->mt76.wcid[idx], &msta->wcid);
-
-out:
-	mutex_unlock(&dev->mt76.mutex);
-
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_add);
 
-int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta)
+void mt76x02_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta)
 {
-	struct mt76x02_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
 	int idx = wcid->idx;
 
-	mt76_sta_remove(&dev->mt76, vif, sta);
-
-	mutex_lock(&dev->mt76.mutex);
 	mt76x02_mac_wcid_set_drop(dev, idx, true);
 	mt76x02_mac_wcid_setup(dev, idx, 0, NULL);
-	mutex_unlock(&dev->mt76.mutex);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_remove);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 843dda261cf8..6eaab156387a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -323,6 +323,8 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 		.rx_skb = mt76x02_queue_rx_skb,
 		.rx_poll_complete = mt76x02_rx_poll_complete,
 		.sta_ps = mt76x02_sta_ps,
+		.sta_add = mt76x02_sta_add,
+		.sta_remove = mt76x02_sta_remove,
 	};
 	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 3d73926837bf..b54a32397486 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -182,8 +182,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.config = mt76x2_config,
 	.configure_filter = mt76x02_configure_filter,
 	.bss_info_changed = mt76x02_bss_info_changed,
-	.sta_add = mt76x02_sta_add,
-	.sta_remove = mt76x02_sta_remove,
+	.sta_state = mt76_sta_state,
 	.set_key = mt76x02_set_key,
 	.conf_tx = mt76x02_conf_tx,
 	.sw_scan_start = mt76x02_sw_scan,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index de0fbdb02c4d..0be3784f44fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -141,6 +141,8 @@ struct mt76x02_dev *mt76x2u_alloc_device(struct device *pdev)
 		.tx_complete_skb = mt76x02u_tx_complete_skb,
 		.tx_status_data = mt76x02_tx_status_data,
 		.rx_skb = mt76x02_queue_rx_skb,
+		.sta_add = mt76x02_sta_add,
+		.sta_remove = mt76x02_sta_remove,
 	};
 	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index a9ecc92875ae..2b48cc51a30d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -127,8 +127,7 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.stop = mt76x2u_stop,
 	.add_interface = mt76x2u_add_interface,
 	.remove_interface = mt76x02_remove_interface,
-	.sta_add = mt76x02_sta_add,
-	.sta_remove = mt76x02_sta_remove,
+	.sta_state = mt76_sta_state,
 	.set_key = mt76x02_set_key,
 	.ampdu_action = mt76x02_ampdu_action,
 	.config = mt76x2u_config,
-- 
2.17.0

