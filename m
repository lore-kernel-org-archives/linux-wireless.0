Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB26C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 22:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F7F220880
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 22:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550702137;
	bh=SFAxjjeSOzna7dN1F9c3fo/OJXNKtExvjv3G267ZNFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZlFaKTlkTwHzBLklnQmGdyGrY4DImkBHsrAqbhQqYASWnrCf0jhJAOr6oAMnwr3CB
	 A0UVIdzp4TsXQPRfkZJWPSld51mDI3iQ/yiNcaUqFepZnKQWt8QDXPPuc5DCmAnecK
	 D2/3TrAWqe92tr2wLhqzOanYQLN1yLflSgGJNxnk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbfBTWfg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 17:35:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbfBTWfg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 17:35:36 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A808C20836;
        Wed, 20 Feb 2019 22:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550702135;
        bh=SFAxjjeSOzna7dN1F9c3fo/OJXNKtExvjv3G267ZNFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6JriGxMmF/6/3xg5QjjTEIVU5iThaT8No9z5c1pv91T747QMgpFoyYmJd5M+ng/W
         cnu4awZIcHqk9avQhKasxhMgq89Df1qa0Wjf9OYDVlpBTngUH4n1EC2MHvs+TV9nrw
         mCXLCbTzITP1hcV1v/IP6HohvP+3B8tcaN2PKOAQ=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH 3/3] mt76: usb: simplify mt76u_tx_build_sg routine
Date:   Wed, 20 Feb 2019 23:35:18 +0100
Message-Id: <1f0f5345a786ae811e3074ef4fb3ce017e5e33f2.1550701735.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550701735.git.lorenzo@kernel.org>
References: <cover.1550701735.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Use skb_to_sgvec instad of skb_to_sgvec_nomark in mt76u_tx_build_sg.
Remove nsgs check in mt76u_tx_build_sg since it is already performed
by skb_to_sgvec

Suggested-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 211ef7876de2..cbfddf2ebfeb 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -719,23 +719,12 @@ static int
 mt76u_tx_build_sg(struct mt76_dev *dev, struct sk_buff *skb,
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

