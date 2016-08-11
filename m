Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56431 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932671AbcHKVMh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 17:12:37 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Pontus Fuchs <pontus.fuchs@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 11/16] net: wireless: ath: ar5523: ar5523: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:05:30 +0200
Message-Id: <1470949539-25392-12-git-send-email-wsa-dev@sang-engineering.com> (sfid-20160811_231302_192604_FE908F8D)
In-Reply-To: <1470949539-25392-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949539-25392-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 8aded24bcdf49e..7a60d2e652dad6 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -706,10 +706,8 @@ static int ar5523_alloc_rx_bufs(struct ar5523 *ar)
 
 		data->ar = ar;
 		data->urb = usb_alloc_urb(0, GFP_KERNEL);
-		if (!data->urb) {
-			ar5523_err(ar, "could not allocate rx data urb\n");
+		if (!data->urb)
 			goto err;
-		}
 		list_add_tail(&data->list, &ar->rx_data_free);
 		atomic_inc(&ar->rx_data_free_cnt);
 	}
@@ -824,7 +822,6 @@ static void ar5523_tx_work_locked(struct ar5523 *ar)
 
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
-			ar5523_err(ar, "Failed to allocate TX urb\n");
 			ieee80211_free_txskb(ar->hw, skb);
 			continue;
 		}
@@ -949,10 +946,8 @@ static int ar5523_alloc_tx_cmd(struct ar5523 *ar)
 	init_completion(&cmd->done);
 
 	cmd->urb_tx = usb_alloc_urb(0, GFP_KERNEL);
-	if (!cmd->urb_tx) {
-		ar5523_err(ar, "could not allocate urb\n");
+	if (!cmd->urb_tx)
 		return -ENOMEM;
-	}
 	cmd->buf_tx = usb_alloc_coherent(ar->dev, AR5523_MAX_TXCMDSZ,
 					 GFP_KERNEL,
 					 &cmd->urb_tx->transfer_dma);
-- 
2.8.1

