Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0DDC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C50020657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Tkw3+A+i";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Tkw3+A+i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbfCKPxf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:53:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56520 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbfCKPxf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 11:53:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B302760A05; Mon, 11 Mar 2019 15:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552319614;
        bh=IjIB6eVkGQGxszUBdficAYOpdpqvf88+WIaGrLXfnPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tkw3+A+ioAF3x06jAwN3tXxQ65u6lMnzsupi4QMu8EuYezHy3W8fRI4/0tx0UD8Gq
         en38+62glG3RDSsETo3nTNw/GaiUYX5+sy/I8KS/hhVoqagI5X9WDMege+5eW3raKD
         HJ9jY0wAM/XdAU5BS6XSJdDYi+m9t6GFaxT6F5oI=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C8BB460A05;
        Mon, 11 Mar 2019 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552319614;
        bh=IjIB6eVkGQGxszUBdficAYOpdpqvf88+WIaGrLXfnPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tkw3+A+ioAF3x06jAwN3tXxQ65u6lMnzsupi4QMu8EuYezHy3W8fRI4/0tx0UD8Gq
         en38+62glG3RDSsETo3nTNw/GaiUYX5+sy/I8KS/hhVoqagI5X9WDMege+5eW3raKD
         HJ9jY0wAM/XdAU5BS6XSJdDYi+m9t6GFaxT6F5oI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C8BB460A05
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH 2/2] ath10k: Fix NSS tx stats for legacy rates
Date:   Mon, 11 Mar 2019 21:23:22 +0530
Message-Id: <1552319602-17795-3-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552319602-17795-1-git-send-email-pillair@codeaurora.org>
References: <1552319602-17795-1-git-send-email-pillair@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The ratecode field given by firmware in the tx stats
gives the details of NSS and MCS, if the preamble
specifies that it is HT/VHT. In case of OFDM/CCK, as
specified by the preamble, the ratecode indicates the
legacy rate instead of NSS/MCS data. For OFDM/CCK cases,
the NSS should always be 1, i.e. 1x1 mode for 11g and 11b.

Currently the legacy rate is misinterpreted as NSS & MCS, leading
to incorrect updation of tx stats corresponding to NSS, which is
displayed in the tx stats via debugfs.

Fix the nss value to 1 for 11b and 11g modes by checking
the preamble indication in the ratecode provided by the firmware.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: e88975ca37d1 ("ath10k: dump tx stats in rate table format")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 8c3c940..c1308a6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2955,6 +2955,8 @@ ath10k_accumulate_per_peer_tx_stats(struct ath10k *ar,
 		STATS_OP_FMT(RETRY).ht[0][ht_idx] += pstats->retry_bytes;
 		STATS_OP_FMT(RETRY).ht[1][ht_idx] += pstats->retry_pkts;
 	} else {
+		/* For 11g and 11b, NSS is 1x1 */
+		nss = 1;
 		mcs = legacy_rate_idx;
 
 		STATS_OP_FMT(SUCC).legacy[0][mcs] += pstats->succ_bytes;
-- 
2.7.4

