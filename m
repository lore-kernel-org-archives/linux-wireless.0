Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4393 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab2FLOrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 10:47:48 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 4/8] ath9k_hw: remove MCI_STATE_NEED_FLUSH_BT_INFO
Date: Tue, 12 Jun 2012 20:18:19 +0530
Message-ID: <1339512503-26670-5-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120612_164750_970557_C9CF87FD)
In-Reply-To: <1339512503-26670-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339512503-26670-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |   17 -----------------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |    1 -
 2 files changed, 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 3b44ebe..9a761a1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1245,23 +1245,6 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 		query_type = MCI_GPM_COEX_QUERY_BT_TOPOLOGY;
 		ar9003_mci_send_coex_bt_status_query(ah, true, query_type);
 		break;
-	case MCI_STATE_NEED_FLUSH_BT_INFO:
-		/*
-		 * btcoex_hw.mci.unhalt_bt_gpm means whether it's
-		 * needed to send UNHALT message. It's set whenever
-		 * there's a request to send HALT message.
-		 * mci_halted_bt_gpm means whether HALT message is sent
-		 * out successfully.
-		 *
-		 * Checking (mci_unhalt_bt_gpm == false) instead of
-		 * checking (ah->mci_halted_bt_gpm == false) will make
-		 * sure currently is in UNHALT-ed mode and BT can
-		 * respond to status query.
-		 */
-		value = (!mci->unhalt_bt_gpm && mci->need_flush_btinfo) ? 1 : 0;
-		if (p_data)
-			mci->need_flush_btinfo = (*p_data != 0) ? true : false;
-		break;
 	case MCI_STATE_RECOVER_RX:
 		ar9003_mci_prep_interface(ah);
 		mci->query_bt = true;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 05f42a9..a7c17e5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -203,7 +203,6 @@ enum mci_state_type {
 	MCI_STATE_SEND_WLAN_COEX_VERSION,
 	MCI_STATE_SEND_VERSION_QUERY,
 	MCI_STATE_SEND_STATUS_QUERY,
-	MCI_STATE_NEED_FLUSH_BT_INFO,
 	MCI_STATE_SET_CONCUR_TX_PRI,
 	MCI_STATE_RECOVER_RX,
 	MCI_STATE_NEED_FTP_STOMP,
-- 
1.7.10.4

