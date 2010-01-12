Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58842 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0ALMtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:49:16 -0500
Date: Tue, 12 Jan 2010 13:49:15 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 10/17] mwl8k: handle 5 GHz legacy rate bitmaps in firmware commands
Message-ID: <20100112124915.GZ1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever mac80211 gives us a legacy rate bitmap in the context of the
5 GHz band, we need to remember to shift the bitmap left by 5 positions
before giving it to the firmware, as the firmware follows the bitmap
bit assignment of the 2.4 GHz rate table even if we're on the 5 GHz
band, and the 2.4 GHz rate table includes five non-OFDM rates at the
start that are not valid in the 5 GHz band.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cc2ce61..e370245 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2836,6 +2836,7 @@ static int mwl8k_cmd_set_new_stn_add(struct ieee80211_hw *hw,
 				     struct ieee80211_sta *sta)
 {
 	struct mwl8k_cmd_set_new_stn *cmd;
+	u32 rates;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -2848,7 +2849,11 @@ static int mwl8k_cmd_set_new_stn_add(struct ieee80211_hw *hw,
 	memcpy(cmd->mac_addr, sta->addr, ETH_ALEN);
 	cmd->stn_id = cpu_to_le16(sta->aid);
 	cmd->action = cpu_to_le16(MWL8K_STA_ACTION_ADD);
-	cmd->legacy_rates = cpu_to_le32(sta->supp_rates[IEEE80211_BAND_2GHZ]);
+	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
+	else
+		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+	cmd->legacy_rates = cpu_to_le32(rates);
 	if (sta->ht_cap.ht_supported) {
 		cmd->ht_rates[0] = sta->ht_cap.mcs.rx_mask[0];
 		cmd->ht_rates[1] = sta->ht_cap.mcs.rx_mask[1];
@@ -2972,6 +2977,7 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 {
 	struct mwl8k_cmd_update_stadb *cmd;
 	struct peer_capability_info *p;
+	u32 rates;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -2990,8 +2996,11 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	p->ht_caps = sta->ht_cap.cap;
 	p->extended_ht_caps = (sta->ht_cap.ampdu_factor & 3) |
 		((sta->ht_cap.ampdu_density & 7) << 2);
-	legacy_rate_mask_to_array(p->legacy_rates,
-				  sta->supp_rates[IEEE80211_BAND_2GHZ]);
+	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
+	else
+		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+	legacy_rate_mask_to_array(p->legacy_rates, rates);
 	memcpy(p->ht_rates, sta->ht_cap.mcs.rx_mask, 16);
 	p->interop = 1;
 	p->amsdu_enabled = 0;
@@ -3345,7 +3354,12 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			goto out;
 		}
 
-		ap_legacy_rates = ap->supp_rates[IEEE80211_BAND_2GHZ];
+		if (hw->conf.channel->band == IEEE80211_BAND_2GHZ) {
+			ap_legacy_rates = ap->supp_rates[IEEE80211_BAND_2GHZ];
+		} else {
+			ap_legacy_rates =
+				ap->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+		}
 		memcpy(ap_mcs_rates, ap->ht_cap.mcs.rx_mask, 16);
 
 		rcu_read_unlock();
@@ -3422,7 +3436,13 @@ mwl8k_bss_info_changed_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		 * beacons will always go out at 1 Mb/s).
 		 */
 		idx = ffs(vif->bss_conf.basic_rates);
-		rate = idx ? mwl8k_rates_24[idx - 1].hw_value : 2;
+		if (idx)
+			idx--;
+
+		if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+			rate = mwl8k_rates_24[idx].hw_value;
+		else
+			rate = mwl8k_rates_50[idx].hw_value;
 
 		mwl8k_cmd_use_fixed_rate_ap(hw, rate, rate);
 	}
-- 
1.5.6.4
