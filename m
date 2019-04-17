Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86331C10F12
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4136B2073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:17:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RMrM0eRy";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Zg1q/IIy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731279AbfDQIRi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 04:17:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbfDQIRi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 04:17:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2B2F36032C; Wed, 17 Apr 2019 08:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555489057;
        bh=JEV+600VuvzCIM0AtpMvv4lC0jW5usmWzfgOEA37cWc=;
        h=From:To:Cc:Subject:Date:From;
        b=RMrM0eRyoqFAwvYC/FgnZWx4EdNXXs+/E0B/z5mE6knJpH99EOckXjXGlvMr3VHNQ
         srwxQ7QvPKma5uNz2BeIRgjrf2vKG9oZ7FYDIaFx8Oy+XRg8wXQ/gW1vQE79v/gFPc
         uXf7ntXdezYtLtXnMhMrkaNIyTtrikAH+sR5Fpw4=
Received: from wl-HP-Z240-SFF-Workstation.ap.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: leiwa@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6857460850;
        Wed, 17 Apr 2019 08:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555489056;
        bh=JEV+600VuvzCIM0AtpMvv4lC0jW5usmWzfgOEA37cWc=;
        h=From:To:Cc:Subject:Date:From;
        b=Zg1q/IIy3KnNAeFdm8B6zUNmhYKgyEYQo2qcS3NCLT5NkgKR0rTdRgWprb95vlPjr
         /1toP3Ngxwr/EI+4f0NF/EFQWQ10WD2JvVCFd0pEDrqHa9CB4xkrwL2J2G4yuQ9dzl
         XfKqg7uR2IeVwxf1J6l7VN7QgNILs89dDkYdVMeM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6857460850
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=leiwa@codeaurora.org
From:   Lei Wang <leiwa@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Lei Wang <leiwa@codeaurora.org>
Subject: [PATCH v2] ath10k: fix different tx duration output
Date:   Wed, 17 Apr 2019 16:17:25 +0800
Message-Id: <1555489045-18070-1-git-send-email-leiwa@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

TX duration output of tx_stats in debugfs and station dump had big
difference because they got tx duration value from different statistic
data. We should use the same statistic data.

Tested: QCA988X with firmware ver 10.2.4-1.0-00043

Signed-off-by: Lei Wang <leiwa@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b73c23d..5414169 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7977,6 +7977,11 @@ static void ath10k_sta_statistics(struct ieee80211_hw *hw,
 	sinfo->rx_duration = arsta->rx_duration;
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_DURATION);
 
+	if (arsta->tx_stats && ath10k_debug_is_extd_tx_stats_enabled(ar)) {
+		sinfo->tx_duration = arsta->tx_stats->tx_duration;
+		sinfo->filled |= 1ULL << NL80211_STA_INFO_TX_DURATION;
+	}
+
 	if (!arsta->txrate.legacy && !arsta->txrate.nss)
 		return;
 
-- 
1.9.1

