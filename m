Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25005 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab2ILN35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 09:29:57 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 4/6] ath9k: move coex param updation within mci work
Date: Wed, 12 Sep 2012 18:59:22 +0530
Message-ID: <1347456564-8222-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120912_153001_292367_E6DA1506)
In-Reply-To: <1347456564-8222-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1347456564-8222-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update all coex parameters in sigle place. So that we can avoid
redoing the same operation in mutiple places and it eases debugging.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mci.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 3a400c8..fa859e3 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -121,7 +121,14 @@ static void ath_mci_update_scheme(struct ath_softc *sc)
 	if (mci_hw->config & ATH_MCI_CONFIG_DISABLE_TUNING)
 		goto skip_tuning;
 
+	mci->aggr_limit = 0;
 	btcoex->duty_cycle = ath_mci_duty_cycle[num_profile];
+	btcoex->btcoex_period = ATH_MCI_DEF_BT_PERIOD;
+	if (NUM_PROF(mci))
+		btcoex->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+	else
+		btcoex->bt_stomp_type = mci->num_mgmt ? ATH_BTCOEX_STOMP_ALL :
+							ATH_BTCOEX_STOMP_LOW;
 
 	if (num_profile == 1) {
 		info = list_first_entry(&mci->info,
@@ -133,7 +140,8 @@ static void ath_mci_update_scheme(struct ath_softc *sc)
 			else if (info->T == 6) {
 				mci->aggr_limit = 6;
 				btcoex->duty_cycle = 30;
-			}
+			} else
+				mci->aggr_limit = 6;
 			ath_dbg(common, MCI,
 				"Single SCO, aggregation limit %d 1/4 ms\n",
 				mci->aggr_limit);
@@ -273,16 +281,6 @@ static void ath_mci_process_profile(struct ath_softc *sc,
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

