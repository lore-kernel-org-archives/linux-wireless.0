Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80DAC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 04:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 763C92087C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 04:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BuNFOmR0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GleS3K05"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbfCLEeK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 00:34:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48696 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfCLEeK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 00:34:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 48DE2608FC; Tue, 12 Mar 2019 04:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552365249;
        bh=KwzbrWBYXszv7PvzuATdkZzaJG8kj7CXlvg95Aer6W0=;
        h=From:To:Cc:Subject:Date:From;
        b=BuNFOmR0ypaOIKzgXK9az/NvdlvtfRP0h4R4XM9phrXmxneAOeuYjiIOYVeEhDYvx
         2B8Owy4DIxTnqDXYrxeJNKgc79jawY7rmfpRMYTfN2d3L/qr6RyUOeUGfJ/RSuLhBC
         fZ3aagwbqZCZpms3jfkCjxxDe2vaIKPsaR1IjIt4=
Received: from hy-Z220.ap.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: yanghuan@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8C90C6021F;
        Tue, 12 Mar 2019 04:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552365248;
        bh=KwzbrWBYXszv7PvzuATdkZzaJG8kj7CXlvg95Aer6W0=;
        h=From:To:Cc:Subject:Date:From;
        b=GleS3K05BsQxAtY13nnss8MeoHlvzQSd4tUGblYEm9Cv7Cz+9w79lIQmQRnuPmk0a
         jW4qGoEYgwZuC70Pup0VewZuqT6BKa7oyN2Uw1ZrV0U+u4Ai7OI73WTHHVH8v3/VgN
         5xl2uQ8wihzeeV+/1RTB/+zyyYAzaf8qXzuocu6E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8C90C6021F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=yanghuan@codeaurora.org
From:   Brandon Huang <yanghuan@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Brandon Huang <yanghuan@codeaurora.org>
Subject: [PATCH] ath10k: Fix the tx stats bytes & packets parsing
Date:   Tue, 12 Mar 2019 12:33:39 +0800
Message-Id: <1552365219-16842-1-git-send-email-yanghuan@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In tx_stats debugfs, txrate->flags may contain multiple bits. For
example, RATE_INFO_FLAGS_SHORT_GI could be set, and tx stats bytes
and packets will be not updated correctly.

Fix this issue by using bit operation to check txrate->flags.

Tested HW: QCA9984
Tested Firmware: 10.4-3.9.0.1-00007

Signed-off-by: Brandon Huang <yanghuan@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a20ea27..584b86b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2938,14 +2938,14 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 
 #define STATS_OP_FMT(name) tx_stats->stats[ATH10K_STATS_TYPE_##name]
 
-	if (txrate->flags == RATE_INFO_FLAGS_VHT_MCS) {
+	if (txrate->flags & RATE_INFO_FLAGS_VHT_MCS) {
 		STATS_OP_FMT(SUCC).vht[0][mcs] += pstats->succ_bytes;
 		STATS_OP_FMT(SUCC).vht[1][mcs] += pstats->succ_pkts;
 		STATS_OP_FMT(FAIL).vht[0][mcs] += pstats->failed_bytes;
 		STATS_OP_FMT(FAIL).vht[1][mcs] += pstats->failed_pkts;
 		STATS_OP_FMT(RETRY).vht[0][mcs] += pstats->retry_bytes;
 		STATS_OP_FMT(RETRY).vht[1][mcs] += pstats->retry_pkts;
-	} else if (txrate->flags == RATE_INFO_FLAGS_MCS) {
+	} else if (txrate->flags & RATE_INFO_FLAGS_MCS) {
 		STATS_OP_FMT(SUCC).ht[0][ht_idx] += pstats->succ_bytes;
 		STATS_OP_FMT(SUCC).ht[1][ht_idx] += pstats->succ_pkts;
 		STATS_OP_FMT(FAIL).ht[0][ht_idx] += pstats->failed_bytes;
@@ -2966,7 +2966,7 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	if (ATH10K_HW_AMPDU(pstats->flags)) {
 		tx_stats->ba_fails += ATH10K_HW_BA_FAIL(pstats->flags);
 
-		if (txrate->flags == RATE_INFO_FLAGS_MCS) {
+		if (txrate->flags & RATE_INFO_FLAGS_MCS) {
 			STATS_OP_FMT(AMPDU).ht[0][ht_idx] +=
 				pstats->succ_bytes + pstats->retry_bytes;
 			STATS_OP_FMT(AMPDU).ht[1][ht_idx] +=
-- 
1.9.1

