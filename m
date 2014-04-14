Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38119 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaDNH0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 03:26:39 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so6309934eek.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 00:26:38 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 3/4] ath10k: prevent beacon memory leak
Date: Mon, 14 Apr 2014 09:20:09 +0200
Message-Id: <1397460010-19153-4-git-send-email-michal.kazior@tieto.com> (sfid-20140414_092650_259229_B262F36F)
In-Reply-To: <1397460010-19153-1-git-send-email-michal.kazior@tieto.com>
References: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
 <1397460010-19153-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If DMA mapping of next beacon failed ath10k leaked
the beacon.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 11176cc..72cc4f2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1441,6 +1441,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 					ATH10K_SKB_CB(bcn)->paddr);
 		if (ret) {
 			ath10k_warn("failed to map beacon: %d\n", ret);
+			dev_kfree_skb_any(bcn);
 			goto skip;
 		}
 
-- 
1.8.5.3

