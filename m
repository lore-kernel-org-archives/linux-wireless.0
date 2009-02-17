Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39996 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZBQKKT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 05:10:19 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 02:10:19 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18842.35879.358339.530725@gargle.gargle.HOWL> (sfid-20090217_111028_907053_9EE68C7A)
Date: Tue, 17 Feb 2009 15:36:31 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/4] ath9k: Remove a few unused capability macros
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   26 --------------------------
 drivers/net/wireless/ath9k/hw.h |    7 -------
 2 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index eeee5b8..2c0173a 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -3357,8 +3357,6 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result)
 {
-	const struct ath9k_hw_capabilities *pCap = &ah->caps;
-
 	switch (type) {
 	case ATH9K_CAP_CIPHER:
 		switch (capability) {
@@ -3384,16 +3382,10 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 	case ATH9K_CAP_TKIP_SPLIT:
 		return (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) ?
 			false : true;
-	case ATH9K_CAP_WME_TKIPMIC:
-		return 0;
-	case ATH9K_CAP_PHYCOUNTERS:
-		return ah->has_hw_phycounters ? 0 : -ENXIO;
 	case ATH9K_CAP_DIVERSITY:
 		return (REG_READ(ah, AR_PHY_CCK_DETECT) &
 			AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV) ?
 			true : false;
-	case ATH9K_CAP_PHYDIAG:
-		return true;
 	case ATH9K_CAP_MCAST_KEYSRCH:
 		switch (capability) {
 		case 0:
@@ -3408,18 +3400,6 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			}
 		}
 		return false;
-	case ATH9K_CAP_TSF_ADJUST:
-		return (ah->misc_mode & AR_PCU_TX_ADD_TSF) ?
-			true : false;
-	case ATH9K_CAP_RFSILENT:
-		if (capability == 3)
-			return false;
-	case ATH9K_CAP_ANT_CFG_2GHZ:
-		*result = pCap->num_antcfg_2ghz;
-		return true;
-	case ATH9K_CAP_ANT_CFG_5GHZ:
-		*result = pCap->num_antcfg_5ghz;
-		return true;
 	case ATH9K_CAP_TXPOW:
 		switch (capability) {
 		case 0:
@@ -3472,12 +3452,6 @@ bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 		else
 			ah->sta_id1_defaults &= ~AR_STA_ID1_MCAST_KSRCH;
 		return true;
-	case ATH9K_CAP_TSF_ADJUST:
-		if (setting)
-			ah->misc_mode |= AR_PCU_TX_ADD_TSF;
-		else
-			ah->misc_mode &= ~AR_PCU_TX_ADD_TSF;
-		return true;
 	default:
 		return false;
 	}
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index ddab3b7..5ec416b 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -153,16 +153,9 @@ enum ath9k_capability_type {
 	ATH9K_CAP_CIPHER = 0,
 	ATH9K_CAP_TKIP_MIC,
 	ATH9K_CAP_TKIP_SPLIT,
-	ATH9K_CAP_PHYCOUNTERS,
 	ATH9K_CAP_DIVERSITY,
 	ATH9K_CAP_TXPOW,
-	ATH9K_CAP_PHYDIAG,
 	ATH9K_CAP_MCAST_KEYSRCH,
-	ATH9K_CAP_TSF_ADJUST,
-	ATH9K_CAP_WME_TKIPMIC,
-	ATH9K_CAP_RFSILENT,
-	ATH9K_CAP_ANT_CFG_2GHZ,
-	ATH9K_CAP_ANT_CFG_5GHZ,
 	ATH9K_CAP_DS
 };
 
-- 
1.6.1

