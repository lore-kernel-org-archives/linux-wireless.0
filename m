Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E46C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 09:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64C1221773
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 09:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfBLJYq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 04:24:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727660AbfBLJYq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 04:24:46 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DCF3286679;
        Tue, 12 Feb 2019 09:24:45 +0000 (UTC)
Received: from localhost (ovpn-204-125.brq.redhat.com [10.40.204.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 423E462F8B;
        Tue, 12 Feb 2019 09:24:42 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH] mt76x02u: remove bogus check and comment padding
Date:   Tue, 12 Feb 2019 10:24:42 +0100
Message-Id: <1549963482-13523-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 12 Feb 2019 09:24:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In mt76x02u_skb_dma_info() pad is always non-zero. Patch removes
bogus check and add comments to the function.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index dc2226c722dd..31df06a05b09 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -49,7 +49,12 @@ int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 	       FIELD_PREP(MT_TXD_INFO_DPORT, port) | flags;
 	put_unaligned_le32(info, skb_push(skb, sizeof(info)));
 
+	/* Add zero pad of 4 - 7 bytes */
 	pad = round_up(skb->len, 4) + 4 - skb->len;
+
+	/* First packet of a A-MSDU burst keeps track of the whole burst
+	 * length, need to update lenght of it and the last packet.
+	 */
 	skb_walk_frags(skb, iter) {
 		last = iter;
 		if (!iter->next) {
@@ -59,11 +64,10 @@ int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 		}
 	}
 
-	if (unlikely(pad)) {
-		if (skb_pad(last, pad))
-			return -ENOMEM;
-		__skb_put(last, pad);
-	}
+	if (skb_pad(last, pad))
+		return -ENOMEM;
+	__skb_put(last, pad);
+
 	return 0;
 }
 
-- 
2.19.2

