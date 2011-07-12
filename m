Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58693 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab1GLBCT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 21:02:19 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	mickflemm@gmail.com
Subject: [PATCH v3 3/8] ath5k: fix reference clock frequency for spur mitigation on AR2413
Date: Tue, 12 Jul 2011 09:02:00 +0800
Message-Id: <1310432525-70077-3-git-send-email-nbd@openwrt.org> (sfid-20110712_030223_204039_A72428E4)
In-Reply-To: <1310432525-70077-2-git-send-email-nbd@openwrt.org>
References: <1310432525-70077-1-git-send-email-nbd@openwrt.org>
 <1310432525-70077-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR2413 uses the same reference clock as AR5413

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/phy.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index acf73a0..dd2b417 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -105,6 +105,7 @@ bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
 
 	if ((ah->ah_radio == AR5K_RF5112) ||
 	(ah->ah_radio == AR5K_RF5413) ||
+	(ah->ah_radio == AR5K_RF2413) ||
 	(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4)))
 		refclk_freq = 40;
 	else
-- 
1.7.3.2

