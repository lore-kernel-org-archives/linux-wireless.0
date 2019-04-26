Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F9BC43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 08:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D21772077B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 08:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfDZIJf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 04:09:35 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:11469 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725854AbfDZIJe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 04:09:34 -0400
X-UUID: cd9fc6e4eee9439f88dd73de72256b5f-20190426
X-UUID: cd9fc6e4eee9439f88dd73de72256b5f-20190426
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 342274836; Fri, 26 Apr 2019 16:09:30 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 26 Apr 2019 16:09:29 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 26 Apr 2019 16:09:29 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>
CC:     Roy Luo <royluo@google.com>, YF Luo <yf.luo@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v2] mt76: fix endianness sparse warnings
Date:   Fri, 26 Apr 2019 16:09:22 +0800
Message-ID: <d593c15bae7b4d72df17c3c4670ca9e28ef5c47f.1556265836.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix many warnings with incorrect endian assumptions.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
Change since v2: use standard le16_to_cpu() instead of underscored version 
---
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 2f2961ee0a92..b1d96a46a41c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -627,7 +627,7 @@ mt7603_mac_fill_rx(struct mt7603_dev *dev, struct sk_buff *skb)
 	status->aggr = unicast &&
 		       !ieee80211_is_qos_nullfunc(hdr->frame_control);
 	status->tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
-	status->seqno = IEEE80211_SEQ_TO_SN(hdr->seq_ctrl);
+	status->seqno = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 1bf3e7b5f6a7..b8f48d10f27a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -235,7 +235,7 @@ int mt7615_mac_fill_rx(struct mt7615_dev *dev, struct sk_buff *skb)
 	status->aggr = unicast &&
 		       !ieee80211_is_qos_nullfunc(hdr->frame_control);
 	status->tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
-	status->seqno = IEEE80211_SEQ_TO_SN(hdr->seq_ctrl);
+	status->seqno = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 
 	return 0;
 }
@@ -337,7 +337,7 @@ int mt7615_mac_write_txwi(struct mt7615_dev *dev, __le32 *txwi,
 	struct ieee80211_vif *vif = info->control.vif;
 	int tx_count = 8;
 	u8 fc_type, fc_stype, p_fmt, q_idx, omac_idx = 0;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	u16 seqno = 0;
 	u32 val;
 
@@ -353,8 +353,8 @@ int mt7615_mac_write_txwi(struct mt7615_dev *dev, __le32 *txwi,
 		tx_count = msta->rate_count;
 	}
 
-	fc_type = (fc & IEEE80211_FCTL_FTYPE) >> 2;
-	fc_stype = (fc & IEEE80211_FCTL_STYPE) >> 4;
+	fc_type = (le16_to_cpu(fc) & IEEE80211_FCTL_FTYPE) >> 2;
+	fc_stype = (le16_to_cpu(fc) & IEEE80211_FCTL_STYPE) >> 4;
 
 	if (ieee80211_is_data(fc)) {
 		q_idx = skb_get_queue_mapping(skb);
@@ -468,7 +468,7 @@ void mt7615_txp_skb_unmap(struct mt76_dev *dev,
 	txp = (struct mt7615_txp *)(txwi + MT_TXD_SIZE);
 	for (i = 1; i < txp->nbuf; i++)
 		dma_unmap_single(dev->dev, le32_to_cpu(txp->buf[i]),
-				 le32_to_cpu(txp->len[i]), DMA_TO_DEVICE);
+				 le16_to_cpu(txp->len[i]), DMA_TO_DEVICE);
 }
 
 int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
@@ -506,7 +506,7 @@ int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	txp = (struct mt7615_txp *)(txwi + MT_TXD_SIZE);
 	for (i = 0; i < nbuf; i++) {
 		txp->buf[i] = cpu_to_le32(tx_info->buf[i + 1].addr);
-		txp->len[i] = cpu_to_le32(tx_info->buf[i + 1].len);
+		txp->len[i] = cpu_to_le16(tx_info->buf[i + 1].len);
 	}
 	txp->nbuf = nbuf;
 
-- 
2.18.0

