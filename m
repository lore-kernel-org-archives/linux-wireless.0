Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34467 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0KWTxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:53:36 -0500
Received: by ewy5 with SMTP id 5so2686900ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:53:35 -0800 (PST)
Date: Tue, 23 Nov 2010 21:53:28 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 30/30] ath5k: Set turbo bit on rf bank 2
Message-ID: <20101123195328.GD4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * A diff between rfbuffer settings of turbo and non-turbo
 modes indicates there is a bit on bank 2 related to turbo operation
 (it's set on turbo modes). This bit is present on all radios except
 RF5413 that seems to have a completely different bank 2. Also
 since 2317 has the same rf-registers locations with 2425 and
 since the bit exists on 2317 I assume it also exists on 2425/2417).
 So in case we use turbo mode (40MHz) enable it on bank modification.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c      |    5 +++++
 drivers/net/wireless/ath/ath5k/rfbuffer.h |   27 ++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 61d3800..df5cd0f 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -824,6 +824,11 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 
 	g_step = &go->go_step[ah->ah_gain.g_step_idx];
 
+	/* Set turbo mode (N/A on RF5413) */
+	if ((ah->ah_bwmode == AR5K_BWMODE_40MHZ) &&
+	(ah->ah_radio != AR5K_RF5413))
+		ath5k_hw_rfb_op(ah, rf_regs, 1, AR5K_RF_TURBO, false);
+
 	/* Bank Modifications (chip-specific) */
 	if (ah->ah_radio == AR5K_RF5111) {
 
diff --git a/drivers/net/wireless/ath/ath5k/rfbuffer.h b/drivers/net/wireless/ath/ath5k/rfbuffer.h
index 70356ba..16b67e8 100644
--- a/drivers/net/wireless/ath/ath5k/rfbuffer.h
+++ b/drivers/net/wireless/ath/ath5k/rfbuffer.h
@@ -79,8 +79,10 @@ struct ath5k_rf_reg {
  * life easier by using an index for each register
  * instead of a full rfb_field */
 enum ath5k_rf_regs_idx {
+	/* BANK 2 */
+	AR5K_RF_TURBO = 0,
 	/* BANK 6 */
-	AR5K_RF_OB_2GHZ = 0,
+	AR5K_RF_OB_2GHZ,
 	AR5K_RF_OB_5GHZ,
 	AR5K_RF_DB_2GHZ,
 	AR5K_RF_DB_5GHZ,
@@ -134,6 +136,9 @@ enum ath5k_rf_regs_idx {
 * RF5111 (Sombrero) *
 \*******************/
 
+/* BANK 2				len  pos col */
+#define	AR5K_RF5111_RF_TURBO		{ 1, 3,   0 }
+
 /* BANK 6				len  pos col */
 #define	AR5K_RF5111_OB_2GHZ		{ 3, 119, 0 }
 #define	AR5K_RF5111_DB_2GHZ		{ 3, 122, 0 }
@@ -158,6 +163,7 @@ enum ath5k_rf_regs_idx {
 #define	AR5K_RF5111_MAX_TIME		{ 2, 49,  0 }
 
 static const struct ath5k_rf_reg rf_regs_5111[] = {
+	{2, AR5K_RF_TURBO,		AR5K_RF5111_RF_TURBO},
 	{6, AR5K_RF_OB_2GHZ,		AR5K_RF5111_OB_2GHZ},
 	{6, AR5K_RF_DB_2GHZ,		AR5K_RF5111_DB_2GHZ},
 	{6, AR5K_RF_OB_5GHZ,		AR5K_RF5111_OB_5GHZ},
@@ -231,6 +237,9 @@ static const struct ath5k_ini_rfbuffer rfb_5111[] = {
 * RF5112/RF2112 (Derby) *
 \***********************/
 
+/* BANK 2 (Common)			len  pos col */
+#define	AR5K_RF5112X_RF_TURBO		{ 1, 1,   2 }
+
 /* BANK 7 (Common)			len  pos col */
 #define	AR5K_RF5112X_GAIN_I		{ 6, 14,  0 }
 #define	AR5K_RF5112X_MIXVGA_OVR		{ 1, 36,  0 }
@@ -262,6 +271,7 @@ static const struct ath5k_ini_rfbuffer rfb_5111[] = {
 #define AR5K_RF5112_PWD(_n)		{ 1, (302 - _n), 3 }
 
 static const struct ath5k_rf_reg rf_regs_5112[] = {
+	{2, AR5K_RF_TURBO,		AR5K_RF5112X_RF_TURBO},
 	{6, AR5K_RF_OB_2GHZ,		AR5K_RF5112_OB_2GHZ},
 	{6, AR5K_RF_DB_2GHZ,		AR5K_RF5112_DB_2GHZ},
 	{6, AR5K_RF_OB_5GHZ,		AR5K_RF5112_OB_5GHZ},
@@ -378,6 +388,7 @@ static const struct ath5k_ini_rfbuffer rfb_5112[] = {
 #define	AR5K_RF5112A_XB5_LVL		{ 2, 3,	  3 }
 
 static const struct ath5k_rf_reg rf_regs_5112a[] = {
+	{2, AR5K_RF_TURBO,		AR5K_RF5112X_RF_TURBO},
 	{6, AR5K_RF_OB_2GHZ,		AR5K_RF5112A_OB_2GHZ},
 	{6, AR5K_RF_DB_2GHZ,		AR5K_RF5112A_DB_2GHZ},
 	{6, AR5K_RF_OB_5GHZ,		AR5K_RF5112A_OB_5GHZ},
@@ -481,11 +492,15 @@ static const struct ath5k_ini_rfbuffer rfb_5112a[] = {
 * RF2413 (Griffin) *
 \******************/
 
+/* BANK 2				len  pos col */
+#define AR5K_RF2413_RF_TURBO		{ 1, 1,   2 }
+
 /* BANK 6 				len  pos col */
 #define	AR5K_RF2413_OB_2GHZ		{ 3, 168, 0 }
 #define	AR5K_RF2413_DB_2GHZ		{ 3, 165, 0 }
 
 static const struct ath5k_rf_reg rf_regs_2413[] = {
+	{2, AR5K_RF_TURBO,		AR5K_RF2413_RF_TURBO},
 	{6, AR5K_RF_OB_2GHZ,		AR5K_RF2413_OB_2GHZ},
 	{6, AR5K_RF_DB_2GHZ,		AR5K_RF2413_DB_2GHZ},
 };
@@ -536,11 +551,15 @@ static const struct ath5k_ini_rfbuffer rfb_2413[] = {
 * RF2315/RF2316 (Cobra SoC) *
 \***************************/
 
+/* BANK 2				len  pos col */
+#define	AR5K_RF2316_RF_TURBO		{ 1, 1,   2 }
+
 /* BANK 6				len  pos col */
 #define	AR5K_RF2316_OB_2GHZ		{ 3, 178, 0 }
 #define	AR5K_RF2316_DB_2GHZ		{ 3, 175, 0 }
 
 static const struct ath5k_rf_reg rf_regs_2316[] = {
+	{2, AR5K_RF_TURBO,		AR5K_RF2316_RF_TURBO},
 	{6, AR5K_RF_OB_2GHZ,		AR5K_RF2316_OB_2GHZ},
 	{6, AR5K_RF_DB_2GHZ,		AR5K_RF2316_DB_2GHZ},
 };
@@ -665,17 +684,20 @@ static const struct ath5k_ini_rfbuffer rfb_5413[] = {
 * AR2317 (Spider SoC)       *
 \***************************/
 
+/* BANK 2				len  pos col */
+#define AR5K_RF2425_RF_TURBO		{ 1, 1,   2 }
+
 /* BANK 6				len  pos col */
 #define	AR5K_RF2425_OB_2GHZ		{ 3, 193, 0 }
 #define	AR5K_RF2425_DB_2GHZ		{ 3, 190, 0 }
 
 static const struct ath5k_rf_reg rf_regs_2425[] = {
+	{2, AR5K_RF_TURBO,		AR5K_RF2425_RF_TURBO},
 	{6, AR5K_RF_OB_2GHZ,		AR5K_RF2425_OB_2GHZ},
 	{6, AR5K_RF_DB_2GHZ,		AR5K_RF2425_DB_2GHZ},
 };
 
 /* Default mode specific settings
- * XXX: a/aTurbo ?
  */
 static const struct ath5k_ini_rfbuffer rfb_2425[] = {
 	/* BANK / C.R.     A/XR         B           G      */
@@ -764,7 +786,6 @@ static const struct ath5k_ini_rfbuffer rfb_2317[] = {
 /*
  * TODO: Handle the few differences with swan during
  * bank modification and get rid of this
- * XXX: a/aTurbo ?
  */
 static const struct ath5k_ini_rfbuffer rfb_2417[] = {
 	/* BANK / C.R.     A/XR         B           G      */
