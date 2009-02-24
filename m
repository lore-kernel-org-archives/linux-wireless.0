Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52527 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087AbZBXLmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 06:42:08 -0500
Date: Tue, 24 Feb 2009 13:42:01 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Add module parameter to disable hardware crypto
Message-ID: <20090224114201.GB21933@jm.kir.nu> (sfid-20090224_124211_250628_44CBCB11)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nohwcrypt=1 module parameter can now be used to disable hardware
crypto in ath9k. While the hardware acceleration handles most cases,
it may be useful to be able to force mac80211 software implementation
to be used for some tests, e.g., with virtual interface combinations
that may not yet be supported in the key cache configuration. In
addition, this allows management frame protection to be tested with
older hardware revisions.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/main.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-02-24 13:34:44.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-02-24 13:35:01.000000000 +0200
@@ -26,6 +26,10 @@ MODULE_DESCRIPTION("Support for Atheros 
 MODULE_SUPPORTED_DEVICE("Atheros 802.11n WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
+static int modparam_nohwcrypt;
+module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
+
 /* We use the hw_value as an index into our private channel structure */
 
 #define CHAN2G(_freq, _idx)  { \
@@ -1587,7 +1591,7 @@ int ath_attach(u16 devid, struct ath_sof
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK;
 
-	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah))
+	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || modparam_nohwcrypt)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
 	hw->wiphy->interface_modes =
@@ -2468,6 +2472,9 @@ static int ath9k_set_key(struct ieee8021
 	struct ath_softc *sc = hw->priv;
 	int ret = 0;
 
+	if (modparam_nohwcrypt)
+		return -ENOSPC;
+
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
 	DPRINTF(sc, ATH_DBG_KEYCACHE, "Set HW Key\n");

-- 
Jouni Malinen                                            PGP id EFC895FA
