Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A1AC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 14:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5FC02146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 14:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550671553;
	bh=bz7HMCpga5Y3lSsrapXlbvvO8LjIopHploTHVeBoNwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LkVfVXnSZ1eSaKimECwz1tb+94zlje+z4hsLMj60egWaQz3uwjnOpXrT3peCBC/f6
	 uyYsKKZCKBvgn0ui8aFukjax/zKzu2xEAqcmKOcK8oWfrAZvMuOVkk0FSd71K21ihB
	 s2js426D0vOemtWa/O+VP8TYxtlOLwAR8+DIMfd8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfBTOFx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 09:05:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbfBTOFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 09:05:52 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 236DF2147A;
        Wed, 20 Feb 2019 14:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550671552;
        bh=bz7HMCpga5Y3lSsrapXlbvvO8LjIopHploTHVeBoNwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVkCzXaoGuBlci8RTNrKT7C2TyGFYWaOW6APybIaPmeL+BK0eqbJCi4mp/ofU8ClN
         XXdtUdA9oP5LC8kCN/yh2JKbu6Qa8AddfAns5L0lZVJIwI9d6cjALkL4PQRbag8ZRV
         X++r2prBR8LEuujEGY+YWwc9Ag3r4kwleTLW5LX8=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [RFC 3/3] mt76: usb: simplify mt76u_tx_build_sg routine
Date:   Wed, 20 Feb 2019 15:05:35 +0100
Message-Id: <517694b70bc88a867d4bc3c62cce05c3d3eb7faa.1550671183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550671183.git.lorenzo@kernel.org>
References: <cover.1550671183.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Use skb_to_sgvec instad of skb_to_sgvec_nomark in mt76u_tx_build_sg.
Moreover remove nsgs check since it is already performed in skb_to_sgvec

Suggested-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 24bf96de9f9d..87b89d5f1d03 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -724,23 +724,12 @@ static int
 mt76u_tx_build_sg(struct mt76_dev * dev, struct sk_buff *skb,
 		  struct urb *urb)
 {
-	struct sk_buff *iter;
-	int nsgs;
-
 	if (!dev->usb.sg_en)
 		return 0;
 
-	nsgs = 1 + skb_shinfo(skb)->nr_frags;
-	skb_walk_frags(skb, iter)
-		nsgs += 1 + skb_shinfo(iter)->nr_frags;
-
-	memset(urb->sg, 0, sizeof(*urb->sg) * MT_SG_MAX_SIZE);
-
-	nsgs = min_t(int, MT_SG_MAX_SIZE, nsgs);
-	sg_init_marker(urb->sg, nsgs);
-	urb->num_sgs = nsgs;
-
-	return skb_to_sgvec_nomark(skb, urb->sg, 0, skb->len);
+	sg_init_table(urb->sg, MT_SG_MAX_SIZE);
+	urb->num_sgs = skb_to_sgvec(skb, urb->sg, 0, skb->len);
+	return urb->num_sgs;
 }
 
 static int
-- 
2.20.1

