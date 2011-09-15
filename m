Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57945 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932575Ab1IOK75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 06:59:57 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH] ath9k: sync the dma buffer after changing the retry flag
Date: Thu, 15 Sep 2011 12:59:49 +0200
Message-Id: <1316084389-68945-1-git-send-email-nbd@openwrt.org> (sfid-20110915_130000_502133_82DF6386)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 31a01b5..7794011 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -262,6 +262,7 @@ static void ath_tx_set_retry(struct ath_softc *sc, struct ath_txq *txq,
 			     struct sk_buff *skb)
 {
 	struct ath_frame_info *fi = get_frame_info(skb);
+	struct ath_buf *bf = fi->bf;
 	struct ieee80211_hdr *hdr;
 
 	TX_STAT_INC(txq->axq_qnum, a_retries);
@@ -270,6 +271,8 @@ static void ath_tx_set_retry(struct ath_softc *sc, struct ath_txq *txq,
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_RETRY);
+	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+		sizeof(*hdr), DMA_TO_DEVICE);
 }
 
 static struct ath_buf *ath_tx_get_buffer(struct ath_softc *sc)
-- 
1.7.3.2

