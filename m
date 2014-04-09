Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39499 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaDIKHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:07:42 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so1668451eek.36
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:07:41 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/4] ath10k: make sure to not use invalid beacon pointer
Date: Wed,  9 Apr 2014 12:01:23 +0200
Message-Id: <1397037685-7485-3-git-send-email-michal.kazior@tieto.com> (sfid-20140409_120800_207619_FA96F1F7)
In-Reply-To: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
References: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If DMA mapping of next beacon failed it was
possible for next SWBA to access a pointer that
was already unmapped and freed. This could cause
memory corruption.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index d4b48ef..35c7d52 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1441,6 +1441,8 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 			dev_kfree_skb_any(arvif->beacon);
 		}
 
+		arvif->beacon = NULL;
+
 		ATH10K_SKB_CB(bcn)->paddr = dma_map_single(arvif->ar->dev,
 							   bcn->data, bcn->len,
 							   DMA_TO_DEVICE);
-- 
1.8.5.3

