Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2D6C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 794312147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:28:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eMzJGYhz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XThtv9zR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfBZJ2W (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:28:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43226 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfBZJ2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:28:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5FD8360F3E; Tue, 26 Feb 2019 09:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551173301;
        bh=nhfSGt53PoSUjTSlgnj135k6pqYFOY0ku36KxQsUAfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMzJGYhz4qta3h1T5pB5TZk+nbunoTkYPmftkDTXyKtbR00WS7v2fmDqdzqXGFZPR
         cBGI1hdte9SiADU0KFdz/L/6mS8veNkPbcUZFZigA+amHV5/+PFADg+OdF7PRzp9GT
         JTlCFGxUd4NtsT6xd3Za0+Y9GUMecZ9PDJ9IQZOw=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3346160F3E;
        Tue, 26 Feb 2019 09:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551173299;
        bh=nhfSGt53PoSUjTSlgnj135k6pqYFOY0ku36KxQsUAfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XThtv9zRgYUnbuXrLV3kLdg1INyFQpoRkqhnAP/grMV0hqOI8dbIt9MKDTPv0Nm7D
         TZ90yJ5IPRmAL06CyZoqXcDxHd1P+4v9ruu15F68tzu6TsMvJ1JaZJuXqdQ3nIbjF1
         lmE9G+AIb08T1o8xgJFt6trOxdg79Gt8Sz2YD/tM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3346160F3E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH v2 3/4] ath10k: Fix the wrong updation of SGI in tx_stats debugfs
Date:   Tue, 26 Feb 2019 14:57:57 +0530
Message-Id: <1551173278-20926-4-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551173278-20926-1-git-send-email-svishnoi@codeaurora.org>
References: <1551173278-20926-1-git-send-email-svishnoi@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The SGI is updated wrongly in tx stats table in debugfs per sta
entry. To know whether the packets/bytes are sent with SHORT GI,
test whether the SGI bit(ATH10K_RATE_INFO_FLAGS_SGI_BIT) is set or
not in the txrate flags.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: a904417fc876 ("ath10k: add extended per sta tx statistics support")
Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 4 +++-
 drivers/net/wireless/ath/ath10k/wmi.h    | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 941ae20..2394a47 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2913,12 +2913,14 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	struct rate_info *txrate = &arsta->txrate;
 	struct ath10k_htt_tx_stats *tx_stats;
 	int idx, ht_idx, gi, mcs, bw, nss;
+	unsigned long flags;
 
 	if (!arsta->tx_stats)
 		return;
 
 	tx_stats = arsta->tx_stats;
-	gi = (arsta->txrate.flags & RATE_INFO_FLAGS_SHORT_GI);
+	flags = txrate->flags;
+	gi = test_bit(ATH10K_RATE_INFO_FLAGS_SGI_BIT, &flags);
 	ht_idx = txrate->mcs + txrate->nss * 8;
 	mcs = txrate->mcs;
 	bw = txrate->bw;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index d915942..6df9a59 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5051,6 +5051,7 @@ enum wmi_rate_preamble {
 #define ATH10K_GI_NUM		2
 #define ATH10K_HT_MCS_NUM	32
 #define ATH10K_RATE_TABLE_NUM	320
+#define ATH10K_RATE_INFO_FLAGS_SGI_BIT	2
 
 /* Value to disable fixed rate setting */
 #define WMI_FIXED_RATE_NONE    (0xff)
-- 
1.9.1

