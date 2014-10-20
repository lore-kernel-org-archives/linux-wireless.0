Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:42352 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaJTNy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:54:26 -0400
Received: by mail-la0-f46.google.com with SMTP id gi9so3972181lab.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:54:24 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 8/9] ath10k: don't forget to replenish after fragmented Rx
Date: Mon, 20 Oct 2014 15:40:37 +0200
Message-Id: <1413812438-14640-9-git-send-email-michal.kazior@tieto.com> (sfid-20141020_155433_852951_E2059E4B)
In-Reply-To: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
References: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In theory it was possible to drain entire HTT Rx
ring via fragmented Rx leading to Rx lockup.

In practice non-data traffic would always trigger
replenishment via the regular Rx handler.

For correctness sake make sure to replenish the
ring on fragmented Rx.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index ddb9fe9..39e1969 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1355,6 +1355,8 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 				      &attention);
 	spin_unlock_bh(&htt->rx_ring.lock);
 
+	tasklet_schedule(&htt->rx_replenish_task);
+
 	ath10k_dbg(ar, ATH10K_DBG_HTT_DUMP, "htt rx frag ahead\n");
 
 	if (ret) {
-- 
1.8.5.3

