Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59042 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852AbZC0Vra (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:47:30 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] ath5k: fix scanning in AR2424
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Date: Fri, 27 Mar 2009 17:47:27 -0400
Message-ID: <20090327214727.28989.90735.stgit@mj.roinet.com> (sfid-20090327_224735_296662_063238E6)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR5K_PHY_PLL_40MHZ_5413 should not be ORed with AR5K_PHY_MODE_RAD_RF5112
for 5 GHz channels.

The incorrect PLL value breaks scanning in the countries where 5 GHz
channels are allowed.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/ath5k/reset.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
index 7a17d31..faede82 100644
--- a/drivers/net/wireless/ath5k/reset.c
+++ b/drivers/net/wireless/ath5k/reset.c
@@ -359,7 +359,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 			mode |= AR5K_PHY_MODE_FREQ_5GHZ;
 
 			if (ah->ah_radio == AR5K_RF5413)
-				clock |= AR5K_PHY_PLL_40MHZ_5413;
+				clock = AR5K_PHY_PLL_40MHZ_5413;
 			else
 				clock |= AR5K_PHY_PLL_40MHZ;
 
