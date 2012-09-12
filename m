Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27233 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2ILGyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 02:54:53 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 4/5] ath9k: move coex param updation within mci work
Date: Wed, 12 Sep 2012 12:23:52 +0530
Message-ID: <1347432833-10343-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120912_085459_468605_D9149716)
In-Reply-To: <1347432833-10343-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1347432833-10343-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update all coex parameters in sigle place. So that we can avoid
redoing the same operation in mutiple places and it eases debugging.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mci.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 3a400c8..637e809 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -122,6 +122,12 @@ static void ath_mci_update_scheme(struct ath_softc *sc)
 		goto skip_tuning;
 
 	btcoex->duty_cycle = ath_mci_duty_cycle[num_profile];
+	btcoex->btcoex_period = ATH_MCI_DEF_BT_PERIOD;
+	if (NUM_PROF(mci))
+		btcoex->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+	else
+		btcoex->bt_stomp_type = mci->num_mgmt ? ATH_BTCOEX_STOMP_ALL :
+							ATH_BTCOEX_STOMP_LOW;
 
 	if (num_profile == 1) {
 		info = list_first_entry(&mci->info,
@@ -133,7 +139,8 @@ static void ath_mci_update_scheme(struct ath_softc *sc)
 			else if (info->T == 6) {
 				mci->aggr_limit = 6;
 				btcoex->duty_cycle = 30;
-			}
+			} else
+				mci->aggr_limit = 6;
 			ath_dbg(common, MCI,
 				"Single SCO, aggregation limit %d 1/4 ms\n",
 				mci->aggr_limit);
@@ -273,16 +280,6 @@ static void ath_mci_process_profile(struct ath_softc *sc,
 	} else
 		ath_mci_del_profile(common, mci, entry);
 
-	btcoex->btcoex_period = ATH_MCI_DEF_BT_PERIOD;
-	mci->aggr_limit = mci->num_sco ? 6 : 0;
-
-	btcoex->duty_cycle = ath_mci_duty_cycle[NUM_PROF(mci)];
-	if (NUM_PROF(mci))
-		btcoex->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
-	else
-		btcoex->bt_stomp_type = mci->num_mgmt ? ATH_BTCOEX_STOMP_ALL :
-							ATH_BTCOEX_STOMP_LOW;
-
 	ieee80211_queue_work(sc->hw, &sc->mci_work);
 }
 
-- 
1.7.12

