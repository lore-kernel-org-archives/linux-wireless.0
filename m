Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E96C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 05:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0D8620863
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 05:36:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="b2qIVdmr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eLaMosKh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbfBAFgh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 00:36:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbfBAFgg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 00:36:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 63ACE60A31; Fri,  1 Feb 2019 05:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548999396;
        bh=jpvJB/hbiatxUn3jTj25FD2nkjPyuWEJbl/mo2gFlUM=;
        h=From:To:Cc:Subject:Date:From;
        b=b2qIVdmraINvAqntyvxpPAziPb1EkYw5IS6FgZWNeO6wJ90eEYcx4weQVrAdLF81F
         OfLISAUClBGxKcBFqK1BjlJ2mK+zHG5+SAebpBBYK3e9vRTyjjEsZNYibM+7P35K6c
         BtY9lKEI19LuwuWPXMdFv0RSDGVREx0sJ+Qt82O8=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7911460721;
        Fri,  1 Feb 2019 05:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548999395;
        bh=jpvJB/hbiatxUn3jTj25FD2nkjPyuWEJbl/mo2gFlUM=;
        h=From:To:Cc:Subject:Date:From;
        b=eLaMosKhm3XRgcNDCvevacBTWZrE5pIDLnlbv7ASqVfnMhVWCrYDGyXQStvi0f7ox
         8i2KeCik2Ux4NRF+3vDwYaDPGJlrV04/egxIIv7HhROnMV7gP3jU0WR+Nx7e7UCOBB
         TgSbie+hTfJ2tJRgBTTUgXuSbcHleKLQuZz/Lui8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7911460721
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH] ath10k: Fill tx_duration for each peer in Tx stats per STA
Date:   Fri,  1 Feb 2019 11:06:30 +0530
Message-Id: <1548999390-25576-1-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Firmware sends the tx_duration for each in HTT_T2H_MSG_TYPE_PEER_STATS
msg. Fill the tx_duration sent by firmware in the tx stats information
per STA.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f42bac2..89d84dc 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2975,6 +2975,8 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 		STATS_OP_FMT(RETRY).rate_table[0][idx] += pstats->retry_bytes;
 		STATS_OP_FMT(RETRY).rate_table[1][idx] += pstats->retry_pkts;
 	}
+
+	tx_stats->tx_duration += pstats->duration;
 }
 
 static void
@@ -3141,6 +3143,7 @@ static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
 		p_tx_stats->succ_pkts = __le16_to_cpu(tx_stats->succ_pkts);
 		p_tx_stats->retry_pkts = __le16_to_cpu(tx_stats->retry_pkts);
 		p_tx_stats->failed_pkts = __le16_to_cpu(tx_stats->failed_pkts);
+		p_tx_stats->duration = __le16_to_cpu(tx_stats->tx_duration);
 
 		ath10k_update_per_peer_tx_stats(ar, sta, p_tx_stats);
 	}
-- 
1.9.1

