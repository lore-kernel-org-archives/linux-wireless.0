Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6C2C04EBC
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 975592084A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:12:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="j+LMd+q7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 975592084A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389571AbeKPVYa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 16:24:30 -0500
Received: from nbd.name ([46.4.11.11]:34392 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389552AbeKPVYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 16:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wa28JDi1hXgehISLEaPJ8S/MU5fEJXcHuh2M1dYI+O4=; b=j+LMd+q77gcpfur/vVEF3lIC7O
        k4Ib4UEIxDJihIThCnPwAS3ckJQ5R55prDu9FHmZA+dqikq3yXKkPLORtycIAW7NCn8M23tuPFq5i
        6zWaMO3yYsch423QxyIF14CLJXWd0uRI+XwGKpVE37ZZIyvuGHoZuKkLrW1bzSgjfnxk=;
Received: by maeck.local (Postfix, from userid 501)
        id 6F38B463F112; Fri, 16 Nov 2018 12:12:35 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/7] mt76: do not wake tx queues during flush
Date:   Fri, 16 Nov 2018 12:12:30 +0100
Message-Id: <20181116111235.86347-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181116111235.86347-1-nbd@nbd.name>
References: <20181116111235.86347-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

While the queue is being cleaned up, the stack must not attempt to add
any extra packets

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index d62f8d9f2ea1..e2ba26378575 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -168,7 +168,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 
 		if (entry.txwi) {
 			mt76_put_txwi(dev, entry.txwi);
-			wake = true;
+			wake = !flush;
 		}
 
 		if (!flush && q->tail == last)
-- 
2.17.0

