Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:2113 "EHLO
	HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158Ab2FTOJ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 10:09:56 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: [RFC] {cfg,nl,mac}80211: 802.11ac changes
Date: Wed, 20 Jun 2012 14:09:55 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3A1E@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120620_161000_298341_F8B736BA)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added 2 new NL commands to push VHT capabilities to user space as part of 11ac changes.
Added new VHT structs and defines.
Appended VHT cap IE in probe req.

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---
 include/linux/ieee80211.h  |   63 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nl80211.h    |    6 ++++
 include/net/cfg80211.h     |   17 ++++++++++++
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/util.c        |   25 +++++++++++++++++
 net/wireless/nl80211.c     |    9 ++++++
 6 files changed, 122 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ce9af89..607aee4 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1072,6 +1072,66 @@ struct ieee80211_ht_operation {
 #define WLAN_HT_SMPS_CONTROL_STATIC	1
 #define WLAN_HT_SMPS_CONTROL_DYNAMIC	3
 
+struct ieee80211_vht_capabilities {
+	__le32 vht_capabilities_info;
+	u8 vht_supported_mcs_set[8];
+} __attribute__((packed));
+
+struct ieee80211_vht_operation {
+	u8 vht_operation_information_chwidth;
+	u8 vht_operation_information_chan_center_freq1;
+	u8 vht_operation_information_chan_center_freq2;
+	__le16 vht_basic_mcs_set;
+} __attribute__((packed));
+
+/**
+ * struct ieee80211_vht_mcs_info - VHT MCS information
+ * @rx_mask: RX mask
+ * @rx_highest: highest supported RX rate. If set represents
+ *	the highest supported RX data rate in units of 1 Mbps.
+ *	If this field is 0 this value should not be used to
+ *	consider the highest RX data rate supported.
+ * @tx_params: TX parameters
+ */
+struct ieee80211_vht_mcs_info {
+	__le16 rx_mcs_map;
+	__le16 rx_highest;
+	__le16 tx_mcs_map;
+	__le16 tx_highest;
+} __attribute__((packed));
+
+#define IEEE80211_VHT_MCS_ZERO_TO_SEVEN_SUPPORT 0
+#define IEEE80211_VHT_MCS_ZERO_TO_EIGHT_SUPPORT 1
+#define IEEE80211_VHT_MCS_ZERO_TO_NINE_SUPPORT  2
+#define IEEE80211_VHT_MCS_NOT_SUPPORTED 3
+
+/* 802.11ac VHT Capabilities */
+#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991                0x00000001
+#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454               0x00000002
+#define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ              0x00000004
+#define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ     0x00000008
+#define IEEE80211_VHT_CAP_RXLDPC                              0x00000010
+#define IEEE80211_VHT_CAP_SHORT_GI_80                         0x00000020
+#define IEEE80211_VHT_CAP_SHORT_GI_160                        0x00000040
+#define IEEE80211_VHT_CAP_TXSTBC                              0x00000080
+#define IEEE80211_VHT_CAP_RXSTBC_1                            0x00000100
+#define IEEE80211_VHT_CAP_RXSTBC_2                            0x00000200
+#define IEEE80211_VHT_CAP_RXSTBC_3                            0x00000300
+#define IEEE80211_VHT_CAP_RXSTBC_4                            0x00000400
+#define IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE               0x00000800
+#define IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE               0x00001000
+#define IEEE80211_VHT_CAP_BEAMFORMER_ANTENNAS_MAX             0x00006000
+#define IEEE80211_VHT_CAP_SOUNDING_DIMENTION_MAX              0x00030000
+#define IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE               0x00080000
+#define IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE               0x00100000
+#define IEEE80211_VHT_CAP_VHT_TXOP_PS                         0x00200000
+#define IEEE80211_VHT_CAP_HTC_VHT                             0x00400000
+#define IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT          0x00800000
+#define IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_UNSOL_MFB   0x08000000
+#define IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_MRQ_MFB     0x0c000000
+#define IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN                  0x10000000
+#define IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN                  0x20000000
+
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
 #define WLAN_AUTH_SHARED_KEY 1
@@ -1332,6 +1392,9 @@ enum ieee80211_eid {
 	WLAN_EID_DSE_REGISTERED_LOCATION = 58,
 	WLAN_EID_SUPPORTED_REGULATORY_CLASSES = 59,
 	WLAN_EID_EXT_CHANSWITCH_ANN = 60,
+
+	WLAN_EID_VHT_CAPABILITY = 191,
+	WLAN_EID_VHT_OPERATION = 192,
 };
 
 /* Action category code */
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 970afdf..16ea46e 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1792,6 +1792,9 @@ enum nl80211_mpath_info {
  * @NL80211_BAND_ATTR_HT_CAPA: HT capabilities, as in the HT information IE
  * @NL80211_BAND_ATTR_HT_AMPDU_FACTOR: A-MPDU factor, as in 11n
  * @NL80211_BAND_ATTR_HT_AMPDU_DENSITY: A-MPDU density, as in 11n
+ * @NL80211_BAND_ATTR_VHT_MCS_SET: 32-byte attribute containing the MCS set as
+ *	defined in 802.11ac
+ * @NL80211_BAND_ATTR_VHT_CAPA: VHT capabilities, as in the HT information IE
  * @NL80211_BAND_ATTR_MAX: highest band attribute currently defined
  * @__NL80211_BAND_ATTR_AFTER_LAST: internal use
  */
@@ -1805,6 +1808,9 @@ enum nl80211_band_attr {
 	NL80211_BAND_ATTR_HT_AMPDU_FACTOR,
 	NL80211_BAND_ATTR_HT_AMPDU_DENSITY,
 
+	NL80211_BAND_ATTR_VHT_MCS_SET,
+	NL80211_BAND_ATTR_VHT_CAPA,
+
 	/* keep last */
 	__NL80211_BAND_ATTR_AFTER_LAST,
 	NL80211_BAND_ATTR_MAX = __NL80211_BAND_ATTR_AFTER_LAST - 1
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7319f25..5a4e5b3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -211,6 +211,22 @@ struct ieee80211_sta_ht_cap {
 };
 
 /**
+ * struct ieee80211_sta_vht_cap - STA's VHT capabilities
+ *
+ * This structure describes most essential parameters needed
+ * to describe 802.11ac VHT capabilities for an STA.
+ *
+ * @vht_supported: is VHT supported by the STA
+ * @cap: VHT capabilities map as described in 802.11ac spec
+ * @vht_mcs: Supported VHT MCS rates
+ */
+struct ieee80211_sta_vht_cap {
+	bool vht_supported;
+	u32 cap; /* use IEEE80211_VHT_CAP_ */
+	struct ieee80211_vht_mcs_info vht_mcs;
+};
+
+/**
  * struct ieee80211_supported_band - frequency band definition
  *
  * This structure describes a frequency band a wiphy
@@ -233,6 +249,7 @@ struct ieee80211_supported_band {
 	int n_channels;
 	int n_bitrates;
 	struct ieee80211_sta_ht_cap ht_cap;
+	struct ieee80211_sta_vht_cap vht_cap;
 };
 
 /*
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e6cbf5b..bd37ed7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1471,6 +1471,8 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       struct ieee80211_channel *channel,
 			       enum nl80211_channel_type channel_type,
 			       u16 prot_mode);
+u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
+					u32 cap);
 
 /* channel management */
 enum ieee80211_chan_mode {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1df4019..075fc9a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1072,6 +1072,10 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 		pos += noffset - offset;
 	}
 
+	if (sband->vht_cap.vht_supported)
+		pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
+						sband->vht_cap.cap);
+
 	return pos - buffer;
 }
 
@@ -1696,6 +1700,27 @@ u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 	return pos;
 }
 
