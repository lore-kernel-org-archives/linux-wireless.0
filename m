Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47708 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752447AbeC1NEh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 09:04:37 -0400
From: mpubbise@codeaurora.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [PATCH] mac80211: allow AP_VLAN operation on crypto controlled devices
Date: Wed, 28 Mar 2018 18:34:19 +0530
Message-Id: <1522242259-16166-1-git-send-email-mpubbise@codeaurora.org> (sfid-20180328_150441_720201_36719BEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <mpubbise@codeaurora.org>

In the current implementation, mac80211 advertises the support of
AP_VLANs based on the driver's support for AP mode; it also
blocks encrypted AP_VLAN operation on devices advertising
SW_CRYPTO_CONTROL.

The implementation seems weird in it's current form and could be
often confusing, this is because there can be drivers advertising
both SW_CRYPTO_CONTROL and AP mode support (ex: ath10k) in which case
AP_VLAN will still be supported but only in open BSS and not in
secured BSS.

When SW_CRYPTO_CONTROL is enabled, it makes more sense if the decision
to support AP_VLANs is left to the driver. Mac80211 can then allow
AP_VLAN operations depending on the driver support.

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
 net/mac80211/key.c  | 8 +++++---
 net/mac80211/main.c | 8 ++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index aee05ec..ee0d0cc 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -126,7 +126,7 @@ static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata,
 
 static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = key->sdata;
 	struct sta_info *sta;
 	int ret = -EOPNOTSUPP;
 
@@ -162,7 +162,6 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	if (sta && !sta->uploaded)
 		goto out_unsupported;
 
-	sdata = key->sdata;
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		/*
 		 * The driver doesn't know anything about VLAN interfaces.
@@ -214,8 +213,11 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		/* all of these we can do in software - if driver can */
 		if (ret == 1)
 			return 0;
-		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL))
+		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL)) {
+			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+				return 0;
 			return -EINVAL;
+		}
 		return 0;
 	default:
 		return -EINVAL;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0785d04..8d0333b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -930,8 +930,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			             IEEE80211_HT_CAP_SM_PS_SHIFT;
 	}
 
-	/* if low-level driver supports AP, we also support VLAN */
-	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
+	/* if low-level driver supports AP, we also support VLAN.
+	 * drivers advertising SW_CRYPTO_CONTROL should enable AP_VLAN
+	 * based on their support to transmit SW encrypted packets.
+	 */
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP) &&
+	    !ieee80211_hw_check(&local->hw, SW_CRYPTO_CONTROL)) {
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
 		hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);
 	}
-- 
2.7.4
