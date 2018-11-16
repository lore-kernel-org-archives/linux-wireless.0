Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F97C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E25822084A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:12:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="rQV8bBoq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E25822084A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389585AbeKPVYb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 16:24:31 -0500
Received: from nbd.name ([46.4.11.11]:34386 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389555AbeKPVYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 16:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SRrEc2cBj4ySCNuymOyUoBfTWHZT0zmjEMlDntDll5Q=; b=rQV8bBoq04HjvhUevzgFRp8qMp
        +jQT63r29Sd6fxTW+rUIqzuBFCH/AKMvfkTQQ8+6Z8eZ/WolKnuTYgZBdlB0+GwKAKnPbIwYG490v
        oDmer42AulfNljQoiA0hZhHIy3IUFG176nmBe1ZqCWS7XHxEMHAYkYXy3w9nqsUQlCsk=;
Received: by maeck.local (Postfix, from userid 501)
        id 69270463F111; Fri, 16 Nov 2018 12:12:35 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH v2 5/7] mt76: mt76x02: make group_wcid the first member in struct mt76x02_vif
Date:   Fri, 16 Nov 2018 12:12:33 +0100
Message-Id: <20181116111235.86347-5-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20181116111235.86347-1-nbd@nbd.name>
References: <20181116111235.86347-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allows mt76 core to cast vif->drv_priv to struct mt76_wcid

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index b076c4305585..cf5c06a0a58a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -37,9 +37,8 @@ struct mt76x02_tx_status {
 #define MT_MAX_VIFS		8
 
 struct mt76x02_vif {
+	struct mt76_wcid group_wcid; /* must be first */
 	u8 idx;
-
-	struct mt76_wcid group_wcid;
 };
 
 DECLARE_EWMA(signal, 10, 8);
-- 
2.17.0

