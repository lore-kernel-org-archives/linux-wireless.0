Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53583 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbbJ0MWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 08:22:08 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/4] ath10k: fill HT/VHT MCS rateset only for configured chainmask
Date: Tue, 27 Oct 2015 17:51:12 +0530
Message-ID: <1445948474-16738-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151027_132214_931247_3E73E647)
In-Reply-To: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HT/VHT MCS rateset should be filled only for configured chainmask
rather that max supported chainmask. Fix that by checking configured
chainmask while filling HT/VHT MCS rate map.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b4eb9fd..4e799d4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6972,7 +6972,7 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 
 	mcs_map = 0;
 	for (i = 0; i < 8; i++) {
-		if (i < ar->num_rf_chains)
+		if ((i < ar->num_rf_chains) && (ar->cfg_tx_chainmask & BIT(i)))
 			mcs_map |= IEEE80211_VHT_MCS_SUPPORT_0_9 << (i*2);
 		else
 			mcs_map |= IEEE80211_VHT_MCS_NOT_SUPPORTED << (i*2);
@@ -7039,8 +7039,10 @@ static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar)
 	if (ar->vht_cap_info & WMI_VHT_CAP_MAX_MPDU_LEN_MASK)
 		ht_cap.cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
-	for (i = 0; i < ar->num_rf_chains; i++)
-		ht_cap.mcs.rx_mask[i] = 0xFF;
+	for (i = 0; i < ar->num_rf_chains; i++) {
+		if (ar->cfg_rx_chainmask & BIT(i))
+			ht_cap.mcs.rx_mask[i] = 0xFF;
+	}
 
 	ht_cap.mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
 
-- 
2.6.2

