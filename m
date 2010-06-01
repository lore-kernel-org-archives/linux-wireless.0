Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41926 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab0FAJp4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 05:45:56 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 02:45:56 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.54894.49729.663288@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:14:14 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/13] ath9k_htc: Fix bug in handling CONF_IDLE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable the radio only when mac80211 indicates it,
through the IEEE80211_CONF_CHANGE_IDLE flag.
Not handling this properly will result in multiple
calls to radio_disable() even though the radio is
already idle.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index d6c1f2f..bdd76cd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1453,7 +1453,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if (priv->ps_idle) {
+	if ((changed & IEEE80211_CONF_CHANGE_IDLE) && priv->ps_idle) {
 		ath_print(common, ATH_DBG_CONFIG,
 			  "idle: disabling radio\n");
 		ath9k_htc_radio_disable(hw);
-- 
1.7.1

