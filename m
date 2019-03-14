Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF3BC4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F1A421852
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552571679;
	bh=EBFDoWpVRJGH7hRS86qvtUgKobfID1vyhSCA1GRr0oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Q6o87+86Iv6rt2/P/vn20F18sWl5TWNT26TjiSfbi+JaZxfip/GOopAQ9PACtflRS
	 CY8MHynxrG3YaNcO4BrbGSjx8+IA1/fwqBU7Q6O0kljqX5qhuuB9LyLuUNF2WMG71q
	 zh/0wU7iEQB2CWxqzDFWFeLCDQBvNFZ1VstVKY1c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfCNNyi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbfCNNyh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 09:54:37 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF07F2184E;
        Thu, 14 Mar 2019 13:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552571677;
        bh=EBFDoWpVRJGH7hRS86qvtUgKobfID1vyhSCA1GRr0oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3aMNYW02A5MjWxltTltGHkX/OHmO3MZCW2SzSolfeZxbOPqAfxb//Og1b5IH5l+6
         N04nx/+XT2huQlMtvKBNDWiNcJs+6LKMr/H27pgWJdh+0WbZo/TnGJHPLI2udkkFV5
         OH7NCTxdtmEfkOKWR0Sv9Ot8/XHGGq3eRTfRnyRY=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 1/4] mt76: move mt76x02_insert_hdr_pad in mt76-core module
Date:   Thu, 14 Mar 2019 14:54:09 +0100
Message-Id: <81e008fa4025affabc6424974e7654b6e46e7efb.1552570806.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552570806.git.lorenzo@kernel.org>
References: <cover.1552570806.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_insert_hdr_pad in m76-core and rename it in
mt76_insert_hdr_pad in order to be used in mt76_dma_tx_queue_skb.
This is a preliminary patch in order to properly support tx dma
mapping for new chipsets (e.g. mt7615)

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h        | 14 ++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02.h     |  1 -
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c    |  5 +----
 .../wireless/mediatek/mt76/mt76x02_usb_core.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c    | 16 ----------------
 5 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 57136073e1fa..c8ab74ae243e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -653,6 +653,20 @@ static inline struct mt76_tx_cb *mt76_tx_skb_cb(struct sk_buff *skb)
 	return ((void *) IEEE80211_SKB_CB(skb)->status.status_driver_data);
 }
 
+static inline void mt76_insert_hdr_pad(struct sk_buff *skb)
+{
+	int len = ieee80211_get_hdrlen_from_skb(skb);
+
+	if (len % 4 == 0)
+		return;
+
+	skb_push(skb, 2);
+	memmove(skb->data, skb->data + 2, len);
+
+	skb->data[len] = 0;
+	skb->data[len + 1] = 0;
+}
+
 void mt76_rx(struct mt76_dev *dev, enum mt76_rxq_id q, struct sk_buff *skb);
 void mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	     struct mt76_wcid *wcid, struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 392b96fcb520..53ec8103a268 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -163,7 +163,6 @@ void mt76x02_set_tx_ackto(struct mt76x02_dev *dev);
 void mt76x02_set_coverage_class(struct ieee80211_hw *hw,
 				s16 coverage_class);
 int mt76x02_set_rts_threshold(struct ieee80211_hw *hw, u32 val);
-int mt76x02_insert_hdr_pad(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
 bool mt76x02_tx_status_data(struct mt76_dev *mdev, u8 *update);
 void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index ce9ace11339d..0a3a3605c151 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -155,7 +155,6 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	struct mt76x02_txwi *txwi = txwi_ptr;
 	int qsel = MT_QSEL_EDCA;
 	int pid;
-	int ret;
 
 	if (qid == MT_TXQ_PSD && wcid && wcid->idx < 128)
 		mt76x02_mac_wcid_set_drop(dev, wcid->idx, false);
@@ -165,9 +164,7 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
 	txwi->pktid = pid;
 
-	ret = mt76x02_insert_hdr_pad(skb);
-	if (ret < 0)
-		return ret;
+	mt76_insert_hdr_pad(skb);
 
 	if (pid >= MT_PACKET_ID_FIRST)
 		qsel = MT_QSEL_MGMT;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 8ab63255ba6f..6c3fc4cea283 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -82,7 +82,7 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	enum mt76_qsel qsel;
 	u32 flags;
 
-	mt76x02_insert_hdr_pad(skb);
+	mt76_insert_hdr_pad(skb);
 
 	txwi = (struct mt76x02_txwi *)(skb->data - sizeof(struct mt76x02_txwi));
 	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index b14a55737829..81d65319d3ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -566,22 +566,6 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_rate_tbl_update);
 
-int mt76x02_insert_hdr_pad(struct sk_buff *skb)
-{
-	int len = ieee80211_get_hdrlen_from_skb(skb);
-
-	if (len % 4 == 0)
-		return 0;
-
-	skb_push(skb, 2);
-	memmove(skb->data, skb->data + 2, len);
-
-	skb->data[len] = 0;
-	skb->data[len + 1] = 0;
-	return 2;
-}
-EXPORT_SYMBOL_GPL(mt76x02_insert_hdr_pad);
-
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len)
 {
 	int hdrlen;
-- 
2.20.1

