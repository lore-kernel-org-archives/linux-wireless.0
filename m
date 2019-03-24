Return-Path: <SRS0=yoP0=R3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673ACC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 14:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B8A721906
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 14:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553439297;
	bh=LXBF2R8bIAyDDO/smDih3uCtHsR3PVkpUj70P9WaklE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HE3EQ1yOXILXcwGgkDr4Ew1FvuihnJD7p8gIYoRHq63wCE/9egvSZd0KSwY8eFLtL
	 h7BPPN1m4KqcgV86jnZmvNj1PYTxJg57V3LvTaIF5hpQwUd8weXmYSlIZEzEISm8Jr
	 C6KhaXvaUi+LDqQ4WgSN2SD61YaeavpENP1262DA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfCXOvx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Mar 2019 10:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbfCXOvx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Mar 2019 10:51:53 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2988E2147C;
        Sun, 24 Mar 2019 14:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553439112;
        bh=LXBF2R8bIAyDDO/smDih3uCtHsR3PVkpUj70P9WaklE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miLICvz24dJlqwO75jk5CDdel/XCSdKfWD28kVHufaRFZzfXwL8Zseewf3sW7gqBN
         LLII88BIxQ35Y0jgQbiXoAZMAmX7mNTzsXGlAaqUqAdXX72x4BTe3nXWv3yfCqGkSz
         niEMwnidjl+eZ8cC+V0dpqaYgcZAhff0zfmkMmjg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com
Subject: [PATCH] mt76: usb: reduce locking in mt76u_tx_tasklet
Date:   Sun, 24 Mar 2019 15:51:43 +0100
Message-Id: <1f489df8bc635660a1d1fb72400e5562504c0555.1553437543.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1553437543.git.lorenzo@kernel.org>
References: <cover.1553437543.git.lorenzo@kernel.org>
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
Changes since RFC:
- reset done to false in mt76u_tx_tasklet instead of in mt76u_tx_queue_skb
---
 drivers/net/wireless/mediatek/mt76/usb.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 15aeda0582e7..f06112180694 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -624,28 +624,35 @@ static void mt76u_tx_tasklet(unsigned long data)
 	int i;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		u32 n_queued = 0, n_sw_queued = 0;
+		int idx;
+
 		sq = &dev->q_tx[i];
 		q = sq->q;
 
-		spin_lock_bh(&q->lock);
-		while (true) {
-			if (!q->entry[q->head].done || !q->queued)
+		while (q->queued > n_queued) {
+			if (!q->entry[q->head].done)
 				break;
 
 			if (q->entry[q->head].schedule) {
 				q->entry[q->head].schedule = false;
-				sq->swq_queued--;
+				n_sw_queued++;
 			}
 
+			idx = q->head;
 			entry = q->entry[q->head];
 			q->head = (q->head + 1) % q->ndesc;
-			q->queued--;
+			n_queued++;
 
-			spin_unlock_bh(&q->lock);
 			dev->drv->tx_complete_skb(dev, i, &entry);
-			spin_lock_bh(&q->lock);
+			q->entry[idx].done = false;
 		}
 
+		spin_lock_bh(&q->lock);
+
+		sq->swq_queued -= n_sw_queued;
+		q->queued -= n_queued;
+
 		wake = q->stopped && q->queued < q->ndesc - 8;
 		if (wake)
 			q->stopped = false;
@@ -741,7 +748,6 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	if (err < 0)
 		return err;
 
-	q->entry[idx].done = false;
 	urb = q->entry[idx].urb;
 	err = mt76u_tx_setup_buffers(dev, skb, urb);
 	if (err < 0)
-- 
2.20.1

