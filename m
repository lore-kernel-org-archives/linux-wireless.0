Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA40C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 942352082A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:58:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 942352082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbeJAXhN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 19:37:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38621 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbeJAXhM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 19:37:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id a13-v6so4076643wrt.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 09:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oafILQCBdgqtNBLQ7JUQ3Wgmjr2a+rYxTAYf2bKdtTA=;
        b=nzLEfAIrwHevUY/lwQ49qRphb6NqHKuaVSo9IHMF2YpbD7JajuK1ktCOJDOtgqBvpP
         xC2QpHdata/ZWpKZN+cEPAbO+wWVOrFQMFEGLuBYaqph47kpYHXvsXc+Sikralz8S/So
         5jTeB3FpOSCQ8J+xfxiGqf0zS24+qP98bzB7tTtwNPB+gAOBBIFbUvwSrYjQJXTLdpri
         gteKyA7IAvXXLfdfupIAV0tYZTHQsgWbp/AsIXE13EUwCKiMwJK68WtQGQC/C15Uygg+
         jxU9C6OmPrUHZnL1jio46351Rectbf2+fVBzKXg75pClRySquJodUnJlfxBbLUlllCD0
         U6sg==
X-Gm-Message-State: ABuFfojAOvCUlKLZrsE9Q0nRsS/anh9g1NP2LHJsPCBLta+c0f0M4kYO
        gILvZYCNWzKILCx7J0fvR9echw==
X-Google-Smtp-Source: ACcGV6217qnOcWTZKGfJYJeVwj1KnUy8QSipKFJn4Ojy9mpjC1IzEQcsB7A0qxPaYv27KlKn++lWzA==
X-Received: by 2002:adf:bbc3:: with SMTP id z3-v6mr7708370wrg.183.1538413107730;
        Mon, 01 Oct 2018 09:58:27 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id b2-v6sm5057600wru.51.2018.10.01.09.58.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Oct 2018 09:58:27 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mt76: move mt76x02_mac_write_txwi in mt76x02-lib module
Date:   Mon,  1 Oct 2018 18:58:19 +0200
Message-Id: <d7902a17660b4eadd66a04656297553f5fa4d8ee.1538411693.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538411693.git.lorenzo.bianconi@redhat.com>
References: <cover.1538411693.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_mac_write_txwi in mt76x02_mac.c since it is shared between
mt76x0 and mt76x2 drivers. This is a preliminary patch to unify txwi
configuration between mt76x0 and mt76x2 drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 63 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  3 +
 .../net/wireless/mediatek/mt76/mt76x2/mac.c   | 60 ------------------
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |  3 -
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_tx.c    |  2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_core.c  |  3 +-
 7 files changed, 69 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index df4366a702c9..71d677a6b88a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -18,6 +18,7 @@
 #include "mt76.h"
 #include "mt76x02_regs.h"
 #include "mt76x02_mac.h"
+#include "mt76x02_util.h"
 
 enum mt76x02_cipher_type
 mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
@@ -341,6 +342,68 @@ mt76x02_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 	return 0;
 }
 
+void mt76x02_mac_write_txwi(struct mt76_dev *dev, struct mt76x02_txwi *txwi,
+			    struct sk_buff *skb, struct mt76_wcid *wcid,
+			    struct ieee80211_sta *sta, int len)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *rate = &info->control.rates[0];
+	struct ieee80211_key_conf *key = info->control.hw_key;
+	u16 rate_ht_mask = FIELD_PREP(MT_RXWI_RATE_PHY, BIT(1) | BIT(2));
+	u8 nss;
+	s8 txpwr_adj, max_txpwr_adj;
+	u8 ccmp_pn[8], nstreams = dev->chainmask & 0xf;
+
+	memset(txwi, 0, sizeof(*txwi));
+
+	if (wcid)
+		txwi->wcid = wcid->idx;
+	else
+		txwi->wcid = 0xff;
+
+	txwi->pktid = 1;
+
+	if (wcid && wcid->sw_iv && key) {
+		u64 pn = atomic64_inc_return(&key->tx_pn);
+		ccmp_pn[0] = pn;
+		ccmp_pn[1] = pn >> 8;
+		ccmp_pn[2] = 0;
+		ccmp_pn[3] = 0x20 | (key->keyidx << 6);
+		ccmp_pn[4] = pn >> 16;
+		ccmp_pn[5] = pn >> 24;
+		ccmp_pn[6] = pn >> 32;
+		ccmp_pn[7] = pn >> 40;
+		txwi->iv = *((__le32 *)&ccmp_pn[0]);
+		txwi->eiv = *((__le32 *)&ccmp_pn[1]);
+	}
+
+	spin_lock_bh(&dev->lock);
+	if (wcid && (rate->idx < 0 || !rate->count)) {
+		txwi->rate = wcid->tx_rate;
+		max_txpwr_adj = wcid->max_txpwr_adj;
+		nss = wcid->tx_rate_nss;
+	} else {
+		txwi->rate = mt76x02_mac_tx_rate_val(dev, rate, &nss);
+		max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, rate);
+	}
+	spin_unlock_bh(&dev->lock);
+
+	if (dev->drv->get_tx_txpwr_adj) {
+		txpwr_adj = dev->drv->get_tx_txpwr_adj(dev, dev->txpower_conf,
+						       max_txpwr_adj);
+		txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
+	}
+
+	if (nstreams > 1 && mt76_rev(dev) >= MT76XX_REV_E4)
+		txwi->txstream = 0x13;
+	else if (nstreams > 1 && mt76_rev(dev) >= MT76XX_REV_E3 &&
+		 !(txwi->rate & cpu_to_le16(rate_ht_mask)))
+		txwi->txstream = 0x93;
+
+	mt76x02_mac_fill_txwi(txwi, skb, sta, len, nss);
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_write_txwi);
+
 static void
 mt76x02_mac_fill_tx_status(struct mt76_dev *dev,
 			  struct ieee80211_tx_info *info,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 62072291e416..ddc8057fbbab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -203,4 +203,7 @@ void mt76x02_send_tx_status(struct mt76_dev *dev,
 int
 mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate);
 void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr);
