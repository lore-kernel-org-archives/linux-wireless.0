Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:25437 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753164Ab0IQCgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 22:36:04 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-028923962
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 11:36:03 +0900 (JST)
Subject: [PATCH 01/11] ath/ath5k/ath9k: Fix crypto capabilities merge issue
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Fri, 17 Sep 2010 11:36:25 +0900
Message-ID: <20100917023625.24997.72252.stgit@tt-desk>
In-Reply-To: <20100917023543.24997.48466.stgit@tt-desk>
References: <20100917023543.24997.48466.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing up a merge issue / concurrent development:

Remove unneeded ath_crypt_caps flags, as per "ath9k_hw: remove useless hw
capability flags" (364734fafbba0c3133e482db78149b9a823ae7a5), but set the
AESCCM flag for ath9k. common ath code still needs a flag for this because
there is ath5k hardware which can't do AES in hardware.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath.h          |    9 ++-------
 drivers/net/wireless/ath/ath5k/attach.c |    3 +--
 drivers/net/wireless/ath/ath9k/hw.c     |    2 ++
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index c558407..dd236c3 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -72,13 +72,8 @@ struct ath_regulatory {
 };
 
 enum ath_crypt_caps {
-	ATH_CRYPT_CAP_MIC_AESCCM		= BIT(0),
-	ATH_CRYPT_CAP_MIC_CKIP			= BIT(1),
-	ATH_CRYPT_CAP_MIC_TKIP			= BIT(2),
-	ATH_CRYPT_CAP_CIPHER_AESCCM		= BIT(3),
-	ATH_CRYPT_CAP_CIPHER_CKIP		= BIT(4),
-	ATH_CRYPT_CAP_CIPHER_TKIP		= BIT(5),
-	ATH_CRYPT_CAP_MIC_COMBINED		= BIT(6),
+	ATH_CRYPT_CAP_CIPHER_AESCCM		= BIT(0),
+	ATH_CRYPT_CAP_MIC_COMBINED		= BIT(1),
 };
 
 struct ath_keyval {
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index a0e0820..20d178e 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -320,8 +320,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	if (srev >= AR5K_SREV_AR5212_V4 &&
 	    (ee->ee_version >= AR5K_EEPROM_VERSION_5_0 &&
 	    !AR5K_EEPROM_AES_DIS(ee->ee_misc5)))
-		common->crypt_caps |= ATH_CRYPT_CAP_CIPHER_AESCCM |
-					ATH_CRYPT_CAP_MIC_AESCCM;
+		common->crypt_caps |= ATH_CRYPT_CAP_CIPHER_AESCCM;
 
 	if (srev >= AR5K_SREV_AR2414) {
 		common->crypt_caps |= ATH_CRYPT_CAP_MIC_COMBINED;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f3c9d75..0b2ff98 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1866,6 +1866,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	pCap->low_5ghz_chan = 4920;
 	pCap->high_5ghz_chan = 6100;
 
+	common->crypt_caps |= ATH_CRYPT_CAP_CIPHER_AESCCM;
+
 	if (ah->config.ht_enable)
 		pCap->hw_caps |= ATH9K_HW_CAP_HT;
 	else

