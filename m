Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:51504 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaJTNyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:54:18 -0400
Received: by mail-lb0-f175.google.com with SMTP id u10so3866354lbd.6
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:54:16 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/9] ath10k: remove unused variable
Date: Mon, 20 Oct 2014 15:40:31 +0200
Message-Id: <1413812438-14640-3-git-send-email-michal.kazior@tieto.com> (sfid-20141020_155422_948983_A9E27A7E)
In-Reply-To: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
References: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rx descriptor variable was no longer used in
the rx handler.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 63c69d8..61ff2ac 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1230,7 +1230,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	struct ath10k *ar = htt->ar;
 	struct ieee80211_rx_status *rx_status = &htt->rx_status;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
-	struct htt_rx_desc *rxd;
 	enum htt_rx_mpdu_status status;
 	struct ieee80211_hdr *hdr;
 	int num_mpdu_ranges;
@@ -1301,10 +1300,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 				continue;
 			}
 
-			rxd = container_of((void *)msdu_head->data,
-					   struct htt_rx_desc,
-					   msdu_payload);
-
 			if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
 							 status,
 							 channel_set,
-- 
1.8.5.3

