Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50668 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbaBYNt7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 08:49:59 -0500
Received: from ultralex.lan ([93.218.100.117]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0LwF9u-1XJTVi1soI-0181SY for
 <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 14:49:58 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 7/7] ath9k_htc: use ath9k_cmn_reload_chainmask
Date: Tue, 25 Feb 2014 14:48:56 +0100
Message-Id: <1393336136-31069-8-git-send-email-linux@rempel-privat.de> (sfid-20140225_145002_198165_479B7A29)
In-Reply-To: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
References: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 5220f46..a8f30dc 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -616,14 +616,7 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&common->sbands[IEEE80211_BAND_5GHZ];
 
-	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
-		if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
-			ath9k_cmn_setup_ht_cap(ah,
-				     &common->sbands[IEEE80211_BAND_2GHZ].ht_cap);
-		if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
-			ath9k_cmn_setup_ht_cap(ah,
-				     &common->sbands[IEEE80211_BAND_5GHZ].ht_cap);
-	}
+	ath9k_cmn_reload_chainmask(ah);
 
 	pBase = ath9k_htc_get_eeprom_base(priv);
 	if (pBase) {
-- 
1.9.0

