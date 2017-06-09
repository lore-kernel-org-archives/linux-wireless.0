Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:36193 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbdFILIE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 07:08:04 -0400
Received: by mail-wr0-f182.google.com with SMTP id v111so29103860wrc.3
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jun 2017 04:08:03 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH v2 2/3] ath10k: Configure rxnss_override for 10.4 firmware.
Date: Fri,  9 Jun 2017 13:07:49 +0200
Message-Id: <20170609110750.14950-2-sven.eckelmann@openmesh.com> (sfid-20170609_130807_297793_81F525C4)
In-Reply-To: <20170609110750.14950-1-sven.eckelmann@openmesh.com>
References: <20170609110750.14950-1-sven.eckelmann@openmesh.com>
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
[sven.eckelmann@openmesh.com: rebase, cleanup, drop 160Mhz workaround cleanup]
Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
v2:
 - rebased patch
 - minor cleanups
 - removal of the 160 MHz workaround (see patch 1)

 drivers/net/wireless/ath/ath10k/mac.c | 31 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c |  7 ++++++-
 drivers/net/wireless/ath/ath10k/wmi.h |  2 ++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8087b6be5484..0752cf351b4a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2519,6 +2519,20 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
 		   sta->addr, arg->peer_max_mpdu, arg->peer_flags);
+
+	if (arg->peer_vht_rates.rx_max_rate &&
+	    (sta->vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK)) {
+		switch (arg->peer_vht_rates.rx_max_rate) {
+		case 1560:
+			/* Must be 2x2 at 160Mhz is all it can do. */
+			arg->peer_bw_rxnss_override = 2;
+			break;
+		case 780:
+			/* Can only do 1x1 at 160Mhz (Long Guard Interval) */
+			arg->peer_bw_rxnss_override = 1;
+			break;
+		}
+	}
 }
 
 static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
@@ -4408,6 +4422,23 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 	vht_cap.vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
 	vht_cap.vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
 
+	/* If we are supporting 160Mhz or 80+80, then the NIC may be able to do
+	 * a restricted NSS for 160 or 80+80 vs what it can do for 80Mhz.  Give
+	 * user-space a clue if that is the case.
+	 */
+	if (vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) {
+		switch (ar->dev_id) {
+		case QCA9984_1_0_DEVICE_ID:
+			/* Can do only 2x2 VHT160 or 80+80.
+			 * 1560Mbps is 4x4 80Mhz or 2x2 160Mhz,
+			 * long-guard-interval
+			 */
+			vht_cap.vht_mcs.rx_highest = 1560;
+			vht_cap.vht_mcs.tx_highest = 1560;
+			break;
+		}
+	}
+
 	return vht_cap;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6afc8d27f0d5..2c3b0214ba5f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -6757,7 +6757,12 @@ ath10k_wmi_peer_assoc_fill_10_4(struct ath10k *ar, void *buf,
 	struct wmi_10_4_peer_assoc_complete_cmd *cmd = buf;
 
 	ath10k_wmi_peer_assoc_fill_10_2(ar, buf, arg);
-	cmd->peer_bw_rxnss_override = 0;
+	if (arg->peer_bw_rxnss_override)
+		cmd->peer_bw_rxnss_override =
+			__cpu_to_le32((arg->peer_bw_rxnss_override - 1) |
+				      BIT(PEER_BW_RXNSS_OVERRIDE_OFFSET));
+	else
+		cmd->peer_bw_rxnss_override = 0;
 }
 
 static int
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1b4865a55595..dd6cac150749 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6028,6 +6028,7 @@ struct wmi_10_2_peer_assoc_complete_cmd {
 	__le32 info0; /* WMI_PEER_ASSOC_INFO0_ */
 } __packed;
 
+#define PEER_BW_RXNSS_OVERRIDE_OFFSET  31
 struct wmi_10_4_peer_assoc_complete_cmd {
 	struct wmi_10_2_peer_assoc_complete_cmd cmd;
 	__le32 peer_bw_rxnss_override;
@@ -6051,6 +6052,7 @@ struct wmi_peer_assoc_complete_arg {
 	u32 peer_vht_caps;
 	enum wmi_phy_mode peer_phymode;
 	struct wmi_vht_rate_set_arg peer_vht_rates;
+	u32 peer_bw_rxnss_override;
 };
 
 struct wmi_peer_add_wds_entry_cmd {
-- 
2.11.0
