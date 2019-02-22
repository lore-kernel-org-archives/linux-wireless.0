Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADF8C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 190A120818
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NJzGWT5p";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ggDmQ7Xu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfBVHVB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:21:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58502 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfBVHVB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 02:21:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DA99860A5F; Fri, 22 Feb 2019 07:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550820060;
        bh=ZoCengWbElX2M6EjafFC20lVt92p4OFtqidaUF/E16Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJzGWT5pvATcRfbMK5zMXE2onMsbumE5NOT7KrJFBoTGXGyfqdO21n7shjsXoLgne
         yctL8fs1cnd0r3QrXPCmURWg0l2S4gTfRYtIkyBqKJF9wkiArfzqRAsCayT/Dddz0c
         80Cm6CUqIvcspponAE2lp9XAhztxHwTfweJYqe5g=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ECE09609BD;
        Fri, 22 Feb 2019 07:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550820058;
        bh=ZoCengWbElX2M6EjafFC20lVt92p4OFtqidaUF/E16Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggDmQ7XudoQVmwwAfIP3x0HEWZdnwSneHIUtLeQdoIBVEBwfT6uRN+9OFlt6WAbj3
         O57AGOosuAzywsNyU+8odPiEYoH/qE0mPXqWzPqJigqNyeqtfZF4sA6mvOsRc6lNny
         dDB6va2FylMHLqTc9cjJpc+ZGjwIYo5qZFdcy6og=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ECE09609BD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH 3/4] ath10k: Fix the wrong updation of SGI in tx_stats debugfs
Date:   Fri, 22 Feb 2019 12:50:33 +0530
Message-Id: <1550820034-18603-4-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550820034-18603-1-git-send-email-svishnoi@codeaurora.org>
References: <1550820034-18603-1-git-send-email-svishnoi@codeaurora.org>
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
 drivers/net/wireless/ath/ath10k/htt_rx.c | 3 ++-
 drivers/net/wireless/ath/ath10k/wmi.h    | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 3a02a76..5b1dd58 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2924,12 +2924,13 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	struct rate_info *txrate = &arsta->txrate;
 	struct ath10k_htt_tx_stats *tx_stats;
 	int idx, ht_idx, gi, mcs, bw, nss;
+	unsigned long flags;
 
 	if (!arsta->tx_stats)
 		return;
 
 	tx_stats = arsta->tx_stats;
-	gi = (arsta->txrate.flags & RATE_INFO_FLAGS_SHORT_GI);
+	gi = test_bit(ATH10K_RATE_INFO_FLAGS_SGI_BIT, &flags);
 	ht_idx = txrate->mcs + txrate->nss * 8;
 	mcs = txrate->mcs;
 	bw = txrate->bw;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 7053db4..b727232 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5062,6 +5062,7 @@ enum wmi_rate_preamble {
 #define ATH10K_GI_NUM		2
 #define ATH10K_HT_MCS_NUM	32
 #define ATH10K_RATE_TABLE_NUM	320
+#define ATH10K_RATE_INFO_FLAGS_SGI_BIT	2
 
 /* Value to disable fixed rate setting */
 #define WMI_FIXED_RATE_NONE    (0xff)
-- 
1.9.1

