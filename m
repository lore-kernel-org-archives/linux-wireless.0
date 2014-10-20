Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:62076 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaJTNy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:54:27 -0400
Received: by mail-la0-f51.google.com with SMTP id ge10so3958808lab.38
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:54:26 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 9/9] ath10k: clear htt->rx_confused on load
Date: Mon, 20 Oct 2014 15:40:38 +0200
Message-Id: <1413812438-14640-10-git-send-email-michal.kazior@tieto.com> (sfid-20141020_155433_251768_BF64502A)
In-Reply-To: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
References: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once driver entered the rx_confused state it would
refuse to rx even after firmware is restarted.
Make sure to clear it so that rx works after, e.g.
hw restart or after all interfaces are stopped.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 39e1969..3e52a33 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -497,6 +497,8 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	size_t size;
 	struct timer_list *timer = &htt->rx_ring.refill_retry_timer;
 
+	htt->rx_confused = false;
+
 	htt->rx_ring.size = ath10k_htt_rx_ring_size(htt);
 	if (!is_power_of_2(htt->rx_ring.size)) {
 		ath10k_warn(ar, "htt rx ring size is not power of 2\n");
-- 
1.8.5.3

