Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96887C04EB8
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 10:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BD602086D
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 10:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BD602086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbeLJKyP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 05:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35676 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbeLJKyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 05:54:15 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E0A93082B25;
        Mon, 10 Dec 2018 10:54:15 +0000 (UTC)
Received: from localhost (ovpn-204-245.brq.redhat.com [10.40.204.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80CF35C1B4;
        Mon, 10 Dec 2018 10:54:10 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 4/4] mt76x0: configure MT_VHT_HT_FBK_CFG1
Date:   Mon, 10 Dec 2018 11:53:58 +0100
Message-Id: <1544439238-4118-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1544439238-4118-1-git-send-email-sgruszka@redhat.com>
References: <1544439238-4118-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 10 Dec 2018 10:54:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Configure MT_VHT_HT_FBK_CFG1 values similar like vendor driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v2: do not configure other fallback registers as they
have proper values by default.

 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
index a1657922758e..0290ba5869a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
@@ -88,6 +88,7 @@ static const struct mt76_reg_pair mt76x0_mac_reg_table[] = {
 	{ MT_TX_PROT_CFG6,		0xe3f42004 },
 	{ MT_TX_PROT_CFG7,		0xe3f42084 },
 	{ MT_TX_PROT_CFG8,		0xe3f42104 },
+	{ MT_VHT_HT_FBK_CFG1,		0xedcba980 },
 };
 
 static const struct mt76_reg_pair mt76x0_bbp_init_tab[] = {
-- 
2.7.5

