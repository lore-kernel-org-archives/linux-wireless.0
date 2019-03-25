Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B99BC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 19:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAE602087C
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 19:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553541531;
	bh=35X4Y/p7hWOVJgc/ZPgRzxYJLNx7eN7kzEKnA5ERo/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Iy/9Uti9kt/PKq8lDvdqSa5fBsjIRIg63KG/eb61jWKN5nWNsU9KR2rC1MA3VJJJR
	 sunrryIY7YqzedDGjbhdof5P0Ve/1Vk6N1ViFtIqGaNkeT8S2yQQHHkHASxRprYAQl
	 QPT+Qg3jOhQdhByu8PeAAQVrX+Bkz6a7Z5HqRb/U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbfCYTSu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 15:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729761AbfCYTSt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 15:18:49 -0400
Received: from localhost.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A2FF20854;
        Mon, 25 Mar 2019 19:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553541529;
        bh=35X4Y/p7hWOVJgc/ZPgRzxYJLNx7eN7kzEKnA5ERo/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSU4zDJr+kvcCTTJvOuHdEUpZewh3zDLkrLU9tMmWGzxpTbTkRuqdzCpsRXEUXR8f
         3RrZzo2HPUmms8dC4DsRwEAYEa0Jmz+o6+vHr3rOpDqH93kEvmXCc7nWQGu3TWT5G3
         IrhJR6n3rCFyhXttZ3QygspsgGevpnGmzmSUK3fY=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com
Subject: [PATCH v2] mt76: usb: reduce locking in mt76u_tx_tasklet
Date:   Mon, 25 Mar 2019 20:18:38 +0100
Message-Id: <7e6146236dac0d616519e2a6e4b32fac9a1cae2f.1553541103.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1553541103.git.lorenzo@kernel.org>
References: <cover.1553541103.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Similar to pci counterpart, reduce locking in mt76u_tx_tasklet since
q->head is managed just in mt76u_tx_tasklet and q->queued is updated
holding q->lock

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- drop idx variable
Changes since RFC:
- reset done to false in mt76u_tx_tasklet instead of in mt76u_tx_queue_skb
This patch is based on https://patchwork.kernel.org/patch/10856027/
---
 drivers/net/wireless/mediatek/mt76/usb.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 15aeda0582e7..fb8b22c1655a 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -624,28 +624,33 @@ static void mt76u_tx_tasklet(unsigned long data)
 	int i;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		u32 n_dequeued = 0, n_sw_dequeued = 0;
+
 		sq = &dev->q_tx[i];
 		q = sq->q;
 
-		spin_lock_bh(&q->lock);
-		while (true) {
-			if (!q->entry[q->head].done || !q->queued)
+		while (q->queued > n_dequeued) {
+			if (!q->entry[q->head].done)
 				break;
 
 			if (q->entry[q->head].schedule) {
 				q->entry[q->head].schedule = false;
-				sq->swq_queued--;
+				n_sw_dequeued++;
 			}
 
 			entry = q->entry[q->head];
+			q->entry[q->head].done = false;
 			q->head = (q->head + 1) % q->ndesc;
-			q->queued--;
+			n_dequeued++;
 
-			spin_unlock_bh(&q->lock);
 			dev->drv->tx_complete_skb(dev, i, &entry);
-			spin_lock_bh(&q->lock);
 		}
 
+		spin_lock_bh(&q->lock);
+
+		sq->swq_queued -= n_sw_dequeued;
+		q->queued -= n_dequeued;
+
 		wake = q->stopped && q->queued < q->ndesc - 8;
 		if (wake)
 			q->stopped = false;
@@ -741,7 +746,6 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	if (err < 0)
 		return err;
 
-	q->entry[idx].done = false;
 	urb = q->entry[idx].urb;
 	err = mt76u_tx_setup_buffers(dev, skb, urb);
 	if (err < 0)
-- 
2.20.1