+u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
+								u32 cap)
+{
+	__le32 tmp;
+
+	*pos++ = WLAN_EID_VHT_CAPABILITY;
+	*pos++ = sizeof(struct ieee80211_vht_capabilities);
+	memset(pos, 0, sizeof(struct ieee80211_vht_capabilities));
+
+	/* capability flags */
+	tmp = cpu_to_le16(cap);
+	memcpy(pos, &tmp, sizeof(u32));
+	pos += sizeof(u32);
+
+	/* VHT MCS set */
+	memcpy(pos, &vht_cap->vht_mcs, sizeof(vht_cap->vht_mcs));
+	pos += sizeof(vht_cap->vht_mcs);
+
+	return pos;
+}
+
 u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       struct ieee80211_channel *channel,
 			       enum nl80211_channel_type channel_type,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ae54b8..bd41a5f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -832,6 +832,15 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 				dev->wiphy.bands[band]->ht_cap.ampdu_density)))
 			goto nla_put_failure;
 
+		/* add VHT info */
+		if (dev->wiphy.bands[band]->vht_cap.vht_supported &&
+		    (nla_put(msg, NL80211_BAND_ATTR_VHT_MCS_SET,
+			     sizeof(dev->wiphy.bands[band]->vht_cap.vht_mcs),
+			     &dev->wiphy.bands[band]->vht_cap.vht_mcs) ||
+		     nla_put_u32(msg, NL80211_BAND_ATTR_VHT_CAPA,
+				 dev->wiphy.bands[band]->vht_cap.cap)))
+			goto nla_put_failure;
+
 		/* add frequencies */
 		nl_freqs = nla_nest_start(msg, NL80211_BAND_ATTR_FREQS);
 		if (!nl_freqs)

Thanks,
Mahesh



