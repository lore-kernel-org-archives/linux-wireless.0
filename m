Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10956 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab2ILNaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 09:30:17 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 6/6] ath9k: fix queuing MCI work twice
Date: Wed, 12 Sep 2012 18:59:24 +0530
Message-ID: <1347456564-8222-6-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120912_153020_783740_325EC45B)
In-Reply-To: <1347456564-8222-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1347456564-8222-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right now MCI work is being queued twice by profile and status
updation. Queue MCI work once when it is needed.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mci.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index fa859e3..8f51e9e 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -250,8 +250,8 @@ static void ath9k_mci_work(struct work_struct *work)
 	ath_mci_update_scheme(sc);
 }
 
-static void ath_mci_process_profile(struct ath_softc *sc,
-				    struct ath_mci_profile_info *info)
+static u8 ath_mci_process_profile(struct ath_softc *sc,
+				  struct ath_mci_profile_info *info)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_btcoex *btcoex = &sc->btcoex;
@@ -277,15 +277,15 @@ static void ath_mci_process_profile(struct ath_softc *sc,
 
 	if (info->start) {
 		if (!entry && !ath_mci_add_profile(common, mci, info))
-			return;
+			return 0;
 	} else
 		ath_mci_del_profile(common, mci, entry);
 
-	ieee80211_queue_work(sc->hw, &sc->mci_work);
+	return 1;
 }
 
-static void ath_mci_process_status(struct ath_softc *sc,
-				   struct ath_mci_profile_status *status)
+static u8 ath_mci_process_status(struct ath_softc *sc,
+				 struct ath_mci_profile_status *status)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_mci_profile *mci = &btcoex->mci;
@@ -294,14 +294,14 @@ static void ath_mci_process_status(struct ath_softc *sc,
 
 	/* Link status type are not handled */
 	if (status->is_link)
-		return;
+		return 0;
 
 	info.conn_handle = status->conn_handle;
 	if (ath_mci_find_profile(mci, &info))
-		return;
+		return 0;
 
 	if (status->conn_handle >= ATH_MCI_MAX_PROFILE)
-		return;
+		return 0;
 
 	if (status->is_critical)
 		__set_bit(status->conn_handle, mci->status);
@@ -315,7 +315,9 @@ static void ath_mci_process_status(struct ath_softc *sc,
 	} while (++i < ATH_MCI_MAX_PROFILE);
 
 	if (old_num_mgmt != mci->num_mgmt)
-		ieee80211_queue_work(sc->hw, &sc->mci_work);
+		return 1;
+
+	return 0;
 }
 
 static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
@@ -324,7 +326,7 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 	struct ath_mci_profile_info profile_info;
 	struct ath_mci_profile_status profile_status;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	u8 major, minor;
+	u8 major, minor, update_scheme = 0;
 	u32 seq_num;
 
 	if (ar9003_mci_state(ah, MCI_STATE_NEED_FLUSH_BT_INFO) &&
@@ -359,7 +361,7 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 			break;
 		}
 
-		ath_mci_process_profile(sc, &profile_info);
+		update_scheme += ath_mci_process_profile(sc, &profile_info);
 		break;
 	case MCI_GPM_COEX_BT_STATUS_UPDATE:
 		profile_status.is_link = *(rx_payload +
@@ -375,12 +377,14 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 			profile_status.is_link, profile_status.conn_handle,
 			profile_status.is_critical, seq_num);
 
-		ath_mci_process_status(sc, &profile_status);
+		update_scheme += ath_mci_process_status(sc, &profile_status);
 		break;
 	default:
 		ath_dbg(common, MCI, "Unknown GPM COEX message = 0x%02x\n", opcode);
 		break;
 	}
+	if (update_scheme)
+		ieee80211_queue_work(sc->hw, &sc->mci_work);
 }
 
 int ath_mci_setup(struct ath_softc *sc)
-- 
1.7.12

