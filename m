Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47622 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbbDQPQF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 11:16:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/11] ath10k: enable IEEE80211_HW_SUPPORT_FAST_XMIT
Date: Fri, 17 Apr 2015 17:15:47 +0200
Message-Id: <1429283751-5104-7-git-send-email-johannes@sipsolutions.net> (sfid-20150417_171610_637358_3B690690)
In-Reply-To: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The driver can clearly enable fast-xmit since it does rate
control in the device and thus must do duration calculation
there as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 6fd7189b7b01..9c0c0a12a85a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5500,7 +5500,8 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_HAS_RATE_CONTROL |
 			IEEE80211_HW_AP_LINK_PS |
 			IEEE80211_HW_SPECTRUM_MGMT |
-			IEEE80211_HW_SW_CRYPTO_CONTROL;
+			IEEE80211_HW_SW_CRYPTO_CONTROL |
+			IEEE80211_HW_SUPPORT_FAST_XMIT;
 
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
 
-- 
2.1.4

