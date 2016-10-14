Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36815 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753282AbcJNKTX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 06:19:23 -0400
Subject: [PATCH v2 2/2] ath10k: add VHT160 support
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 14 Oct 2016 13:19:12 +0300
Message-ID: <20161014101912.5300.66145.stgit@potku.adurom.net> (sfid-20161014_121928_087764_DB02C173)
In-Reply-To: <20161014101710.5300.21550.stgit@potku.adurom.net>
References: <20161014101710.5300.21550.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sebastian Gottschall <s.gottschall@dd-wrt.com>

This patch adds full VHT160 support for QCA9984 chipsets Tested on Netgear
R7800. 80+80 is possible, but disabled so far since it seems to contain
glitches like missing vht station flags (this may be firmware or mac80211
related).

Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Patchwork-Id: 9335111
[kvalo@qca.qualcomm.com: refactoring and fix few warnings]
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c  |    7 +++++-
 drivers/net/wireless/ath/ath10k/mac.c     |   32 +++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    1 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |    1 +
 drivers/net/wireless/ath/ath10k/wmi.c     |    9 +++++++-
 drivers/net/wireless/ath/ath10k/wmi.h     |   27 +++++++++++++++++++++++-
 6 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 285b235268d7..fc93d14ad472 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -702,6 +702,10 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		/* 80MHZ */
 		case 2:
 			status->vht_flag |= RX_VHT_FLAG_80MHZ;
+			break;
+		case 3:
+			status->vht_flag |= RX_VHT_FLAG_160MHZ;
+			break;
 		}
 
 		status->flag |= RX_FLAG_VHT;
