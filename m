Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:42254 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbbBYMpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 07:45:54 -0500
Received: by lbiw7 with SMTP id w7so3525585lbi.9
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 04:45:53 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFCv2 4/4] ath10k: add WOW patterns support
Date: Wed, 25 Feb 2015 13:44:58 +0100
Message-Id: <1424868298-17372-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150225_134600_046841_0E81312F)
In-Reply-To: <1424868298-17372-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1424868298-17372-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add patterns support for WOW.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c    |  1 +
 drivers/net/wireless/ath/ath10k/hw.h      |  1 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |  4 +++
 drivers/net/wireless/ath/ath10k/wow.c     | 49 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wow.h     |  1 +
 6 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 39bf8fb..5bcf83ff 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -972,6 +972,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_num_stations = TARGET_TLV_NUM_STATIONS;
 		ar->max_num_vdevs = TARGET_TLV_NUM_VDEVS;
 		ar->htt.max_num_pending_tx = TARGET_TLV_NUM_MSDU_DESC;
+		ar->wow.max_num_patterns = TARGET_TLV_NUM_WOW_PATTERNS;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 460771f..a06291b 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -263,6 +263,7 @@ struct ath10k_pktlog_hdr {
 						 2)
 #define TARGET_TLV_NUM_TIDS			((TARGET_TLV_NUM_PEERS) * 2)
 #define TARGET_TLV_NUM_MSDU_DESC		(1024 + 32)
+#define TARGET_TLV_NUM_WOW_PATTERNS		22
 
 /* Number of Copy Engines supported */
 #define CE_COUNT 8
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index deed5da..d8e20c6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1229,7 +1229,7 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->num_tdls_conn_table_entries = __cpu_to_le32(0x20);
 	cfg->beacon_tx_offload_max_vdev = __cpu_to_le32(2);
 	cfg->num_multicast_filter_entries = __cpu_to_le32(5);
-	cfg->num_wow_filters = __cpu_to_le32(0x16);
+	cfg->num_wow_filters = __cpu_to_le32(ar->wow.max_num_patterns);
 	cfg->num_keep_alive_pattern = __cpu_to_le32(6);
 	cfg->keep_alive_pattern_size = __cpu_to_le32(0);
 	cfg->max_tdls_concurrent_sleep_sta = __cpu_to_le32(1);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 7e0c9eb..b985dfd 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5005,6 +5005,10 @@ struct wmi_wow_ev_arg {
 	u32 data_len;
 };
 
+#define WOW_MIN_PATTERN_SIZE	1
+#define WOW_MAX_PATTERN_SIZE	148
+#define WOW_MAX_PKT_OFFSET	128
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
diff --git a/drivers/net/wireless/ath/ath10k/wow.c b/drivers/net/wireless/ath/ath10k/wow.c
index 77c2b4d..5c95fa4 100644
--- a/drivers/net/wireless/ath/ath10k/wow.c
+++ b/drivers/net/wireless/ath/ath10k/wow.c
@@ -23,9 +23,15 @@
 #include "wmi.h"
 #include "wmi-ops.h"
 
-static const struct wiphy_wowlan_support ath10k_wowlan_support = {
+static struct wiphy_wowlan_support ath10k_wowlan_support = {
 	.flags = WIPHY_WOWLAN_DISCONNECT |
 		 WIPHY_WOWLAN_MAGIC_PKT,
+	/* .n_patterns is set during driver runtime
+	 * per hw/fw capabilities
+	 */
+	.pattern_min_len = WOW_MIN_PATTERN_SIZE,
+	.pattern_max_len = WOW_MAX_PATTERN_SIZE,
+	.max_pkt_offset = WOW_MAX_PKT_OFFSET,
 };
 
 static int ath10k_wow_vif_cleanup(struct ath10k_vif *arvif)
@@ -42,6 +48,15 @@ static int ath10k_wow_vif_cleanup(struct ath10k_vif *arvif)
 		}
 	}
 
+	for (i = 0; i < ar->wow.max_num_patterns; i++) {
+		ret = ath10k_wmi_wow_del_pattern(ar, arvif->vdev_id, i);
+		if (ret) {
+			ath10k_warn(ar, "failed to delete wow pattern %d for vdev %i: %d\n",
+				    i, arvif->vdev_id, ret);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
@@ -70,6 +85,8 @@ static int ath10k_vif_wow_set_wakeups(struct ath10k_vif *arvif,
 	int ret, i;
 	unsigned long wow_mask = 0;
 	struct ath10k *ar = arvif->ar;
+	const struct cfg80211_pkt_pattern *patterns = wowlan->patterns;
+	int pattern_id = 0;
 
 	/* Setup requested WOW features */
 	switch (arvif->vdev_type) {
@@ -100,6 +117,35 @@ static int ath10k_vif_wow_set_wakeups(struct ath10k_vif *arvif,
 		break;
 	}
 
+	for (i = 0; i < wowlan->n_patterns; i++) {
+		u8 bitmask[WOW_MAX_PATTERN_SIZE] = {};
+		int j;
+
+		if (patterns[i].pattern_len > WOW_MAX_PATTERN_SIZE)
+			continue;
+
+		/* convert bytemask to bitmask */
+		for (j = 0; j < patterns[i].pattern_len; j++)
+			if (patterns[i].mask[j/8] & BIT(j%8))
+				bitmask[j] = 0xff;
+
+		ret = ath10k_wmi_wow_add_pattern(ar, arvif->vdev_id,
+						 pattern_id,
+						 patterns[i].pattern,
+						 bitmask,
+						 patterns[i].pattern_len,
+						 patterns[i].pkt_offset);
+		if (ret) {
+			ath10k_warn(ar, "failed to add pattern %i to vdev %i: %d\n",
+				    pattern_id,
+				    arvif->vdev_id, ret);
+			return ret;
+		}
+
+		pattern_id++;
+		__set_bit(WOW_PATTERN_MATCH_EVENT, &wow_mask);
+	}
+
 	for (i = 0; i < WOW_EVENT_MAX; i++) {
 		if (!test_bit(i, &wow_mask))
 			continue;
@@ -274,6 +320,7 @@ int ath10k_wow_init(struct ieee80211_hw *hw)
 	if (!test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT, ar->fw_features))
 		return 0;
 
+	ath10k_wowlan_support.n_patterns = ar->wow.max_num_patterns;
 	ar->hw->wiphy->wowlan = &ath10k_wowlan_support;
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/wow.h b/drivers/net/wireless/ath/ath10k/wow.h
index 32b724a..6c8bfe0 100644
--- a/drivers/net/wireless/ath/ath10k/wow.h
+++ b/drivers/net/wireless/ath/ath10k/wow.h
@@ -17,6 +17,7 @@
 #define _WOW_H_
 
 struct ath10k_wow {
+	u32 max_num_patterns;
 	struct completion wakeup_completed;
 };
 
-- 
1.9.1

