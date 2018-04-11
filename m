Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f201.google.com ([209.85.216.201]:49848 "EHLO
        mail-qt0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754963AbeDKSmJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Apr 2018 14:42:09 -0400
Received: by mail-qt0-f201.google.com with SMTP id k23so1904926qtj.16
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2018 11:42:08 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 11 Apr 2018 11:41:56 -0700
Message-Id: <20180411184156.167978-1-rkir@google.com> (sfid-20180411_204216_557611_3BD461A7)
Subject: [PATCH] ANDROID: mac80211_hwsim: support/ignore power state changes
From: rkir@google.com
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        bjoernj@google.com, lfy@google.com, rkir@google.com
Cc: Bjoern Johansson <bjoernj@google.com>,
        Lingfeng Yang <lfy@google.com>,
        Roman Kiryanov <rkir@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bjoern Johansson <bjoernj@google.com>

Indicate support for power state changes and handle them by calling an
empty function.
The important part is "ieee80211_hw_set(hw, SUPPORTS_PS);" at the
bottom of the diff. Without this upper layers in the kernel will return an
error code when trying to set the power state because the driver doesn't
indicate power state support. This in turn causes VTS
(Android Vendor Test Suite) failures because the WiFi HAL can't enable
power saving mode. The remaining code is just there to deal with the
incoming state change request.

Signed-off-by: Bjoern Johansson <bjoernj@google.com>
Signed-off-by: Lingfeng Yang <lfy@google.com>
Signed-off-by: Roman Kiryanov <rkir@google.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 6afe896e5cb8..ff4741188814 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1637,6 +1637,11 @@ static const char * const hwsim_chanwidths[] = {
 	[NL80211_CHAN_WIDTH_160] = "vht160",
 };
 
+static void mac80211_power_state_changed(bool enabled)
+{
+	/* TODO: Do something when the power state changes */
+}
+
 static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
@@ -1649,6 +1654,12 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	};
 	int idx;
 
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		bool enabled = (conf->flags & IEEE80211_CONF_PS) != 0;
+
+		mac80211_power_state_changed(enabled);
+	}
+
 	if (conf->chandef.chan)
 		wiphy_dbg(hw->wiphy,
 			  "%s (freq=%d(%d - %d)/%s idle=%d ps=%d smps=%s)\n",
@@ -2650,7 +2661,9 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, MFP_CAPABLE);
 	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, SUPPORTS_PS);
 	ieee80211_hw_set(hw, TDLS_WIDER_BW);
+
 	if (rctbl)
 		ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
 
-- 
2.17.0.484.g0c8726318c-goog
