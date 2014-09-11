Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48277 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaIKNfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 09:35:24 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	stable@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] Revert "ath9k: Calculate sleep duration"
Date: Thu, 11 Sep 2014 19:05:48 +0530
Message-Id: <1410442548-15782-1-git-send-email-sujith@msujith.org> (sfid-20140911_153528_193017_EFB789C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This reverts commit 09ebb810927a110e4c354beb20308830d108a54b.

ath9k_hw_set_sta_beacon_timers() configures AR_TIM_PERIOD with
the beacon interval. Before this commit, the sleepduration was
never greater than the beacon interval. But now, the behavior
has changed. For example, with an AP that uses a beacon interval of 100:

ath: phy9: next beacon 61128704
ath: phy9: beacon period 204800
ath: phy9: DTIM period 204800

If the sleepduration is calculated based on the listen time, then
the bmiss threshold should also be changed since the HW would
be in sleep state for a longer time, but that is not done currently.

To avoid configuring a higher beacon interval based on the sleepduration,
revert to the original behavior. Power consumption is not a
problem since PS is disabled in ath9k anyway.

Cc: stable@vger.kernel.org
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/common-beacon.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-beacon.c b/drivers/net/wireless/ath/ath9k/common-beacon.c
index 733be51..775d1d2 100644
--- a/drivers/net/wireless/ath/ath9k/common-beacon.c
+++ b/drivers/net/wireless/ath/ath9k/common-beacon.c
@@ -57,7 +57,7 @@ int ath9k_cmn_beacon_config_sta(struct ath_hw *ah,
 				 struct ath9k_beacon_state *bs)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	int dtim_intval, sleepduration;
+	int dtim_intval;
 	u64 tsf;
 
 	/* No need to configure beacon if we are not associated */
@@ -75,7 +75,6 @@ int ath9k_cmn_beacon_config_sta(struct ath_hw *ah,
 	 * last beacon we received (which may be none).
 	 */
 	dtim_intval = conf->intval * conf->dtim_period;
-	sleepduration = ah->hw->conf.listen_interval * conf->intval;
 
 	/*
 	 * Pull nexttbtt forward to reflect the current
@@ -113,7 +112,7 @@ int ath9k_cmn_beacon_config_sta(struct ath_hw *ah,
 	 */
 
 	bs->bs_sleepduration = TU_TO_USEC(roundup(IEEE80211_MS_TO_TU(100),
-						  sleepduration));
+						 conf->intval));
 	if (bs->bs_sleepduration > bs->bs_dtimperiod)
 		bs->bs_sleepduration = bs->bs_dtimperiod;
 
-- 
2.1.0

