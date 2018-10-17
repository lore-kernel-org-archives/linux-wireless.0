Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD97ECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CC102150D
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:11:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ZvgdvNDb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CC102150D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbeJQTGR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 15:06:17 -0400
Received: from nbd.name ([46.4.11.11]:57744 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbeJQTGR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 15:06:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xy8GZ0yHpbHQy1dmCp+ZW89JxBJY1bBOByC/BbZTxdM=; b=ZvgdvNDbzRug4r4SHt9a8P1kro
        IBzhC+3JJRDZiVYZUPn9ekxvUpI0AVGpwZNag/nN5DMTcr+dx+SF7uPDsemrcQ+YLGtG8cHO+wIKS
        X4tLouPAgYhYgWQvld1GzzOAaKcPdQ6bHHkWFgFRdhtHj8ncNoAaOQdD4959KMpOSBN0=;
Received: by maeck.lan (Postfix, from userid 501)
        id 6BCF93FD2998; Wed, 17 Oct 2018 13:11:01 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     sgruszka@redhat.com, lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76: clean up unused leftover EXPORT_SYMBOLs
Date:   Wed, 17 Oct 2018 13:11:01 +0200
Message-Id: <20181017111101.19685-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make previously exported functions static where possible

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h         | 2 --
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 8 +-------
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  | 2 --
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c | 2 --
 drivers/net/wireless/mediatek/mt76/usb.c          | 6 ++----
 6 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 3bfa7f5e3513..53ddc4fa5884 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -668,8 +668,6 @@ int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
 			 void *buf, size_t len);
 void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
 		     const u16 offset, const u32 val);
-u32 mt76u_rr(struct mt76_dev *dev, u32 addr);
-void mt76u_wr(struct mt76_dev *dev, u32 addr, u32 val);
 int mt76u_init(struct mt76_dev *dev, struct usb_interface *intf);
 void mt76u_deinit(struct mt76_dev *dev);
 int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 3896da690b83..899ffd026e62 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -18,7 +18,7 @@
 #include "mt76x02.h"
 #include "mt76x02_trace.h"
 
-enum mt76x02_cipher_type
+static enum mt76x02_cipher_type
 mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
 {
 	memset(key_data, 0, 32);
@@ -43,7 +43,6 @@ mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
 		return MT_CIPHER_NONE;
 	}
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_get_key_info);
 
 int mt76x02_mac_shared_key_setup(struct mt76x02_dev *dev, u8 vif_idx,
 				 u8 key_idx, struct ieee80211_key_conf *key)
@@ -95,7 +94,6 @@ int mt76x02_mac_wcid_set_key(struct mt76x02_dev *dev, u8 idx,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_wcid_set_key);
 
 void mt76x02_mac_wcid_setup(struct mt76x02_dev *dev, u8 idx,
 			    u8 vif_idx, u8 *mac)
@@ -154,7 +152,6 @@ void mt76x02_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq)
 
 	mt76_txq_init(&dev->mt76, txq);
 }
-EXPORT_SYMBOL_GPL(mt76x02_txq_init);
 
 static __le16
 mt76x02_mac_tx_rate_val(struct mt76x02_dev *dev,
@@ -239,7 +236,6 @@ bool mt76x02_mac_load_tx_status(struct mt76x02_dev *dev,
 
 	return true;
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_load_tx_status);
 
 static int
 mt76x02_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
@@ -483,7 +479,6 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 out:
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL_GPL(mt76x02_send_tx_status);
 
 int
 mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate)
@@ -705,7 +700,6 @@ void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq)
 		kfifo_put(&dev->txstatus_fifo, stat);
 	}
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_poll_tx_status);
 
 static void
 mt76x02_mac_queue_txdone(struct mt76x02_dev *dev, struct sk_buff *skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index c1936e2277d1..81c16aef6a94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -199,8 +199,6 @@ mt76x02_skb_tx_info(struct sk_buff *skb)
 }
 
 void mt76x02_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq);
-enum mt76x02_cipher_type
-mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data);
 
 int mt76x02_mac_shared_key_setup(struct mt76x02_dev *dev, u8 vif_idx,
 				 u8 key_idx, struct ieee80211_key_conf *key);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 39f092034240..784b76e08382 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -225,7 +225,6 @@ static void mt76x02_dma_enable(struct mt76x02_dev *dev)
 	mt76_clear(dev, MT_WPDMA_GLO_CFG,
 		   MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
 }
-EXPORT_SYMBOL_GPL(mt76x02_dma_enable);
 
 void mt76x02_dma_cleanup(struct mt76x02_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index d3de08872d6e..7ec3f8f5f228 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -110,7 +110,6 @@ s8 mt76x02_tx_get_max_txpwr_adj(struct mt76x02_dev *dev,
 
 	return max_txpwr;
 }
-EXPORT_SYMBOL_GPL(mt76x02_tx_get_max_txpwr_adj);
 
 s8 mt76x02_tx_get_txpwr_adj(struct mt76x02_dev *dev, s8 txpwr, s8 max_txpwr_adj)
 {
@@ -125,7 +124,6 @@ s8 mt76x02_tx_get_txpwr_adj(struct mt76x02_dev *dev, s8 txpwr, s8 max_txpwr_adj)
 	else
 		return (txpwr < -16) ? 8 : (txpwr + 32) / 2;
 }
-EXPORT_SYMBOL_GPL(mt76x02_tx_get_txpwr_adj);
 
 void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 5f0faf07c346..4ef61d64fc36 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -100,7 +100,7 @@ static u32 __mt76u_rr(struct mt76_dev *dev, u32 addr)
 	return data;
 }
 
-u32 mt76u_rr(struct mt76_dev *dev, u32 addr)
+static u32 mt76u_rr(struct mt76_dev *dev, u32 addr)
 {
 	u32 ret;
 
@@ -110,7 +110,6 @@ u32 mt76u_rr(struct mt76_dev *dev, u32 addr)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(mt76u_rr);
 
 /* should be called with usb_ctrl_mtx locked */
 static void __mt76u_wr(struct mt76_dev *dev, u32 addr, u32 val)
@@ -136,13 +135,12 @@ static void __mt76u_wr(struct mt76_dev *dev, u32 addr, u32 val)
 	trace_usb_reg_wr(dev, addr, val);
 }
 
-void mt76u_wr(struct mt76_dev *dev, u32 addr, u32 val)
+static void mt76u_wr(struct mt76_dev *dev, u32 addr, u32 val)
 {
 	mutex_lock(&dev->usb.usb_ctrl_mtx);
 	__mt76u_wr(dev, addr, val);
 	mutex_unlock(&dev->usb.usb_ctrl_mtx);
 }
-EXPORT_SYMBOL_GPL(mt76u_wr);
 
 static u32 mt76u_rmw(struct mt76_dev *dev, u32 addr,
 		     u32 mask, u32 val)
-- 
2.17.0

