Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E25CC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57545217D9
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="RQ94wn73"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfBRTmW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:42:22 -0500
Received: from nbd.name ([46.4.11.11]:56642 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfBRTmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 14:42:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yYycXiVPvNB6oOHhdA2Q2BHXHRdLv7VgfW36zopqt6o=; b=RQ94wn733X369NklX7jkWtvAHO
        wPDo3UE979IEvj850Yiw8hFwNLxZjxxbHVYwCc3n8oENAzOVc/0lk9EBxB4HtqlgCeKp2Aqc5/+Zo
        hFPx/JCEyLIm+43400QlbkmZvErYU5Gi2Y3Rtz4NMsyM9p14Ccd8QLpduhi23QK7D7uU=;
Received: by maeck.lan (Postfix, from userid 501)
        id 261DA5004555; Mon, 18 Feb 2019 20:42:18 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mt76: fix tx status timeout processing
Date:   Mon, 18 Feb 2019 20:42:15 +0100
Message-Id: <20190218194218.41314-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove bogus check for MT_PACKET_ID_NO_ACK in mt76_tx_status_skb_get, which
is already handled in callers and turns timeout calls into no-ops
Do not clean up pending status items on reordering of tx status information
if the timeout is not reached yet

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index ef38e8626da9..5a349fe3e576 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -205,9 +205,6 @@ mt76_tx_status_skb_get(struct mt76_dev *dev, struct mt76_wcid *wcid, int pktid,
 {
 	struct sk_buff *skb, *tmp;
 
-	if (pktid == MT_PACKET_ID_NO_ACK)
-		return NULL;
-
 	skb_queue_walk_safe(&dev->status_list, skb, tmp) {
 		struct mt76_tx_cb *cb = mt76_tx_skb_cb(skb);
 
@@ -217,7 +214,7 @@ mt76_tx_status_skb_get(struct mt76_dev *dev, struct mt76_wcid *wcid, int pktid,
 		if (cb->pktid == pktid)
 			return skb;
 
-		if (!pktid &&
+		if (pktid >= 0 &&
 		    !time_after(jiffies, cb->jiffies + MT_TX_STATUS_SKB_TIMEOUT))
 			continue;
 
-- 
2.17.0

