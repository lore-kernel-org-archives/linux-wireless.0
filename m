Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53484 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbYJWGrw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 02:47:52 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 23:47:52 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18688.7551.438939.184353@gargle.gargle.HOWL> (sfid-20081023_084755_781925_0AE54DDD)
Date: Thu, 23 Oct 2008 12:15:19 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>, <Vasanth.Thiagarajan@Atheros.com>
Subject: [PATCH] ath9k: Check if the STA supports HT when initializing rate control
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index f1dbae3..c7800e0 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -2027,7 +2027,7 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
 
 	ath_setup_rates(sc, sband, sta, ath_rc_priv);
-	if (sc->hw->conf.ht.enabled) {
+	if (sta->ht_cap.ht_supported) {
 		for (i = 0; i < 77; i++) {
 			if (sta->ht_cap.mcs.rx_mask[i/8] & (1<<(i%8)))
 				ath_rc_priv->neg_ht_rates.rs_rates[j++] = i;
-- 
1.6.0.2

