Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1066 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZD3T4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 15:56:55 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 8/9] ath5k: use ctl settings based on current regdomain
Date: Thu, 30 Apr 2009 15:55:51 -0400
Message-Id: <1241121352-6064-9-git-send-email-me@bobcopeland.com>
In-Reply-To: <1241121352-6064-1-git-send-email-me@bobcopeland.com>
References: <1241121352-6064-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update ath5k to use the ctl settings for tx power based on current
regulatory domain.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 6737ba0..d0d1c35 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -2158,8 +2158,6 @@ done:
  * Get the max edge power for this channel if
  * we have such data from EEPROM's Conformance Test
  * Limits (CTL), and limit max power if needed.
- *
- * FIXME: Only works for world regulatory domains
  */
 static void
 ath5k_get_max_ctl_power(struct ath5k_hw *ah,
@@ -2175,26 +2173,23 @@ ath5k_get_max_ctl_power(struct ath5k_hw *ah,
 	u8 ctl_idx = 0xFF;
 	u32 target = channel->center_freq;
 
-	/* Find out a CTL for our mode that's not mapped
-	 * on a specific reg domain.
-	 *
-	 * TODO: Map our current reg domain to one of the 3 available
-	 * reg domain ids so that we can support more CTLs. */
+	ctl_mode = ath_regd_get_band_ctl(&ah->ah_regulatory, channel->band);
+
 	switch (channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
-		ctl_mode = AR5K_CTL_11A | AR5K_CTL_NO_REGDOMAIN;
+		ctl_mode |= AR5K_CTL_11A;
 		break;
 	case CHANNEL_G:
-		ctl_mode = AR5K_CTL_11G | AR5K_CTL_NO_REGDOMAIN;
+		ctl_mode |= AR5K_CTL_11G;
 		break;
 	case CHANNEL_B:
-		ctl_mode = AR5K_CTL_11B | AR5K_CTL_NO_REGDOMAIN;
+		ctl_mode |= AR5K_CTL_11B;
 		break;
 	case CHANNEL_T:
-		ctl_mode = AR5K_CTL_TURBO | AR5K_CTL_NO_REGDOMAIN;
+		ctl_mode |= AR5K_CTL_TURBO;
 		break;
 	case CHANNEL_TG:
-		ctl_mode = AR5K_CTL_TURBOG | AR5K_CTL_NO_REGDOMAIN;
+		ctl_mode |= AR5K_CTL_TURBOG;
 		break;
 	case CHANNEL_XR:
 		/* Fall through */
-- 
1.6.0.6


