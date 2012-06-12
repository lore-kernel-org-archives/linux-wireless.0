Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4501 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab2FLOs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 10:48:26 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 8/8] ath9k_hw: remove MCI_STATE_SET_BT_SLEEP
Date: Tue, 12 Jun 2012 20:18:23 +0530
Message-ID: <1339512503-26670-9-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120612_164829_921001_009B25E6)
In-Reply-To: <1339512503-26670-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339512503-26670-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |    3 ---
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |    1 -
 drivers/net/wireless/ath/ath9k/mci.c        |    2 +-
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 25f99ef..cc2853a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1191,9 +1191,6 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
 			   AR_MCI_RX_REMOTE_SLEEP) ?
 			MCI_BT_SLEEP : MCI_BT_AWAKE;
 		break;
-	case MCI_STATE_SET_BT_SLEEP:
-		mci->bt_state = MCI_BT_SLEEP;
-		break;
 	case MCI_STATE_SET_BT_AWAKE:
 		mci->bt_state = MCI_BT_AWAKE;
 		ar9003_mci_send_coex_version_query(ah, true);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 98bfc62..d33b8e1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -189,7 +189,6 @@ enum mci_bt_state {
 /* Type of state query */
 enum mci_state_type {
 	MCI_STATE_ENABLE,
-	MCI_STATE_SET_BT_SLEEP,
 	MCI_STATE_SET_BT_AWAKE,
 	MCI_STATE_SET_BT_CAL_START,
 	MCI_STATE_SET_BT_CAL,
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index e83d720..7d34a50 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -455,7 +455,7 @@ void ath_mci_intr(struct ath_softc *sc)
 		if ((mci_hw->bt_state == MCI_BT_AWAKE) &&
 		    (ar9003_mci_state(ah, MCI_STATE_REMOTE_SLEEP) !=
 		     MCI_BT_AWAKE))
-			ar9003_mci_state(ah, MCI_STATE_SET_BT_SLEEP);
+			mci_hw->bt_state = MCI_BT_SLEEP;
 	}
 
 	if ((mci_int & AR_MCI_INTERRUPT_RX_INVALID_HDR) ||
-- 
1.7.10.4

