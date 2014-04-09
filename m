Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53659 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785AbaDIKHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:07:41 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so1681857eek.32
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:07:40 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/4] ath10k: make sure to not leak beacon dma mapping
Date: Wed,  9 Apr 2014 12:01:22 +0200
Message-Id: <1397037685-7485-2-git-send-email-michal.kazior@tieto.com> (sfid-20140409_120755_560246_4DBD20B4)
In-Reply-To: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
References: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If for some reason mac80211 wouldn't stop
beaconing gracefully and just removed interface of
a running AP/IBSS interface it was possible to
leak pending beacon DMA mapping. It's very
unlikely but better safe than sorry.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 58ec5a7..5a9da3a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2738,6 +2738,9 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
 	spin_lock_bh(&ar->data_lock);
 	if (arvif->beacon) {
+		dma_unmap_single(arvif->ar->dev,
+				 ATH10K_SKB_CB(arvif->beacon)->paddr,
+				 arvif->beacon->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(arvif->beacon);
 		arvif->beacon = NULL;
 	}
-- 
1.8.5.3

