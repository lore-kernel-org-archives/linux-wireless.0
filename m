Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18462 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZAGI6o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 03:58:44 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 00:58:44 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18788.28161.172196.813321@gargle.gargle.HOWL> (sfid-20090107_095848_905261_3F505AC8)
Date: Wed, 7 Jan 2009 14:25:29 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Fix chainmask handling bug
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chainmasks have to be updated before setting the channel,
since the HW reset routine uses them to set the appropriate registers.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index f590fce..416b2ac 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2144,13 +2144,13 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 						    conf->ht.channel_type);
 		}
 
+		ath_update_chainmask(sc, conf_is_ht(conf));
+
 		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0) {
 			DPRINTF(sc, ATH_DBG_FATAL, "Unable to set channel\n");
 			mutex_unlock(&sc->mutex);
 			return -EINVAL;
 		}
-
-		ath_update_chainmask(sc, conf_is_ht(conf));
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
-- 
1.6.0.3

