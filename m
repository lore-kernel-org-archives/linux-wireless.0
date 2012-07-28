Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16428 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2G1BNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 21:13:35 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: reconfigure RSN capabilities when restarting AP
Date: Fri, 27 Jul 2012 18:13:27 -0700
Message-ID: <1343438007-5252-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120728_031341_371291_E7DEE58F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the firmware decides to initiate a channel switch on an AP vif
running an RSN BSS, reconfigure the saved RSN IE capabilities as well.

Fixes a bug where the beacon and 4-way handshake would have a capability
mismatch after a channel switch, since the firmware apparently clears
these on an AP disconnect.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    1 +
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/main.c     |   12 ++++++++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c8716df..94acde8 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2883,6 +2883,7 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 					    WLAN_EID_RSN, WMI_RSN_IE_CAPB,
 					    (const u8 *) &rsn_capab,
 					    sizeof(rsn_capab));
+		vif->rsn_capab = rsn_capab;
 		if (res < 0)
 			return res;
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index baf149e..a95bf6a 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -605,6 +605,7 @@ struct ath6kl_vif {
 	struct net_device_stats net_stats;
 	struct target_stats target_stats;
 	struct wmi_connect_cmd profile;
+	u16 rsn_capab;
 
 	struct list_head mc_filter;
 };
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index eca4d47..9533558 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -608,6 +608,18 @@ static int ath6kl_commit_ch_switch(struct ath6kl_vif *vif, u16 channel)
 
 	switch (vif->nw_type) {
 	case AP_NETWORK:
+		/*
+		 * reconfigure any saved RSN IE capabilites in the beacon /
+		 * probe response to stay in sync with the supplicant.
+		 */
+		if (vif->rsn_capab &&
+		    test_bit(ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE,
+			     ar->fw_capabilities))
+			ath6kl_wmi_set_ie_cmd(ar->wmi, vif->fw_vif_idx,
+					      WLAN_EID_RSN, WMI_RSN_IE_CAPB,
+					      (const u8 *) &vif->rsn_capab,
+					      sizeof(vif->rsn_capab));
+
 		return ath6kl_wmi_ap_profile_commit(ar->wmi, vif->fw_vif_idx,
 						    &vif->profile);
 	default:
-- 
1.7.4.1

