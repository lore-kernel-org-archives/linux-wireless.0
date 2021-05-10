Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28728C43462
	for <linux-wireless@archiver.kernel.org>; Mon, 10 May 2021 09:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB59861456
	for <linux-wireless@archiver.kernel.org>; Mon, 10 May 2021 09:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhEJJ2O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 May 2021 05:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhEJJ2M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 May 2021 05:28:12 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B42C06175F
        for <linux-wireless@vger.kernel.org>; Mon, 10 May 2021 02:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uhYa0hFsdn3Y+WAfgZZ/MlI8Ygo4dVX05h/M1I8gnsU=; b=eWVB7VU4d24LtaFU+R8NM2YomV
        zPvAc7euSvAJkBSEpeayXJOX1l+tothRcfQr3c7fiBNqorb/c9DV62kk9bQ6rIS+SsZH05o7ncCac
        JHw/FKUyUOVyzR7zsqMtgQ5rhncwPBdK/EXS8CpxNyy8QWAIPECErGwhfoFFeebuSaGc=;
Received: from p54ae9ff2.dip0.t-ipconnect.de ([84.174.159.242] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lg2Bt-000572-FZ
        for linux-wireless@vger.kernel.org; Mon, 10 May 2021 11:27:05 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/9] mt76: mt7615: fix fixed-rate tx status reporting
Date:   Mon, 10 May 2021 11:26:56 +0200
Message-Id: <20210510092703.90500-2-nbd@nbd.name>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210510092703.90500-1-nbd@nbd.name>
References: <20210510092703.90500-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rely on the txs fixed-rate bit instead of info->control.rates

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index f81a17d56008..c600a0b2b00b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1235,22 +1235,20 @@ static bool mt7615_fill_txs(struct mt7615_dev *dev, struct mt7615_sta *sta,
 	int first_idx = 0, last_idx;
 	int i, idx, count;
 	bool fixed_rate, ack_timeout;
-	bool probe, ampdu, cck = false;
+	bool ampdu, cck = false;
 	bool rs_idx;
 	u32 rate_set_tsf;
 	u32 final_rate, final_rate_flags, final_nss, txs;
 
-	fixed_rate = info->status.rates[0].count;
-	probe = !!(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
-
 	txs = le32_to_cpu(txs_data[1]);
-	ampdu = !fixed_rate && (txs & MT_TXS1_AMPDU);
+	ampdu = txs & MT_TXS1_AMPDU;
 
 	txs = le32_to_cpu(txs_data[3]);
 	count = FIELD_GET(MT_TXS3_TX_COUNT, txs);
 	last_idx = FIELD_GET(MT_TXS3_LAST_TX_RATE, txs);
 
 	txs = le32_to_cpu(txs_data[0]);
+	fixed_rate = txs & MT_TXS0_FIXED_RATE;
 	final_rate = FIELD_GET(MT_TXS0_TX_RATE, txs);
 	ack_timeout = txs & MT_TXS0_ACK_TIMEOUT;
 
@@ -1272,7 +1270,7 @@ static bool mt7615_fill_txs(struct mt7615_dev *dev, struct mt7615_sta *sta,
 
 	first_idx = max_t(int, 0, last_idx - (count - 1) / MT7615_RATE_RETRY);
 
-	if (fixed_rate && !probe) {
+	if (fixed_rate) {
 		info->status.rates[0].count = count;
 		i = 0;
 		goto out;
-- 
2.30.1

