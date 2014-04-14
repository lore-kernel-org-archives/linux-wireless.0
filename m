Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53034 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaDNH0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 03:26:40 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so6212126eek.36
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 00:26:39 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 4/4] ath10k: fix firmware recovery with ap interface
Date: Mon, 14 Apr 2014 09:20:10 +0200
Message-Id: <1397460010-19153-5-git-send-email-michal.kazior@tieto.com> (sfid-20140414_092644_971242_DA825C77)
In-Reply-To: <1397460010-19153-1-git-send-email-michal.kazior@tieto.com>
References: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
 <1397460010-19153-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacon data wasn't properly cleared during early
phase of recovery. This in turn caused firmware to
crash because the beacon data was submitted before
vdevs were fully re-configured. Ultimately the
device was considered wedged and nothing worked
until driver was reloaded.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 22e8239..e2c01dc 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2291,6 +2291,8 @@ static void ath10k_tx(struct ieee80211_hw *hw,
  */
 void ath10k_halt(struct ath10k *ar)
 {
+	struct ath10k_vif *arvif;
+
 	lockdep_assert_held(&ar->conf_mutex);
 
 	if (ath10k_monitor_is_enabled(ar)) {
@@ -2313,6 +2315,17 @@ void ath10k_halt(struct ath10k *ar)
 		ar->scan.in_progress = false;
 		ieee80211_scan_completed(ar->hw, true);
 	}
+
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		if (!arvif->beacon)
+			continue;
+
+		dma_unmap_single(arvif->ar->dev,
+				 ATH10K_SKB_CB(arvif->beacon)->paddr,
+				 arvif->beacon->len, DMA_TO_DEVICE);
+		dev_kfree_skb_any(arvif->beacon);
+		arvif->beacon = NULL;
+	}
 	spin_unlock_bh(&ar->data_lock);
 }
 
-- 
1.8.5.3

