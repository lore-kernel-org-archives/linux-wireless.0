Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59650 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab3LSRCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 12:02:00 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3/4] ath9k: fix TSF offset precision issue
Date: Thu, 19 Dec 2013 18:01:50 +0100
Message-Id: <1387472511-86178-3-git-send-email-nbd@openwrt.org> (sfid-20131219_180204_775316_9ECAC05F)
In-Reply-To: <1387472511-86178-1-git-send-email-nbd@openwrt.org>
References: <1387472511-86178-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dividing the beacon interval by ATH_BCBUF (8) truncates the result for
the default beacon interval of 100.
Fix the calculation by moving the division after conversion from TU to
microseconds.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index accfb3b..112aff7 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -279,13 +279,14 @@ static void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 	struct ath_vif *avp = (void *)vif->drv_priv;
-	u64 tsfadjust;
+	u32 tsfadjust;
 
 	if (avp->av_bslot == 0)
 		return;
 
-	tsfadjust = cur_conf->beacon_interval * avp->av_bslot / ATH_BCBUF;
-	avp->tsf_adjust = cpu_to_le64(TU_TO_USEC(tsfadjust));
+	tsfadjust = cur_conf->beacon_interval * avp->av_bslot;
+	tsfadjust = TU_TO_USEC(tsfadjust) / ATH_BCBUF;
+	avp->tsf_adjust = cpu_to_le64(tsfadjust);
 
 	ath_dbg(common, CONFIG, "tsfadjust is: %llu for bslot: %d\n",
 		(unsigned long long)tsfadjust, avp->av_bslot);
-- 
1.8.3.4 (Apple Git-47)

