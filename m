Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38234 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbeIJLRF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 07:17:05 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v3] ath10k: management tx ack rssi capability check
Date: Mon, 10 Sep 2018 11:54:30 +0530
Message-Id: <1536560670-4292-1-git-send-email-bpothuno@codeaurora.org> (sfid-20180910_082443_005477_2BE2E4A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding WMI service check for management tx ack rssi support; this is
done to maintain common avg ack signal in user level for both data
and management tx ack packet.

Tested on QCA4019(fw version-10.4-3.2.1-00063).

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
v3:
 modified ack rssi support check to newly added command.
 cfg80211/mac80211 changes are already merged hence
 modified ath10k patch alone.

 drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 97548f9..84c6ecd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8479,9 +8479,10 @@ int ath10k_mac_register(struct ath10k *ar)
 	wiphy_ext_feature_set(ar->hw->wiphy,
 			      NL80211_EXT_FEATURE_SET_SCAN_DWELL);
 
-	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
+	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map) ||
+	    test_bit(WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS, ar->wmi.svc_map))
 		wiphy_ext_feature_set(ar->hw->wiphy,
-				      NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT);
+				      NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT);
 
 	/*
 	 * on LL hardware queues are managed entirely by the FW
-- 
2.7.4
