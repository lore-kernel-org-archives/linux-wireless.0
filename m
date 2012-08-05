Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52849 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab2HETgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 15:36:18 -0400
Received: by mail-we0-f174.google.com with SMTP id x8so1488533wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Aug 2012 12:36:17 -0700 (PDT)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 3/5] ath5k: Preserve tx power level requested from above on phy_init
Date: Sun,  5 Aug 2012 22:35:35 +0300
Message-Id: <1344195337-27461-4-git-send-email-mickflemm@gmail.com> (sfid-20120805_213620_805643_60EF0A90)
In-Reply-To: <1344195337-27461-1-git-send-email-mickflemm@gmail.com>
References: <1344195337-27461-1-git-send-email-mickflemm@gmail.com>
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

