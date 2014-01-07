Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbaAGXPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:15:23 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 06/12] mac80211_hwsim: minimize rctbl module parameter usage
Date: Wed,  8 Jan 2014 00:15:11 +0100
Message-Id: <1389136517-21216-7-git-send-email-johannes@sipsolutions.net> (sfid-20140108_001534_450426_A3837343)
In-Reply-To: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
References: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Check the flag that the module parameter sets instead, so
later radios can use different parameters.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 421528e..5670ecb 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -802,7 +802,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	if (control->sta)
 		hwsim_check_sta_magic(control->sta);
 
-	if (rctbl)
+	if (hw->flags & IEEE80211_HW_SUPPORTS_RC_TABLE)
 		ieee80211_get_tx_rates(txi->control.vif, control->sta, skb,
 				       txi->control.rates,
 				       ARRAY_SIZE(txi->control.rates));
@@ -909,7 +909,7 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 {
 	u32 _pid = ACCESS_ONCE(wmediumd_portid);
 
-	if (rctbl) {
+	if (hw->flags & IEEE80211_HW_SUPPORTS_RC_TABLE) {
 		struct ieee80211_tx_info *txi = IEEE80211_SKB_CB(skb);
 		ieee80211_get_tx_rates(txi->control.vif, NULL, skb,
 				       txi->control.rates,
@@ -946,7 +946,7 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 	if (skb == NULL)
 		return;
 	info = IEEE80211_SKB_CB(skb);
-	if (rctbl)
+	if (hw->flags & IEEE80211_HW_SUPPORTS_RC_TABLE)
 		ieee80211_get_tx_rates(vif, NULL, skb,
 				       info->control.rates,
 				       ARRAY_SIZE(info->control.rates));
-- 
1.8.5.1

