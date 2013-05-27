Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45288 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3E0JbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 05:31:19 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath10k: Use VHT MCS map given by firmware
Date: Mon, 27 May 2013 14:58:39 +0530
Message-Id: <1369646921-22278-1-git-send-email-sujith@msujith.org> (sfid-20130527_113122_811455_5C6B1966)
In-Reply-To: <20899.9846.857204.903600@gargle.gargle.HOWL>
References: <20899.9846.857204.903600@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The supported MCS set for VHT is calculated by the firmware based
on the RX chainmask/NSS supported by the chip, which could be
2x2 or 3x3. Instead of hardcoding support for 3-SS, use the map
given by the firmware directly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 20 +++++++-------------
 drivers/net/wireless/ath/ath10k/wmi.c  |  1 +
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 539336d..7b303c0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -266,6 +266,7 @@ struct ath10k {
 	u32 hw_max_tx_power;
 	u32 ht_cap_info;
 	u32 vht_cap_info;
+	u32 vht_supp_mcs;
 
 	struct targetdef *targetdef;
 	struct hostdef *hostdef;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2412161..74dc3f9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2793,23 +2793,17 @@ static const struct ieee80211_iface_combination ath10k_if_comb = {
 static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 {
 	struct ieee80211_sta_vht_cap vht_cap = {0};
-	u16 mcs_map;
 
 	vht_cap.vht_supported = 1;
+
+	/*
+	 * Currently the firmware sends
+	 * WMI_VHT_CAP_DEFAULT_ALL | WMI_VHT_CAP_RX_STBC_1SS.
+	 */
 	vht_cap.cap = ar->vht_cap_info;
 
-	/* FIXME: check dynamically how many streams board supports */
-	mcs_map = IEEE80211_VHT_MCS_SUPPORT_0_9 << 0 |
-		IEEE80211_VHT_MCS_SUPPORT_0_9 << 2 |
-		IEEE80211_VHT_MCS_SUPPORT_0_9 << 4 |
-		IEEE80211_VHT_MCS_NOT_SUPPORTED << 6 |
-		IEEE80211_VHT_MCS_NOT_SUPPORTED << 8 |
-		IEEE80211_VHT_MCS_NOT_SUPPORTED << 10 |
-		IEEE80211_VHT_MCS_NOT_SUPPORTED << 12 |
-		IEEE80211_VHT_MCS_NOT_SUPPORTED << 14;
-
-	vht_cap.vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
-	vht_cap.vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
+	vht_cap.vht_mcs.rx_mcs_map = cpu_to_le16(ar->vht_supp_mcs);
+	vht_cap.vht_mcs.tx_mcs_map = cpu_to_le16(ar->vht_supp_mcs);
 
 	return vht_cap;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 7d4b798..df15a82 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -854,6 +854,7 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 	ar->hw_max_tx_power = __le32_to_cpu(ev->hw_max_tx_power);
 	ar->ht_cap_info = __le32_to_cpu(ev->ht_cap_info);
 	ar->vht_cap_info = __le32_to_cpu(ev->vht_cap_info);
+	ar->vht_supp_mcs = __le32_to_cpu(ev->vht_supp_mcs);
 	ar->fw_version_major =
 		(__le32_to_cpu(ev->sw_version) & 0xff000000) >> 24;
 	ar->fw_version_minor = (__le32_to_cpu(ev->sw_version) & 0x00ffffff);
-- 
1.8.3

