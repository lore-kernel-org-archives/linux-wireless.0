Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6668 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3JVLLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 07:11:23 -0400
Date: Tue, 22 Oct 2013 14:11:17 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211_hwsim: Fix tracking of beaconing for multi-vif
Message-ID: <20131022111117.GA9983@jouni.qca.qualcomm.com> (sfid-20131022_131126_356367_D65BE582)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211_hwsim canceled beacon_timer on any vif changing from enabled
to disabled beaconing. This breaks cases where there are multiple
beaconing vifs and only one of them is removed. Fix this by tracking
beaconing status per vif and disable beacon_timer only if no active vif
remain with beaconing enabled.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2cd3f54..de0df86 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -167,6 +167,7 @@ struct hwsim_vif_priv {
 	u32 magic;
 	u8 bssid[ETH_ALEN];
 	bool assoc;
+	bool bcn_en;
 	u16 aid;
 };
 
@@ -1170,6 +1171,16 @@ static void mac80211_hwsim_configure_filter(struct ieee80211_hw *hw,
 	*total_flags = data->rx_filter;
 }
 
+static void mac80211_hwsim_bcn_en_iter(void *data, u8 *mac,
+				       struct ieee80211_vif *vif)
+{
+	unsigned int *count = data;
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+
+	if (vp->bcn_en)
+		(*count)++;
+}
+
 static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 					    struct ieee80211_vif *vif,
 					    struct ieee80211_bss_conf *info,
@@ -1180,7 +1191,8 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 
 	hwsim_check_magic(vif);
 
-	wiphy_debug(hw->wiphy, "%s(changed=0x%x)\n", __func__, changed);
+	wiphy_debug(hw->wiphy, "%s(changed=0x%x vif->addr=%pM)\n",
+		    __func__, changed, vif->addr);
 
 	if (changed & BSS_CHANGED_BSSID) {
 		wiphy_debug(hw->wiphy, "%s: BSSID changed: %pM\n",
@@ -1202,6 +1214,7 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		wiphy_debug(hw->wiphy, "  BCN EN: %d\n", info->enable_beacon);
+		vp->bcn_en = info->enable_beacon;
 		if (data->started &&
 		    !hrtimer_is_queued(&data->beacon_timer.timer) &&
 		    info->enable_beacon) {
@@ -1215,8 +1228,16 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 			tasklet_hrtimer_start(&data->beacon_timer,
 					      ns_to_ktime(until_tbtt * 1000),
 					      HRTIMER_MODE_REL);
-		} else if (!info->enable_beacon)
-			tasklet_hrtimer_cancel(&data->beacon_timer);
+		} else if (!info->enable_beacon) {
+			unsigned int count = 0;
+			ieee80211_iterate_active_interfaces(
+				data->hw, IEEE80211_IFACE_ITER_NORMAL,
+				mac80211_hwsim_bcn_en_iter, &count);
+			wiphy_debug(hw->wiphy, "  beaconing vifs remaining: %u",
+				    count);
+			if (count == 0)
+				tasklet_hrtimer_cancel(&data->beacon_timer);
+		}
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
