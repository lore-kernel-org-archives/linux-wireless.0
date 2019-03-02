Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF08C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99FAB20863
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551534658;
	bh=VX5jMTes6qzryBKpA7F0ZfrN3TrLH6bgQdrt6fk60sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FlinIqM44Jwlr0gjaJPdSTyCagO/kHDkWR+yetgbdZzwfu/96oxwSBhlAbxIwgzJH
	 UVufyOoldiWsnoJwRoPe+sMe/PYdL1MgrWJGaCRAoYwG758F4MwxQnGkX8CHorIe9q
	 dJe373qjx+XJOGykz6UeJs0Jcp+QgDv89jDmu8WQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfCBNu5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 08:50:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbfCBNu5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 08:50:57 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D729620838;
        Sat,  2 Mar 2019 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551534656;
        bh=VX5jMTes6qzryBKpA7F0ZfrN3TrLH6bgQdrt6fk60sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1j9PvmJ6yFjNMUR4ma3Jxjo59W37szsek+7eZaUFZOcRJhQ2REKx+Z7bHr7n0EP8
         gUeGN1YW0uz+bAkmLSHYondU2RqU/muN+/kEmEuVw2YU8BPNmITDcHX5MpZ9J7UkOQ
         v7jLiq7ipy6mJg/itzuplM8Ufzz/sKGhB3xlki5Y=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76: usb: reduce code indentation in mt76u_alloc_tx
Date:   Sat,  2 Mar 2019 14:50:49 +0100
Message-Id: <2ead6e0fc3222faa772a37d55736c03041c90a1f.1551534029.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551534029.git.lorenzo@kernel.org>
References: <cover.1551534029.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Improve code readability reducing code indentation in
mt76u_alloc_tx

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 4c1abd492405..c30878d2dc5c 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -787,6 +787,7 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 {
 	struct mt76u_buf *buf;
 	struct mt76_queue *q;
+	size_t size;
 	int i, j;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
@@ -810,15 +811,15 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 			if (!buf->urb)
 				return -ENOMEM;
 
-			if (dev->usb.sg_en) {
-				size_t size = MT_SG_MAX_SIZE *
-					      sizeof(struct scatterlist);
+			if (!dev->usb.sg_en)
+				continue;
 
-				buf->urb->sg = devm_kzalloc(dev->dev, size,
-							    GFP_KERNEL);
-				if (!buf->urb->sg)
-					return -ENOMEM;
-			}
+			size = MT_SG_MAX_SIZE * sizeof(struct scatterlist);
+
+			buf->urb->sg = devm_kzalloc(dev->dev, size,
+						    GFP_KERNEL);
+			if (!buf->urb->sg)
+				return -ENOMEM;
 		}
 	}
 	return 0;
-- 
2.20.1

