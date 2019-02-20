Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C518BC10F01
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 09:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CC1A21773
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 09:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550654458;
	bh=faFlszDhggK9XiYYIjdtyl0jicijAwUnGlaSJ2FDJfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=z8M6Lci+n2sZTPxmGUszVvuBagJB0QbzbK/fOTotRWrRLLK4pmr94HToqfrIkx7Gi
	 VOBs4CL0w/nGYJ+uEETRLNEYCdfk79c8iUStdqV4INgn/1SakOiarsyTPCDUtLPs5A
	 o1rbMXMpXNXA0kGXT5Q0vBScK6sfVkTgJ4K3cXq8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfBTJU5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 04:20:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfBTJU5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 04:20:57 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D488F2086C;
        Wed, 20 Feb 2019 09:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550654456;
        bh=faFlszDhggK9XiYYIjdtyl0jicijAwUnGlaSJ2FDJfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfbmsTp3qIP2WFHyhKt6ujlpCoH4OYOG6ZtyiPS+60cBcjZXBqceS3RqwQtQLSwID
         +Te2DSFf8VdLYjn8kTkrd+3IcIxc5C7hz7iYD/JEqFQkXOVoh937453ZSgKtmI9WJM
         1xBFi6HNa3sfEE9f09a92Tuak0YrOcgbKY9LNCXg=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76: usb: check urb->num_sgs limit in mt76u_process_rx_entry
Date:   Wed, 20 Feb 2019 10:20:37 +0100
Message-Id: <9111504273864ca3838481c57ad0f22dea74e303.1550654091.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550654091.git.lorenzo@kernel.org>
References: <cover.1550654091.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

check nsgs value is less than urb->num_sgs in mt76u_process_rx_entry
in order to avoid an out-of-bound access of urb->sg array

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 78191968b4fa..5d7b57827d1e 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -464,7 +464,7 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct mt76u_buf *buf)
 	__skb_put(skb, data_len);
 	len -= data_len;
 
-	while (len > 0 && urb->num_sgs) {
+	while (len > 0 && nsgs < urb->num_sgs) {
 		data_len = min_t(int, len, urb->sg[nsgs].length);
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 				sg_page(&urb->sg[nsgs]),
-- 
2.20.1

