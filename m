Return-Path: <SRS0=2qsG=EC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6790C4363A
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Oct 2020 00:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F2342151B
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Oct 2020 00:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603758564;
	bh=X8lBN1La8+tYGxssc0c66XRKu04bVNdwauw8oNCdDSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xEzbM6+5YiOlstvaaTuMWGJa23/FXdoAthBvT1EPFZ2xMlFmfXh8yo/d8IlrTcK7C
	 3cH/VvF1D39U5IxgiYTw7Wqon13aNadpIeCk8iW+CJieIecWp6qjYMyll7ska7GZfB
	 a13z/t6y21aQSA2qLfR9vOU2K7w5YfPXlIZiwfF8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409807AbgJZXwj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409796AbgJZXwi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01A0620882;
        Mon, 26 Oct 2020 23:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756357;
        bh=X8lBN1La8+tYGxssc0c66XRKu04bVNdwauw8oNCdDSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ik/53r9gQ01rLYRWgGChTckYnYJ3CnV0XsP/R4FuRrUiFnKH1kpwwaFJmdwtXD9ox
         KCyLG97tu1ONPvPbpVaJ+eNeEe9ObD6Pjgm6p3vvv4LY3uhnpOhsbeqZXLyQpyUvse
         9quOnqEhk4TU/fnG4OQi2LLW7Cnl1bnzxaWtMFvk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 027/132] ath10k: fix retry packets update in station dump
Date:   Mon, 26 Oct 2020 19:50:19 -0400
Message-Id: <20201026235205.1023962-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Venkateswara Naralasetty <vnaralas@codeaurora.org>

[ Upstream commit 67b927f9820847d30e97510b2f00cd142b9559b6 ]

When tx status enabled, retry count is updated from tx completion status.
which is not working as expected due to firmware limitation where
firmware can not provide per MSDU rate statistics from tx completion
status. Due to this tx retry count is always 0 in station dump.

Fix this issue by updating the retry packet count from per peer
statistics. This patch will not break on SDIO devices since, this retry
count is already updating from peer statistics for SDIO devices.

Tested-on: QCA9984 PCI 10.4-3.6-00104
Tested-on: QCA9882 PCI 10.2.4-1.0-00047

Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1591856446-26977-1-git-send-email-vnaralas@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 8 +++++---
 drivers/net/wireless/ath/ath10k/mac.c    | 5 +++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index d787cbead56ab..cac05e7bb6b07 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -3575,12 +3575,14 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 	}
 
 	if (ar->htt.disable_tx_comp) {
-		arsta->tx_retries += peer_stats->retry_pkts;
 		arsta->tx_failed += peer_stats->failed_pkts;
-		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx retries %d tx failed %d\n",
-			   arsta->tx_retries, arsta->tx_failed);
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "tx failed %d\n",
+			   arsta->tx_failed);
 	}
 
+	arsta->tx_retries += peer_stats->retry_pkts;
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx retries %d", arsta->tx_retries);
+
 	if (ath10k_debug_is_extd_tx_stats_enabled(ar))
 		ath10k_accumulate_per_peer_tx_stats(ar, arsta, peer_stats,
 						    rate_idx);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 919d15584d4a2..d9d4b15a6d81c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8547,12 +8547,13 @@ static void ath10k_sta_statistics(struct ieee80211_hw *hw,
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 
 	if (ar->htt.disable_tx_comp) {
-		sinfo->tx_retries = arsta->tx_retries;
-		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_RETRIES);
 		sinfo->tx_failed = arsta->tx_failed;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 	}
 
+	sinfo->tx_retries = arsta->tx_retries;
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_RETRIES);
+
 	ath10k_mac_sta_get_peer_stats_info(ar, sta, sinfo);
 }
 
-- 
2.25.1

