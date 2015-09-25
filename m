Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7393 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbbIYIB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2015 04:01:27 -0400
From: Vivek Natarajan <nataraja@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: [PATCH v2] ath10k: Use station's current operating mode from assoc request
Date: Fri, 25 Sep 2015 13:31:08 +0530
Message-ID: <1443168068-5719-1-git-send-email-nataraja@qti.qualcomm.com> (sfid-20150925_100131_433048_C5253BF4)
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
v2: Fix commit message

 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bb44161..5acebf5 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2169,7 +2169,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 			arg->peer_ht_rates.rates[i] = i;
 	} else {
 		arg->peer_ht_rates.num_rates = n;
-		arg->peer_num_spatial_streams = max_nss;
+		arg->peer_num_spatial_streams = min(sta->rx_nss, max_nss);
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac ht peer %pM mcs cnt %d nss %d\n",
-- 
1.9.1

