Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56002 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab3BUTLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 14:11:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: support VHT capability overrides
Date: Thu, 21 Feb 2013 20:11:45 +0100
Message-Id: <1361473906-14941-3-git-send-email-johannes@sipsolutions.net> (sfid-20130221_201204_329642_5700A04E)
In-Reply-To: <1361473906-14941-1-git-send-email-johannes@sipsolutions.net>
References: <1361473906-14941-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Support the cfg80211 API to override VHT capabilities
on association.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  4 +++
 net/mac80211/main.c        | 18 ++++++++++
 net/mac80211/mlme.c        | 12 ++++++-
 net/mac80211/vht.c         | 87 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6d16906..939c97e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -479,6 +479,8 @@ struct ieee80211_if_managed {
 
 	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
 	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
+	struct ieee80211_vht_cap vht_capa; /* configured VHT overrides */
+	struct ieee80211_vht_cap vht_capa_mask; /* Valid parts of vht_capa */
 };
 
 struct ieee80211_if_ibss {
@@ -1439,6 +1441,8 @@ void ieee80211_sta_set_rx_nss(struct sta_info *sta);
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
 				 enum ieee80211_band band, bool nss_only);
+void ieee80211_apply_vhtcap_overrides(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_sta_vht_cap *vht_cap);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c89f0bc..3548ec3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -501,6 +501,23 @@ static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
 	},
 };
 
+static const struct ieee80211_vht_cap mac80211_vht_capa_mod_mask = {
+	.vht_cap_info =
+		cpu_to_le32(IEEE80211_VHT_CAP_RXLDPC |
+			    IEEE80211_VHT_CAP_SHORT_GI_80 |
+			    IEEE80211_VHT_CAP_SHORT_GI_160 |
+			    IEEE80211_VHT_CAP_TXSTBC |
+			    IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
+			    IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
+			    IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN |
+			    IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
+			    IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK),
+	.supp_mcs = {
+		.rx_mcs_map = cpu_to_le16(~0),
+		.tx_mcs_map = cpu_to_le16(~0),
+	},
+};
+
 static const u8 extended_capabilities[] = {
 	0, 0, 0, 0, 0, 0, 0,
 	WLAN_EXT_CAPA8_OPMODE_NOTIF,
@@ -609,6 +626,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					 IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH;
 	local->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
 	wiphy->ht_capa_mod_mask = &mac80211_ht_capa_mod_mask;
+	wiphy->vht_capa_mod_mask = &mac80211_vht_capa_mod_mask;
 
 	INIT_LIST_HEAD(&local->interfaces);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6a7d19b..ef56e0a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -609,6 +609,7 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 	BUILD_BUG_ON(sizeof(vht_cap) != sizeof(sband->vht_cap));
 
 	memcpy(&vht_cap, &sband->vht_cap, sizeof(vht_cap));
+	ieee80211_apply_vhtcap_overrides(sdata, &vht_cap);
 
 	/* determine capability flags */
 	cap = vht_cap.cap;
@@ -1801,9 +1802,11 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.p2p_ctwindow = 0;
 	sdata->vif.bss_conf.p2p_oppps = false;
 
-	/* on the next assoc, re-program HT parameters */
+	/* on the next assoc, re-program HT/VHT parameters */
 	memset(&ifmgd->ht_capa, 0, sizeof(ifmgd->ht_capa));
 	memset(&ifmgd->ht_capa_mask, 0, sizeof(ifmgd->ht_capa_mask));
+	memset(&ifmgd->vht_capa, 0, sizeof(ifmgd->vht_capa));
+	memset(&ifmgd->vht_capa_mask, 0, sizeof(ifmgd->vht_capa_mask));
 
 	sdata->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
 
@@ -4094,6 +4097,9 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
 	}
 
