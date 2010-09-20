Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22705 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab0ITMaD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 08:30:03 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 05:29:56 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Fix beacon distribution in IBSS mode
Date: Mon, 20 Sep 2010 18:01:12 +0530
Message-ID: <1284985872-31021-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch ensures fair beacon distribution in IBSS mode
by configuring proper CWmin based on slot time.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    9 +++++-
 drivers/net/wireless/ath/ath9k/hw.c             |   32 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h             |    1 +
 3 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index bd1506e..3e699a5 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -235,7 +235,14 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 	ath9k_hw_get_txq_props(ah, qnum, &qi_be);
 
 	qi.tqi_aifs = qi_be.tqi_aifs;
-	qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
+	/* For WIFI Beacon Distribution
+	 * Long slot time  : 2x cwmin
+	 * Short slot time : 4x cwmin
+	 */
+	if (ath9k_hw_getslottime(ah) == ATH9K_SLOT_TIME_20)
+		qi.tqi_cwmin = 2*qi_be.tqi_cwmin;
+	else
+		qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
 	qi.tqi_cwmax = qi_be.tqi_cwmax;
 
 	if (!ath9k_hw_set_txq_props(ah, priv->beaconq, &qi)) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 40c6451..0798ebc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -103,6 +103,21 @@ static u32 ath9k_hw_mac_clks(struct ath_hw *ah, u32 usecs)
 		return usecs * ATH9K_CLOCK_RATE_5GHZ_OFDM;
 }
 
+static u32 ath9k_hw_mac_usecs(struct ath_hw *ah, u32 clks)
+{
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+
+	if (!ah->curchan) /* should really check for CCK instead */
+		return clks / ATH9K_CLOCK_RATE_CCK;
+	if (conf->channel->band == IEEE80211_BAND_2GHZ)
+		return clks / ATH9K_CLOCK_RATE_2GHZ_OFDM;
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_FASTCLOCK)
+		return clks / ATH9K_CLOCK_FAST_RATE_5GHZ_OFDM;
+	else
+		return clks / ATH9K_CLOCK_RATE_5GHZ_OFDM;
+}
+
 static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
 {
 	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
@@ -113,6 +128,16 @@ static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
 		return ath9k_hw_mac_clks(ah, usecs);
 }
 
+static u32 ath9k_hw_mac_to_usecs(struct ath_hw *ah, u32 clks)
+{
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+
+	if (conf_is_ht40(conf))
+		return ath9k_hw_mac_usecs(ah, clks) / 2;
+	else
+		return ath9k_hw_mac_usecs(ah, clks);
+}
+
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 {
 	int i;
@@ -786,6 +811,13 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 	}
 }
 
+u32 ath9k_hw_getslottime(struct ath_hw *ah)
+{
+	u32 val = REG_READ(ah, AR_D_GBL_IFS_SLOT) & 0xFFFF;
+	return ath9k_hw_mac_to_usecs(ah, val);
+}
+EXPORT_SYMBOL(ath9k_hw_getslottime);
+
 void ath9k_hw_init_global_settings(struct ath_hw *ah)
 {
 	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a3c2ce2..68f97e0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -909,6 +909,7 @@ void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1);
 void ath9k_hw_setbssidmask(struct ath_hw *ah);
 void ath9k_hw_write_associd(struct ath_hw *ah);
 u64 ath9k_hw_gettsf64(struct ath_hw *ah);
+u32 ath9k_hw_getslottime(struct ath_hw *ah);
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
 void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting);
-- 
1.7.2.3

