Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59038 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZDNBls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 21:41:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, chunkeey@web.de,
	me@bobcopeland.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	stable@kernel.org
Subject: [PATCH] atheros: fix propagation of bad EEPROM on regulatory init
Date: Mon, 13 Apr 2009 21:41:46 -0400
Message-Id: <1239673306-13954-1-git-send-email-lrodriguez@atheros.com> (sfid-20090414_034151_807141_2F4ACE5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the EEPROM is not in good condition we cannot continue so
we currently bail out but only ath5k is bailing out properly.
Both ath9k and ar9170 were proceeding and if a user were to run
into this they'd see an obscure panic. Lets propagate the error
as intended and make sure we inform the user by lifting the
error message from debug to a kernel error.

Stable note: You can find a port of this page here:

http://bombadil.infradead.org/~mcgrof/patches/ath9k/ath9k-fix-eeprom.patch.txt

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ar9170/main.c |    2 ++
 drivers/net/wireless/ath/ath9k/main.c  |    5 +++--
 drivers/net/wireless/ath/regd.c        |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index d40cfae..767a981 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1648,6 +1648,8 @@ int ar9170_register(struct ar9170 *ar, struct device *pdev)
 
 	err = ath_regd_init(&ar->regulatory, ar->hw->wiphy,
 			    ar9170_reg_notifier);
+	if (err)
+		goto err_out;
 
 	err = ieee80211_register_hw(ar->hw);
 	if (err)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9a196c1..d72768a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1418,8 +1418,9 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	for (i = 0; i < sc->keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
 
-	if (ath_regd_init(&sc->sc_ah->regulatory, sc->hw->wiphy,
-			  ath9k_reg_notifier))
+	error = ath_regd_init(&sc->sc_ah->regulatory, sc->hw->wiphy,
+			      ath9k_reg_notifier);
+	if (error)
 		goto bad;
 
 	/* default to MONITOR mode */
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index a90c7cf..458c629 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -479,7 +479,7 @@ ath_regd_init(struct ath_regulatory *reg,
 	u16 regdmn;
 
 	if (!ath_regd_is_eeprom_valid(reg)) {
-		printk(KERN_DEBUG "ath: Invalid EEPROM contents\n");
+		printk(KERN_ERR "ath: Invalid EEPROM contents\n");
 		return -EINVAL;
 	}
 
-- 
1.6.0.6

