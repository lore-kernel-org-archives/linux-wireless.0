Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:8127 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753631AbXKWKvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 05:51:54 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 2/3] ath5k: noise calibration also for rf511x
Date: Fri, 23 Nov 2007 19:52:02 +0900
Message-Id: <1195815123-22375-3-git-send-email-bruno@thinktube.com> (sfid-20071123_105159_068332_6942C6DD)
In-Reply-To: <1195815123-22375-2-git-send-email-bruno@thinktube.com>
References: <1195815123-22375-1-git-send-email-bruno@thinktube.com>
 <1195815123-22375-2-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

also perform full noise calibration in ath5k_hw_rf511x_calibrate() instead of
just writing the bit.

Changes-licensed-under: ISC
Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/phy.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 9b91121..f250c2e 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1702,8 +1702,7 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 		((u32)q_coff) | ((u32)i_coff << AR5K_PHY_IQ_CORR_Q_I_COFF_S));
 
 done:
-	/* Start noise floor calibration */
-	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
+	ath5k_hw_noise_floor_calibration(ah, channel->freq);
 
 	/* Request RF gain */
 	if (channel->val & CHANNEL_5GHZ) {
-- 
1.5.3.4

