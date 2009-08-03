Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34791 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbZHCTZF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:05 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 07/24] ath9k: call hw initializer directly
Date: Mon, 3 Aug 2009 12:24:39 -0700
Message-ID: <1249327496-24629-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_attach() was going first through some device id verifier,
and then calling some other helper which was doing the real hardware
initialization. Lets just do the devid checks within the real worker
by calling a helper ath9k_hw_devid_supported().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   48 +++++++++++++++++++----------------
 1 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ff2875b..d8ae289 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -608,12 +608,35 @@ static int ath9k_hw_post_attach(struct ath_hw *ah)
 	return 0;
 }
 
-static int ath9k_hw_do_attach(struct ath_hw *ah,
-			      struct ath_softc *sc)
+static bool ath9k_hw_devid_supported(u16 devid)
+{
+	switch (devid) {
+	case AR5416_DEVID_PCI:
+	case AR5416_DEVID_PCIE:
+	case AR5416_AR9100_DEVID:
+	case AR9160_DEVID_PCI:
+	case AR9280_DEVID_PCI:
+	case AR9280_DEVID_PCIE:
+	case AR9285_DEVID_PCIE:
+	case AR5416_DEVID_AR9287_PCI:
+	case AR5416_DEVID_AR9287_PCIE:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+int ath9k_hw_attach(struct ath_hw *ah, struct ath_softc *sc)
 {
 	int r;
 	u32 i, j;
 
+	if (!ath9k_hw_devid_supported(ah->hw_version.devid)) {
+		r = -EOPNOTSUPP;
+		goto bad;
+	}
+
 	ath9k_hw_newstate(ah);
 	ath9k_hw_set_defaults(ah);
 
@@ -1183,25 +1206,6 @@ void ath9k_hw_detach(struct ath_hw *ah)
 	kfree(ah);
 }
 
-int ath9k_hw_attach(struct ath_hw *ah, struct ath_softc *sc)
-{
-	switch (ah->hw_version.devid) {
-	case AR5416_DEVID_PCI:
-	case AR5416_DEVID_PCIE:
-	case AR5416_AR9100_DEVID:
-	case AR9160_DEVID_PCI:
-	case AR9280_DEVID_PCI:
-	case AR9280_DEVID_PCIE:
-	case AR9285_DEVID_PCIE:
-	case AR5416_DEVID_AR9287_PCI:
-	case AR5416_DEVID_AR9287_PCIE:
-		return ath9k_hw_do_attach(ah, sc);
-	default:
-		break;
-	}
-	return -EOPNOTSUPP;
-}
-
 /*******/
 /* INI */
 /*******/
@@ -2898,7 +2902,7 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 		/*
 		 * AR9280 2.0 or later chips use SerDes values from the
 		 * initvals.h initialized depending on chipset during
-		 * ath9k_hw_do_attach()
+		 * ath9k_hw_attach()
 		 */
 		for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
 			REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
-- 
1.6.3.3

