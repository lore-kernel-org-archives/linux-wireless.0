Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:35429 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaDNH0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 03:26:36 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so6169471eek.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 00:26:35 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 1/4] ath10k: make sure to not leak beacon dma mapping
Date: Mon, 14 Apr 2014 09:20:07 +0200
Message-Id: <1397460010-19153-2-git-send-email-michal.kazior@tieto.com> (sfid-20140414_092642_802469_EE5C428F)
In-Reply-To: <1397460010-19153-1-git-send-email-michal.kazior@tieto.com>
References: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
 <1397460010-19153-1-git-send-email-michal.kazior@tieto.com>
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
index 8385a7a..22e8239 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2771,6 +2771,9 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
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

