Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1229 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323AbZDSOra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:47:30 -0400
Date: Sun, 19 Apr 2009 10:46:40 -0400
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 1/7] ath5k: Allow user/driver to set txpower
Message-ID: <20090419144640.GC866@hash.localnet> (sfid-20090419_164734_329363_8CC4DDE6)
References: <20090416002220.GA4138@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090416002220.GA4138@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2009 at 03:22:20AM +0300, Nick Kossifidis wrote:
>  * Now that we have regulatory control enable the driver to set txpower on hw

I assume this needs my patch for the CTLs (reproduced below).  Any 
objections to it?

From: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: use ctl settings based on current regdomain

Update ath5k to use the ctl settings for tx power based on current
regulatory domain.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 9e2faae..0ecd16f 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1743,8 +1743,6 @@ done:
  * Get the max edge power for this channel if
  * we have such data from EEPROM's Conformance Test
  * Limits (CTL), and limit max power if needed.
- *
- * FIXME: Only works for world regulatory domains
  */
 static void
 ath5k_get_max_ctl_power(struct ath5k_hw *ah,
@@ -1760,26 +1758,23 @@ ath5k_get_max_ctl_power(struct ath5k_hw *ah,
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

-- 
Bob Copeland %% www.bobcopeland.com

