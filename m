Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:52038 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZALL6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 06:58:43 -0500
Received: by bwz14 with SMTP id 14so31970290bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 03:58:41 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH] ath5k: discard 11g caps if reported by an ar5211 eeprom
Date: Mon, 12 Jan 2009 13:04:06 +0100
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901121304.07360.helmut.schaa@gmail.com> (sfid-20090112_125851_642424_D3125D14)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At least one ar5211 card (GIGABYTE GN-WLMA101, 168c:0012 subsystem
1458:e800) reports itself as 11g capable which seems to be a bug in the
eeprom. initvals.c assumes that ar5211 is only 11b capable and thus refuses
to initialize this card. Hence this patch changes the probing for 11g
capabilities to discard 11g capabilities for ar5211 cards which allows this
specific card to work fine in 11b and 11a modes.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Is anybody aware of 11g-capable ar5211 cards which would be limited by
this patch?

diff --git a/drivers/net/wireless/ath5k/caps.c b/drivers/net/wireless/ath5k/caps.c
index 150f5ed..367a6c7 100644
--- a/drivers/net/wireless/ath5k/caps.c
+++ b/drivers/net/wireless/ath5k/caps.c
@@ -85,7 +85,8 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 		/* Enable  802.11b if a 2GHz capable radio (2111/5112) is
 		 * connected */
 		if (AR5K_EEPROM_HDR_11B(ee_header) ||
-				AR5K_EEPROM_HDR_11G(ee_header)) {
+		    (AR5K_EEPROM_HDR_11G(ee_header) &&
+		     ah->ah_version != AR5K_AR5211)) {
 			/* 2312 */
 			ah->ah_capabilities.cap_range.range_2ghz_min = 2412;
 			ah->ah_capabilities.cap_range.range_2ghz_max = 2732;
@@ -94,7 +95,8 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 				__set_bit(AR5K_MODE_11B,
 						ah->ah_capabilities.cap_mode);
 
-			if (AR5K_EEPROM_HDR_11G(ee_header))
+			if (AR5K_EEPROM_HDR_11G(ee_header) &&
+			    ah->ah_version != AR5K_AR5211)
 				__set_bit(AR5K_MODE_11G,
 						ah->ah_capabilities.cap_mode);
 		}
