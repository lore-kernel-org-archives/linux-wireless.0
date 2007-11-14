Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:34676 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613AbXKNQL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 11:11:27 -0500
Date: Wed, 14 Nov 2007 18:11:40 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 1/4] ath5k: Fix another faulty channel flag check
Message-ID: <20071114161139.GA6365@localhost.domain.invalid> (sfid-20071114_161130_174427_571CCE7B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*Fix another faulty channel flags check
    
Don't check channel->val against CHANNEL_A/B/G flags because they have common flags set
eg. doing AND between CHANNEL_A and CHANNEL_G always returns true because they have
CHANNEL_OFDM, same goes for CHANNEL_B and CHANNEL_G that have CHANNEL_2GHZ in common.
    
Instead check against CHANNEL_CCK/OFDM/2GHZ/5GHZ...

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index f78ca6e..ead2d75 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -719,7 +719,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 				AR5K_SREV_RAD_5112A) {
 			ath5k_hw_reg_write(ah, AR5K_PHY_CCKTXCTL_WORLD,
 					AR5K_PHY_CCKTXCTL);
-			if (channel->val & CHANNEL_A)
+			if (channel->val & CHANNEL_5GHZ)
 				data = 0xffb81020;
 			else
 				data = 0xffb80d20;


