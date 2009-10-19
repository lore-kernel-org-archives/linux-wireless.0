Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Stephen Chen <Stephen.Chen@atheros.com>
Subject: [RFT 02/15] ath9k_hw: update register initialization/reset values for ar9271
Date: Mon, 19 Oct 2009 02:33:33 -0400
Message-Id: <1255934026-20686-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This update the register initialization/reset values (aka initvals)
for ar9271 based on the last recommended values on 2009-06-04 by our
systems engineering team.

The changes account for:

  * Supporting ar9271 1.0 and ar9271 1.1 together, the difference
    is bb_spectral_scan_ena, for 1.0 we'll set this to 0x1.

  * Ensuring we get the correct noise floor values -115 ~ -118
    when we enable bb_enable_ant_div_lnadiv=0 and
    mc_tx_def_ant_sel=1. Previous to this we would get noise
    floor values in the range -50 ~ -80. To fix settings for
    the registers:

     - bb_ch1_xatten1_db
     - bb_ch1_xatten2_db
     - bb_ch1_xatten1_margin
     - bb_ch1_xatten2_margin
     - bb_ch1_gain_force
     - bb_ch1_xatten2_hyst_margin
     - bb_ch1_xatten1_hyst_margin
     - bb_ch1_max_oc_gain

  * 0x8120[2] mc_mic_new_location_enable is changed to 0x1. The MAC team
    suggest to set this value.

  * 0x9910[0] bb_spectral_scan_ena is changed to 0x0.
    For ar9271 1.1 we don't need to enable this bit.

