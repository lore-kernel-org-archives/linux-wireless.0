Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45773 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280AbaFZLYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 07:24:00 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 3/3] ath9k: Calculate sleep duration
Date: Thu, 26 Jun 2014 16:54:42 +0530
Message-ID: <1403781882-468-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140626_132404_499406_C1A4C9CA)
In-Reply-To: <1403781882-468-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1403781882-468-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right now sleep duration is configured as beacon interval. It should be
the multiple of beacon interval by listen period which helps to
reduce station power consumption.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/common-beacon.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-beacon.c b/drivers/net/wireless/ath/ath9k/common-beacon.c
index 775d1d2..733be51 100644
--- a/drivers/net/wireless/ath/ath9k/common-beacon.c
+++ b/drivers/net/wireless/ath/ath9k/common-beacon.c
@@ -57,7 +57,7 @@ int ath9k_cmn_beacon_config_sta(struct ath_hw *ah,
 				 struct ath9k_beacon_state *bs)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	int dtim_intval;
+	int dtim_intval, sleepduration;
 	u64 tsf;
 
 	/* No need to configure beacon if we are not associated */
@@ -75,6 +75,7 @@ int ath9k_cmn_beacon_config_sta(struct ath_hw *ah,
 	 * last beacon we received (which may be none).
 	 */
 	dtim_intval = conf->intval * conf->dtim_period;
+	sleepduration = ah->hw->conf.listen_interval * conf->intval;
 
 	/*
 	 * Pull nexttbtt forward to reflect the current
@@ -112,7 +113,7 @@ int ath9k_cmn_beacon_config_sta(struct ath_hw *ah,
 	 */
 
 	bs->bs_sleepduration = TU_TO_USEC(roundup(IEEE80211_MS_TO_TU(100),
-						 conf->intval));
+						  sleepduration));
 	if (bs->bs_sleepduration > bs->bs_dtimperiod)
 		bs->bs_sleepduration = bs->bs_dtimperiod;
 
-- 
2.0.0

