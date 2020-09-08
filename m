Return-Path: <SRS0=ylPz=CR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01518C43461
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Sep 2020 21:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A075120768
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Sep 2020 21:18:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="YCgqQkS6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbgIHVSJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Sep 2020 17:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728631AbgIHVSD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Sep 2020 17:18:03 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3819C061573
        for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2020 14:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xaPk7cTDqaEwfXS7jkKrLqiO9M5K7qzRC7RSwWrn9mM=; b=YCgqQkS6g/8tsXCUNbnIhku6iv
        PMw5+u8ptbaq6VORH0lK7NPIwUrsKzU2fCBMrByo3GVbJl3EJJyhZKeAImqkoR6jlIcdslRURfCIk
        bOI4glaUufCHtmT8YGpKyCbydzVoY0vzL2lPZeIoWo2faTBfki/Mh0SdZeWHNKi/tkAE=;
Received: from p4ff13fcb.dip0.t-ipconnect.de ([79.241.63.203] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kFl02-0002Cx-Hi
        for linux-wireless@vger.kernel.org; Tue, 08 Sep 2020 23:17:58 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 03/11] mt76: testmode: add a limit for queued tx_frames packets
Date:   Tue,  8 Sep 2020 23:17:48 +0200
Message-Id: <20200908211756.15998-3-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908211756.15998-1-nbd@nbd.name>
References: <20200908211756.15998-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This avoids running out of available tx tokens

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/testmode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/testmode.c b/drivers/net/wireless/mediatek/mt76/testmode.c
index f6fd515dfe57..a38abb6868d5 100644
--- a/drivers/net/wireless/mediatek/mt76/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/testmode.c
@@ -33,7 +33,8 @@ void mt76_testmode_tx_pending(struct mt76_dev *dev)
 
 	spin_lock_bh(&q->lock);
 
-	while (td->tx_pending > 0 && q->queued < q->ndesc / 2) {
+	while (td->tx_pending > 0 && td->tx_queued - td->tx_done < 1000 &&
+	       q->queued < q->ndesc / 2) {
 		int ret;
 
 		ret = dev->queue_ops->tx_queue_skb(dev, qid, skb_get(skb), wcid, NULL);
-- 
2.28.0

