Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65191 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883AbaDIKHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:07:43 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so1669737eei.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:07:42 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/4] ath10k: prevent beacon memory leak
Date: Wed,  9 Apr 2014 12:01:24 +0200
Message-Id: <1397037685-7485-4-git-send-email-michal.kazior@tieto.com> (sfid-20140409_120752_980020_52538786)
In-Reply-To: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
References: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If DMA mapping of next beacon failed ath10k leaked
the beacon.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 35c7d52..ca51f17 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1450,6 +1450,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 					ATH10K_SKB_CB(bcn)->paddr);
 		if (ret) {
 			ath10k_warn("failed to map beacon: %d\n", ret);
+			dev_kfree_skb_any(bcn);
 			goto skip;
 		}
 
-- 
1.8.5.3

