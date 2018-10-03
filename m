Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358E6C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 08:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05DA620835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 08:17:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05DA620835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbeJCPEf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 11:04:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbeJCPEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 11:04:34 -0400
Received: from smtp.corp.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA2A6C003EBC;
        Wed,  3 Oct 2018 08:17:15 +0000 (UTC)
Received: from localhost (ovpn-204-105.brq.redhat.com [10.40.204.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B14A09D7E4;
        Wed,  3 Oct 2018 08:17:12 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: fix frag length allocation for usb
Date:   Wed,  3 Oct 2018 10:17:11 +0200
Message-Id: <1538554631-5168-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.27
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 03 Oct 2018 08:17:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is correct fix for c12128ce44b0 ("mt76: use a per rx queue page
fragment cache"). We use wrong length when we allocate segments for
MCU transmissions, which require bigger segment size than e->buf_size.

Commit 481bb0432414 ("mt76: usb: make rx page_frag_cache access atomic")
partially solved the problem or actually mask it by changing
mt76u_mcu_init_rx() and mt76u_alloc_queues() sequence, so e->buf_size
become non zero any longer, but still not big enough to handle MCU data.

Patch fixes memory corruption which can manifest itself as random,
not easy to reproduce crashes, during mt76 driver load or unload.

Fixes: c12128ce44b0 ("mt76: use a per rx queue page fragment cache")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index de7785c4f6af..6b643ea701e3 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -286,7 +286,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		void *data;
 		int offset;
 
-		data = page_frag_alloc(&q->rx_page, q->buf_size, GFP_ATOMIC);
+		data = page_frag_alloc(&q->rx_page, len, GFP_ATOMIC);
 		if (!data)
 			break;
 
-- 
2.7.5

