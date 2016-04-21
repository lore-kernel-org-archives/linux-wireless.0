Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbcDUNSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 09:18:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] ath10k: remove VHT capabilities from 2.4GHz
Date: Thu, 21 Apr 2016 16:17:49 +0300
Message-ID: <1461244669-19871-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20160421_151815_245155_C1FD0EB4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

According to the spec, VHT doesn't exist in 2.4GHz.

There are vendor extensions to allow a subset of VHT to work
(notably 256-QAM), but since mac80211 doesn't support those
advertising VHT capability on 2.4GHz leads to the behaviour
of reporting VHT capabilities but not being able to use any
of them due to mac80211's code requiring 80 MHz support.

Remove the VHT capabilities from 2.4GHz for now. If mac80211
gets extended to use the (likely Broadcom) vendor IEs for it
and handles the lack of 80 MHz support, it can be added back.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---

v2:

* Cc ath10k@lists.infradead.org

 drivers/net/wireless/ath/ath10k/mac.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bcf025f51310..d2a852805b07 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4276,9 +4276,6 @@ static void ath10k_mac_setup_ht_vht_cap(struct ath10k *ar)
 	if (ar->phy_capability & WHAL_WLAN_11G_CAPABILITY) {
 		band = &ar->mac.sbands[NL80211_BAND_2GHZ];
 		band->ht_cap = ht_cap;
-
-		/* Enable the VHT support at 2.4 GHz */
-		band->vht_cap = vht_cap;
 	}
 	if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY) {
 		band = &ar->mac.sbands[NL80211_BAND_5GHZ];
-- 
1.7.9.5