@@ -926,7 +930,7 @@ static void ath10k_process_rx(struct ath10k *ar,
 	*status = *rx_status;
 
 	ath10k_dbg(ar, ATH10K_DBG_DATA,
-		   "rx skb %pK len %u peer %pM %s %s sn %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%llx fcs-err %i mic-err %i amsdu-more %i\n",
+		   "rx skb %pK len %u peer %pM %s %s sn %u %s%s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%llx fcs-err %i mic-err %i amsdu-more %i\n",
 		   skb,
 		   skb->len,
 		   ieee80211_get_SA(hdr),
@@ -940,6 +944,7 @@ static void ath10k_process_rx(struct ath10k *ar,
 		   status->flag & RX_FLAG_VHT ? "vht" : "",
 		   status->flag & RX_FLAG_40MHZ ? "40" : "",
 		   status->vht_flag & RX_VHT_FLAG_80MHZ ? "80" : "",
+		   status->vht_flag & RX_VHT_FLAG_160MHZ ? "160" : "",
 		   status->flag & RX_FLAG_SHORT_GI ? "sgi " : "",
 		   status->rate_idx,
 		   status->vht_nss,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index cbd0f4c3dad4..a8e7ae4b3f1b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -569,10 +569,14 @@ chan_to_phymode(const struct cfg80211_chan_def *chandef)
 		case NL80211_CHAN_WIDTH_80:
 			phymode = MODE_11AC_VHT80;
 			break;
+		case NL80211_CHAN_WIDTH_160:
+			phymode = MODE_11AC_VHT160;
+			break;
+		case NL80211_CHAN_WIDTH_80P80:
+			phymode = MODE_11AC_VHT80_80;
+			break;
 		case NL80211_CHAN_WIDTH_5:
 		case NL80211_CHAN_WIDTH_10:
-		case NL80211_CHAN_WIDTH_80P80:
-		case NL80211_CHAN_WIDTH_160:
 			phymode = MODE_UNKNOWN;
 			break;
 		}
@@ -971,6 +975,7 @@ static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
 	arg.vdev_id = vdev_id;
 	arg.channel.freq = channel->center_freq;
 	arg.channel.band_center_freq1 = chandef->center_freq1;
+	arg.channel.band_center_freq2 = chandef->center_freq2;
 
 	/* TODO setup this dynamically, what in case we
 	   don't have any vifs? */
@@ -1382,6 +1387,7 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif,
 
 	arg.channel.freq = chandef->chan->center_freq;
 	arg.channel.band_center_freq1 = chandef->center_freq1;
+	arg.channel.band_center_freq2 = chandef->center_freq2;
 	arg.channel.mode = chan_to_phymode(chandef);
 
 	arg.channel.min_power = 0;
@@ -2445,6 +2451,9 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
 		arg->peer_flags |= ar->wmi.peer_flags->bw80;
 
+	if (sta->bandwidth == IEEE80211_STA_RX_BW_160)
+		arg->peer_flags |= ar->wmi.peer_flags->bw160;
+
 	arg->peer_vht_rates.rx_max_rate =
 		__le16_to_cpu(vht_cap->vht_mcs.rx_highest);
 	arg->peer_vht_rates.rx_mcs_set =
@@ -2501,6 +2510,18 @@ static bool ath10k_mac_sta_has_ofdm_only(struct ieee80211_sta *sta)
 static enum wmi_phy_mode ath10k_mac_get_phymode_vht(struct ath10k *ar,
 						    struct ieee80211_sta *sta)
 {
+	if (sta->bandwidth == IEEE80211_STA_RX_BW_160) {
+		switch (sta->vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) {
+		case IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ:
+			return MODE_11AC_VHT160;
+		case IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ:
+			return MODE_11AC_VHT80_80;
+		default:
+			/* not sure if this is a valid case? */
+			return MODE_11AC_VHT160;
+		}
+	}
+
 	if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
 		return MODE_11AC_VHT80;
 
@@ -4289,6 +4310,10 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 		vht_cap.cap |= val;
 	}
 
+	if ((ar->vht_cap_info & IEEE80211_VHT_CAP_SHORT_GI_160) &&
+	    !(ar->vht_cap_info & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))
+		vht_cap.cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
+
 	mcs_map = 0;
 	for (i = 0; i < 8; i++) {
 		if ((i < ar->num_rf_chains) && (ar->cfg_tx_chainmask & BIT(i)))
@@ -6945,6 +6970,9 @@ static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
 			bw = WMI_PEER_CHWIDTH_80MHZ;
 			break;
 		case IEEE80211_STA_RX_BW_160:
+			bw = WMI_PEER_CHWIDTH_160MHZ;
+			break;
+		default:
 			ath10k_warn(ar, "Invalid bandwidth %d in rc update for %pM\n",
 				    sta->bandwidth, sta->addr);
 			bw = WMI_PEER_CHWIDTH_20MHZ;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index e64f59300a7c..e6d0fe5dcfe4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3560,6 +3560,7 @@ static const struct wmi_peer_flags_map wmi_tlv_peer_flags_map = {
 	.vht = WMI_TLV_PEER_VHT,
 	.bw80 = WMI_TLV_PEER_80MHZ,
 	.pmf = WMI_TLV_PEER_PMF,
+	.bw160 = WMI_TLV_PEER_160MHZ,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index b8aa6000573c..22cf011e839a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -543,6 +543,7 @@ enum wmi_tlv_peer_flags {
 	WMI_TLV_PEER_VHT = 0x02000000,
 	WMI_TLV_PEER_80MHZ = 0x04000000,
 	WMI_TLV_PEER_PMF = 0x08000000,
+	WMI_TLV_PEER_160MHZ = 0x20000000,
 };
 
 enum wmi_tlv_tag {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 387c4eede388..12b3aff8ffa2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -28,6 +28,7 @@
 #include "wmi-ops.h"
 #include "p2p.h"
 #include "hw.h"
+#include "hif.h"
 
 #define ATH10K_WMI_BARRIER_ECHO_ID 0xBA991E9
 #define ATH10K_WMI_BARRIER_TIMEOUT_HZ (3 * HZ)
@@ -1576,6 +1577,7 @@ static const struct wmi_peer_flags_map wmi_peer_flags_map = {
 	.bw80 = WMI_PEER_80MHZ,
 	.vht_2g = WMI_PEER_VHT_2G,
 	.pmf = WMI_PEER_PMF,
+	.bw160 = WMI_PEER_160MHZ,
 };
 
 static const struct wmi_peer_flags_map wmi_10x_peer_flags_map = {
@@ -1593,6 +1595,7 @@ static const struct wmi_peer_flags_map wmi_10x_peer_flags_map = {
 	.spatial_mux = WMI_10X_PEER_SPATIAL_MUX,
 	.vht = WMI_10X_PEER_VHT,
 	.bw80 = WMI_10X_PEER_80MHZ,
+	.bw160 = WMI_10X_PEER_160MHZ,
 };
 
 static const struct wmi_peer_flags_map wmi_10_2_peer_flags_map = {
@@ -1612,6 +1615,7 @@ static const struct wmi_peer_flags_map wmi_10_2_peer_flags_map = {
 	.bw80 = WMI_10_2_PEER_80MHZ,
 	.vht_2g = WMI_10_2_PEER_VHT_2G,
 	.pmf = WMI_10_2_PEER_PMF,
+	.bw160 = WMI_10_2_PEER_160MHZ,
 };
 
 void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
@@ -1636,7 +1640,10 @@ void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
 
 	ch->mhz = __cpu_to_le32(arg->freq);
 	ch->band_center_freq1 = __cpu_to_le32(arg->band_center_freq1);
-	ch->band_center_freq2 = 0;
+	if (arg->mode == MODE_11AC_VHT80_80)
+		ch->band_center_freq2 = __cpu_to_le32(arg->band_center_freq2);
+	else
+		ch->band_center_freq2 = 0;
 	ch->min_power = arg->min_power;
 	ch->max_power = arg->max_power;
 	ch->reg_power = arg->max_reg_power;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1b243c899bef..69d854e04594 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1728,8 +1728,10 @@ enum wmi_phy_mode {
 	MODE_11AC_VHT20_2G = 11,
 	MODE_11AC_VHT40_2G = 12,
 	MODE_11AC_VHT80_2G = 13,
-	MODE_UNKNOWN    = 14,
-	MODE_MAX        = 14
+	MODE_11AC_VHT80_80 = 14,
+	MODE_11AC_VHT160 = 15,
+	MODE_UNKNOWN    = 16,
+	MODE_MAX        = 16
 };
 
 static inline const char *ath10k_wmi_phymode_str(enum wmi_phy_mode mode)
@@ -1757,6 +1759,10 @@ static inline const char *ath10k_wmi_phymode_str(enum wmi_phy_mode mode)
 		return "11ac-vht40";
 	case MODE_11AC_VHT80:
 		return "11ac-vht80";
+	case MODE_11AC_VHT160:
+		return "11ac-vht160";
+	case MODE_11AC_VHT80_80:
+		return "11ac-vht80+80";
 	case MODE_11AC_VHT20_2G:
 		return "11ac-vht20-2g";
 	case MODE_11AC_VHT40_2G:
@@ -1811,6 +1817,7 @@ struct wmi_channel {
 struct wmi_channel_arg {
 	u32 freq;
 	u32 band_center_freq1;
+	u32 band_center_freq2;
 	bool passive;
 	bool allow_ibss;
 	bool allow_ht;
@@ -1875,9 +1882,18 @@ enum wmi_channel_change_cause {
 #define WMI_VHT_CAP_MAX_MPDU_LEN_MASK            0x00000003
 #define WMI_VHT_CAP_RX_LDPC                      0x00000010
 #define WMI_VHT_CAP_SGI_80MHZ                    0x00000020
+#define WMI_VHT_CAP_SGI_160MHZ                   0x00000040
 #define WMI_VHT_CAP_TX_STBC                      0x00000080
 #define WMI_VHT_CAP_RX_STBC_MASK                 0x00000300
 #define WMI_VHT_CAP_RX_STBC_MASK_SHIFT           8
+#define WMI_VHT_CAP_SU_BFER                      0x00000800
+#define WMI_VHT_CAP_SU_BFEE                      0x00001000
+#define WMI_VHT_CAP_MAX_CS_ANT_MASK              0x0000E000
+#define WMI_VHT_CAP_MAX_CS_ANT_MASK_SHIFT        13
+#define WMI_VHT_CAP_MAX_SND_DIM_MASK             0x00070000
+#define WMI_VHT_CAP_MAX_SND_DIM_MASK_SHIFT       16
+#define WMI_VHT_CAP_MU_BFER                      0x00080000
+#define WMI_VHT_CAP_MU_BFEE                      0x00100000
 #define WMI_VHT_CAP_MAX_AMPDU_LEN_EXP            0x03800000
 #define WMI_VHT_CAP_MAX_AMPDU_LEN_EXP_SHIFT      23
 #define WMI_VHT_CAP_RX_FIXED_ANT                 0x10000000
@@ -1926,6 +1942,8 @@ enum {
 	REGDMN_MODE_11AC_VHT40PLUS   = 0x40000, /* 5Ghz, VHT40 + channels */
 	REGDMN_MODE_11AC_VHT40MINUS  = 0x80000, /* 5Ghz  VHT40 - channels */
 	REGDMN_MODE_11AC_VHT80       = 0x100000, /* 5Ghz, VHT80 channels */
+	REGDMN_MODE_11AC_VHT160      = 0x200000,     /* 5Ghz, VHT160 channels */
+	REGDMN_MODE_11AC_VHT80_80    = 0x400000,     /* 5Ghz, VHT80+80 channels */
 	REGDMN_MODE_ALL              = 0xffffffff
 };
 
@@ -5769,6 +5787,7 @@ enum wmi_peer_chwidth {
 	WMI_PEER_CHWIDTH_20MHZ = 0,
 	WMI_PEER_CHWIDTH_40MHZ = 1,
 	WMI_PEER_CHWIDTH_80MHZ = 2,
+	WMI_PEER_CHWIDTH_160MHZ = 3,
 };
 
 enum wmi_peer_param {
@@ -5859,6 +5878,7 @@ struct wmi_peer_flags_map {
 	u32 bw80;
 	u32 vht_2g;
 	u32 pmf;
+	u32 bw160;
 };
 
 enum wmi_peer_flags {
@@ -5878,6 +5898,7 @@ enum wmi_peer_flags {
 	WMI_PEER_80MHZ = 0x04000000,
 	WMI_PEER_VHT_2G = 0x08000000,
 	WMI_PEER_PMF = 0x10000000,
+	WMI_PEER_160MHZ = 0x20000000
 };
 
 enum wmi_10x_peer_flags {
@@ -5895,6 +5916,7 @@ enum wmi_10x_peer_flags {
 	WMI_10X_PEER_SPATIAL_MUX = 0x00200000,
 	WMI_10X_PEER_VHT = 0x02000000,
 	WMI_10X_PEER_80MHZ = 0x04000000,
+	WMI_10X_PEER_160MHZ = 0x20000000
 };
 
 enum wmi_10_2_peer_flags {
@@ -5914,6 +5936,7 @@ enum wmi_10_2_peer_flags {
 	WMI_10_2_PEER_80MHZ = 0x04000000,
 	WMI_10_2_PEER_VHT_2G = 0x08000000,
 	WMI_10_2_PEER_PMF = 0x10000000,
+	WMI_10_2_PEER_160MHZ = 0x20000000
 };
 
 /*
