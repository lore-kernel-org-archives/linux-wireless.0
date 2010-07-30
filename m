Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53907 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab0G3C4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 22:56:23 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: add fastcc to debug print for channel change
Date: Thu, 29 Jul 2010 22:56:22 -0400
Message-Id: <1280458582-5435-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helps us debug channel changes better.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0429dda..5999a61 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -195,9 +195,10 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		fastcc = false;
 
 	ath_print(common, ATH_DBG_CONFIG,
-		  "(%u MHz) -> (%u MHz), conf_is_ht40: %d\n",
+		  "(%u MHz) -> (%u MHz), conf_is_ht40: %d fastcc: %d\n",
 		  sc->sc_ah->curchan->channel,
-		  channel->center_freq, conf_is_ht40(conf));
+		  channel->center_freq, conf_is_ht40(conf),
+		  fastcc);
 
 	spin_lock_bh(&sc->sc_resetlock);
 
-- 
1.7.0.4

