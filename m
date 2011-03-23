Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:52366 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118Ab1CWNrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 09:47:18 -0400
Date: Wed, 23 Mar 2011 14:52:19 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Support RSN IBSS
Message-ID: <20110323125219.GA26467@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for using RSN IBSS with ath9k. For now, this uses software
crypto for group addressed frames in RSN IBSS, but that may be
optimized in the future by extending the key cache design to support
per-STA RX GTK.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/init.c |    2 ++
 drivers/net/wireless/ath/ath9k/main.c |   14 ++++++++++++++
 2 files changed, 16 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/init.c	2011-03-23 14:14:12.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/init.c	2011-03-23 14:15:04.000000000 +0200
@@ -690,6 +690,8 @@ void ath9k_set_hw_capab(struct ath_softc
 	if (AR_SREV_5416(sc->sc_ah))
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
+	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+
 	hw->queues = 4;
 	hw->max_rates = 4;
 	hw->channel_change_time = 5000;
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2011-03-23 14:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2011-03-23 14:15:04.000000000 +0200
@@ -1845,6 +1845,20 @@ static int ath9k_set_key(struct ieee8021
 	if (ath9k_modparam_nohwcrypt)
 		return -ENOSPC;
 
+	if (vif->type == NL80211_IFTYPE_ADHOC &&
+	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
+	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		/*
+		 * For now, disable hw crypto for the RSN IBSS group keys. This
+		 * could be optimized in the future to use a modified key cache
+		 * design to support per-STA RX GTK, but until that gets
+		 * implemented, use of software crypto for group addressed
+		 * frames is a acceptable to allow RSN IBSS to be used.
+		 */
+		return -EOPNOTSUPP;
+	}
+
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
 	ath_dbg(common, ATH_DBG_CONFIG, "Set HW Key\n");

-- 
Jouni Malinen                                            PGP id EFC895FA
