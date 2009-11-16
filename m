Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4658 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZKPNbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 08:31:37 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, daniel.folkers@task24.nl
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>, stable@kernel.org
Subject: [PATCH] ath5k: allow setting txpower to 0
Date: Mon, 16 Nov 2009 08:30:29 -0500
Message-Id: <1258378229-23113-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As a holdover from earlier code when we used to set
the power limit to '0' after a reset to configure the
default transmit power, ath5k interprets txpower=0 as
12.5 dBm.  Fix that by just passing 0 through.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=14567

Cc: stable@kernel.org
Reported-by: Daniel Folkers <daniel.folkers@task24.nl>
Tested-by: Daniel Folkers <daniel.folkers@task24.nl>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 8959907..721ec5e 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3025,8 +3025,6 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		ATH5K_ERR(ah->ah_sc, "invalid tx power: %u\n", txpower);
 		return -EINVAL;
 	}
-	if (txpower == 0)
-		txpower = AR5K_TUNE_DEFAULT_TXPOWER;
 
 	/* Reset TX power values */
 	memset(&ah->ah_txpower, 0, sizeof(ah->ah_txpower));
-- 
1.6.3.3


