Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017FDC433DB
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Jan 2021 11:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C52CC23A34
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Jan 2021 11:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbhANLam (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Jan 2021 06:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbhANLaY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jan 2021 06:30:24 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925BDC061798
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2021 03:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=c5Ag22wQQvDBoNg142bW0jk8oMULth+A1IKpzmgTgCg=; b=A5EXGv7H0tHJRRHnzeTC4IncZ8
        +eMUZDu5UODHMMBu7+DfMf4vyTa/xzUfK2Mn6VGoqSCm4GJM9VDXx5mhOP4RsFoiRs2xcUEPW5cgS
        3SMA8fZqnTa7ovS8fsWOwNxuqcwWPcaDVB6J9hvCFP57Ad7QicrHL7lZ7hxUHRUCXpQo=;
Received: from p54ae91f2.dip0.t-ipconnect.de ([84.174.145.242] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1l00og-0001PU-K2
        for linux-wireless@vger.kernel.org; Thu, 14 Jan 2021 12:29:26 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] mt76: mt7603: fix ED/CCA monitoring with single-stream devices
Date:   Thu, 14 Jan 2021 12:29:19 +0100
Message-Id: <20210114112925.87646-1-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not use the RSSI values of the unavailable chain

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 7f0e3df3a094..cc4e7bc48294 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1631,9 +1631,13 @@ mt7603_edcca_check(struct mt7603_dev *dev)
 	if (rssi0 > 128)
 		rssi0 -= 256;
 
-	rssi1 = FIELD_GET(MT_AGC_41_RSSI_1, val);
-	if (rssi1 > 128)
-		rssi1 -= 256;
+	if (dev->mphy.antenna_mask & BIT(1)) {
+		rssi1 = FIELD_GET(MT_AGC_41_RSSI_1, val);
+		if (rssi1 > 128)
+			rssi1 -= 256;
+	} else {
+		rssi1 = rssi0;
+	}
 
 	if (max(rssi0, rssi1) >= -40 &&
 	    dev->ed_strong_signal < MT7603_EDCCA_BLOCK_TH)
-- 
2.28.0

