Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42514C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F2A420657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:53:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UgxifJd4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UgxifJd4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfCKPxd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:53:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56462 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbfCKPxd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 11:53:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B37E1609CD; Mon, 11 Mar 2019 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552319612;
        bh=CM0hDcRbyJ64utIMdr4YIxwB0GNq2WuY2iplAD3XbpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgxifJd4X76VRpNAScvfTVZc1C0sI1+sJeYECb7W3fRSj6BW/bdGLhplT8tMuTHlZ
         d6WW7TRVhOdRWK9ARxDBCwy4zX68H3kSEQjNUt1576GIwROujJOfo8rPgNjmBsOffC
         IGZF0LpNJ6xa+JmWlReEDOQbzGew48VFG1lgip3A=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D4260608CE;
        Mon, 11 Mar 2019 15:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552319612;
        bh=CM0hDcRbyJ64utIMdr4YIxwB0GNq2WuY2iplAD3XbpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgxifJd4X76VRpNAScvfTVZc1C0sI1+sJeYECb7W3fRSj6BW/bdGLhplT8tMuTHlZ
         d6WW7TRVhOdRWK9ARxDBCwy4zX68H3kSEQjNUt1576GIwROujJOfo8rPgNjmBsOffC
         IGZF0LpNJ6xa+JmWlReEDOQbzGew48VFG1lgip3A=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D4260608CE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH 1/2] ath10k: Fix rate table updation in tx stats
Date:   Mon, 11 Mar 2019 21:23:21 +0530
Message-Id: <1552319602-17795-2-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552319602-17795-1-git-send-email-pillair@codeaurora.org>
References: <1552319602-17795-1-git-send-email-pillair@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The index for updating rate table, which is displayed
in the tx stats via debugfs, is calculated using the
bandwidth value. The bandwidth values do not map
correctly with the bandwidth values shown in the rate table.

Correct the bandwidth value calculation which is used
to calculate the index for rate table updation for tx stats.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: e88975ca37d1 ("ath10k: dump tx stats in rate table format")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a20ea27..8c3c940 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2922,6 +2922,7 @@ ath10k_accumulate_per_peer_tx_stats(struct ath10k *ar,
 	struct ath10k_htt_tx_stats *tx_stats;
 	int idx, ht_idx, gi, mcs, bw, nss;
 	unsigned long flags;
+	int rtable_bw;
 
 	if (!arsta->tx_stats)
 		return;
@@ -2930,11 +2931,12 @@ ath10k_accumulate_per_peer_tx_stats(struct ath10k *ar,
 	flags = txrate->flags;
 	gi = test_bit(ATH10K_RATE_INFO_FLAGS_SGI_BIT, &flags);
 	mcs = ATH10K_HW_MCS_RATE(pstats->ratecode);
+	rtable_bw = ath10k_get_bw(&ar->hw_params, pstats->flags);
 	bw = txrate->bw;
 	nss = txrate->nss;
 	ht_idx = mcs + (nss - 1) * 8;
 	idx = mcs * 8 + 8 * 10 * (nss - 1);
-	idx += bw * 2 + gi;
+	idx += rtable_bw * 2 + gi;
 
 #define STATS_OP_FMT(name) tx_stats->stats[ATH10K_STATS_TYPE_##name]
 
-- 
2.7.4

