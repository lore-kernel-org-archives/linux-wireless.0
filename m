Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409CFC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A8B02147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mI+YMtGe";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bET0Tt90"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfBZJ20 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:28:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43462 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfBZJ20 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:28:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 505E36119D; Tue, 26 Feb 2019 09:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551173305;
        bh=DTgSUigAa+16wNRwYpKJnzAJHhs31S5eJ+7IIDYgJe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mI+YMtGe0cI9bTrA7yd0qbP/NkTIixPeATj7YCWYwO5TSKnILot9X6pxEN0QX2n/h
         HBYPZhb8hpMSq3LPSrHa7rBhm4a3jYNLD32d9tj8nwwBUMvJDzwi9F5EGED7JxKl4U
         9Ev9aw6UgotcSmkVnnI0vEW451aM+TmBqYkIWZ00=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B87A460FEE;
        Tue, 26 Feb 2019 09:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551173303;
        bh=DTgSUigAa+16wNRwYpKJnzAJHhs31S5eJ+7IIDYgJe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bET0Tt901f++gZgKg/BOQM/WpmerLeCRBLBnpKJ09T3FOGXla3wQFr4SjW3PUuA5i
         41GInr/re4q0O9J81EwLzaCm7fc3FZJFkWU1DQtC7yMYTB59OxYR4NiEaBMdSdU2Yn
         yYyR99w+NvkZkh34IBi0kZD9EAibOL8DyTNLkZ3I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B87A460FEE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH v2 4/4] ath10k: Fix the wrong calculation ht_idx and idx of rate table for tx_stats
Date:   Tue, 26 Feb 2019 14:57:58 +0530
Message-Id: <1551173278-20926-5-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551173278-20926-1-git-send-email-svishnoi@codeaurora.org>
References: <1551173278-20926-1-git-send-email-svishnoi@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ht_idx (ht rate index) and idx (rate table index) are calculated based on
mcs index. This mcs index used in the above calculation should be 0-9 for
getting the correct ht_idx and idx.

Currently the mcs index used for the above calculations is mcs index which
can be 0-31 (in case of HT), leading to incorrect rate index and ht index values.

Fix the issue by obtaining mcs value from the ratecode reported by firmware
and use it for calculating ht_idx and idx (rate-table index).

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: e88975ca37d1 ("ath10k: dump tx stats in rate table format")
Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 2394a47..d34c76f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2921,11 +2921,11 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	tx_stats = arsta->tx_stats;
 	flags = txrate->flags;
 	gi = test_bit(ATH10K_RATE_INFO_FLAGS_SGI_BIT, &flags);
-	ht_idx = txrate->mcs + txrate->nss * 8;
-	mcs = txrate->mcs;
+	mcs = ATH10K_HW_MCS_RATE(pstats->ratecode);
 	bw = txrate->bw;
 	nss = txrate->nss;
-	idx = mcs * 8 + 8 * 10 * nss;
+	ht_idx = mcs + (nss - 1) * 8;
+	idx = mcs * 8 + 8 * 10 * (nss - 1);
 	idx += bw * 2 + gi;
 
 #define STATS_OP_FMT(name) tx_stats->stats[ATH10K_STATS_TYPE_##name]
-- 
1.9.1

