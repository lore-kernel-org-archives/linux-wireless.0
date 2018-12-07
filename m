Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3815C07E85
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 13:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 778CC20868
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 13:27:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 778CC20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbeLGN1U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:27:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbeLGN1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 08:27:20 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 70D63308FB9D;
        Fri,  7 Dec 2018 13:27:20 +0000 (UTC)
Received: from localhost (unknown [10.43.2.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3332805E2;
        Fri,  7 Dec 2018 13:27:17 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 2/5] mt76x02: fixup MT_PROT_RATE_* defines
Date:   Fri,  7 Dec 2018 14:27:08 +0100
Message-Id: <1544189231-3676-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1544189231-3676-1-git-send-email-sgruszka@redhat.com>
References: <1544189231-3676-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 07 Dec 2018 13:27:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On new mt76 chips, phy mode is configured by last 3 bits
of rate value. Hence OFDM bit is marked by 0x2000
instead of 0x4000.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
index f7de77d09d28..d1ac847adce5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
@@ -440,9 +440,9 @@
 #define MT_PROT_TXOP_ALLOW_GF40		BIT(25)
 #define MT_PROT_RTS_THR_EN		BIT(26)
 #define MT_PROT_RATE_CCK_11		0x0003
-#define MT_PROT_RATE_OFDM_6		0x4000
-#define MT_PROT_RATE_OFDM_24		0x4004
-#define MT_PROT_RATE_DUP_OFDM_24	0x4084
+#define MT_PROT_RATE_OFDM_6		0x2000
+#define MT_PROT_RATE_OFDM_24		0x2004
+#define MT_PROT_RATE_DUP_OFDM_24	0x2084
 #define MT_PROT_TXOP_ALLOW_ALL		GENMASK(25, 20)
 #define MT_PROT_TXOP_ALLOW_BW20		(MT_PROT_TXOP_ALLOW_ALL &	\
 					 ~MT_PROT_TXOP_ALLOW_MM40 &	\
-- 
1.9.3

