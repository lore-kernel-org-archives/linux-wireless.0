Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:47577 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3GPGgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 02:36:46 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] ath9k: Use correct channel when switching bands
Date: Tue, 16 Jul 2013 12:03:20 +0530
Message-Id: <1373956402-22169-4-git-send-email-sujith@msujith.org> (sfid-20130716_083653_961125_C7D0A33A)
In-Reply-To: <1373956402-22169-1-git-send-email-sujith@msujith.org>
References: <1373956402-22169-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 50e5979..1dac46d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1526,7 +1526,8 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		ath9k_hw_mark_phy_inactive(ah);
 		udelay(5);
 
-		ath9k_hw_init_pll(ah, NULL);
+		if (band_switch)
+			ath9k_hw_init_pll(ah, chan);
 
 		if (ath9k_hw_fast_chan_change(ah, chan, &ini_reloaded)) {
 			ath_err(common, "Failed to do fast channel change\n");
-- 
1.8.3.2

