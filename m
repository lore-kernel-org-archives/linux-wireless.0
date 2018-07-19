Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44274 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731696AbeGSOKO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 10:10:14 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v2 3/3] ath10k: management tx ack rssi capability check
Date: Thu, 19 Jul 2018 18:56:29 +0530
Message-Id: <1532006789-32454-4-git-send-email-bpothuno@codeaurora.org> (sfid-20180719_152706_974046_A35360D2)
In-Reply-To: <1532006789-32454-1-git-send-email-bpothuno@codeaurora.org>
References: <1532006789-32454-1-git-send-email-bpothuno@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding WMI service check for management tx ack rssi support; this is
done to maintain common avg ack signal in user level for both data
and management tx ack packet.

Tested on QCA4019(fw version-10.4-3.2.1-00063).

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
Note: This patch depends on following patch
      https://patchwork.kernel.org/patch/10343153/
 
 drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1ebd9c63..70d8489 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8410,9 +8410,10 @@ int ath10k_mac_register(struct ath10k *ar)
 	wiphy_ext_feature_set(ar->hw->wiphy,
 			      NL80211_EXT_FEATURE_SET_SCAN_DWELL);
 
-	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
+	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map) ||
+	    test_bit(WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS, ar->wmi.svc_map))
 		wiphy_ext_feature_set(ar->hw->wiphy,
-				NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT);
+			NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT);
 
 	/*
 	 * on LL hardware queues are managed entirely by the FW
-- 
2.7.4