+	if (req->flags & ASSOC_REQ_DISABLE_VHT)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
+
 	/* Also disable HT if we don't support it or the AP doesn't use WMM */
 	sband = local->hw.wiphy->bands[req->bss->channel->band];
 	if (!sband->ht_cap.ht_supported ||
@@ -4117,6 +4123,10 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	memcpy(&ifmgd->ht_capa_mask, &req->ht_capa_mask,
 	       sizeof(ifmgd->ht_capa_mask));
 
+	memcpy(&ifmgd->vht_capa, &req->vht_capa, sizeof(ifmgd->vht_capa));
+	memcpy(&ifmgd->vht_capa_mask, &req->vht_capa_mask,
+	       sizeof(ifmgd->vht_capa_mask));
+
 	if (req->ie && req->ie_len) {
 		memcpy(assoc_data->ie, req->ie, req->ie_len);
 		assoc_data->ie_len = req->ie_len;
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index a2c2258..9ba0f22 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -13,6 +13,93 @@
 #include "rate.h"
 
 
+static void __check_vhtcap_disable(struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_sta_vht_cap *vht_cap,
+				   u32 flag)
+{
+	__le32 le_flag = cpu_to_le32(flag);
+
+	if (sdata->u.mgd.vht_capa_mask.vht_cap_info & le_flag &&
+	    !(sdata->u.mgd.vht_capa.vht_cap_info & le_flag))
+		vht_cap->cap &= ~flag;
+}
+
+void ieee80211_apply_vhtcap_overrides(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_sta_vht_cap *vht_cap)
+{
+	int i;
+	u16 rxmcs_mask, rxmcs_cap, rxmcs_n, txmcs_mask, txmcs_cap, txmcs_n;
+
+	if (!vht_cap->vht_supported)
+		return;
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return;
+
+	__check_vhtcap_disable(sdata, vht_cap,
+			       IEEE80211_VHT_CAP_RXLDPC);
+	__check_vhtcap_disable(sdata, vht_cap,
+			       IEEE80211_VHT_CAP_SHORT_GI_80);
+	__check_vhtcap_disable(sdata, vht_cap,
+			       IEEE80211_VHT_CAP_SHORT_GI_160);
+	__check_vhtcap_disable(sdata, vht_cap,
+			       IEEE80211_VHT_CAP_TXSTBC);
+	__check_vhtcap_disable(sdata, vht_cap,
+			       IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE);
+	__check_vhtcap_disable(sdata, vht_cap,
+			       IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE);
+	__check_vhtcap_disable(sdata, vht_cap,
+			       IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN);
+	__check_vhtcap_disable(sdata, vht_cap,
+			       IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN);
+
+	/* Allow user to decrease AMPDU length exponent */
+	if (sdata->u.mgd.vht_capa_mask.vht_cap_info &
+	    cpu_to_le32(IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK)) {
+		u32 cap, n;
+
+		n = le32_to_cpu(sdata->u.mgd.vht_capa.vht_cap_info) &
+			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
+		n >>= IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
+		cap = vht_cap->cap & IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
+		cap >>= IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
+
+		if (n < cap) {
+			vht_cap->cap &=
+				~IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
+			vht_cap->cap |=
+				n << IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
+		}
+	}
+
+	/* Allow the user to decrease MCSes */
+	rxmcs_mask =
+		le16_to_cpu(sdata->u.mgd.vht_capa_mask.supp_mcs.rx_mcs_map);
+	rxmcs_n = le16_to_cpu(sdata->u.mgd.vht_capa.supp_mcs.rx_mcs_map);
+	rxmcs_n &= rxmcs_mask;
+	rxmcs_cap = le16_to_cpu(vht_cap->vht_mcs.rx_mcs_map);
+
+	txmcs_mask =
+		le16_to_cpu(sdata->u.mgd.vht_capa_mask.supp_mcs.tx_mcs_map);
+	txmcs_n = le16_to_cpu(sdata->u.mgd.vht_capa.supp_mcs.tx_mcs_map);
+	txmcs_n &= txmcs_mask;
+	txmcs_cap = le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map);
+	for (i = 0; i < 8; i++) {
+		if (rxmcs_mask & (3 << 2*i) &&
+		    (rxmcs_n & (3 << 2*i)) < (rxmcs_cap & (3 << 2*i))) {
+			rxmcs_cap &= ~(3 << 2*i);
+			rxmcs_cap |= (rxmcs_n & (3 << 2*i));
+		}
+		if (txmcs_mask & (3 << 2*i) &&
+		    (txmcs_n & (3 << 2*i)) < (txmcs_cap & (3 << 2*i))) {
+			txmcs_cap &= ~(3 << 2*i);
+			txmcs_cap |= (txmcs_n & (3 << 2*i));
+		}
+	}
+	vht_cap->vht_mcs.rx_mcs_map = cpu_to_le16(rxmcs_cap);
+	vht_cap->vht_mcs.tx_mcs_map = cpu_to_le16(txmcs_cap);
+}
+
 void
 ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_supported_band *sband,
-- 
1.8.0

