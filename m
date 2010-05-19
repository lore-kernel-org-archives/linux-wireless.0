Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:49573 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756716Ab0ESBd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:33:27 -0400
Received: from vs3010.wh2.ocn.ne.jp (125.206.180.173)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0543322805
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:33:25 +0900 (JST)
Subject: [PATCH v2 18/20] ath5k: update AR5K_PHY_RESTART_DIV_GC values to
	match masks
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:32:14 +0900
Message-ID: <20100519013214.22206.43556.stgit@tt-desk>
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
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
index d9506e7..2136930 100644
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

