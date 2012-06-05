Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-4.exch022.serverdata.net ([206.225.164.187]:33126
	"EHLO HUB022-nj-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761725Ab2FEKmU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 06:42:20 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: [RFC v2] cfg80211: 802.11ac change
Date: Tue, 5 Jun 2012 10:42:18 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A4FA6@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120605_124236_783089_B7C19005)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


nl80211 change to push hw VHT caps and new structs, ieee defines per Draft 2.1 AC spec.

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h |   49 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nl80211.h   |    6 +++++
 include/net/cfg80211.h    |   17 +++++++++++++++
 net/wireless/nl80211.c    |    9 ++++++++
 4 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ce9af89..758cf78 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1072,6 +1072,55 @@ struct ieee80211_ht_operation {
 #define WLAN_HT_SMPS_CONTROL_STATIC	1
 #define WLAN_HT_SMPS_CONTROL_DYNAMIC	3
 
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
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a6959f7..ac17bfc 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1788,6 +1788,9 @@ enum nl80211_mpath_info {
  * @NL80211_BAND_ATTR_HT_CAPA: HT capabilities, as in the HT information IE
  * @NL80211_BAND_ATTR_HT_AMPDU_FACTOR: A-MPDU factor, as in 11n
  * @NL80211_BAND_ATTR_HT_AMPDU_DENSITY: A-MPDU density, as in 11n
+ * @NL80211_BAND_ATTR_VHT_MCS_SET: 32-byte attribute containing the MCS set as
+ *	defined in 802.11ac
+ * @NL80211_BAND_ATTR_VHT_CAPA: VHT capabilities, as in the HT information IE
  * @NL80211_BAND_ATTR_MAX: highest band attribute currently defined
  * @__NL80211_BAND_ATTR_AFTER_LAST: internal use
  */
@@ -1801,6 +1804,9 @@ enum nl80211_band_attr {
 	NL80211_BAND_ATTR_HT_AMPDU_FACTOR,
 	NL80211_BAND_ATTR_HT_AMPDU_DENSITY,
 
+	NL80211_BAND_ATTR_VHT_MCS_SET,
+	NL80211_BAND_ATTR_VHT_CAPA,
+
 	/* keep last */
 	__NL80211_BAND_ATTR_AFTER_LAST,
 	NL80211_BAND_ATTR_MAX = __NL80211_BAND_ATTR_AFTER_LAST - 1
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0289d4c..2af16e2 100644
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
+    struct ieee80211_sta_vht_cap vht_cap;
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 206465d..0e2e64d 100644
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






