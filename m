Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45279 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbZEYTfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 15:35:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: avoid leaking mutex in ath5k_config
Date: Mon, 25 May 2009 21:34:10 +0200
Message-Id: <1243280050-3755-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
I lost track of the related bug report -- Johannes, do you recall?

 drivers/net/wireless/ath/ath5k/base.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index fb51937..dd6dc8d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2779,7 +2779,7 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 
 	ret = ath5k_chan_set(sc, conf->channel);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 
 	if ((changed & IEEE80211_CONF_CHANGE_POWER) &&
 	(sc->power_level != conf->power_level)) {
@@ -2808,8 +2808,9 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 	 */
 	ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
 
+unlock:
 	mutex_unlock(&sc->lock);
-	return 0;
+	return ret;
 }
 
 #define SUPPORTED_FIF_FLAGS \
-- 
1.6.0.6

