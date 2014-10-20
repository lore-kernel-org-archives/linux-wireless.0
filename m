Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:41052 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaJTNy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:54:26 -0400
Received: by mail-la0-f42.google.com with SMTP id gf13so4430378lab.15
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:54:23 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 7/9] ath10k: add extra sanity check when popping amsdu
Date: Mon, 20 Oct 2014 15:40:36 +0200
Message-Id: <1413812438-14640-8-git-send-email-michal.kazior@tieto.com> (sfid-20141020_155436_339795_73161A73)
In-Reply-To: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
References: <1413812438-14640-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The netbuf pop can return NULL. Make sure to check
for that. It shouldn't happen but better safe than
sorry.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7fa4d87..ddb9fe9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -428,6 +428,15 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		while (msdu_chained--) {
 			struct sk_buff *next = ath10k_htt_rx_netbuf_pop(htt);
 
+			if (!next) {
+				ath10k_err(ar, "failed to pop chained msdu\n");
+				ath10k_htt_rx_free_msdu_chain(*head_msdu);
+				*head_msdu = NULL;
+				msdu = NULL;
+				htt->rx_confused = true;
+				break;
+			}
+
 			skb_trim(next, 0);
 			skb_put(next, min(msdu_len, HTT_RX_BUF_SIZE));
 			msdu_len -= next->len;
-- 
1.8.5.3

