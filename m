Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:56451 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaDNH0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 03:26:38 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so6149267eek.6
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 00:26:37 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 2/4] ath10k: make sure to not use invalid beacon pointer
Date: Mon, 14 Apr 2014 09:20:08 +0200
Message-Id: <1397460010-19153-3-git-send-email-michal.kazior@tieto.com> (sfid-20140414_092644_336917_7659C70E)
In-Reply-To: <1397460010-19153-1-git-send-email-michal.kazior@tieto.com>
References: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
 <1397460010-19153-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If DMA mapping of next beacon failed it was
possible for next SWBA to access a pointer that
was already unmapped and freed. This could cause
memory corruption.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * move arvif->beacon=NULL after dev_kfree_skb() [Kalle]

 drivers/net/wireless/ath/ath10k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index fe4d5f1..11176cc 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1431,6 +1431,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 					 ATH10K_SKB_CB(arvif->beacon)->paddr,
 					 arvif->beacon->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(arvif->beacon);
+			arvif->beacon = NULL;
 		}
 
 		ATH10K_SKB_CB(bcn)->paddr = dma_map_single(arvif->ar->dev,
-- 
1.8.5.3

