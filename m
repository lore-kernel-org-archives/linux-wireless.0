Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25179 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758092AbZC3KCp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:45 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:44 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38852.877562.282540@gargle.gargle.HOWL> (sfid-20090330_120247_910201_31BFF9FF)
Date: Mon, 30 Mar 2009 15:28:28 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 04/17] ath9k: Change return value of ath9k_hw_fill_cap_info
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This routine always return true, checking for false
in the return value is invalid. Fix this.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   10 ++--------
 drivers/net/wireless/ath9k/hw.h |    2 +-
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 169d8ef..4ad1508 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -837,11 +837,7 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	if (AR_SREV_9280_20(ah))
 		ath9k_hw_init_txgain_ini(ah);
 
-	if (!ath9k_hw_fill_cap_info(ah)) {
-		DPRINTF(sc, ATH_DBG_RESET, "failed ath9k_hw_fill_cap_info\n");
-		ecode = -EINVAL;
-		goto bad;
-	}
+	ath9k_hw_fill_cap_info(ah);
 
 	if ((ah->hw_version.devid == AR9280_DEVID_PCI) &&
 	    test_bit(ATH9K_MODE_11A, ah->caps.wireless_modes)) {
@@ -3228,7 +3224,7 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 /* HW Capabilities */
 /*******************/
 
-bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
+void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	u16 capField = 0, eeval;
@@ -3403,8 +3399,6 @@ bool ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		ah->btactive_gpio = 6;
 		ah->wlanactive_gpio = 5;
 	}
-
-	return true;
 }
 
 bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 5ba6a4b..c50faae 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -557,7 +557,7 @@ struct ath_hw *ath9k_hw_attach(u16 devid, struct ath_softc *sc, int *error);
 void ath9k_hw_rfdetach(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   bool bChannelChange);
-bool ath9k_hw_fill_cap_info(struct ath_hw *ah);
+void ath9k_hw_fill_cap_info(struct ath_hw *ah);
 bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result);
 bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
-- 
1.6.2.1

