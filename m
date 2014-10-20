Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:51461 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaJTNyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:54:16 -0400
Received: by mail-la0-f52.google.com with SMTP id hz20so3930632lab.39
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:54:15 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/9] ath10k: don't drop control and null func Rx
Date: Mon, 20 Oct 2014 15:40:30 +0200
Message-Id: <1413812438-14640-2-git-send-email-michal.kazior@tieto.com> (sfid-20141020_155420_422310_14D5882F)
In-Reply-To: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
References: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HTT_RX_IND_MPDU_STATUS_MGMT_CTRL was pretty greedy
and because of that ath10k ended up dropping
Control Frames as well as Null Func frames.

Reported-by: Okhwan Lee <ohlee@mwnl.snu.ac.kr>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index fbb3175..63c69d8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1200,8 +1200,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 	}
 
 	/* Skip mgmt frames while we handle this in WMI */
-	if (status == HTT_RX_IND_MPDU_STATUS_MGMT_CTRL ||
-	    attention & RX_ATTENTION_FLAGS_MGMT_TYPE) {
+	if (attention & RX_ATTENTION_FLAGS_MGMT_TYPE) {
 		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx mgmt ctrl\n");
 		return false;
 	}
-- 
1.8.5.3

