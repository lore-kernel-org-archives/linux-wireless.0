Return-Path: <SRS0=b555=BB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE81C433E1
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Jul 2020 10:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5985206F5
	for <linux-wireless@archiver.kernel.org>; Wed, 22 Jul 2020 10:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731876AbgGVKRK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 22 Jul 2020 06:17:10 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:54472 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731610AbgGVKRJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Jul 2020 06:17:09 -0400
Received: from localhost.localdomain ([93.23.199.134])
        by mwinf5d52 with ME
        id 6AH32300b2uUVcV03AH4tY; Wed, 22 Jul 2020 12:17:06 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 22 Jul 2020 12:17:06 +0200
X-ME-IP: 93.23.199.134
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] ipw2100: Use GFP_KERNEL instead of GFP_ATOMIC in some memory allocation
Date:   Wed, 22 Jul 2020 12:17:01 +0200
Message-Id: <20200722101701.26126-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The call chain is:
   ipw2100_pci_init_one            (the probe function)
     --> ipw2100_queues_allocate
       --> ipw2100_tx_allocate

No lock is taken in the between.
So it is safe to use GFP_KERNEL in 'ipw2100_tx_allocate()'.

BTW, 'ipw2100_queues_allocate()' also calls 'ipw2100_msg_allocate()' which
already allocates some memory using GFP_KERNEL.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 83d2f2acc0de..699deca745a2 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -4430,7 +4430,7 @@ static int ipw2100_tx_allocate(struct ipw2100_priv *priv)
 
 	priv->tx_buffers = kmalloc_array(TX_PENDED_QUEUE_LENGTH,
 					 sizeof(struct ipw2100_tx_packet),
-					 GFP_ATOMIC);
+					 GFP_KERNEL);
 	if (!priv->tx_buffers) {
 		bd_queue_free(priv, &priv->tx_queue);
 		return -ENOMEM;
-- 
2.25.1

