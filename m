Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32F6C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 12:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6629820657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 12:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552307743;
	bh=ubLXmSYwGrscSmkPKmB22NWSxsBw0d+B05iDfjBNkdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HNnHjV+OospEWeOb/5ZUQaQRW8PX5ut1LC8GfQEPfiSlDIpDL980jGndPw/ZVXjxq
	 Cox2ZXzyMiz1ad+gJNz9rEO+Tkka0HR7KyXS7yuC8jXvhGbUv7YedaEMcowGFdvT4l
	 h5qNWgpnKd6IgPkqnnquTs86qtdJiGghZY/s3R6s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbfCKMfm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbfCKMfm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 08:35:42 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD97920657;
        Mon, 11 Mar 2019 12:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552307741;
        bh=ubLXmSYwGrscSmkPKmB22NWSxsBw0d+B05iDfjBNkdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xiadEwhgxjo5FKP9KFcFhyWcRY5wzIfwi7hFJooJGpclf8IXDy+kwkj+GHxLizc9p
         CK7z5Zr8VsjWIDMgnKFFSC0fFepw7+f6ZgH2vhc+LU/BEDK7kMzWfvRrySy6fldabL
         Vn/ArW7owjnvWc7yFFJNnXDelgwRYAkhFvLwRfak=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH 1/4] mt76: move mt76x02_insert_hdr_pad in mt76-core module
Date:   Mon, 11 Mar 2019 13:35:23 +0100
Message-Id: <0ec618f40f6308f4da8c6a766519dfd66fa5ad57.1552306908.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552306908.git.lorenzo@kernel.org>
References: <cover.1552306908.git.lorenzo@kernel.org>
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
 drivers/net/wireless/mediatek/mt76/mt76.h        | 15 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02.h     |  1 -
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c    |  2 +-
 .../wireless/mediatek/mt76/mt76x02_usb_core.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c    | 16 ----------------
 5 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 57136073e1fa..971d968c1b5f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -653,6 +653,21 @@ static inline struct mt76_tx_cb *mt76_tx_skb_cb(struct sk_buff *skb)
 	return ((void *) IEEE80211_SKB_CB(skb)->status.status_driver_data);
 }
 
+static inline int mt76_insert_hdr_pad(struct sk_buff *skb)
+{
+	int len = ieee80211_get_hdrlen_from_skb(skb);
+
+	if (len % 4 == 0)
+		return 0;
+
+	skb_push(skb, 2);
+	memmove(skb->data, skb->data + 2, len);
+
+	skb->data[len] = 0;
+	skb->data[len + 1] = 0;
+	return 2;
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
index ce9ace11339d..f574866c7e9d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -165,7 +165,7 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
 	txwi->pktid = pid;
 
-	ret = mt76x02_insert_hdr_pad(skb);
+	ret = mt76_insert_hdr_pad(skb);
 	if (ret < 0)
 		return ret;
 
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

