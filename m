Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49653 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab2IXSpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 14:45:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: David Binderman <dcb314@hotmail.com>, me@bobcopeland.com,
	mickflemm@gmail.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: add missing breaks in ath5k_hw_set_spur_mitigation_filter
Date: Mon, 24 Sep 2012 14:30:19 -0400
Message-Id: <1348511419-11881-1-git-send-email-linville@tuxdriver.com> (sfid-20120924_204533_778273_29555E38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

https://bugzilla.kernel.org/show_bug.cgi?id=47681

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/phy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 8b71a2d..d605217 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1975,11 +1975,13 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 			spur_delta_phase = (spur_offset << 18) / 25;
 			spur_freq_sigma_delta = (spur_delta_phase >> 10);
 			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz / 2;
+			break;
 		case AR5K_BWMODE_5MHZ:
 			/* Both sample_freq and chip_freq are 10MHz (?) */
 			spur_delta_phase = (spur_offset << 19) / 25;
 			spur_freq_sigma_delta = (spur_delta_phase >> 10);
 			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz / 4;
+			break;
 		default:
 			if (channel->band == IEEE80211_BAND_5GHZ) {
 				/* Both sample_freq and chip_freq are 40MHz */
-- 
1.7.11.4

