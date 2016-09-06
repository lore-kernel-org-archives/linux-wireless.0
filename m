Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8606 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754586AbcIFHJQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 03:09:16 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        "Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: advertize hardware packet loss mechanism
Date: Tue, 6 Sep 2016 12:38:41 +0530
Message-ID: <20160906070841.4266-1-rmanohar@qti.qualcomm.com> (sfid-20160906_090920_002490_85FF7F99)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Indicate hardware (or firmware) supports that CQM packet-loss report
will be generated based on station kickout algorithm. As of now mac80211
tracks connection loss by missing msdu counts (50) whereas ath10k
firmware tracks them by missing ppdus (+ BAR tries). While firmware is
trying to adapt its rate table, mac80211 might send out low_ack event to
hostapd. This is causing frequent connect and disconnect iteration under
noisy environment or when station is roaming around.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 79525f769db6..bae7662e7207 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7865,6 +7865,7 @@ int ath10k_mac_register(struct ath10k *ar)
 	ieee80211_hw_set(ar->hw, WANT_MONITOR_VIF);
 	ieee80211_hw_set(ar->hw, CHANCTX_STA_CSA);
 	ieee80211_hw_set(ar->hw, QUEUE_CONTROL);
+	ieee80211_hw_set(ar->hw, REPORTS_LOW_ACK);
 
 	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
 		ieee80211_hw_set(ar->hw, SW_CRYPTO_CONTROL);
-- 
2.9.3
