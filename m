Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41560 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbbBPFR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 00:17:27 -0500
Received: from [117.222.159.239] (port=14037 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YNE3i-000EUz-Da
	for linux-wireless@vger.kernel.org; Mon, 16 Feb 2015 00:17:27 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 8/9] ath9k: Fix GPM initialization
Date: Mon, 16 Feb 2015 10:50:00 +0530
Message-Id: <1424064001-7009-9-git-send-email-sujith@msujith.org> (sfid-20150216_061732_983386_75ED9AD1)
In-Reply-To: <1424064001-7009-1-git-send-email-sujith@msujith.org>
References: <1424064001-7009-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Handle MCI_STATE_INIT_GPM_OFFSET separately and do not
overload ar9003_mci_get_next_gpm_offset() with a special
case.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 27 +++++++++++++--------------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |  2 +-
 drivers/net/wireless/ath/ath9k/mci.c        |  5 ++---
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 505dfe3..133b867 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -593,7 +593,7 @@ static u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
 		if (!time_out)
 			break;
 
-		offset = ar9003_mci_get_next_gpm_offset(ah, false, &more_data);
+		offset = ar9003_mci_get_next_gpm_offset(ah, &more_data);
 
 		if (offset == MCI_GPM_INVALID)
 			continue;
@@ -657,7 +657,7 @@ static u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
 		time_out = 0;
 
 	while (more_data == MCI_GPM_MORE) {
-		offset = ar9003_mci_get_next_gpm_offset(ah, false, &more_data);
+		offset = ar9003_mci_get_next_gpm_offset(ah, &more_data);
 		if (offset == MCI_GPM_INVALID)
 			break;
 
@@ -986,7 +986,8 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	regval &= ~SM(1, AR_MCI_COMMAND2_RESET_RX);
 	REG_WRITE(ah, AR_MCI_COMMAND2, regval);
 
-	ar9003_mci_get_next_gpm_offset(ah, true, NULL);
+	/* Init GPM offset after MCI Reset Rx */
+	ar9003_mci_state(ah, MCI_STATE_INIT_GPM_OFFSET);
 
 	REG_WRITE(ah, AR_MCI_MSG_ATTRIBUTES_TABLE,
 		  (SM(0xe801, AR_MCI_MSG_ATTRIBUTES_TABLE_INVALID_HDR) |
@@ -1280,6 +1281,14 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
 		}
 		value &= AR_BTCOEX_CTRL_MCI_MODE_EN;
 		break;
+	case MCI_STATE_INIT_GPM_OFFSET:
+		value = MS(REG_READ(ah, AR_MCI_GPM_1), AR_MCI_GPM_WRITE_PTR);
+
+		if (value < mci->gpm_len)
+			mci->gpm_idx = value;
+		else
+			mci->gpm_idx = 0;
+		break;
 	case MCI_STATE_LAST_SCHD_MSG_OFFSET:
 		value = MS(REG_READ(ah, AR_MCI_RX_STATUS),
 				    AR_MCI_RX_LAST_SCHD_MSG_INDEX);
@@ -1426,21 +1435,11 @@ void ar9003_mci_check_gpm_offset(struct ath_hw *ah)
 	mci->gpm_idx = 0;
 }
 
-u32 ar9003_mci_get_next_gpm_offset(struct ath_hw *ah, bool first, u32 *more)
+u32 ar9003_mci_get_next_gpm_offset(struct ath_hw *ah, u32 *more)
 {
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	u32 offset, more_gpm = 0, gpm_ptr;
 
-	if (first) {
-		gpm_ptr = MS(REG_READ(ah, AR_MCI_GPM_1), AR_MCI_GPM_WRITE_PTR);
-
-		if (gpm_ptr >= mci->gpm_len)
-			gpm_ptr = 0;
-
-		mci->gpm_idx = gpm_ptr;
-		return gpm_ptr;
-	}
-
 	/*
 	 * This could be useful to avoid new GPM message interrupt which
 	 * may lead to spurious interrupt after power sleep, or multiple
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 174ebea..e288611 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -312,7 +312,7 @@ int ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
 void ar9003_mci_cleanup(struct ath_hw *ah);
 void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
 			      u32 *rx_msg_intr);
-u32 ar9003_mci_get_next_gpm_offset(struct ath_hw *ah, bool first, u32 *more);
+u32 ar9003_mci_get_next_gpm_offset(struct ath_hw *ah, u32 *more);
 void ar9003_mci_set_bt_version(struct ath_hw *ah, u8 major, u8 minor);
 void ar9003_mci_send_wlan_channels(struct ath_hw *ah);
 /*
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 3f7a11e..66596b9 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -495,7 +495,7 @@ void ath_mci_intr(struct ath_softc *sc)
 	ar9003_mci_get_interrupt(sc->sc_ah, &mci_int, &mci_int_rxmsg);
 
 	if (ar9003_mci_state(ah, MCI_STATE_ENABLE) == 0) {
-		ar9003_mci_get_next_gpm_offset(ah, true, NULL);
+		ar9003_mci_state(ah, MCI_STATE_INIT_GPM_OFFSET);
 		return;
 	}
 
@@ -559,8 +559,7 @@ void ath_mci_intr(struct ath_softc *sc)
 				return;
 
 			pgpm = mci->gpm_buf.bf_addr;
-			offset = ar9003_mci_get_next_gpm_offset(ah, false,
-								&more_data);
+			offset = ar9003_mci_get_next_gpm_offset(ah, &more_data);
 
 			if (offset == MCI_GPM_INVALID)
 				break;
-- 
2.3.0

