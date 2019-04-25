Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D53AC43218
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 14:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40E982081C
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 14:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfDYOmM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:42:12 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:61175 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725900AbfDYOmM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 10:42:12 -0400
X-UUID: 1237c519beb144d0bed54fd807e93833-20190425
X-UUID: 1237c519beb144d0bed54fd807e93833-20190425
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 809769604; Thu, 25 Apr 2019 22:42:04 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 25 Apr 2019 22:42:03 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 25 Apr 2019 22:42:03 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
CC:     Roy Luo <royluo@google.com>, Sean Wang <sean.wang@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH] mt76: fix endianness sparse warnings
Date:   Thu, 25 Apr 2019 22:42:01 +0800
Message-ID: <865a5eb36f295fc81e3dcbe95929dcfce4956897.1556203212.git.ryder.lee@mediatek.com>
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
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 2f2961ee0a92..af5769d05e6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -627,7 +627,7 @@ mt7603_mac_fill_rx(struct mt7603_dev *dev, struct sk_buff *skb)
 	status->aggr = unicast &&
 		       !ieee80211_is_qos_nullfunc(hdr->frame_control);
 	status->tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
-	status->seqno = IEEE80211_SEQ_TO_SN(hdr->seq_ctrl);
+	status->seqno = IEEE80211_SEQ_TO_SN(__le16_to_cpu(hdr->seq_ctrl));
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 1bf3e7b5f6a7..4b934b0f5a39 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -235,7 +235,7 @@ int mt7615_mac_fill_rx(struct mt7615_dev *dev, struct sk_buff *skb)
 	status->aggr = unicast &&
 		       !ieee80211_is_qos_nullfunc(hdr->frame_control);
 	status->tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
-	status->seqno = IEEE80211_SEQ_TO_SN(hdr->seq_ctrl);
+	status->seqno = IEEE80211_SEQ_TO_SN(__le16_to_cpu(hdr->seq_ctrl));
 
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

