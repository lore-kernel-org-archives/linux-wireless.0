Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33156 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbbHFMq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 08:46:27 -0400
Received: by lbbyj8 with SMTP id yj8so41981690lbb.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 05:46:26 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: wake up offchannel queue properly
Date: Thu,  6 Aug 2015 14:46:54 +0200
Message-Id: <1438865214-1651-1-git-send-email-michal.kazior@tieto.com> (sfid-20150806_144632_006110_933CECE7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once HTT Tx queue got full offchannel queue was
stopped and never woken up again. This broke, e.g.
P2P. This could be reproduced after running a lot
of traffic enough to saturate 100% of the driver
Tx queue and then trying to send offchannel
traffic.

Fixes: 96d828d45e16 ("ath10k: rework tx queue locking")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index acd222f3b899..c7ff0c8a5bd4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3002,6 +3002,8 @@ void ath10k_mac_tx_unlock(struct ath10k *ar, int reason)
 						   IEEE80211_IFACE_ITER_RESUME_ALL,
 						   ath10k_mac_tx_unlock_iter,
 						   ar);
+
+	ieee80211_wake_queue(ar->hw, ar->hw->offchannel_tx_hw_queue);
 }
 
 void ath10k_mac_vif_tx_lock(struct ath10k_vif *arvif, int reason)
-- 
2.1.4

