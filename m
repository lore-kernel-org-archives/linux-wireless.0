Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:39783 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753817AbeD2TuF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Apr 2018 15:50:05 -0400
From: s.gottschall@dd-wrt.com
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: [PATCH v5] ath10k: fix crash in recent 3.5.3 9984 firmware due wrong handling of peer_bw_rxnss_override parameter
Date: Sun, 29 Apr 2018 21:49:57 +0200
Message-Id: <20180429194957.3144-1-s.gottschall@dd-wrt.com> (sfid-20180429_215009_336717_35CDCFB8)
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

v2: remove debug messages
v3: apply some cosmetics, update documentation
v4: fix compile warning and truncate nss to maximum of 2x2 since current chipsets only support 2x2 at vht160
v5: handle maximum nss for chipsets supportig vht160 with 1x1 only
---
 drivers/net/wireless/ath/ath10k/mac.c | 48 ++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/wmi.c |  7 +---
 drivers/net/wireless/ath/ath10k/wmi.h | 14 +++++++-
 3 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5be6386ede8f..a95a32102ef3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2528,23 +2528,41 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 		__le16_to_cpu(vht_cap->vht_mcs.tx_highest);
 	arg->peer_vht_rates.tx_mcs_set = ath10k_peer_assoc_h_vht_limit(
 		__le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map), vht_mcs_mask);
+	arg->peer_bw_rxnss_override = 0;
+
+	if (arg->peer_num_spatial_streams && ar->hw_params.vht160_mcs_rx_highest) {
+		int nss160 = arg->peer_num_spatial_streams;
+		/* truncate vht160 nss value to 2x2 since all known chipsets do not support more than 2x2 in vht160 modes */
+		if (nss160 > 2) {
+			if (ar->hw_params.vht160_mcs_rx_highest == 1560)
+				nss160 = 2;
+			else
+				nss160 = 1;
+		}
+		/* in case if peer is connected with vht160 or vht80+80, we need to properly adjust rxnss parameters */
+		switch(arg->peer_phymode) {
+		case MODE_11AC_VHT80_80:
+			arg->peer_bw_rxnss_override = BW_NSS_FWCONF_80_80(nss160);
+		/* fall through */
+		case MODE_11AC_VHT160:
+			arg->peer_bw_rxnss_override |= BW_NSS_FWCONF_160(nss160);
+		break;
+		default:
+		break;
+		}
+	}
 
-	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
-		   sta->addr, arg->peer_max_mpdu, arg->peer_flags);
+	/* in case peer has no nss properties for some reasons, we set local nss to minimum (1x1) to avoid a 
+	 * firmware assert / crash. this applies only to VHT160 or VHT80+80 and is a WAR for clients breaking
+	 * the spec.
+	 */
 
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
+	if (!(arg->peer_num_spatial_streams || !ar->hw_params.vht160_mcs_rx_highest) && (arg->peer_phymode == MODE_11AC_VHT80_80 || arg->peer_phymode == MODE_11AC_VHT160)) {
+		arg->peer_bw_rxnss_override = BW_NSS_FWCONF_MAP_ENABLE;
 	}
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
+		   sta->addr, arg->peer_max_mpdu, arg->peer_flags);
 }
 
 static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
@@ -2696,9 +2714,9 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
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
index 2c36256a441d..3797dca317ff 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -7211,12 +7211,7 @@ ath10k_wmi_peer_assoc_fill_10_4(struct ath10k *ar, void *buf,
 	struct wmi_10_4_peer_assoc_complete_cmd *cmd = buf;
 
 	ath10k_wmi_peer_assoc_fill_10_2(ar, buf, arg);
-	if (arg->peer_bw_rxnss_override)
-		cmd->peer_bw_rxnss_override =
-			__cpu_to_le32((arg->peer_bw_rxnss_override - 1) |
-				      BIT(PEER_BW_RXNSS_OVERRIDE_OFFSET));
-	else
-		cmd->peer_bw_rxnss_override = 0;
+	cmd->peer_bw_rxnss_override = __cpu_to_le32(arg->peer_bw_rxnss_override);
 }
 
 static int
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
2.17.0
