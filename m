Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:47845 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752559Ab1AYEPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 23:15:32 -0500
Received: from vs3010.wh2.ocn.ne.jp (125.206.180.173)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-063698929
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 13:15:31 +0900 (JST)
Subject: [PATCH 2/6] ath5k: Use local variable for capabilities
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 25 Jan 2011 13:15:28 +0900
Message-ID: <20110125041528.6944.18770.stgit@localhost6.localdomain6>
In-Reply-To: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shorten some lines and make code more readable.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/caps.c |   39 +++++++++++++++------------------
 1 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index 31cad80..39baee1 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -32,23 +32,24 @@
  */
 int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 {
+	struct ath5k_capabilities *caps = &ah->ah_capabilities;
 	u16 ee_header;
 
 	/* Capabilities stored in the EEPROM */
-	ee_header = ah->ah_capabilities.cap_eeprom.ee_header;
+	ee_header = caps->cap_eeprom.ee_header;
 
 	if (ah->ah_version == AR5K_AR5210) {
 		/*
 		 * Set radio capabilities
 		 * (The AR5110 only supports the middle 5GHz band)
 		 */
-		ah->ah_capabilities.cap_range.range_5ghz_min = 5120;
-		ah->ah_capabilities.cap_range.range_5ghz_max = 5430;
-		ah->ah_capabilities.cap_range.range_2ghz_min = 0;
-		ah->ah_capabilities.cap_range.range_2ghz_max = 0;
+		caps->cap_range.range_5ghz_min = 5120;
+		caps->cap_range.range_5ghz_max = 5430;
+		caps->cap_range.range_2ghz_min = 0;
+		caps->cap_range.range_2ghz_max = 0;
 
 		/* Set supported modes */
-		__set_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode);
+		__set_bit(AR5K_MODE_11A, caps->cap_mode);
 	} else {
 		/*
 		 * XXX The tranceiver supports frequencies from 4920 to 6100GHz
@@ -67,12 +68,11 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 
 		if (AR5K_EEPROM_HDR_11A(ee_header)) {
 			/* 4920 */
-			ah->ah_capabilities.cap_range.range_5ghz_min = 5005;
-			ah->ah_capabilities.cap_range.range_5ghz_max = 6100;
+			caps->cap_range.range_5ghz_min = 5005;
+			caps->cap_range.range_5ghz_max = 6100;
 
 			/* Set supported modes */
-			__set_bit(AR5K_MODE_11A,
-					ah->ah_capabilities.cap_mode);
+			__set_bit(AR5K_MODE_11A, caps->cap_mode);
 		}
 
 		/* Enable  802.11b if a 2GHz capable radio (2111/5112) is
@@ -81,32 +81,29 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 		    (AR5K_EEPROM_HDR_11G(ee_header) &&
 		     ah->ah_version != AR5K_AR5211)) {
 			/* 2312 */
-			ah->ah_capabilities.cap_range.range_2ghz_min = 2412;
-			ah->ah_capabilities.cap_range.range_2ghz_max = 2732;
+			caps->cap_range.range_2ghz_min = 2412;
+			caps->cap_range.range_2ghz_max = 2732;
 
 			if (AR5K_EEPROM_HDR_11B(ee_header))
-				__set_bit(AR5K_MODE_11B,
-						ah->ah_capabilities.cap_mode);
+				__set_bit(AR5K_MODE_11B, caps->cap_mode);
 
 			if (AR5K_EEPROM_HDR_11G(ee_header) &&
 			    ah->ah_version != AR5K_AR5211)
-				__set_bit(AR5K_MODE_11G,
-						ah->ah_capabilities.cap_mode);
+				__set_bit(AR5K_MODE_11G, caps->cap_mode);
 		}
 	}
 
 	/* Set number of supported TX queues */
 	if (ah->ah_version == AR5K_AR5210)
-		ah->ah_capabilities.cap_queues.q_tx_num =
-			AR5K_NUM_TX_QUEUES_NOQCU;
+		caps->cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES_NOQCU;
 	else
-		ah->ah_capabilities.cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES;
+		caps->cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES;
 
 	/* newer hardware has PHY error counters */
 	if (ah->ah_mac_srev >= AR5K_SREV_AR5213A)
-		ah->ah_capabilities.cap_has_phyerr_counters = true;
+		caps->cap_has_phyerr_counters = true;
 	else
-		ah->ah_capabilities.cap_has_phyerr_counters = false;
+		caps->cap_has_phyerr_counters = false;
 
 	return 0;
 }

