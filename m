Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51045 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbaD0Ohr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2014 10:37:47 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.15] ath9k_hw: do not lower ANI setting below default on AR913x
Date: Sun, 27 Apr 2014 16:37:39 +0200
Message-Id: <1398609459-42175-1-git-send-email-nbd@openwrt.org> (sfid-20140427_163752_007281_3FDBD16A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the amount of noise fluctuates strongly, low immunity settings
can sometimes disrupt signal detection on AR913x chips. When that
happens, no OFDM/CCK errors are reported anymore, and ANI tunes the
radio to the lowest immunity settings.
Usually rx/tx fails as well in that case.

To fix this, keep noise immunity settings at or above ANI default level,
which will keep radio parameters at or above INI values.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 6d47783..ba502a2 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -155,6 +155,9 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel,
 		ATH9K_ANI_RSSI_THR_LOW,
 		ATH9K_ANI_RSSI_THR_HIGH);
 
+	if (AR_SREV_9100(ah) && immunityLevel < ATH9K_ANI_OFDM_DEF_LEVEL)
+		immunityLevel = ATH9K_ANI_OFDM_DEF_LEVEL;
+
 	if (!scan)
 		aniState->ofdmNoiseImmunityLevel = immunityLevel;
 
@@ -235,6 +238,9 @@ static void ath9k_hw_set_cck_nil(struct ath_hw *ah, u_int8_t immunityLevel,
 		BEACON_RSSI(ah), ATH9K_ANI_RSSI_THR_LOW,
 		ATH9K_ANI_RSSI_THR_HIGH);
 
+	if (AR_SREV_9100(ah) && immunityLevel < ATH9K_ANI_CCK_DEF_LEVEL)
+		immunityLevel = ATH9K_ANI_CCK_DEF_LEVEL;
+
 	if (ah->opmode == NL80211_IFTYPE_STATION &&
 	    BEACON_RSSI(ah) <= ATH9K_ANI_RSSI_THR_LOW &&
 	    immunityLevel > ATH9K_ANI_CCK_MAX_LEVEL_LOW_RSSI)
-- 
1.8.5.2 (Apple Git-48)

