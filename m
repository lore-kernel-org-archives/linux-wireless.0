Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CA7C64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75BC82082A
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:05:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75BC82082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbeJDQ54 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 12:57:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbeJDQ54 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 12:57:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 36BCC30832D8;
        Thu,  4 Oct 2018 10:05:24 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A3F418256;
        Thu,  4 Oct 2018 10:05:21 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 5/5] mt76x0: use bus helper to identify rf access method
Date:   Thu,  4 Oct 2018 12:04:55 +0200
Message-Id: <1538647495-15213-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1538647495-15213-1-git-send-email-sgruszka@redhat.com>
References: <1538647495-15213-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 04 Oct 2018 10:05:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76_is_usb() to identify RF access method instead of
MT76_STATE_MCU_RUNNING flag and add warning since MCU has
to be initialized before we can access RF registers via MCU.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 8e4194e59398..202f436eb358 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -111,12 +111,14 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
 static int
 rf_wr(struct mt76x02_dev *dev, u32 offset, u8 val)
 {
-	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state)) {
+	if (mt76_is_usb(dev)) {
 		struct mt76_reg_pair pair = {
 			.reg = offset,
 			.value = val,
 		};
 
+		WARN_ON_ONCE(!test_bit(MT76_STATE_MCU_RUNNING,
+			     &dev->mt76.state));
 		return mt76_wr_rp(dev, MT_MCU_MEMMAP_RF, &pair, 1);
 	} else {
 		return mt76x0_rf_csr_wr(dev, offset, val);
@@ -129,11 +131,13 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
 	int ret;
 	u32 val;
 
-	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state)) {
+	if (mt76_is_usb(dev)) {
 		struct mt76_reg_pair pair = {
 			.reg = offset,
 		};
 
+		WARN_ON_ONCE(!test_bit(MT76_STATE_MCU_RUNNING,
+			     &dev->mt76.state));
 		ret = mt76_rd_rp(dev, MT_MCU_MEMMAP_RF, &pair, 1);
 		val = pair.value;
 	} else {
-- 
1.9.3

