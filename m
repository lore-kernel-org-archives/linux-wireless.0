Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:55569
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751702AbaI0VA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 17:00:27 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 2/2] ath9k_hw: disable hardware ad-hoc flag on ar934x rev 3
Date: Sat, 27 Sep 2014 22:49:44 +0200
Message-Id: <1411850984-65861-2-git-send-email-nbd@openwrt.org> (sfid-20140927_230031_424226_3F5B7959)
In-Reply-To: <1411850984-65861-1-git-send-email-nbd@openwrt.org>
References: <1411850984-65861-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On AR934x rev 3, settin the ad-hoc flag completely messes up hardware
state - beacons get stuck, almost no packets make it out, hardware is
constantly reset.

When leaving out that flag and setting up the hw like in AP mode, TSF
timers won't be automatically synced, but at least the rest works.

AR934x rev 2 and older are not affected by this bug

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  | 9 ++++++---
 drivers/net/wireless/ath/ath9k/reg.h | 4 ++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cf0128e..88654e3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1189,9 +1189,12 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 
 	switch (opmode) {
 	case NL80211_IFTYPE_ADHOC:
-		set |= AR_STA_ID1_ADHOC;
-		REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
-		break;
+		if (!AR_SREV_9340_13(ah)) {
+			set |= AR_STA_ID1_ADHOC;
+			REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
+			break;
+		}
+		/* fall through */
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		set |= AR_STA_ID1_STA_AP;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index a149970..95fdf93 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -903,6 +903,10 @@
 #define AR_SREV_9340(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9340))
 
+#define AR_SREV_9340_13(_ah) \
+	(AR_SREV_9340((_ah)) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9340_13))
+
 #define AR_SREV_9340_13_OR_LATER(_ah) \
 	(AR_SREV_9340((_ah)) && \
 	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9340_13))
-- 
2.0.4

