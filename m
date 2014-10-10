Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:44399 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaJJMGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 08:06:45 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] ath10k: fix kernel panic while shutting down AP
Date: Fri, 10 Oct 2014 17:38:27 +0530
Message-ID: <1412942907-24760-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141010_140648_717485_589C2E5A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on GFP flag given to DMA coherent allocation, the behaviour of
dma_free_coherent is changed. This behavioural diffrence is noticeable
in ARM platform. If DMA memory is allocated with GFP_KERNEL, free
coherent can not be called inside spin lock. This is causing kernel
crash in ARM platforms. Fix this by changing GFP flag to atomic.

Cc: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 75e0aeb..14a5944 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2839,7 +2839,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		arvif->beacon_buf = dma_zalloc_coherent(ar->dev,
 							IEEE80211_MAX_FRAME_LEN,
 							&arvif->beacon_paddr,
-							GFP_KERNEL);
+							GFP_ATOMIC);
 		if (!arvif->beacon_buf) {
 			ret = -ENOMEM;
 			ath10k_warn(ar, "failed to allocate beacon buffer: %d\n",
-- 
2.1.2

