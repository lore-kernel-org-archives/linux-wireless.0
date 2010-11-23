Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40204 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab0KWTm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:42:28 -0500
Received: by ewy5 with SMTP id 5so2680465ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:42:27 -0800 (PST)
Date: Tue, 23 Nov 2010 21:42:22 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 24/30] ath5k: No need to save/restore staid flags on reset
Message-ID: <20101123194222.GX4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Since we set antenna flags on phy init and ack bitrate
 mode on pcu init, there is no need to save/restore sta_id
 flags on ath5k_hw_reset. Also we don't need to re-set our
 mac address because it's not affected by resets.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/reset.c |   22 +---------------------
 1 files changed, 1 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index f92f7bb..93014fd 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -940,13 +940,11 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		struct ieee80211_channel *channel, bool fast, bool skip_pcu)
 {
-	struct ath_common *common = ath5k_hw_common(ah);
-	u32 s_seq[10], s_led[3], staid1_flags, tsf_up, tsf_lo;
+	u32 s_seq[10], s_led[3], tsf_up, tsf_lo;
 	u8 mode, freq, ee_mode;
 	int i, ret;
 
 	ee_mode = 0;
-	staid1_flags = 0;
 	tsf_up = 0;
 	tsf_lo = 0;
 	freq = 0;
@@ -1115,15 +1113,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	s_led[1] = ath5k_hw_reg_read(ah, AR5K_GPIOCR);
 	s_led[2] = ath5k_hw_reg_read(ah, AR5K_GPIODO);
 
-	/* AR5K_STA_ID1 flags, only preserve antenna
-	 * settings and ack/cts rate mode */
-	staid1_flags = ath5k_hw_reg_read(ah, AR5K_STA_ID1) &
-			(AR5K_STA_ID1_DEFAULT_ANTENNA |
-			AR5K_STA_ID1_DESC_ANTENNA |
-			AR5K_STA_ID1_RTS_DEF_ANTENNA |
-			AR5K_STA_ID1_ACKCTS_6MB |
-			AR5K_STA_ID1_BASE_RATE_11B |
-			AR5K_STA_ID1_SELFGEN_DEF_ANT);
 
 	/*
 	 * Since we are going to write rf buffer
@@ -1195,15 +1184,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	ath5k_hw_reg_write(ah, s_led[1], AR5K_GPIOCR);
 	ath5k_hw_reg_write(ah, s_led[2], AR5K_GPIODO);
 
-	/* Restore sta_id flags and preserve our mac address*/
-	ath5k_hw_reg_write(ah,
-			   get_unaligned_le32(common->macaddr),
-			   AR5K_STA_ID0);
-	ath5k_hw_reg_write(ah,
-			   staid1_flags | get_unaligned_le16(common->macaddr + 4),
-			   AR5K_STA_ID1);
-
-
 	/*
 	 * Initialize PCU
 	 */
