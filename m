Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:14934 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZFLXIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 19:08:49 -0400
Received: by rv-out-0506.google.com with SMTP id f9so724806rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2009 16:08:51 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] ath5k: fix mesh beaconing
Date: Fri, 12 Jun 2009 16:09:53 -0700
Message-Id: <1244848193-11210-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is from Nick Kossifidis but he forgot to send it.  It ensures
that the beacon queue gets started in mesh mode as well, otherwise ath5k
will not beacon in mesh point mode.

At this time, we still need to issue a scan before mesh beaconing will
work but that appears to be a separate problem.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index ec35503..2942f13 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -733,8 +733,9 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 	/*
 	 * Set the beacon register and enable all timers.
 	 */
-	/* When in AP mode zero timer0 to start TSF */
-	if (ah->ah_op_mode == NL80211_IFTYPE_AP)
+	/* When in AP or Mesh Point mode zero timer0 to start TSF */
+	if (ah->ah_op_mode == NL80211_IFTYPE_AP ||
+	    ah->ah_op_mode == NL80211_IFTYPE_MESH_POINT)
 		ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
 
 	ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
-- 
1.5.6.3

