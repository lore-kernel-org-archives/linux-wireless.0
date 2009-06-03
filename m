Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:60726 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZFCSYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:24:51 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ar9170: remove deprecated code
Date: Wed, 3 Jun 2009 22:24:48 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200906032224.48483.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes code (deprecated by "cfg80211: add rfkill support" )

main.c: In function 'ar9170_op_config':
main.c:1306: warning: '__IEEE80211_CONF_CHANGE_RADIO_ENABLED' 
is deprecated (declared at include/net/mac80211.h:551)

and a useless device state.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 4c4b08f..c7cba66 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -102,7 +102,6 @@ enum ar9170_device_state {
 	AR9170_STOPPED,
 	AR9170_IDLE,
 	AR9170_STARTED,
-	AR9170_ASSOCIATED,
 };
 
 struct ar9170_rxstream_mpdu_merge {
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index b889fda..b104d7e 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1303,11 +1303,6 @@ static int ar9170_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&ar->mutex);
 
-	if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED) {
-		/* TODO */
-		err = 0;
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
 		/* TODO */
 		err = 0;
@@ -1490,8 +1485,6 @@ static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		ar->state = bss_conf->assoc ? AR9170_ASSOCIATED : ar->state;
-
 #ifndef CONFIG_AR9170_LEDS
 		/* enable assoc LED. */
 		err = ar9170_set_leds_state(ar, bss_conf->assoc ? 2 : 0);
