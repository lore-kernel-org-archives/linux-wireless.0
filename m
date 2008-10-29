Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3360 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYJ2MbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 08:31:14 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, mickflemm@gmail.com, jirislaby@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: enable hardware encryption for WEP
Date: Wed, 29 Oct 2008 08:30:54 -0400
Message-Id: <1225283457-24417-2-git-send-email-me@bobcopeland.com> (sfid-20081029_133120_271224_3086CD95)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change re-enables hardware encryption for ath5k after setting up
mac80211 to handle the initialization vectors which happens to make it
work.  Add a module param (nohwcrypt) to optionally turn it off.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 6f368e8..4bf3678 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -60,6 +60,9 @@
 #include "debug.h"
 
 static int ath5k_calinterval = 10; /* Calibrate PHY every 10 secs (TODO: Fixme) */
+static int modparam_nohwcrypt;
+module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 
 /******************\
@@ -2975,11 +2978,12 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	struct ath5k_softc *sc = hw->priv;
 	int ret = 0;
 
+	if (modparam_nohwcrypt)
+		return -EOPNOTSUPP;
+
 	switch (key->alg) {
 	case ALG_WEP:
-	/* XXX: fix hardware encryption, its not working. For now
-	 * allow software encryption */
-		/* break; */
+		break;
 	case ALG_TKIP:
 	case ALG_CCMP:
 		return -EOPNOTSUPP;
@@ -2999,6 +3003,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		}
 		__set_bit(key->keyidx, sc->keymap);
 		key->hw_key_idx = key->keyidx;
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		break;
 	case DISABLE_KEY:
 		ath5k_hw_reset_key(sc->ah, key->keyidx);
-- 
1.5.4.2.182.gb3092


