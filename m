Return-Path: <SRS0=KylO=Z2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2A2C432C3
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Dec 2019 05:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C97AB2073C
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Dec 2019 05:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfLDFoB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 4 Dec 2019 00:44:01 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:48832 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfLDFoB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Dec 2019 00:44:01 -0500
Received: from localhost.localdomain ([90.126.97.183])
        by mwinf5d51 with ME
        id Zhjw2100L3xPcdm03hjxz8; Wed, 04 Dec 2019 06:43:59 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 04 Dec 2019 06:43:59 +0100
X-ME-IP: 90.126.97.183
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sgruszka@redhat.com, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] rt2x00usb: Fix a warning message in 'rt2x00usb_watchdog_tx_dma()'
Date:   Wed,  4 Dec 2019 06:43:55 +0100
Message-Id: <20191204054355.11729-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

'forced' is duplicated in the message, axe one of them.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index bc2dfef0de22..92e9e023c349 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -522,7 +522,7 @@ EXPORT_SYMBOL_GPL(rt2x00usb_flush_queue);
 
 static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 {
-	rt2x00_warn(queue->rt2x00dev, "TX queue %d DMA timed out, invoke forced forced reset\n",
+	rt2x00_warn(queue->rt2x00dev, "TX queue %d DMA timed out, invoke forced reset\n",
 		    queue->qid);
 
 	rt2x00queue_stop_queue(queue);
-- 
2.20.1

