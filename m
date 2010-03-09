Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:1403 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753088Ab0CIHzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 02:55:47 -0500
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-084651345
	for <linux-wireless@vger.kernel.org>; Tue,  9 Mar 2010 16:55:45 +0900 (JST)
Subject: [PATCH 06/13] ath5k: remove ah_magic
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 09 Mar 2010 16:55:44 +0900
Message-ID: <20100309075544.30616.17222.stgit@void>
In-Reply-To: <20100309075124.30616.40896.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

it's never used. probably a leftover from the old OpenHAL days...

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    1 -
 drivers/net/wireless/ath/ath5k/desc.c   |    6 ------
 drivers/net/wireless/ath/ath5k/eeprom.h |    3 ---
 3 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index cb79d44..3d63511 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1028,7 +1028,6 @@ struct ath5k_nfcal_hist
 
 /* TODO: Clean up and merge with ath5k_softc */
 struct ath5k_hw {
-	u32			ah_magic;
 	struct ath_common       common;
 
 	struct ath5k_softc	*ah_sc;
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index dc30a2b..dff58e2 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -668,12 +668,6 @@ int ath5k_hw_init_desc_functions(struct ath5k_hw *ah)
 		ah->ah_version != AR5K_AR5212)
 			return -ENOTSUPP;
 
-	/* XXX: What is this magic value and where is it used ? */
-	if (ah->ah_version == AR5K_AR5212)
-		ah->ah_magic = AR5K_EEPROM_MAGIC_5212;
-	else if (ah->ah_version == AR5K_AR5211)
-		ah->ah_magic = AR5K_EEPROM_MAGIC_5211;
-
 	if (ah->ah_version == AR5K_AR5212) {
 		ah->ah_setup_rx_desc = ath5k_hw_setup_rx_desc;
 		ah->ah_setup_tx_desc = ath5k_hw_setup_4word_tx_desc;
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index 473a483..1a65683 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -24,9 +24,6 @@
 						 * SERDES infos are present */
 #define AR5K_EEPROM_MAGIC		0x003d	/* EEPROM Magic number */
 #define AR5K_EEPROM_MAGIC_VALUE		0x5aa5	/* Default - found on EEPROM */
-#define AR5K_EEPROM_MAGIC_5212		0x0000145c /* 5212 */
-#define AR5K_EEPROM_MAGIC_5211		0x0000145b /* 5211 */
-#define AR5K_EEPROM_MAGIC_5210		0x0000145a /* 5210 */
 
 #define	AR5K_EEPROM_IS_HB63		0x000b	/* Talon detect */
 

