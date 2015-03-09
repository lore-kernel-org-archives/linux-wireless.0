Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:45797 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbbCINXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 09:23:13 -0400
Received: by lamq1 with SMTP id q1so6909917lam.12
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 06:23:11 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix CAC regression
Date: Mon,  9 Mar 2015 14:20:55 +0100
Message-Id: <1425907255-14083-1-git-send-email-michal.kazior@tieto.com> (sfid-20150309_142317_901109_C7FF92E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch `ath10k: fix interrupt storm` introduced a
regression. The condition responsible for bringing
up monitor vdev was broken and it was never
started for CAC so effectivelly CAC would not
detect radar pulses.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1138f4f..9887e09 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -856,7 +856,7 @@ static int ath10k_monitor_recalc(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	should_start = ar->monitor ||
-		       !ath10k_mac_should_disable_promisc(ar);
+		       !ath10k_mac_should_disable_promisc(ar) ||
 		       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-- 
1.8.5.3

