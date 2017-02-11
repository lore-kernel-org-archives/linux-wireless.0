Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33198 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751149AbdBKAPK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 19:15:10 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Configure rxnss_override for 10.4 firmware.
Date: Fri, 10 Feb 2017 16:09:05 -0800
Message-Id: <1486771745-15150-1-git-send-email-greearb@candelatech.com> (sfid-20170211_011542_950806_BC0D5084)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

QCA9984 hardware can do 4x4 at 80Mhz, but only 2x2 at 160Mhz.

First, report this to user-space by setting the max-tx-speed
and max-rx-speed vht capabilities.

Second, if the peer rx-speed is configured, and if we
are in 160 or 80+80 mode, and the peer rx-speed matches
the max speed for 2x2 or 1x1 at 160Mhz (long guard interval),
then use that info to set the peer_bw_rxnss_override appropriately.

Without this, a 9984 firmware will not use 2x2 ratesets when
transmitting to peer (it will be stuck at 1x1), because
the firmware would not have configured the rxnss_override.

This could use some testing....

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 30 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.c |  7 ++++++-
 drivers/net/wireless/ath/ath10k/wmi.h |  2 ++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b9c9105..0bde1db 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2760,6 +2760,18 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 		   sta->addr, arg->peer_max_mpdu, arg->peer_flags,
 		   arg->peer_vht_rates.rx_max_rate, arg->peer_vht_rates.rx_mcs_set,
 		   arg->peer_vht_rates.tx_max_rate, arg->peer_vht_rates.tx_mcs_set);
+
+	if ((arg->peer_vht_rates.rx_max_rate) &&
+	    (sta->vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK)) {
+		if (arg->peer_vht_rates.rx_max_rate == 1560) {
+			/* Must be 2x2 at 160Mhz is all it can do. */
+			arg->peer_bw_rxnss_override = 2;
+		}
+		else if (arg->peer_vht_rates.rx_max_rate == 780) {
+			/* Can only do 1x2 at 160Mhz (Long Guard Interval) */
+			arg->peer_bw_rxnss_override = 1;
+		}
+	}
 }
 
 static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
@@ -4899,7 +4911,8 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 		vht_cap.cap |= val;
 	}
 
-	if ((ar->vht_cap_info & IEEE80211_VHT_CAP_SHORT_GI_160) && !(ar->vht_cap_info & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)) {
+	if ((ar->vht_cap_info & IEEE80211_VHT_CAP_SHORT_GI_160) &&
+	    ((ar->vht_cap_info & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) == 0)) {
 		vht_cap.cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
 	}
 
@@ -4917,6 +4930,21 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 	vht_cap.vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
 	vht_cap.vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
 
+	/* If we are supporting 160Mhz or 80+80, then the NIC may be able to do a restricted NSS
+	 * for 160 or 80+80 vs what it can do for 80Mhz.  Give user-space a clue if that is the
+	 * case.
+	 */
+	if (vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) {
+		/* Something more than 80Mhz at least */
+		if (ar->dev_id == QCA9984_1_0_DEVICE_ID) {
+			/* Can do only 2x2 VHT160 or 80+80.
+			 * 1560Mbps is 4x4 80Mhz or 2x2 160Mhz, long-guard-interval
+			 */
+			vht_cap.vht_mcs.rx_highest = 1560;
+			vht_cap.vht_mcs.tx_highest = 1560;
+		}
+	}
+
 	return vht_cap;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 38db6be..05ca7f5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -7036,7 +7036,12 @@ ath10k_wmi_peer_assoc_fill_10_4(struct ath10k *ar, void *buf,
 	struct wmi_10_4_peer_assoc_complete_cmd *cmd = buf;
 
 	ath10k_wmi_peer_assoc_fill_10_2(ar, buf, arg);
-	cmd->peer_bw_rxnss_override = 0;
+	if (arg->peer_bw_rxnss_override)
+		cmd->peer_bw_rxnss_override =
+			__cpu_to_le32((arg->peer_bw_rxnss_override - 1) |
+				      (1<<PEER_BW_RXNSS_OVERRIDE_OFFSET));
+	else
+		cmd->peer_bw_rxnss_override = 0;
 }
 
 static int
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 5a71bb4..ccbb1bc 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6173,6 +6173,7 @@ struct wmi_10_2_peer_assoc_complete_cmd_ct {
 	struct wmi_ct_assoc_overrides overrides;
 } __packed;
 
+#define PEER_BW_RXNSS_OVERRIDE_OFFSET  31
 struct wmi_10_4_peer_assoc_complete_cmd {
 	struct wmi_10_2_peer_assoc_complete_cmd cmd;
 	__le32 peer_bw_rxnss_override;
@@ -6201,6 +6202,7 @@ struct wmi_peer_assoc_complete_arg {
 	u32 peer_vht_caps;
 	enum wmi_phy_mode peer_phymode;
 	struct wmi_vht_rate_set_arg peer_vht_rates;
+	u32 peer_bw_rxnss_override;
 
 	/* CT firmware only (beta-15 and higher ) */
 	bool has_rate_overrides;
-- 
2.4.11
