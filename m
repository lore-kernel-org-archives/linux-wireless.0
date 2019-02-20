Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACBDC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 23:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F87220880
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 23:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550707050;
	bh=QtmkSGKzMYYyX3TT3DfOa3HQpcsLMOH7EOfYe4atbWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IBrm+DezNg71i72hXHm7+kc1DNRM8NrNLe6aSdeetf2eqct3ehEApjcz7ZF489V2b
	 Bf2PygbOuNfPbuqqbDzy5A5JXHfIFHfRqDfWsE0mkI0ma4pr/mIZqR1kMOYfUu/oUs
	 e358h1l67wDp5BzPeGKLx+dL1GynWRXEAgblhORA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfBTX52 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 18:57:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfBTX52 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 18:57:28 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C93F2087B;
        Wed, 20 Feb 2019 23:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550707047;
        bh=QtmkSGKzMYYyX3TT3DfOa3HQpcsLMOH7EOfYe4atbWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZly5BQ57Dkr17iYrrLmexdmLxiJbfvhSJUqH6juvo5PQozdoZLHOD7yu5hk1fwui
         V/lXYkcqdlxbxKuMcYE2EqFqrFW9dMyzVmHVpfepUJMbD0w8fplXKfBYvi7npS0wMT
         IEdYI8qgf6vpjC6BwfE6Fevt4ME8btleptJH+rLs=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, dan.carpenter@oracle.com,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH] mt76: usb: fix warning in mt76u_buf_free
Date:   Thu, 21 Feb 2019 00:57:19 +0100
Message-Id: <bfd5659680fb3ef89554a48ff950d74dd88240dd.1550706341.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550706341.git.lorenzo@kernel.org>
References: <cover.1550706341.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Fix following static checker warning in mt76u_buf_free:
  drivers/net/wireless/mediatek/mt76/usb.c:372 mt76u_buf_free()
  warn: address of 'urb->sg[i]' is non-NULL

There is no need to check sg page pointer since urb->num_sgs
has been already validated in mt76u_fill_rx_sg

Fixes: cb83585e1121 ("mt76: usb: fix possible memory leak in mt76u_buf_free")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index cbfddf2ebfeb..ac3da948d43a 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -364,16 +364,11 @@ mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf)
 void mt76u_buf_free(struct mt76u_buf *buf)
 {
 	struct urb *urb = buf->urb;
-	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < urb->num_sgs; i++) {
-		sg = &urb->sg[i];
-		if (!sg)
-			continue;
+	for (i = 0; i < urb->num_sgs; i++)
+		skb_free_frag(sg_virt(&urb->sg[i]));
 
-		skb_free_frag(sg_virt(sg));
-	}
 	if (buf->buf)
 		skb_free_frag(buf->buf);
 
-- 
2.20.1

