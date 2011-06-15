Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15926 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab1FOWD3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 18:03:29 -0400
Subject: [PATCH 2/2] ath5k: annotate reg in ath5k_hw_nic_reset() as __iomem
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 15 Jun 2011 18:03:28 -0400
Message-ID: <20110615220328.1942.9381.stgit@mj.roinet.com> (sfid-20110616_000331_715447_F07B99AE)
In-Reply-To: <20110615220322.1942.81252.stgit@mj.roinet.com>
References: <20110615220322.1942.81252.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/reset.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 126a4ea..1676a3e 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -375,19 +375,19 @@ static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
 static int ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
 {
 	u32 mask = flags ? flags : ~0U;
-	volatile u32 *reg;
+	volatile __iomem u32 *reg;
 	u32 regval;
 	u32 val = 0;
 
 	/* ah->ah_mac_srev is not available at this point yet */
 	if (ah->ah_sc->devid >= AR5K_SREV_AR2315_R6) {
-		reg = (u32 *) AR5K_AR2315_RESET;
+		reg = (u32 __iomem *) AR5K_AR2315_RESET;
 		if (mask & AR5K_RESET_CTL_PCU)
 			val |= AR5K_AR2315_RESET_WMAC;
 		if (mask & AR5K_RESET_CTL_BASEBAND)
 			val |= AR5K_AR2315_RESET_BB_WARM;
 	} else {
-		reg = (u32 *) AR5K_AR5312_RESET;
+		reg = (u32 __iomem *) AR5K_AR5312_RESET;
 		if (to_platform_device(ah->ah_sc->dev)->id == 0) {
 			if (mask & AR5K_RESET_CTL_PCU)
 				val |= AR5K_AR5312_RESET_WMAC0;
