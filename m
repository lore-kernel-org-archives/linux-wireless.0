Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56769 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab0JCRH0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Oct 2010 13:07:26 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 4/4] ath9k_hw: fix regression in ANI listen time calculation
Date: Sun,  3 Oct 2010 19:07:19 +0200
Message-Id: <1286125639-15137-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286125639-15137-3-git-send-email-nbd@openwrt.org>
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org>
 <1286125639-15137-2-git-send-email-nbd@openwrt.org>
 <1286125639-15137-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  wireless-testing
  commit 37e5bf6535a4d697fb9fa6f268a8354a612cbc00
  Author: Luis R. Rodriguez <lrodriguez@atheros.com>
  Date:   Sat Jun 12 00:33:40 2010 -0400

    ath9k_hw: fix clock rate calculations for ANI

This commit accidentally broke clock rate calculation by doubling the
calculated clock rate

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 61e7a48..a1894d2 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -542,7 +542,7 @@ static u8 ath9k_hw_chan_2_clockrate_mhz(struct ath_hw *ah)
 	if (conf_is_ht40(conf))
 		return clockrate * 2;
 
-	return clockrate * 2;
+	return clockrate;
 }
 
 static int32_t ath9k_hw_ani_get_listen_time(struct ath_hw *ah)
-- 
1.7.2.2

