Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37365 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab0CJQPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 11:15:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, mickflemm@gmail.com, proski@gnu.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/3] ath5k: remove dead source in ath5k_combine_linear_pcdac_curves
Date: Wed, 10 Mar 2010 11:08:49 -0500
Message-Id: <1268237330-30013-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1268237330-30013-1-git-send-email-linville@tuxdriver.com>
References: <1268237330-30013-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code was commented-out when it was added about a year ago and
remains unchanged -- seems as if we don't need it...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 97a705a..1c425a5 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -2427,19 +2427,6 @@ ath5k_combine_linear_pcdac_curves(struct ath5k_hw *ah, s16* table_min,
 		pcdac_tmp = pcdac_high_pwr;
 
 		edge_flag = 0x40;
-#if 0
-		/* If both min and max power limits are in lower
-		 * power curve's range, only use the low power curve.
-		 * TODO: min/max levels are related to target
-		 * power values requested from driver/user
-		 * XXX: Is this really needed ? */
-		if (min_pwr < table_max[1] &&
-		max_pwr < table_max[1]) {
-			edge_flag = 0;
-			pcdac_tmp = pcdac_low_pwr;
-			max_pwr_idx = (table_max[1] - table_min[1])/2;
-		}
-#endif
 	} else {
 		pcdac_low_pwr = ah->ah_txpower.tmpL[1]; /* Zeroed */
 		pcdac_high_pwr = ah->ah_txpower.tmpL[0];
-- 
1.6.2.5

