Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2859BC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 08:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F005320863
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 08:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfBKIhy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 03:37:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfBKIhx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 03:37:53 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D87F480467;
        Mon, 11 Feb 2019 08:37:53 +0000 (UTC)
Received: from localhost (ovpn-204-174.brq.redhat.com [10.40.204.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 675C560123;
        Mon, 11 Feb 2019 08:37:46 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC] mt76x02u: correct pad for fragments
Date:   Mon, 11 Feb 2019 09:37:44 +0100
Message-Id: <1549874264-7661-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 11 Feb 2019 08:37:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Modifying skb->len & data_len doesn't look correct. Issue is not critical
we just pad 2 times, except first padding is not filled with zeros.

However I'm not sure if we should not add pad to all skb's in frags
list.

Additionally remove unlikely(pad) condition, we always pad for at least
four bytes what is needed by HW.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 22 +++++++------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index dc2226c722dd..c7ca2d93720a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -49,21 +49,15 @@ int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 	       FIELD_PREP(MT_TXD_INFO_DPORT, port) | flags;
 	put_unaligned_le32(info, skb_push(skb, sizeof(info)));
 
-	pad = round_up(skb->len, 4) + 4 - skb->len;
-	skb_walk_frags(skb, iter) {
+	skb_walk_frags(skb, iter)
 		last = iter;
-		if (!iter->next) {
-			skb->data_len += pad;
-			skb->len += pad;
-			break;
-		}
-	}
-
-	if (unlikely(pad)) {
-		if (skb_pad(last, pad))
-			return -ENOMEM;
-		__skb_put(last, pad);
-	}
+
+	/* Add zero pad of 4 - 7 bytes at the end of buffer */
+	pad = round_up(skb->len, 4) + 4 - skb->len;
+	if (skb_pad(last, pad))
+		return -ENOMEM;
+	__skb_put(last, pad);
+
 	return 0;
 }
 
-- 
2.19.2

