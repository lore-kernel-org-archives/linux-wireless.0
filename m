Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41002 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0KWTsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:48:55 -0500
Received: by ewy5 with SMTP id 5so2684055ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:48:54 -0800 (PST)
Date: Tue, 23 Nov 2010 21:48:32 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 27/30] ath5k: Use correct clock when setting ofdm timings
Message-ID: <20101123194832.GA4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Use correct clock value when setting OFDM timings on
 non-default bwmodes.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 31239ab..95b602b 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -228,8 +228,20 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
 	 * ALGO: coef = (5 * clock / carrier_freq) / 2
 	 * we scale coef by shifting clock value by 24 for
 	 * better precision since we use integers */
-	/* TODO: Half/quarter rate */
-	clock =  (channel->hw_value & CHANNEL_TURBO) ? 80 : 40;
+	switch (ah->ah_bwmode) {
+	case AR5K_BWMODE_40MHZ:
+		clock = 40 * 2;
+		break;
+	case AR5K_BWMODE_10MHZ:
+		clock = 40 / 2;
+		break;
+	case AR5K_BWMODE_5MHZ:
+		clock = 40 / 4;
+		break;
+	default:
+		clock = 40;
+		break;
+	}
 	coef_scaled = ((5 * (clock << 24)) / 2) / channel->center_freq;
 
 	/* Get exponent
