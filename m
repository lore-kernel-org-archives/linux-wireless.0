Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4393 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2FLOrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 10:47:43 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/8] ath9k_hw: remove MCI_STATE_SEND_WLAN_CHANNELS
Date: Tue, 12 Jun 2012 20:18:18 +0530
Message-ID: <1339512503-26670-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120612_164746_804743_A2639C9F)
In-Reply-To: <1339512503-26670-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339512503-26670-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a MCI util function to send wlan channel info to BT.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |   25 +++++++++----------------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |    2 +-
 drivers/net/wireless/ath/ath9k/mci.c        |    2 +-
 3 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index a021e74..3b44ebe 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1238,22 +1238,6 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 	case MCI_STATE_SEND_WLAN_COEX_VERSION:
 		ar9003_mci_send_coex_version_response(ah, true);
 		break;
-	case MCI_STATE_SEND_WLAN_CHANNELS:
-		if (p_data) {
-			if (((mci->wlan_channels[1] & 0xffff0000) ==
-			     (*(p_data + 1) & 0xffff0000)) &&
-			    (mci->wlan_channels[2] == *(p_data + 2)) &&
-			    (mci->wlan_channels[3] == *(p_data + 3)))
-				break;
-
-			mci->wlan_channels[0] = *p_data++;
-			mci->wlan_channels[1] = *p_data++;
-			mci->wlan_channels[2] = *p_data++;
-			mci->wlan_channels[3] = *p_data++;
-		}
-		mci->wlan_channels_update = true;
-		ar9003_mci_send_coex_wlan_channels(ah, true);
-		break;
 	case MCI_STATE_SEND_VERSION_QUERY:
 		ar9003_mci_send_coex_version_query(ah, true);
 		break;
@@ -1453,3 +1437,12 @@ void ar9003_mci_set_bt_version(struct ath_hw *ah, u8 major, u8 minor)
 		mci->bt_ver_major, mci->bt_ver_minor);
 }
 EXPORT_SYMBOL(ar9003_mci_set_bt_version);
+
+void ar9003_mci_send_wlan_channels(struct ath_hw *ah)
+{
+	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+
+	mci->wlan_channels_update = true;
+	ar9003_mci_send_coex_wlan_channels(ah, true);
+}
+EXPORT_SYMBOL(ar9003_mci_send_wlan_channels);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index d4e7739..05f42a9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -201,7 +201,6 @@ enum mci_state_type {
 	MCI_STATE_CONT_TXRX,
 	MCI_STATE_RESET_REQ_WAKE,
 	MCI_STATE_SEND_WLAN_COEX_VERSION,
-	MCI_STATE_SEND_WLAN_CHANNELS,
 	MCI_STATE_SEND_VERSION_QUERY,
 	MCI_STATE_SEND_STATUS_QUERY,
 	MCI_STATE_NEED_FLUSH_BT_INFO,
@@ -263,6 +262,7 @@ void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
 			      u32 *rx_msg_intr);
 u32 ar9003_mci_get_next_gpm_offset(struct ath_hw *ah, bool first, u32 *more);
 void ar9003_mci_set_bt_version(struct ath_hw *ah, u8 major, u8 minor);
+void ar9003_mci_send_wlan_channels(struct ath_hw *ah);
 /*
  * These functions are used by ath9k_hw.
  */
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 6f4188a..dbc8e1d 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -312,7 +312,7 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 		ar9003_mci_set_bt_version(ah, major, minor);
 		break;
 	case MCI_GPM_COEX_STATUS_QUERY:
-		ar9003_mci_state(ah, MCI_STATE_SEND_WLAN_CHANNELS, NULL);
+		ar9003_mci_send_wlan_channels(ah);
 		break;
 	case MCI_GPM_COEX_BT_PROFILE_INFO:
 		memcpy(&profile_info,
-- 
1.7.10.4

