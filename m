Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54399 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2G1OdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2012 10:33:16 -0400
Received: by wgbdr13 with SMTP id dr13so3584067wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jul 2012 07:33:15 -0700 (PDT)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 3/4] ath5k: Preserve tx power level requested from above on phy_init
Date: Sat, 28 Jul 2012 17:32:50 +0300
Message-Id: <1343485971-31360-3-git-send-email-mickflemm@gmail.com> (sfid-20120728_163356_138100_F96FB693)
In-Reply-To: <1343485971-31360-1-git-send-email-mickflemm@gmail.com>
References: <1343485971-31360-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By using cur_pwr on phy_init we re-use the power level previously set by the
driver, not the one we got from above.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 84a9aaf..27ca993 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3802,8 +3802,8 @@ ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	 * RF buffer settings on 5211/5212+ so that we
 	 * properly set curve indices.
 	 */
-	ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr ?
-			ah->ah_txpower.txp_cur_pwr / 2 : AR5K_TUNE_MAX_TXPOWER);
+	ret = ath5k_hw_txpower(ah, channel, ah->power_level ?
+			ah->power_level * 2 : AR5K_TUNE_MAX_TXPOWER);
 	if (ret)
 		return ret;
 
-- 
1.7.3.4

