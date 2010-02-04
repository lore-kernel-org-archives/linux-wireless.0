Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:52852 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab0BDVxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 16:53:48 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] ath9k: Fix rate table choice
Date: Thu,  4 Feb 2010 22:06:06 +0100
Message-Id: <1265317566-15372-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k rate control choose the rate table based on the current channel
(if it is ht40 or not). However, it happens that at this stage, the
channel is still ht20 even if the peer sta capabilities would later
allow ht40. So let's use peer sta capabilities directly.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/ath/ath9k/rc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 1196884..5ce9da5 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1341,10 +1341,8 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 		if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
 			return;
 
-		if (sc->hw->conf.channel_type == NL80211_CHAN_HT40MINUS ||
-		    sc->hw->conf.channel_type == NL80211_CHAN_HT40PLUS)
-			oper_cw40 = true;
-
+		oper_cw40 = (sta->ht_cap.cap &
+			     IEEE80211_HT_CAP_SUP_WIDTH_20_40) ? true : false;
 		oper_sgi40 = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
 			true : false;
 
-- 
1.6.3.3

