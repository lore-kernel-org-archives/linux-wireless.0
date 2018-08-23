Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:13372 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728615AbeHWPQm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:16:42 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 5/9] wil6210: allocate rx reorder buffer only if rx reorder is enabled
Date: Thu, 23 Aug 2018 14:47:09 +0300
Message-Id: <1535024833-15178-6-git-send-email-merez@codeaurora.org> (sfid-20180823_134750_626016_5E59CB4A)
In-Reply-To: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
References: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wil_addba_rx_request allocates the rx reorder buffer regardless
of use_rx_hw_reordering settings.
Fix this by checking wil->use_rx_hw_reordering before allocating
the reorder buffer.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index b608aa1..983bd00 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -382,11 +382,13 @@ int wil_addba_rx_request(struct wil6210_priv *wil, u8 mid,
 	}
 
 	/* apply */
-	r = wil_tid_ampdu_rx_alloc(wil, agg_wsize, ssn);
-	spin_lock_bh(&sta->tid_rx_lock);
-	wil_tid_ampdu_rx_free(wil, sta->tid_rx[tid]);
-	sta->tid_rx[tid] = r;
-	spin_unlock_bh(&sta->tid_rx_lock);
+	if (!wil->use_rx_hw_reordering) {
+		r = wil_tid_ampdu_rx_alloc(wil, agg_wsize, ssn);
+		spin_lock_bh(&sta->tid_rx_lock);
+		wil_tid_ampdu_rx_free(wil, sta->tid_rx[tid]);
+		sta->tid_rx[tid] = r;
+		spin_unlock_bh(&sta->tid_rx_lock);
+	}
 
 out:
 	return rc;
-- 
1.9.1
