Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:47387 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab3GaIzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 04:55:25 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/5] ath10k: advertise more conservative intf combinations
Date: Wed, 31 Jul 2013 10:55:13 +0200
Message-ID: <1375260915-22500-4-git-send-email-michal.kazior@tieto.com> (sfid-20130731_105534_782757_C475B769)
In-Reply-To: <1375260915-22500-1-git-send-email-michal.kazior@tieto.com>
References: <1375260915-22500-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently the available firmware has a limit of
handling 7 APs, 3 GOs or 8 STAs. This is based on
empirical tests and it is still possible some
combinations may crash the firmware.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1ea386e..6a130c5 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3078,9 +3078,15 @@ static const struct ieee80211_iface_limit ath10k_if_limits[] = {
 	.max	= 8,
 	.types	= BIT(NL80211_IFTYPE_STATION)
 		| BIT(NL80211_IFTYPE_P2P_CLIENT)
-		| BIT(NL80211_IFTYPE_P2P_GO)
-		| BIT(NL80211_IFTYPE_AP)
-	}
+	},
+	{
+	.max	= 3,
+	.types	= BIT(NL80211_IFTYPE_P2P_GO)
+	},
+	{
+	.max	= 7,
+	.types	= BIT(NL80211_IFTYPE_AP)
+	},
 };
 
 static const struct ieee80211_iface_combination ath10k_if_comb = {
-- 
1.7.9.5

