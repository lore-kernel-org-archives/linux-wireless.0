Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:11912 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751320Ab0FGELO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 00:11:14 -0400
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0273843873
	for <linux-wireless@vger.kernel.org>; Mon,  7 Jun 2010 13:11:13 +0900 (JST)
Subject: [PATCH 2/5] ath5k: update AR5K_PHY_RESTART_DIV_GC values to match
	masks
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 07 Jun 2010 13:11:25 +0900
Message-ID: <20100607041125.18667.65985.stgit@tt-desk>
In-Reply-To: <20100607041012.18667.6859.stgit@tt-desk>
References: <20100607041012.18667.6859.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

#define AR5K_PHY_RESTART_DIV_GC               0x001c0000
is 3 bit wide.

The previous values of 0xc and 0x8 are 4bit wide and bigger than the mask.

Writing 0 and 1 to AR5K_PHY_RESTART_DIV_GC is consistent with the comments and
initvals we have in the HAL.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/phy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 34ba576..0f3b9be 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1768,13 +1768,13 @@ ath5k_hw_set_fast_div(struct ath5k_hw *ah, u8 ee_mode, bool enable)
 
 	if (enable) {
 		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_RESTART,
-				AR5K_PHY_RESTART_DIV_GC, 0xc);
+				AR5K_PHY_RESTART_DIV_GC, 1);
 
 		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_FAST_ANT_DIV,
 					AR5K_PHY_FAST_ANT_DIV_EN);
 	} else {
 		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_RESTART,
-				AR5K_PHY_RESTART_DIV_GC, 0x8);
+				AR5K_PHY_RESTART_DIV_GC, 0);
 
 		AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_FAST_ANT_DIV,
 					AR5K_PHY_FAST_ANT_DIV_EN);

