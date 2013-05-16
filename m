Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50035 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab3EPLB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 07:01:59 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv3 11/18] ath9k: always use SIFS times from OFDM for 5/10 MHz
Date: Thu, 16 May 2013 13:00:38 +0200
Message-Id: <1368702045-27598-12-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130516_130213_620696_730DBDF3)
In-Reply-To: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

5/10 MHz channels should always use SIFS times as defined in IEEE
802.11-2012 18.4.4 (OFDM PHY characteristics). This makes it compatible
to ath5k, which does the same.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7f25da8..89ee731 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1071,7 +1071,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 11;
 
-		sifstime *= 2;
+		sifstime = 32;
 		ack_offset = 16;
 		slottime = 13;
 	} else if (IS_CHAN_QUARTER_RATE(chan)) {
@@ -1081,7 +1081,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 22;
 
-		sifstime *= 4;
+		sifstime = 64;
 		ack_offset = 32;
 		slottime = 21;
 	} else {
@@ -1118,7 +1118,6 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		ctstimeout += 48 - sifstime - ah->slottime;
 	}
 
-
 	ath9k_hw_set_sifs_time(ah, sifstime);
 	ath9k_hw_setslottime(ah, slottime);
 	ath9k_hw_set_ack_timeout(ah, acktimeout);
-- 
1.7.10.4

