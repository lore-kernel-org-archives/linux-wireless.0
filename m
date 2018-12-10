Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7F2C04EB8
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 10:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0498120821
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 10:54:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0498120821
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbeLJKyG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 05:54:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbeLJKyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 05:54:06 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E19B13082193;
        Mon, 10 Dec 2018 10:54:05 +0000 (UTC)
Received: from localhost (ovpn-204-245.brq.redhat.com [10.40.204.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45F595D717;
        Mon, 10 Dec 2018 10:54:03 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/4] mt76x02: fixup MT_PROT_RATE_* defines
Date:   Mon, 10 Dec 2018 11:53:56 +0100
Message-Id: <1544439238-4118-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1544439238-4118-1-git-send-email-sgruszka@redhat.com>
References: <1544439238-4118-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 10 Dec 2018 10:54:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On new mt76 chips, phy mode is configured by last 3 bits
of rate value. Hence OFDM bit is marked by 0x2000
instead of 0x4000.

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
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
2.7.5

