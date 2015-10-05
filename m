Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41853 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbbJEQCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 12:02:24 -0400
From: Vivek Natarajan <nataraja@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: [PATCH v3] ath10k: Use station's current operating mode from assoc request
Date: Mon, 5 Oct 2015 21:32:08 +0530
Message-ID: <1444060928-5702-1-git-send-email-nataraja@qti.qualcomm.com> (sfid-20151005_180232_382647_76CF800F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current number of spatial streams used by the client is advertised
as a separate IE in assoc request. Use this information to set
the NSS operating mode.

Fixes: 45c9abc059fa ("ath10k: implement more versatile set_bitrate_mask").
Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>
---
v3: Fix max_nss type.

 drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 79490ad..32ad6f3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2084,7 +2084,8 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 	enum ieee80211_band band;
 	const u8 *ht_mcs_mask;
 	const u16 *vht_mcs_mask;
-	int i, n, max_nss;
+	int i, n;
+	u8 max_nss;
 	u32 stbc;
 
 	lockdep_assert_held(&ar->conf_mutex);
@@ -2169,7 +2170,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 			arg->peer_ht_rates.rates[i] = i;
 	} else {
 		arg->peer_ht_rates.num_rates = n;
-		arg->peer_num_spatial_streams = max_nss;
+		arg->peer_num_spatial_streams = min(sta->rx_nss, max_nss);
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac ht peer %pM mcs cnt %d nss %d\n",
-- 
1.9.1

