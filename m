Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3AB4C07E85
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 13:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8441320892
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 13:27:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8441320892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbeLGN1a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:27:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbeLGN1a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 08:27:30 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5E95E5F737;
        Fri,  7 Dec 2018 13:27:30 +0000 (UTC)
Received: from localhost (unknown [10.43.2.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA69D79D6D;
        Fri,  7 Dec 2018 13:27:29 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 5/5] mt76x2: initialize fall-back rate registers
Date:   Fri,  7 Dec 2018 14:27:11 +0100
Message-Id: <1544189231-3676-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1544189231-3676-1-git-send-email-sgruszka@redhat.com>
References: <1544189231-3676-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 07 Dec 2018 13:27:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Initialize MT_LG_FBK_CFG{0,1} and MT_VHT_HT_FBK_CFG{0,1} registers.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
index a1657922758e..01e672bad2f1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
@@ -88,6 +88,10 @@
 	{ MT_TX_PROT_CFG6,		0xe3f42004 },
 	{ MT_TX_PROT_CFG7,		0xe3f42084 },
 	{ MT_TX_PROT_CFG8,		0xe3f42104 },
+	{ MT_VHT_HT_FBK_CFG0,		0x65432100 },
+	{ MT_VHT_HT_FBK_CFG1,		0xedcba980 },
+	{ MT_LG_FBK_CFG0,		0xedcba988 },
+	{ MT_LG_FBK_CFG1,		0x00872100 },
 };
 
 static const struct mt76_reg_pair mt76x0_bbp_init_tab[] = {
-- 
1.9.3