+void mt76x02_mac_write_txwi(struct mt76_dev *dev, struct mt76x02_txwi *txwi,
+			    struct sk_buff *skb, struct mt76_wcid *wcid,
+			    struct ieee80211_sta *sta, int len);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
index 0791fa11875c..c98ce1582aec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
@@ -54,66 +54,6 @@ void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
 }
 EXPORT_SYMBOL_GPL(mt76x2_mac_stop);
 
-void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
-			   struct sk_buff *skb, struct mt76_wcid *wcid,
-			   struct ieee80211_sta *sta, int len)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_tx_rate *rate = &info->control.rates[0];
-	struct ieee80211_key_conf *key = info->control.hw_key;
-	u16 rate_ht_mask = FIELD_PREP(MT_RXWI_RATE_PHY, BIT(1) | BIT(2));
-	u8 nss;
-	s8 txpwr_adj, max_txpwr_adj;
-	u8 ccmp_pn[8];
-
-	memset(txwi, 0, sizeof(*txwi));
-
-	if (wcid)
-		txwi->wcid = wcid->idx;
-	else
-		txwi->wcid = 0xff;
-
-	txwi->pktid = 1;
-
-	if (wcid && wcid->sw_iv && key) {
-		u64 pn = atomic64_inc_return(&key->tx_pn);
-		ccmp_pn[0] = pn;
-		ccmp_pn[1] = pn >> 8;
-		ccmp_pn[2] = 0;
-		ccmp_pn[3] = 0x20 | (key->keyidx << 6);
-		ccmp_pn[4] = pn >> 16;
-		ccmp_pn[5] = pn >> 24;
-		ccmp_pn[6] = pn >> 32;
-		ccmp_pn[7] = pn >> 40;
-		txwi->iv = *((__le32 *)&ccmp_pn[0]);
-		txwi->eiv = *((__le32 *)&ccmp_pn[1]);
-	}
-
-	spin_lock_bh(&dev->mt76.lock);
-	if (wcid && (rate->idx < 0 || !rate->count)) {
-		txwi->rate = wcid->tx_rate;
-		max_txpwr_adj = wcid->max_txpwr_adj;
-		nss = wcid->tx_rate_nss;
-	} else {
-		txwi->rate = mt76x02_mac_tx_rate_val(&dev->mt76, rate, &nss);
-		max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(&dev->mt76, rate);
-	}
-	spin_unlock_bh(&dev->mt76.lock);
-
-	txpwr_adj = mt76x2_tx_get_txpwr_adj(&dev->mt76, dev->mt76.txpower_conf,
-					    max_txpwr_adj);
-	txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
-
-	if (mt76xx_rev(dev) >= MT76XX_REV_E4)
-		txwi->txstream = 0x13;
-	else if (mt76xx_rev(dev) >= MT76XX_REV_E3 &&
-		 !(txwi->rate & cpu_to_le16(rate_ht_mask)))
-		txwi->txstream = 0x93;
-
-	mt76x02_mac_fill_txwi(txwi, skb, sta, len, nss);
-}
-EXPORT_SYMBOL_GPL(mt76x2_mac_write_txwi);
-
 int mt76x2_mac_get_rssi(struct mt76x2_dev *dev, s8 rssi, int chain)
 {
 	struct mt76x2_rx_freq_cal *cal = &dev->cal.rx;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
index b2176f9a661a..95ad5eea4274 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
@@ -48,9 +48,6 @@ void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr);
 
 int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 			  void *rxi);
-void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
-			   struct sk_buff *skb, struct mt76_wcid *wcid,
-			   struct ieee80211_sta *sta, int len);
 
 int mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 vif_idx,
 			  struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 45b21a9a7385..1516fe15d15c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -106,7 +106,7 @@ mt76_write_beacon(struct mt76x2_dev *dev, int offset, struct sk_buff *skb)
 	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x02_txwi)))
 		return -ENOSPC;
 
-	mt76x2_mac_write_txwi(dev, &txwi, skb, NULL, NULL, skb->len);
+	mt76x02_mac_write_txwi(&dev->mt76, &txwi, skb, NULL, NULL, skb->len);
 
 	mt76_wr_copy(dev, offset, &txwi, sizeof(txwi));
 	offset += sizeof(txwi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
index 69dc1f368f52..bef28d57bfcc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
@@ -37,7 +37,7 @@ int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 	if (q == &dev->mt76.q_tx[MT_TXQ_PSD] && wcid && wcid->idx < 128)
 		mt76x02_mac_wcid_set_drop(&dev->mt76, wcid->idx, false);
 
-	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta, skb->len);
+	mt76x02_mac_write_txwi(mdev, txwi, skb, wcid, sta, skb->len);
 
 	ret = mt76x02_insert_hdr_pad(skb);
 	if (ret < 0)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c
index 6eb7b28d102f..a740f059e8e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c
@@ -36,7 +36,6 @@ int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			   u32 *tx_info)
 {
-	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
 	struct mt76x02_txwi *txwi;
 	int err, len = skb->len;
 
@@ -47,7 +46,7 @@ int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	mt76x02_insert_hdr_pad(skb);
 
 	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
-	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
+	mt76x02_mac_write_txwi(mdev, txwi, skb, wcid, sta, len);
 
 	return mt76x02u_set_txinfo(skb, wcid, q2ep(q->hw_idx));
 }
-- 
2.17.1

