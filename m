Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2INKaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 06:30:03 -0400
Received: by pbbrr13 with SMTP id rr13so5422790pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Sep 2012 03:30:03 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath5k: disable HW crypto in management frame
Date: Fri, 14 Sep 2012 18:26:11 +0800
Message-Id: <1347618371-31546-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120914_123010_026072_C1F0A5F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware support for MFP is not available in ath5k. Thus,
this implementation allows the mac80211 stack to do the
actuall crypto operation.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c         |    1 +
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a0a202d..9fd6d9a 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2446,6 +2446,7 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 			IEEE80211_HW_SIGNAL_DBM |
+			IEEE80211_HW_MFP_CAPABLE |
 			IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	hw->wiphy->interface_modes =
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index df61a09..0f34086 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -489,6 +489,9 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (ath5k_modparam_nohwcrypt)
 		return -EOPNOTSUPP;
 
+	if (key->flags & IEEE80211_KEY_FLAG_RX_MGMT)
+		return -EOPNOTSUPP;
+
 	if (vif->type == NL80211_IFTYPE_ADHOC &&
 	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
 	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
-- 
1.7.0.4

