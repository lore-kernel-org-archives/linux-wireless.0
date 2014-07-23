Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:62483 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588AbaGWKHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 06:07:30 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so938603wes.20
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2014 03:07:28 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: don't advertise IBSS iftype for 10.x
Date: Wed, 23 Jul 2014 11:58:09 +0200
Message-Id: <1406109489-17928-1-git-send-email-michal.kazior@tieto.com> (sfid-20140723_120733_736909_067DB66E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 10.x firmware does not support IBSS mode at
all. It can't beacon and it crashes when trying to
scan.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3f9afaa..5122d1b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4700,7 +4700,6 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	ar->hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_AP);
 
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
@@ -4770,6 +4769,8 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->hw->wiphy->iface_combinations = ath10k_if_comb;
 		ar->hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(ath10k_if_comb);
+
+		ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
 	}
 
 	ar->hw->netdev_features = NETIF_F_HW_CSUM;
-- 
1.8.5.3

