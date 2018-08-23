Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:24234 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728588AbeHWPQo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:16:44 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 6/9] wil6210: prevent usage of tx ring 0 for eDMA
Date: Thu, 23 Aug 2018 14:47:10 +0300
Message-Id: <1535024833-15178-7-git-send-email-merez@codeaurora.org> (sfid-20180823_134728_708116_EDC33A7D)
In-Reply-To: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
References: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In enhanced DMA ring 0 is used for RX ring, hence TX ring 0
is an unused element in ring_tx and ring2cid_tid arrays.
Initialize ring2cid_tid CID to WIL6210_MAX_CID to prevent a false
match of CID 0.
Go over the ring_tx and ring2cid_tid from wil_get_min_tx_ring_id
and on to prevent access to index 0 in eDMA.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 7 +++++--
 drivers/net/wireless/ath/wil6210/txrx.c | 6 ++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 827df1c..3fcf799 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -223,6 +223,7 @@ static void wil_disconnect_cid(struct wil6210_vif *vif, int cid,
 	struct net_device *ndev = vif_to_ndev(vif);
 	struct wireless_dev *wdev = vif_to_wdev(vif);
 	struct wil_sta_info *sta = &wil->sta[cid];
+	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
 	might_sleep();
 	wil_dbg_misc(wil, "disconnect_cid: CID %d, MID %d, status %d\n",
@@ -273,7 +274,7 @@ static void wil_disconnect_cid(struct wil6210_vif *vif, int cid,
 	memset(sta->tid_crypto_rx, 0, sizeof(sta->tid_crypto_rx));
 	memset(&sta->group_crypto_rx, 0, sizeof(sta->group_crypto_rx));
 	/* release vrings */
-	for (i = 0; i < ARRAY_SIZE(wil->ring_tx); i++) {
+	for (i = min_ring_id; i < ARRAY_SIZE(wil->ring_tx); i++) {
 		if (wil->ring2cid_tid[i][0] == cid)
 			wil_ring_fini_tx(wil, i);
 	}
@@ -604,8 +605,10 @@ int wil_priv_init(struct wil6210_priv *wil)
 		wil->sta[i].mid = U8_MAX;
 	}
 
-	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++)
+	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
 		spin_lock_init(&wil->ring_tx_data[i].lock);
+		wil->ring2cid_tid[i][0] = WIL6210_MAX_CID;
+	}
 
 	mutex_init(&wil->mutex);
 	mutex_init(&wil->vif_mutex);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index e7b003b38..259e4a8 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -77,8 +77,9 @@ bool wil_is_tx_idle(struct wil6210_priv *wil)
 {
 	int i;
 	unsigned long data_comp_to;
+	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
-	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+	for (i = min_ring_id; i < WIL6210_MAX_TX_RINGS; i++) {
 		struct wil_ring *vring = &wil->ring_tx[i];
 		int vring_index = vring - wil->ring_tx;
 		struct wil_ring_tx_data *txdata =
@@ -1942,6 +1943,7 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 					   bool check_stop)
 {
 	int i;
+	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
 	if (unlikely(!vif))
 		return;
@@ -1974,7 +1976,7 @@ static inline void __wil_update_net_queues(struct wil6210_priv *wil,
 		return;
 
 	/* check wake */
-	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+	for (i = min_ring_id; i < WIL6210_MAX_TX_RINGS; i++) {
 		struct wil_ring *cur_ring = &wil->ring_tx[i];
 		struct wil_ring_tx_data  *txdata = &wil->ring_tx_data[i];
 
-- 
1.9.1
