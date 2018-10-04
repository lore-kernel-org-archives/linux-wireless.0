Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46869C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1905521473
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1905521473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbeJDQ5o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 12:57:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727758AbeJDQ5i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 12:57:38 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 44C5FC04C279;
        Thu,  4 Oct 2018 10:05:06 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCB563091322;
        Thu,  4 Oct 2018 10:05:01 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 1/5] mt76x0: print BBP version only for debug
Date:   Thu,  4 Oct 2018 12:04:51 +0200
Message-Id: <1538647495-15213-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1538647495-15213-1-git-send-email-sgruszka@redhat.com>
References: <1538647495-15213-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.26
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 04 Oct 2018 10:05:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use dev_dbg to print BBP version.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index ba3b5847af48..cbbfd5193d9c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -186,7 +186,6 @@ int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev)
 
 	do {
 		val = mt76_rr(dev, MT_BBP(CORE, 0));
-		printk("BBP version %08x\n", val);
 		if (val && ~val)
 			break;
 	} while (--i);
@@ -196,6 +195,7 @@ int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev)
 		return -EIO;
 	}
 
+	dev_dbg(dev->mt76.dev, "BBP version %08x\n", val);
 	return 0;
 }
 
-- 
1.9.3

