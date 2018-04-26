Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:47865 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752439AbeDZJJY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 05:09:24 -0400
From: s.gottschall@dd-wrt.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: [PATCH v1] ath10k: fix crash in recent 3.5.3 9984 firmware due wrong handling of peer_bw_rxnss_override parameter
Date: Thu, 26 Apr 2018 11:09:06 +0200
Message-Id: <20180426090906.20807-1-s.gottschall@dd-wrt.com> (sfid-20180426_110930_333726_0E9B8318)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sebastian Gottschall <s.gottschall@dd-wrt.com>

current handling of peer_bw_rxnss_override parameter is based on guessing the VHT160/8080 capability by rx rate. this is wrong and may lead
to a non initialized peer_bw_rxnss_override parameter which is required since VHT160 operation mode only supports 2x2 chainmasks in addition the original code
initialized the parameter with wrong masked values.
This patch uses the peer phymode and peer nss information for correct initialisation of the peer_bw_rxnss_override parameter.
if this peer information is not available, we initialize the parameter by minimum nss which is suggested by QCA as temporary workaround according
to the QCA sourcecodes.

Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 39 +++++++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/wmi.c |  4 +---
 drivers/net/wireless/ath/ath10k/wmi.h | 14 ++++++++++++-
 3 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5be6386ede8f..758e1d77eed4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2505,8 +2505,9 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
 		arg->peer_flags |= ar->wmi.peer_flags->bw80;
 
-	if (sta->bandwidth == IEEE80211_STA_RX_BW_160)
+	if (sta->bandwidth == IEEE80211_STA_RX_BW_160) {
 		arg->peer_flags |= ar->wmi.peer_flags->bw160;
+	}
 
 	/* Calculate peer NSS capability from VHT capabilities if STA
 	 * supports VHT.
@@ -2529,22 +2530,28 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	arg->peer_vht_rates.tx_mcs_set = ath10k_peer_assoc_h_vht_limit(
 		__le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map), vht_mcs_mask);
 
-	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
-		   sta->addr, arg->peer_max_mpdu, arg->peer_flags);
+	if (arg->peer_num_spatial_streams && (arg->peer_phymode == MODE_11AC_VHT160 || arg->peer_phymode == MODE_11AC_VHT80_80)) {
+		arg->peer_bw_rxnss_override = BW_NSS_FWCONF_160(arg->peer_num_spatial_streams);
+		printk(KERN_INFO "vht160, set rxnss to %X from peer %X\n", arg->peer_bw_rxnss_override, arg->peer_num_spatial_streams );
+	}
 
-	if (arg->peer_vht_rates.rx_max_rate &&
-	    (sta->vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK)) {
-		switch (arg->peer_vht_rates.rx_max_rate) {
-		case 1560:
-			/* Must be 2x2 at 160Mhz is all it can do. */
-			arg->peer_bw_rxnss_override = 2;
-			break;
-		case 780:
-			/* Can only do 1x1 at 160Mhz (Long Guard Interval) */
-			arg->peer_bw_rxnss_override = 1;
-			break;
-		}
+	if (arg->peer_num_spatial_streams && arg->peer_phymode == MODE_11AC_VHT80_80) {
+		arg->peer_bw_rxnss_override |= BW_NSS_FWCONF_80_80(arg->peer_num_spatial_streams);
+		printk(KERN_INFO "vht8080, set rxnss to %X from peer %X\n", arg->peer_bw_rxnss_override, arg->peer_num_spatial_streams );
 	}
+
+	/* In very exceptional  conditions it is observed  that
+	 * firmware was receiving bw_rxnss_override as 0 for peer from host, and resulting in Target Assert.
+	 * Changing the rxnss_override to minimum nss. This is a temporary WAR. Needs to be fixed
+	 * properly.
+	 */
+	if (!arg->peer_num_spatial_streams && (arg->peer_phymode == MODE_11AC_VHT80_80 || arg->peer_phymode == MODE_11AC_VHT160)) {
+		arg->peer_bw_rxnss_override = BW_NSS_FWCONF_MAP_ENABLE;
+		printk(KERN_INFO "vht8080, set rxnss to WAR %X\n", arg->peer_bw_rxnss_override);
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
+		   sta->addr, arg->peer_max_mpdu, arg->peer_flags);
 }
 
 static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
@@ -2696,9 +2703,9 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
 	ath10k_peer_assoc_h_crypto(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_rates(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_ht(ar, vif, sta, arg);
+	ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_vht(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
-	ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2c36256a441d..7d72fdc703c8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -7212,9 +7212,7 @@ ath10k_wmi_peer_assoc_fill_10_4(struct ath10k *ar, void *buf,
 
 	ath10k_wmi_peer_assoc_fill_10_2(ar, buf, arg);
 	if (arg->peer_bw_rxnss_override)
-		cmd->peer_bw_rxnss_override =
-			__cpu_to_le32((arg->peer_bw_rxnss_override - 1) |
-				      BIT(PEER_BW_RXNSS_OVERRIDE_OFFSET));
+		cmd->peer_bw_rxnss_override = __cpu_to_le32(arg->peer_bw_rxnss_override);
 	else
 		cmd->peer_bw_rxnss_override = 0;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 46ae19bb2c92..1fe0aa5523a6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6380,7 +6380,19 @@ struct wmi_10_2_peer_assoc_complete_cmd {
 	__le32 info0; /* WMI_PEER_ASSOC_INFO0_ */
 } __packed;
 
-#define PEER_BW_RXNSS_OVERRIDE_OFFSET  31
+#define BW_NSS_FWCONF_MAP_ENABLE             (1 << 31)
+#define BW_NSS_FWCONF_MAP_160MHZ_S           (0)
+#define BW_NSS_FWCONF_MAP_160MHZ_M           (0x00000007)
+#define BW_NSS_FWCONF_MAP_80_80MHZ_S         (3)
+#define BW_NSS_FWCONF_MAP_80_80MHZ_M         (0x00000038)
+#define BW_NSS_FWCONF_MAP_M                  (0x0000003F)
+
+#define GET_BW_NSS_FWCONF_160(x)             ((((x) & BW_NSS_FWCONF_MAP_160MHZ_M) >> BW_NSS_FWCONF_MAP_160MHZ_S) + 1)
+#define GET_BW_NSS_FWCONF_80_80(x)           ((((x) & BW_NSS_FWCONF_MAP_80_80MHZ_M) >> BW_NSS_FWCONF_MAP_80_80MHZ_S) + 1)
+
+/* Values defined to set 160 MHz Bandwidth NSS Mapping into FW*/
+#define BW_NSS_FWCONF_160(x)          (BW_NSS_FWCONF_MAP_ENABLE | (((x - 1) << BW_NSS_FWCONF_MAP_160MHZ_S) & BW_NSS_FWCONF_MAP_160MHZ_M))
+#define BW_NSS_FWCONF_80_80(x)        (BW_NSS_FWCONF_MAP_ENABLE | (((x - 1) << BW_NSS_FWCONF_MAP_80_80MHZ_S) & BW_NSS_FWCONF_MAP_80_80MHZ_M))
 
 struct wmi_10_4_peer_assoc_complete_cmd {
 	struct wmi_10_2_peer_assoc_complete_cmd cmd;
-- 
2.14.1
