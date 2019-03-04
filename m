Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8165C10F06
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F9C72082F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="rWndiidZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfCDICo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 03:02:44 -0500
Received: from nbd.name ([46.4.11.11]:40450 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfCDICn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 03:02:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cy6vZMFeuMoX+nSvnHC+hsQUM/hrysbs56i2Uonnvrs=; b=rWndiidZepspqVsMJvKqQVOMNA
        u5TcFhJWbiRR1pCUNX+wG0pzr1v+/3LQcfD1cXJ0Nku7Kh8WhdcNwACsLOYmrRVKd68WuJJFLuGPI
        xl/DCzs1vC2p3mwXsreXZCtsrPy8T8kRC+0OwpyfIFm1tgGPdDp5ywXq6CylrKccJHUU=;
Received: by maeck.lan (Postfix, from userid 501)
        id 1922C50E5412; Mon,  4 Mar 2019 09:02:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 07/11] mt76: mt7603: notify mac80211 about buffered frames in ps queue
Date:   Mon,  4 Mar 2019 09:02:30 +0100
Message-Id: <20190304080234.3221-7-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190304080234.3221-1-nbd@nbd.name>
References: <20190304080234.3221-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Also fix the size check for filtered powersave frames
Fixes a corner case with waking up clients

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index 72d189daad38..4606b539190f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -24,12 +24,16 @@ static void
 mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 {
 	__le32 *txd = (__le32 *)skb->data;
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_sta *sta;
 	struct mt7603_sta *msta;
 	struct mt76_wcid *wcid;
+	void *priv;
 	int idx;
 	u32 val;
+	u8 tid;
 
-	if (skb->len < sizeof(MT_TXD_SIZE) + sizeof(struct ieee80211_hdr))
+	if (skb->len < MT_TXD_SIZE + sizeof(struct ieee80211_hdr))
 		goto free;
 
 	val = le32_to_cpu(txd[1]);
@@ -43,7 +47,7 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	if (!wcid)
 		goto free;
 
-	msta = container_of(wcid, struct mt7603_sta, wcid);
+	priv = msta = container_of(wcid, struct mt7603_sta, wcid);
 	val = le32_to_cpu(txd[0]);
 	skb_set_queue_mapping(skb, FIELD_GET(MT_TXD0_Q_IDX, val));
 
@@ -51,6 +55,11 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 	val |= FIELD_PREP(MT_TXD0_Q_IDX, MT_TX_HW_QUEUE_MGMT);
 	txd[0] = cpu_to_le32(val);
 
+	sta = container_of(priv, struct ieee80211_sta, drv_priv);
+	hdr = (struct ieee80211_hdr *) &skb->data[MT_TXD_SIZE];
+	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+	ieee80211_sta_set_buffered(sta, tid, true);
+
 	spin_lock_bh(&dev->ps_lock);
 	__skb_queue_tail(&msta->psq, skb);
 	if (skb_queue_len(&msta->psq) >= 64) {
-- 
2.17.0