Cc: Stephen Chen <Stephen.Chen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c       |   15 +++++++++++----
 drivers/net/wireless/ath/ath9k/hw.h       |    1 +
 drivers/net/wireless/ath/ath9k/initvals.h |   29 +++++++++++++++++------------
 3 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cab17c6..6df00ab 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -662,10 +662,13 @@ static void ath9k_hw_init_cal_settings(struct ath_hw *ah)
 static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
 {
 	if (AR_SREV_9271(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9271Modes_9271_1_0,
-			       ARRAY_SIZE(ar9271Modes_9271_1_0), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271_1_0,
-			       ARRAY_SIZE(ar9271Common_9271_1_0), 2);
+		INIT_INI_ARRAY(&ah->iniModes, ar9271Modes_9271,
+			       ARRAY_SIZE(ar9271Modes_9271), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271,
+			       ARRAY_SIZE(ar9271Common_9271), 2);
+		INIT_INI_ARRAY(&ah->iniModes_9271_1_0_only,
+			       ar9271Modes_9271_1_0_only,
+			       ARRAY_SIZE(ar9271Modes_9271_1_0_only), 6);
 		return;
 	}
 
@@ -1491,6 +1494,10 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 
 	ath9k_hw_write_regs(ah, modesIndex, freqIndex, regWrites);
 
+	if (AR_SREV_9271_10(ah))
+		REG_WRITE_ARRAY(&ah->iniModes_9271_1_0_only,
+				modesIndex, regWrites);
+
 	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan)) {
 		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex,
 				regWrites);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index cdaec52..0b3fc4e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -596,6 +596,7 @@ struct ath_hw {
 	struct ar5416IniArray iniModesAdditional;
 	struct ar5416IniArray iniModesRxGain;
 	struct ar5416IniArray iniModesTxGain;
+	struct ar5416IniArray iniModes_9271_1_0_only;
 	struct ar5416IniArray iniCckfirNormal;
 	struct ar5416IniArray iniCckfirJapan2484;
 
diff --git a/drivers/net/wireless/ath/ath9k/initvals.h b/drivers/net/wireless/ath/ath9k/initvals.h
index 3ee6658..8a3bf3a 100644
--- a/drivers/net/wireless/ath/ath9k/initvals.h
+++ b/drivers/net/wireless/ath/ath9k/initvals.h
@@ -6379,8 +6379,8 @@ static const u_int32_t ar9287PciePhy_clkreq_off_L1_9287_1_1[][2] = {
 };
 
 
-/* AR9271 initialization values automaticaly created: 03/23/09 */
-static const u_int32_t ar9271Modes_9271_1_0[][6] = {
+/* AR9271 initialization values automaticaly created: 06/04/09 */
+static const u_int32_t ar9271Modes_9271[][6] = {
     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
     { 0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38, 0x00001180 },
@@ -6390,8 +6390,8 @@ static const u_int32_t ar9271Modes_9271_1_0[][6] = {
     { 0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440, 0x00006880 },
     { 0x00009804, 0x00000300, 0x000003c4, 0x000003c4, 0x00000300, 0x00000303 },
     { 0x00009820, 0x02020200, 0x02020200, 0x02020200, 0x02020200, 0x02020200 },
-    { 0x00009824, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e },
-    { 0x00009828, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001 },
+    { 0x00009824, 0x01000e0e, 0x01000e0e, 0x01000e0e, 0x01000e0e, 0x01000e0e },
+    { 0x00009828, 0x3a020001, 0x3a020001, 0x3a020001, 0x3a020001, 0x3a020001 },
     { 0x00009834, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e },
     { 0x00009838, 0x00000007, 0x00000007, 0x00000007, 0x00000007, 0x00000007 },
     { 0x00009840, 0x206a012e, 0x206a012e, 0x206a012e, 0x206a012e, 0x206a012e },
@@ -6405,6 +6405,7 @@ static const u_int32_t ar9271Modes_9271_1_0[][6] = {
     { 0x00009864, 0x0000fe00, 0x0000fe00, 0x0001ce00, 0x0001ce00, 0x0001ce00 },
     { 0x00009868, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0 },
     { 0x0000986c, 0x06903081, 0x06903081, 0x06903881, 0x06903881, 0x06903881 },
+    { 0x00009910, 0x30002310, 0x30002310, 0x30002310, 0x30002310, 0x30002310 },
     { 0x00009914, 0x000007d0, 0x00000fa0, 0x00001130, 0x00000898, 0x000007d0 },
     { 0x00009918, 0x0000000a, 0x00000014, 0x00000016, 0x0000000b, 0x00000016 },
     { 0x00009924, 0xd00a8007, 0xd00a8007, 0xd00a800d, 0xd00a800d, 0xd00a800d },
@@ -6415,7 +6416,7 @@ static const u_int32_t ar9271Modes_9271_1_0[][6] = {
     { 0x000099bc, 0x00000600, 0x00000600, 0x00000c00, 0x00000c00, 0x00000c00 },
     { 0x000099c0, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4 },
     { 0x000099c4, 0x06336f77, 0x06336f77, 0x06336f77, 0x06336f77, 0x06336f77 },
-    { 0x000099c8, 0x6af65329, 0x6af65329, 0x6af65329, 0x6af65329, 0x6af65329 },
+    { 0x000099c8, 0x6af6532f, 0x6af6532f, 0x6af6532f, 0x6af6532f, 0x6af6532f },
     { 0x000099cc, 0x08f186c8, 0x08f186c8, 0x08f186c8, 0x08f186c8, 0x08f186c8 },
     { 0x000099d0, 0x00046384, 0x00046384, 0x00046384, 0x00046384, 0x00046384 },
     { 0x000099d4, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
@@ -6704,7 +6705,7 @@ static const u_int32_t ar9271Modes_9271_1_0[][6] = {
     { 0x0000a358, 0x7999aa02, 0x7999aa02, 0x7999aa0e, 0x7999aa0e, 0x7999aa0e },
 };
 
-static const u_int32_t ar9271Common_9271_1_0[][2] = {
+static const u_int32_t ar9271Common_9271[][2] = {
     { 0x0000000c, 0x00000000 },
     { 0x00000030, 0x00020045 },
     { 0x00000034, 0x00000005 },
@@ -6800,7 +6801,7 @@ static const u_int32_t ar9271Common_9271_1_0[][2] = {
     { 0x0000803c, 0x00000000 },
     { 0x00008048, 0x00000000 },
     { 0x00008054, 0x00000000 },
-    { 0x00008058, 0x02000000 },
+    { 0x00008058, 0x00000000 },
     { 0x0000805c, 0x000fc78f },
     { 0x00008060, 0x0000000f },
     { 0x00008064, 0x00000000 },
@@ -6831,7 +6832,7 @@ static const u_int32_t ar9271Common_9271_1_0[][2] = {
     { 0x00008110, 0x00000168 },
     { 0x00008118, 0x000100aa },
     { 0x0000811c, 0x00003210 },
-    { 0x00008120, 0x08f04814 },
+    { 0x00008120, 0x08f04810 },
     { 0x00008124, 0x00000000 },
     { 0x00008128, 0x00000000 },
     { 0x0000812c, 0x00000000 },
@@ -6878,7 +6879,7 @@ static const u_int32_t ar9271Common_9271_1_0[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -6910,7 +6911,7 @@ static const u_int32_t ar9271Common_9271_1_0[][2] = {
     { 0x00007814, 0x924934a8 },
     { 0x0000781c, 0x00000000 },
     { 0x00007820, 0x00000c04 },
-    { 0x00007824, 0x00d86bff },
+    { 0x00007824, 0x00d8abff },
     { 0x00007828, 0x66964300 },
     { 0x0000782c, 0x8db6d961 },
     { 0x00007830, 0x8db6d96c },
@@ -6944,7 +6945,6 @@ static const u_int32_t ar9271Common_9271_1_0[][2] = {
     { 0x00009904, 0x00000000 },
     { 0x00009908, 0x00000000 },
     { 0x0000990c, 0x00000000 },
-    { 0x00009910, 0x30002310 },
     { 0x0000991c, 0x10000fff },
     { 0x00009920, 0x04900000 },
     { 0x00009928, 0x00000001 },
@@ -6958,7 +6958,7 @@ static const u_int32_t ar9271Common_9271_1_0[][2] = {
     { 0x00009954, 0x5f3ca3de },
     { 0x00009958, 0x0108ecff },
     { 0x00009968, 0x000003ce },
-    { 0x00009970, 0x192bb515 },
+    { 0x00009970, 0x192bb514 },
     { 0x00009974, 0x00000000 },
     { 0x00009978, 0x00000001 },
     { 0x0000997c, 0x00000000 },
@@ -7045,3 +7045,8 @@ static const u_int32_t ar9271Common_9271_1_0[][2] = {
     { 0x0000d380, 0x7f3c7bba },
     { 0x0000d384, 0xf3307ff0 },
 };
+
+static const u_int32_t ar9271Modes_9271_1_0_only[][6] = {
+    { 0x00009910, 0x30002311, 0x30002311, 0x30002311, 0x30002311, 0x30002311 },
+    { 0x00009828, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001 },
+};
-- 
1.6.0.4

