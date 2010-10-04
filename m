Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35391 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab0JDSJz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:09:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/5] ath9k_hw: add a helper function to check for the new ANI implementation
Date: Mon,  4 Oct 2010 20:09:46 +0200
Message-Id: <1286215790-67069-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index a1894d2..9856a1b 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -109,6 +109,11 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hw *ah)
 	ath9k_hw_private_ops(ah)->ani_lower_immunity(ah);
 }
 
+static bool use_new_ani(struct ath_hw *ah)
+{
+	return AR_SREV_9300_20_OR_LATER(ah) || modparam_force_new_ani;
+}
+
 int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 				 struct ath9k_channel *chan)
 {
@@ -1178,7 +1183,7 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 
 	memset(ah->ani, 0, sizeof(ah->ani));
 	for (i = 0; i < ARRAY_SIZE(ah->ani); i++) {
-		if (AR_SREV_9300_20_OR_LATER(ah) || modparam_force_new_ani) {
+		if (use_new_ani(ah)) {
 			ah->ani[i].ofdmTrigHigh = ATH9K_ANI_OFDM_TRIG_HIGH_NEW;
 			ah->ani[i].ofdmTrigLow = ATH9K_ANI_OFDM_TRIG_LOW_NEW;
 
@@ -1230,7 +1235,7 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 	 * since we expect some ongoing maintenance on the tables, let's sanity
 	 * check here default level should not modify INI setting.
 	 */
-	if (AR_SREV_9300_20_OR_LATER(ah) || modparam_force_new_ani) {
+	if (use_new_ani(ah)) {
 		const struct ani_ofdm_level_entry *entry_ofdm;
 		const struct ani_cck_level_entry *entry_cck;
 
-- 
1.7.2.2

