Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45938 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0KWToI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:44:08 -0500
Received: by ewy5 with SMTP id 5so2681338ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:44:07 -0800 (PST)
Date: Tue, 23 Nov 2010 21:44:02 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 25/30] ath5k: Tweak phy activate to rx start delay based on
 bwmode
Message-ID: <20101123194402.GY4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Tweak phy activation -> rx delay for different bwmodes

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 1b6fcf9..8790f0a 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3356,8 +3356,6 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	/*
 	 * On 5211+ read activation -> rx delay
 	 * and use it.
-	 *
-	 * TODO: Half/quarter rate support
 	 */
 	if (ah->ah_version != AR5K_AR5210) {
 		u32 delay;
@@ -3365,8 +3363,13 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 			AR5K_PHY_RX_DELAY_M;
 		delay = (channel->hw_value & CHANNEL_CCK) ?
 			((delay << 2) / 22) : (delay / 10);
-
-		udelay(100 + (2 * delay));
+		if (ah->ah_bwmode == AR5K_BWMODE_10MHZ)
+			delay = delay << 1;
+		if (ah->ah_bwmode == AR5K_BWMODE_5MHZ)
+			delay = delay << 2;
+		/* XXX: /2 on turbo ? Let's be safe
+		 * for now */
+		udelay(100 + delay);
 	} else {
 		mdelay(1);
 	}
