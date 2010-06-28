Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:49133 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752919Ab0F1CDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jun 2010 22:03:44 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-088174619
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jun 2010 11:03:43 +0900 (JST)
Subject: [PATCH] ath5k: fix antenna div gc for <= AR5K_SREV_PHY_2413
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 28 Jun 2010 11:01:48 +0900
Message-ID: <20100628020148.4120.24790.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 39d5b2c83ca8904b6826a0713263a4e5a9c0730a "ath5k: update
AR5K_PHY_RESTART_DIV_GC values to match masks" i introduced a regression on PHY
chips older than AR5K_SREV_PHY_5413, which caused signal values to be about
10dB less that before. This patch reverts the AR5K_PHY_RESTART_DIV_GC values to
the same values which were effectively used before (without the bitmask
mistake). This brings signal levels back to normal on these PHY chips.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/phy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 73c4fcd..6284c38 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1768,7 +1768,7 @@ ath5k_hw_set_fast_div(struct ath5k_hw *ah, u8 ee_mode, bool enable)
 
 	if (enable) {
 		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_RESTART,
-				AR5K_PHY_RESTART_DIV_GC, 1);
+				AR5K_PHY_RESTART_DIV_GC, 4);
 
 		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_FAST_ANT_DIV,
 					AR5K_PHY_FAST_ANT_DIV_EN);

