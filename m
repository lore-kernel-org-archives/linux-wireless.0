Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3E6C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 15:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89AE221852
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 15:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbeLTPQR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 10:16:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbeLTPQR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 10:16:17 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 959EE89AC9;
        Thu, 20 Dec 2018 15:16:17 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6024E100194A;
        Thu, 20 Dec 2018 15:16:16 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Randy Oostdyk <linux-kernel@oostdyk.com>,
        =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH v2 3/3] rt2x00: do not print error when queue is full
Date:   Thu, 20 Dec 2018 16:16:11 +0100
Message-Id: <1545318971-28351-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 20 Dec 2018 15:16:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For unknown reasons printk() on some context can cause CPU hung on
embedded MT7620 AP/router MIPS platforms. What can result on wifi
disconnects.

This patch move queue full messages to debug level what is consistent
with other mac80211 drivers which drop packet silently if tx queue is
full. This make MT7620 OpenWRT routers more stable, what was reported
by various users.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index 92ddc19e7bf7..947fc8964e9a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -671,7 +671,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	spin_lock(&queue->tx_lock);
 
 	if (unlikely(rt2x00queue_full(queue))) {
-		rt2x00_err(queue->rt2x00dev, "Dropping frame due to full tx queue %d\n",
+		rt2x00_dbg(queue->rt2x00dev, "Dropping frame due to full tx queue %d\n",
 			   queue->qid);
 		ret = -ENOBUFS;
 		goto out;
-- 
2.7.5

