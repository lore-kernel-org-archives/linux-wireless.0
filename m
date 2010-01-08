Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57912 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0AHEtO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 23:49:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 20:49:14 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19270.48453.813374.27261@gargle.gargle.HOWL>
Date: Fri, 8 Jan 2010 10:36:13 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/7] ath9k: Fix monitor mode handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 passes appropriate flags indicating whether
monitor mode is being used. Use this to set the HW opmode.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1f7222a..b39c7bc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1581,6 +1581,14 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		if (conf->flags & IEEE80211_CONF_MONITOR) {
+			ath_print(common, ATH_DBG_CONFIG,
+				  "HW opmode set to Monitor mode\n");
+			sc->sc_ah->opmode = NL80211_IFTYPE_MONITOR;
+		}
+	}
+
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
-- 
1.6.6

