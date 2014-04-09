Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59596 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785AbaDIKHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:07:44 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so1681906eek.32
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:07:43 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/4] ath10k: fix firmware recovery with ap interface
Date: Wed,  9 Apr 2014 12:01:25 +0200
Message-Id: <1397037685-7485-5-git-send-email-michal.kazior@tieto.com> (sfid-20140409_120752_325324_78C89E85)
In-Reply-To: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
References: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
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
index 5a9da3a..143ea1c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2264,6 +2264,8 @@ static void ath10k_tx(struct ieee80211_hw *hw,
  */
 void ath10k_halt(struct ath10k *ar)
 {
+	struct ath10k_vif *arvif;
+
 	lockdep_assert_held(&ar->conf_mutex);
 
 	ath10k_stop_cac(ar);
@@ -2280,6 +2282,17 @@ void ath10k_halt(struct ath10k *ar)
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

