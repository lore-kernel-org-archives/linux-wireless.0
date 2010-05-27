Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934418Ab0E0SPp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 14:15:45 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4RIFiMm027195
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 14:15:44 -0400
Date: Thu, 27 May 2010 14:15:42 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100527181139.23917.56655.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: ath: Fix uninitialized variable warnings
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes 'make -j24 CONFIG_DEBUG_SECTION_MISMATCH=y' warning:

drivers/net/wireless/ath/ath9k/eeprom_4k.c: In function ‘ath9k_hw_get_4k_gain_boundaries_pdadcs.clone.1’:
drivers/net/wireless/ath/ath9k/eeprom_4k.c:311: error: ‘minPwrT4’ may be used uninitialized in this function
drivers/net/wireless/ath/ath9k/eeprom_9287.c: In function ‘ath9k_hw_get_AR9287_gain_boundaries_pdadcs’:
drivers/net/wireless/ath/ath9k/eeprom_9287.c:302: error: ‘minPwrT4’ may be used uninitialized in this function
drivers/net/wireless/ath/ath9k/eeprom_def.c: In function ‘ath9k_hw_get_def_gain_boundaries_pdadcs.clone.0’:
drivers/net/wireless/ath/ath9k/eeprom_def.c:679: error: ‘minPwrT4’ may be used uninitialized in this function

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 41a77d1..e25a2ab 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -249,6 +249,7 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 	struct chan_centers centers;
 #define PD_GAIN_BOUNDARY_DEFAULT 58;
 
+	memset(&minPwrT4, 0, AR9287_NUM_PD_GAINS);
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	for (numPiers = 0; numPiers < availPiers; numPiers++) {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index b471db5..9b0478d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -245,6 +245,7 @@ static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 	static u8 vpdTableI[AR5416_EEP4K_NUM_PD_GAINS]
 		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
 
+	memset(&minPwrT4, 0, AR9287_NUM_PD_GAINS);
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	for (numPiers = 0; numPiers < availPiers; numPiers++) {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index e591ad6..9019b6e 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -618,6 +618,7 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 	int16_t minDelta = 0;
 	struct chan_centers centers;
 
+	memset(&minPwrT4, 0, AR9287_NUM_PD_GAINS);
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	for (numPiers = 0; numPiers < availPiers; numPiers++) {
