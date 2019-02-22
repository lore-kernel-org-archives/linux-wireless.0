Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA6FC10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B3592086C
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:20:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Fno/SZ06";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Fno/SZ06"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfBVHUx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:20:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58252 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfBVHUw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 02:20:52 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DA89C6098B; Fri, 22 Feb 2019 07:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550820051;
        bh=++IYFAlbfKwciaSgrWgxoEraMzpZpznMm9fRjnPKgOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fno/SZ06Oh/JXsaFN4C3UJA4bG0h+WVeSrg0Z/aLgLI+GFMrbUrxYQIJWTaWlKzJD
         NXvMU1Sl80Qr94yPua+r3o5amJEW4fqjdqdBq0sYdV/8mISI8jwTkcVT4OBkJXyxgn
         7y/qhCKQ6K1c88V4mPbS76/whAw68ahPIidBV6jI=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B8A55607EF;
        Fri, 22 Feb 2019 07:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550820051;
        bh=++IYFAlbfKwciaSgrWgxoEraMzpZpznMm9fRjnPKgOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fno/SZ06Oh/JXsaFN4C3UJA4bG0h+WVeSrg0Z/aLgLI+GFMrbUrxYQIJWTaWlKzJD
         NXvMU1Sl80Qr94yPua+r3o5amJEW4fqjdqdBq0sYdV/8mISI8jwTkcVT4OBkJXyxgn
         7y/qhCKQ6K1c88V4mPbS76/whAw68ahPIidBV6jI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B8A55607EF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH 1/4] ath10k: Fix the incorrect updation of NSS data in tx stats
Date:   Fri, 22 Feb 2019 12:50:31 +0530
Message-Id: <1550820034-18603-2-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550820034-18603-1-git-send-email-svishnoi@codeaurora.org>
References: <1550820034-18603-1-git-send-email-svishnoi@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The NSS data is updated incorrectly in the tx stats as the array
indexing starts from zero.

Fix the incorrect updation of NSS data in tx_stats by taking into
consideration the array index starting from zero.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: a904417fc876 ("ath10k: add extended per sta tx statistics support")
Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index d5c666c..3a02a76 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2980,7 +2980,7 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 		}
 		STATS_OP_FMT(AMPDU).bw[0][bw] +=
 			pstats->succ_bytes + pstats->retry_bytes;
-		STATS_OP_FMT(AMPDU).nss[0][nss] +=
+		STATS_OP_FMT(AMPDU).nss[0][nss - 1] +=
 			pstats->succ_bytes + pstats->retry_bytes;
 		STATS_OP_FMT(AMPDU).gi[0][gi] +=
 			pstats->succ_bytes + pstats->retry_bytes;
@@ -2988,7 +2988,7 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 			pstats->succ_bytes + pstats->retry_bytes;
 		STATS_OP_FMT(AMPDU).bw[1][bw] +=
 			pstats->succ_pkts + pstats->retry_pkts;
-		STATS_OP_FMT(AMPDU).nss[1][nss] +=
+		STATS_OP_FMT(AMPDU).nss[1][nss - 1] +=
 			pstats->succ_pkts + pstats->retry_pkts;
 		STATS_OP_FMT(AMPDU).gi[1][gi] +=
 			pstats->succ_pkts + pstats->retry_pkts;
@@ -3000,27 +3000,27 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	}
 
 	STATS_OP_FMT(SUCC).bw[0][bw] += pstats->succ_bytes;
-	STATS_OP_FMT(SUCC).nss[0][nss] += pstats->succ_bytes;
+	STATS_OP_FMT(SUCC).nss[0][nss - 1] += pstats->succ_bytes;
 	STATS_OP_FMT(SUCC).gi[0][gi] += pstats->succ_bytes;
 
 	STATS_OP_FMT(SUCC).bw[1][bw] += pstats->succ_pkts;
-	STATS_OP_FMT(SUCC).nss[1][nss] += pstats->succ_pkts;
+	STATS_OP_FMT(SUCC).nss[1][nss - 1] += pstats->succ_pkts;
 	STATS_OP_FMT(SUCC).gi[1][gi] += pstats->succ_pkts;
 
 	STATS_OP_FMT(FAIL).bw[0][bw] += pstats->failed_bytes;
-	STATS_OP_FMT(FAIL).nss[0][nss] += pstats->failed_bytes;
+	STATS_OP_FMT(FAIL).nss[0][nss - 1] += pstats->failed_bytes;
 	STATS_OP_FMT(FAIL).gi[0][gi] += pstats->failed_bytes;
 
 	STATS_OP_FMT(FAIL).bw[1][bw] += pstats->failed_pkts;
-	STATS_OP_FMT(FAIL).nss[1][nss] += pstats->failed_pkts;
+	STATS_OP_FMT(FAIL).nss[1][nss - 1] += pstats->failed_pkts;
 	STATS_OP_FMT(FAIL).gi[1][gi] += pstats->failed_pkts;
 
 	STATS_OP_FMT(RETRY).bw[0][bw] += pstats->retry_bytes;
-	STATS_OP_FMT(RETRY).nss[0][nss] += pstats->retry_bytes;
+	STATS_OP_FMT(RETRY).nss[0][nss - 1] += pstats->retry_bytes;
 	STATS_OP_FMT(RETRY).gi[0][gi] += pstats->retry_bytes;
 
 	STATS_OP_FMT(RETRY).bw[1][bw] += pstats->retry_pkts;
-	STATS_OP_FMT(RETRY).nss[1][nss] += pstats->retry_pkts;
+	STATS_OP_FMT(RETRY).nss[1][nss - 1] += pstats->retry_pkts;
 	STATS_OP_FMT(RETRY).gi[1][gi] += pstats->retry_pkts;
 
 	if (txrate->flags >= RATE_INFO_FLAGS_MCS) {
-- 
1.9.1

