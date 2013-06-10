Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:47591 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3FJIWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 04:22:38 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 3/3] ath9k: Do not assign noise for NULL caldata
Date: Mon, 10 Jun 2013 13:49:40 +0530
Message-Id: <1370852380-8335-3-git-send-email-sujith@msujith.org> (sfid-20130610_102242_472125_EF1C441C)
In-Reply-To: <1370852380-8335-1-git-send-email-sujith@msujith.org>
References: <1370852380-8335-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ah->noise is maintained globally and not per-channel. This
is updated in the reset() routine after the NF history has been
filled for the *current channel*, just before switching to
the new channel. There is no need to do it inside getnf(), since
ah->noise must contain a value for the new channel.

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/calib.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 7304e75..5e8219a 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -387,7 +387,6 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	if (!caldata) {
 		chan->noisefloor = nf;
-		ah->noise = ath9k_hw_getchan_noise(ah, chan);
 		return false;
 	}
 
-- 
1.8.3

