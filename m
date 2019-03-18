Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C55C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 11:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 808CE2084F
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 11:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552907380;
	bh=k+Frzi7BVfLfyxXVWq4cn3RCKugLdNxOLoL+8n462WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AEcp+A7bTIf8zuGN+V+5mCrLEwuZytaEUsBkUa7Io9v4XnutGxvb0q1s/yHOhf17y
	 IFSV1D91UvQVu6p+B3hTXb0DbKATemdqAViwMxoJzZKG0S4iPJJVLTj0w9vlwaVQu7
	 SpIXCVMG235JLcI4E4DZt2ceUJcf9+JZLvInUOgg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfCRLJj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 07:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726914AbfCRLJj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 07:09:39 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CA5F2084F;
        Mon, 18 Mar 2019 11:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552907378;
        bh=k+Frzi7BVfLfyxXVWq4cn3RCKugLdNxOLoL+8n462WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Dwgdq+SwyyGR9jYrkJ7XMXEcn6S/FvKqfN/a568baatGULojwqB1naImhjgqzZ8C
         uPQeYWtSi2inonjEy0ONDvF1vEK6JQu8K0lMc6AwxsymLI0Fzzxc1D9qWAOigdeIHm
         6jhP/UmeJOhdDa/cElXae1q8js7ayl5Jm77Guwf0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com
Subject: [RFC] mt76: usb: reduce locking in mt76u_tx_tasklet
Date:   Mon, 18 Mar 2019 12:09:32 +0100
Message-Id: <1ee5ce7818f9d45c9713ce99e810cb84f50dcf03.1552907276.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552907276.git.lorenzo@kernel.org>
References: <cover.1552907276.git.lorenzo@kernel.org>
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
 drivers/net/wireless/mediatek/mt76/usb.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index ac03acdae279..8cd70c32d77a 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -634,29 +634,33 @@ static void mt76u_tx_tasklet(unsigned long data)
 	int i;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		u32 n_queued = 0, n_sw_queued = 0;
+
 		sq = &dev->q_tx[i];
 		q = sq->q;
 
-		spin_lock_bh(&q->lock);
-		while (true) {
+		while (q->queued > n_queued) {
 			buf = &q->entry[q->head].ubuf;
-			if (!buf->done || !q->queued)
+			if (!buf->done)
 				break;
 
 			if (q->entry[q->head].schedule) {
 				q->entry[q->head].schedule = false;
-				sq->swq_queued--;
+				n_sw_queued++;
 			}
 
 			entry = q->entry[q->head];
 			q->head = (q->head + 1) % q->ndesc;
-			q->queued--;
+			n_queued++;
 
-			spin_unlock_bh(&q->lock);
 			dev->drv->tx_complete_skb(dev, i, &entry);
-			spin_lock_bh(&q->lock);
 		}
 
+		spin_lock_bh(&q->lock);
+
+		sq->swq_queued -= n_sw_queued;
+		q->queued -= n_queued;
+
 		wake = q->stopped && q->queued < q->ndesc - 8;
 		if (wake)
 			q->stopped = false;
-- 
2.20.1

