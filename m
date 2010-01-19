Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48905 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab0ASTET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 14:04:19 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: make tx power config changes take effect immediatley
Date: Tue, 19 Jan 2010 14:04:19 -0500
Message-Id: <1263927859-9252-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Users wishing to tweak tx power want it to happen immediately,
try to respect that. This was tested by Lorenzo by measuring the
received signal strength from an AP with ath9k and the patch.

Changing the tx power on the AP produced these results:

1) iwconfig wlan0 txpower 20 ---> Rx power -37dbm
2) iwconfig wlan0 txpower 15 ---> Rx power -41dbm
3) iwconfig wlan0 txpower 10 ---> Rx power -45dbm
4) iwconfig wlan0 txpower 5 ---> Rx power -51dbm
5) iwconfig wlan0 txpower 0 ---> Rx power -37dbm

The result with 0 is an anomoly and would need to be
addressed through a separate patch.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Tested-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c0c571c..6f3e71c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1624,8 +1624,10 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 skip_chan_change:
-	if (changed & IEEE80211_CONF_CHANGE_POWER)
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		sc->config.txpowlimit = 2 * conf->power_level;
+		ath_update_txpow(sc);
+	}
 
 	spin_lock_bh(&sc->wiphy_lock);
 	disable_radio = ath9k_all_wiphys_idle(sc);
-- 
1.6.3.3

