Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB9CC43444
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBE2C20851
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:51:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="WJvGl5NP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfAQNvg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:51:36 -0500
Received: from nbd.name ([46.4.11.11]:56458 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbfAQNvg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O1agXxWSGn9aB/67OY+JnD8FZ8jKvGakUm7F87n7wx8=; b=WJvGl5NPaDnnWYu3+eHq9KcyUf
        Xcl8voIgnYBOWOuLshd+9nCiL/wIYPoGjW2etHuDsU/0yy42Y7gbcc2dN1oEZQ5tJBmffEI5dlLoV
        doeFszWXwIA+1LWCZPYj/cBV6XWCmGvtPpjvYpNWc7rSy3Wz3Si6fJHmjePbUPLyCnPA=;
Received: by maeck.lan (Postfix, from userid 501)
        id 354024C6F04E; Thu, 17 Jan 2019 14:51:33 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] mt76: fix tx status reporting for non-probing frames
Date:   Thu, 17 Jan 2019 14:51:27 +0100
Message-Id: <20190117135133.2753-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On MT76x2, the hardware does not report tx status in the FIFO register,
if the packet id is 0.
Change the allocation of packet IDs to use 0 for no-ack packets, 1 for
non-probing packets and 2-255 for packets with tx status requested.
Fixes rate control issues

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h             | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c      | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c | 3 +--
 drivers/net/wireless/mediatek/mt76/tx.c               | 9 +++++----
 5 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 8ef430d8afc4..8d56ab97abe3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -239,7 +239,9 @@ struct mt76_rx_tid {
 #define MT_TX_CB_TXS_FAILED		BIT(2)
 
 #define MT_PACKET_ID_MASK		GENMASK(7, 0)
-#define MT_PACKET_ID_NO_ACK		MT_PACKET_ID_MASK
+#define MT_PACKET_ID_NO_ACK		0
+#define MT_PACKET_ID_NO_SKB		1
+#define MT_PACKET_ID_FIRST		2
 
 #define MT_TX_STATUS_SKB_TIMEOUT	HZ
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 6adea0278284..38cd77d30f5c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -433,7 +433,7 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 	}
 
 	if (wcid) {
-		if (stat->pktid)
+		if (stat->pktid >= MT_PACKET_ID_FIRST)
 			status.skb = mt76_tx_status_skb_get(mdev, wcid,
 							    stat->pktid, &list);
 		if (status.skb)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index 4598cb2cc3ff..a5413a309a0a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -177,7 +177,7 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	if (ret < 0)
 		return ret;
 
-	if (pid && pid != MT_PACKET_ID_NO_ACK)
+	if (pid >= MT_PACKET_ID_FIRST)
 		qsel = MT_QSEL_MGMT;
 
 	*tx_info = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 81970cf777c0..098d05e109e7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -87,8 +87,7 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
 	txwi->pktid = pid;
 
-	if ((pid && pid != MT_PACKET_ID_NO_ACK) ||
-	    q2ep(q->hw_idx) == MT_EP_OUT_HCCA)
+	if (pid >= MT_PACKET_ID_FIRST || q2ep(q->hw_idx) == MT_EP_OUT_HCCA)
 		qsel = MT_QSEL_MGMT;
 	else
 		qsel = MT_QSEL_EDCA;
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index f08509c1670d..1ea08ce62713 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -170,21 +170,22 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 	int pid;
 
 	if (!wcid)
-		return 0;
+		return MT_PACKET_ID_NO_ACK;
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return MT_PACKET_ID_NO_ACK;
 
 	if (!(info->flags & (IEEE80211_TX_CTL_REQ_TX_STATUS |
 			     IEEE80211_TX_CTL_RATE_CTRL_PROBE)))
-		return 0;
+		return MT_PACKET_ID_NO_SKB;
 
 	spin_lock_bh(&dev->status_list.lock);
 
 	memset(cb, 0, sizeof(*cb));
 	wcid->packet_id = (wcid->packet_id + 1) & MT_PACKET_ID_MASK;
-	if (!wcid->packet_id || wcid->packet_id == MT_PACKET_ID_NO_ACK)
-		wcid->packet_id = 1;
+	if (wcid->packet_id == MT_PACKET_ID_NO_ACK ||
+	    wcid->packet_id == MT_PACKET_ID_NO_SKB)
+		wcid->packet_id = MT_PACKET_ID_FIRST;
 
 	pid = wcid->packet_id;
 	cb->wcid = wcid->idx;
-- 
2.17.0

