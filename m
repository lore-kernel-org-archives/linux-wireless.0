Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3CAMNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 07:13:07 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: restrict peer's VHT capabilities to own
Date: Fri,  1 Mar 2013 13:13:00 +0100
Message-Id: <1362139980-31675-1-git-send-email-johannes@sipsolutions.net> (sfid-20130301_131312_073764_800ADD2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Implement restricting peer VHT capabilities to the device's own
capabilities. This is useful when a single driver supports more
than one device and the devices have different capabilities
(often they will differ in the number of spatial streams), but
in particular is also necessary for VHT capability overrides to
work correctly -- otherwise it'd be possible to e.g. advertise,
due to overrides, that TX-STBC is not supported, but then still
use it to TX to the AP because it supports RX-STBC.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h |   3 +-
 include/net/mac80211.h    |   5 +-
 net/mac80211/vht.c        | 114 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 117 insertions(+), 5 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9de3875..04af91a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1345,10 +1345,11 @@ struct ieee80211_vht_operation {
 #define IEEE80211_VHT_CAP_RXSTBC_2				0x00000200
 #define IEEE80211_VHT_CAP_RXSTBC_3				0x00000300
 #define IEEE80211_VHT_CAP_RXSTBC_4				0x00000400
+#define IEEE80211_VHT_CAP_RXSTBC_MASK				0x00000700
 #define IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE			0x00000800
 #define IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE			0x00001000
 #define IEEE80211_VHT_CAP_BEAMFORMER_ANTENNAS_MAX		0x00006000
-#define IEEE80211_VHT_CAP_SOUNDING_DIMENTION_MAX		0x00030000
+#define IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MAX		0x00030000
 #define IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE			0x00080000
 #define IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE			0x00100000
 #define IEEE80211_VHT_CAP_VHT_TXOP_PS				0x00200000
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ac0272f..e48ff2e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1230,9 +1230,8 @@ enum ieee80211_sta_rx_bandwidth {
  * @addr: MAC address
  * @aid: AID we assigned to the station if we're an AP
  * @supp_rates: Bitmap of supported rates (per band)
- * @ht_cap: HT capabilities of this STA; restricted to our own TX capabilities
- * @vht_cap: VHT capabilities of this STA; Not restricting any capabilities
- * 	of remote STA. Taking as is.
+ * @ht_cap: HT capabilities of this STA; restricted to our own capabilities
+ * @vht_cap: VHT capabilities of this STA; restricted to our own capabilities
  * @wme: indicates whether the STA supports WME. Only valid during AP-mode.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 9ba0f22..3a83dd7 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -107,6 +107,8 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 				    struct sta_info *sta)
 {
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->sta.vht_cap;
+	struct ieee80211_sta_vht_cap own_cap;
+	u32 cap_info, i;
 
 	memset(vht_cap, 0, sizeof(*vht_cap));
 
@@ -122,12 +124,122 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 
 	vht_cap->vht_supported = true;
 
-	vht_cap->cap = le32_to_cpu(vht_cap_ie->vht_cap_info);
+	own_cap = sband->vht_cap;
+	/*
+	 * If user has specified capability overrides, take care
+	 * of that if the station we're setting up is the AP that
+	 * we advertised a restricted capability set to. Override
+	 * our own capabilities and then use those below.
+	 */
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+		ieee80211_apply_vhtcap_overrides(sdata, &own_cap);
+
+	/* take some capabilities as-is */
+	cap_info = le32_to_cpu(vht_cap_ie->vht_cap_info);
+	vht_cap->cap = cap_info;
+	vht_cap->cap &= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895 |
+			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991 |
+			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
+			IEEE80211_VHT_CAP_RXLDPC |
+			IEEE80211_VHT_CAP_VHT_TXOP_PS |
+			IEEE80211_VHT_CAP_HTC_VHT |
+			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK |
+			IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_UNSOL_MFB |
+			IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_MRQ_MFB |
+			IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
+			IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN;
+
+	/* and some based on our own capabilities */
+	switch (own_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) {
+	case IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ:
+		vht_cap->cap |= cap_info &
+				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
+		break;
+	case IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ:
+		vht_cap->cap |= cap_info &
+				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+		break;
+	default:
+		/* nothing */
+		break;
+	}
+
+	/* symmetric capabilities */
+	vht_cap->cap |= cap_info & own_cap.cap &
+			(IEEE80211_VHT_CAP_SHORT_GI_80 |
+			 IEEE80211_VHT_CAP_SHORT_GI_160);
+
+	/* remaining ones */
+	if (own_cap.cap & IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE) {
+		vht_cap->cap |= cap_info &
+				(IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
+				 IEEE80211_VHT_CAP_BEAMFORMER_ANTENNAS_MAX |
+				 IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MAX);
+	}
+
+	if (own_cap.cap & IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)
+		vht_cap->cap |= cap_info &
+				IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
+
+	if (own_cap.cap & IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)
+		vht_cap->cap |= cap_info &
+				IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
+
+	if (own_cap.cap & IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE)
+		vht_cap->cap |= cap_info &
+				IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE;
+
+	if (own_cap.cap & IEEE80211_VHT_CAP_TXSTBC)
+		vht_cap->cap |= cap_info & IEEE80211_VHT_CAP_RXSTBC_MASK;
+
+	if (own_cap.cap & IEEE80211_VHT_CAP_RXSTBC_MASK)
+		vht_cap->cap |= cap_info & IEEE80211_VHT_CAP_TXSTBC;
 
 	/* Copy peer MCS info, the driver might need them. */
 	memcpy(&vht_cap->vht_mcs, &vht_cap_ie->supp_mcs,
 	       sizeof(struct ieee80211_vht_mcs_info));
 
+	/* but also restrict MCSes */
+	for (i = 0; i < 8; i++) {
+		u16 own_rx, own_tx, peer_rx, peer_tx;
+
+		own_rx = le16_to_cpu(own_cap.vht_mcs.rx_mcs_map);
+		own_rx = (own_rx >> i * 2) & IEEE80211_VHT_MCS_NOT_SUPPORTED;
+
+		own_tx = le16_to_cpu(own_cap.vht_mcs.tx_mcs_map);
+		own_tx = (own_tx >> i * 2) & IEEE80211_VHT_MCS_NOT_SUPPORTED;
+
+		peer_rx = le16_to_cpu(vht_cap->vht_mcs.rx_mcs_map);
+		peer_rx = (peer_rx >> i * 2) & IEEE80211_VHT_MCS_NOT_SUPPORTED;
+
+		peer_tx = le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map);
+		peer_tx = (peer_tx >> i * 2) & IEEE80211_VHT_MCS_NOT_SUPPORTED;
+
+		if (peer_tx != IEEE80211_VHT_MCS_NOT_SUPPORTED) {
+			if (own_rx == IEEE80211_VHT_MCS_NOT_SUPPORTED)
+				peer_tx = IEEE80211_VHT_MCS_NOT_SUPPORTED;
+			else if (own_rx < peer_tx)
+				peer_tx = own_rx;
+		}
+
+		if (peer_rx != IEEE80211_VHT_MCS_NOT_SUPPORTED) {
+			if (own_tx == IEEE80211_VHT_MCS_NOT_SUPPORTED)
+				peer_rx = IEEE80211_VHT_MCS_NOT_SUPPORTED;
+			else if (own_tx < peer_rx)
+				peer_rx = own_tx;
+		}
+
+		vht_cap->vht_mcs.rx_mcs_map &=
+			~cpu_to_le16(IEEE80211_VHT_MCS_NOT_SUPPORTED << i * 2);
+		vht_cap->vht_mcs.rx_mcs_map |= cpu_to_le16(peer_rx << i * 2);
+
+		vht_cap->vht_mcs.tx_mcs_map &=
+			~cpu_to_le16(IEEE80211_VHT_MCS_NOT_SUPPORTED << i * 2);
+		vht_cap->vht_mcs.tx_mcs_map |= cpu_to_le16(peer_tx << i * 2);
+	}
+
+	/* finally set up the bandwidth */
 	switch (vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) {
 	case IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ:
 	case IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ:
-- 
1.8.0

