Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3A6C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 21:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4803221917
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 21:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553205128;
	bh=ulYwG0F5KYe/15mcyzD5dIJhKe0L3Nj6vt7OcqudvX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TzHEsIZHbFQbyHYYLE/CxZxBkgcLv5q9fdemYZQq79AWdoknwzdgdfWpVMmYbAcV/
	 JL+1Jcvz7RdNv76YBPurnhj9BFi6I7hfObIBUzL372K3TvMAElUCD9QgczLM1cLiqv
	 np8c5a4W9A9nrFgL1KTzuAeereoNw25L8IZ1FxIs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfCUVwH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 17:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfCUVwH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 17:52:07 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C713621916;
        Thu, 21 Mar 2019 21:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553205126;
        bh=ulYwG0F5KYe/15mcyzD5dIJhKe0L3Nj6vt7OcqudvX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wt0g1++eW25hNrfaQTt0SSxK5JFlrIp/RhSatg8nexP88sDtv260k2njCLaVXI5QI
         KRSU0t0RbpvACcIY7vgsKMuOP9ULd2m+BNsoscRSrcR46oKhXQpONBVPf17mV3cH6k
         Oz5gV2ko5qiC2eLdk0EyPElGawMdPB/w1g7ezToQ=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com
Subject: [PATCH] mt76: tx: check return value of tx_queue_skb in mt76_tx
Date:   Thu, 21 Mar 2019 22:51:56 +0100
Message-Id: <c57c934c56942a64d6bb09d8fbc6c704568c707c.1553204966.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1553204966.git.lorenzo@kernel.org>
References: <cover.1553204966.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not kick the queue if tx_queue_skb fails in mt76_tx

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 60bbb6561d8f..833c414cea83 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -258,8 +258,8 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	int err, qid = skb_get_queue_mapping(skb);
 	struct mt76_queue *q;
-	int qid = skb_get_queue_mapping(skb);
 
 	if (WARN_ON(qid >= MT_TXQ_PSD)) {
 		qid = MT_TXQ_BE;
@@ -286,7 +286,10 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	q = dev->q_tx[qid].q;
 
 	spin_lock_bh(&q->lock);
-	dev->queue_ops->tx_queue_skb(dev, qid, skb, wcid, sta);
+	err = dev->queue_ops->tx_queue_skb(dev, qid, skb, wcid, sta);
+	if (err < 0)
+		goto out;
+
 	dev->queue_ops->kick(dev, q);
 
 	if (q->queued > q->ndesc - 8 && !q->stopped) {
@@ -294,6 +297,7 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		q->stopped = true;
 	}
 
+out:
 	spin_unlock_bh(&q->lock);
 }
 EXPORT_SYMBOL_GPL(mt76_tx);
-- 
2.20.1

