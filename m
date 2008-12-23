Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22690 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYLWX7e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 18:59:34 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 15:59:34 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v3 13/16] ath9k: remove ath9k_hw_chan2wmode()
Date: Tue, 23 Dec 2008 15:58:48 -0800
Message-ID: <1230076731-22946-14-git-send-email-lrodriguez@atheros.com> (sfid-20081224_010842_196291_723903AD)
In-Reply-To: <1230076731-22946-13-git-send-email-lrodriguez@atheros.com>
References: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-2-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-3-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-4-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-5-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-6-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-7-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-8-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-9-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-10-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-11-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-12-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-13-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only left users are for timing for ACK timeout, slotime and
CTS timeout. We currently use an array CLOCK_RATE to keep
these values per mode and since as only will use A and G
we can depend on the band to get the appropriate values.

We note that we should be using a different clock rate value
for CCK, we can do this in separate patch, currently this is
being disregarded and should only affect when we want to
change the default ACK/CTS timeout or slot time and stuck
with using using 802.11b.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   46 ++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 85da799..3b61bfa 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -23,7 +23,9 @@
 #include "phy.h"
 #include "initvals.h"
 
-static const u8 CLOCK_RATE[] = { 40, 80, 22, 44, 88, 40 };
+#define ATH9K_CLOCK_RATE_CCK		22
+#define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
+#define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
 
 extern struct hal_percal_data iq_cal_multi_sample;
 extern struct hal_percal_data iq_cal_single_sample;
@@ -48,17 +50,18 @@ static void ath9k_hw_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *cha
 
 static u32 ath9k_hw_mac_usec(struct ath_hal *ah, u32 clks)
 {
-	if (ah->ah_curchan != NULL)
-		return clks / CLOCK_RATE[ath9k_hw_chan2wmode(ah, ah->ah_curchan)];
-	else
-		return clks / CLOCK_RATE[ATH9K_MODE_11B];
+	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	if (!ah->ah_curchan) /* should really check for CCK instead */
+		return clks / ATH9K_CLOCK_RATE_CCK;
+	if (conf->channel->band == IEEE80211_BAND_2GHZ)
+		return clks / ATH9K_CLOCK_RATE_2GHZ_OFDM;
+	return clks / ATH9K_CLOCK_RATE_5GHZ_OFDM;
 }
 
 static u32 ath9k_hw_mac_to_usec(struct ath_hal *ah, u32 clks)
 {
-	struct ath9k_channel *chan = ah->ah_curchan;
-
-	if (chan && IS_CHAN_HT40(chan))
+	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	if (conf_is_ht40(conf))
 		return ath9k_hw_mac_usec(ah, clks) / 2;
 	else
 		return ath9k_hw_mac_usec(ah, clks);
@@ -66,34 +69,23 @@ static u32 ath9k_hw_mac_to_usec(struct ath_hal *ah, u32 clks)
 
 static u32 ath9k_hw_mac_clks(struct ath_hal *ah, u32 usecs)
 {
-	if (ah->ah_curchan != NULL)
-		return usecs * CLOCK_RATE[ath9k_hw_chan2wmode(ah,
-			ah->ah_curchan)];
-	else
-		return usecs * CLOCK_RATE[ATH9K_MODE_11B];
+	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	if (!ah->ah_curchan) /* should really check for CCK instead */
+		return usecs *ATH9K_CLOCK_RATE_CCK;
+	if (conf->channel->band == IEEE80211_BAND_2GHZ)
+		return usecs *ATH9K_CLOCK_RATE_2GHZ_OFDM;
+	return usecs *ATH9K_CLOCK_RATE_5GHZ_OFDM;
 }
 
 static u32 ath9k_hw_mac_to_clks(struct ath_hal *ah, u32 usecs)
 {
-	struct ath9k_channel *chan = ah->ah_curchan;
-
-	if (chan && IS_CHAN_HT40(chan))
+	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	if (conf_is_ht40(conf))
 		return ath9k_hw_mac_clks(ah, usecs) * 2;
 	else
 		return ath9k_hw_mac_clks(ah, usecs);
 }
 
-enum wireless_mode ath9k_hw_chan2wmode(struct ath_hal *ah,
-			       const struct ath9k_channel *chan)
-{
-	if (IS_CHAN_B(chan))
-		return ATH9K_MODE_11B;
-	if (IS_CHAN_G(chan))
-		return ATH9K_MODE_11G;
-
-	return ATH9K_MODE_11A;
-}
-
 bool ath9k_hw_wait(struct ath_hal *ah, u32 reg, u32 mask, u32 val)
 {
 	int i;
-- 
1.6.1.rc3.51.g5832d

