Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2754 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab2HXK5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 06:57:15 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH v2] ath9k_hw: small optimization
Date: Fri, 24 Aug 2012 16:27:06 +0530
Message-ID: <1345805826-6291-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120824_125717_838024_D2862FC6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Assign the MCI BT state locally, rather than unnecessarily calling
ar9003_mci_state and updating it.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |    6 ------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |    2 --
 drivers/net/wireless/ath/ath9k/mci.c        |    2 +-
 3 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 9a34fca..ff53091 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1201,12 +1201,6 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
 
 		ar9003_mci_2g5g_switch(ah, false);
 		break;
-	case MCI_STATE_SET_BT_CAL_START:
-		mci->bt_state = MCI_BT_CAL_START;
-		break;
-	case MCI_STATE_SET_BT_CAL:
-		mci->bt_state = MCI_BT_CAL;
-		break;
 	case MCI_STATE_RESET_REQ_WAKE:
 		ar9003_mci_reset_req_wakeup(ah);
 		mci->update_2g5g = true;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index d33b8e1..f3bef8d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -190,8 +190,6 @@ enum mci_bt_state {
 enum mci_state_type {
 	MCI_STATE_ENABLE,
 	MCI_STATE_SET_BT_AWAKE,
-	MCI_STATE_SET_BT_CAL_START,
-	MCI_STATE_SET_BT_CAL,
 	MCI_STATE_LAST_SCHD_MSG_OFFSET,
 	MCI_STATE_REMOTE_SLEEP,
 	MCI_STATE_RESET_REQ_WAKE,
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index fb536e7..9ee1f89 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -201,7 +201,7 @@ static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 	switch (opcode) {
 	case MCI_GPM_BT_CAL_REQ:
 		if (mci_hw->bt_state == MCI_BT_AWAKE) {
-			ar9003_mci_state(ah, MCI_STATE_SET_BT_CAL_START);
+			mci_hw->bt_state = MCI_BT_CAL_START;
 			ath9k_queue_reset(sc, RESET_TYPE_MCI);
 		}
 		ath_dbg(common, MCI, "MCI State : %d\n", mci_hw->bt_state);
-- 
1.7.0.4

