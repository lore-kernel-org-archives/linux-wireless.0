Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33600 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbaKDOeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 09:34:31 -0500
Received: by mail-lb0-f170.google.com with SMTP id z12so2829348lbi.15
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 06:34:29 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 7/7] ath10k: report rx rate and signal for fragmented Rx
Date: Tue,  4 Nov 2014 15:22:11 +0100
Message-Id: <1415110931-10945-8-git-send-email-michal.kazior@tieto.com> (sfid-20141104_153437_875453_454020BB)
In-Reply-To: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fragmented Rx wasn't reporting everything. With
the reworked Rx code it's very easy to fix it.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9073a0e..a22e832 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1519,9 +1519,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 		return;
 	}
 
-	/* FIXME: implement signal strength */
-	rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
-
+	ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status);
 	ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
 	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
 	ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
-- 
1.8.5.3

