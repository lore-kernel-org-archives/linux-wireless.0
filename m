Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-6.exch022.serverdata.net ([206.225.164.189]:40674
	"EHLO HUB022-nj-6.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965807Ab2EQNQo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 09:16:44 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "j@w1.fi" <j@w1.fi>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Chakra Parvathaneni <chakra@posedge.com>
Subject: [RFC] 802.11AC change of beacons
Date: Thu, 17 May 2012 13:06:37 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA087410@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120517_151649_557304_485E8739)
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I modified hostapd code for incorporating VHT IEs in beacons and probe responses. Please review and let me know your comments.

Signed off by: Mahesh

-----------------------------------------------------------------------------------------------------------------
 hostapd/config_file.c        |   75 +++++++++++++++++++++++++
 hostapd/defconfig            |    3 +
 hostapd/hostapd.conf         |  127 ++++++++++++++++++++++++++++++++++++++++++
 src/ap/ap_config.h           |    4 +
 src/ap/beacon.c              |   10 +++
 src/ap/ieee802_11.h          |    2 +
 src/common/ieee802_11_defs.h |   54 ++++++++++++++++++
 src/drivers/driver.h         |   10 +++
 src/drivers/driver_nl80211.c |   12 ++++
 src/drivers/nl80211_copy.h   |    5 ++
 10 files changed, 302 insertions(+), 0 deletions(-)

diff --git a/hostapd/config_file.c b/hostapd/config_file.c
index eab8ad4..188a0de 100644
--- a/hostapd/config_file.c
+++ b/hostapd/config_file.c
@@ -1131,6 +1131,69 @@ static int hostapd_config_ht_capab(struct hostapd_config *conf,
 }
 #endif /* CONFIG_IEEE80211N */
 
+#ifdef CONFIG_IEEE80211AC
+static int hostapd_config_vht_capab(struct hostapd_config *conf,
+                   const char *capab)
+{
+    if (os_strstr(capab, "[MAX-MPDU-7991]"))
+        conf->vht_capab |= VHT_CAP_MAX_MPDU_LENGTH_7991;
+    if (os_strstr(capab, "[MAX-MPDU-11454]"))
+        conf->vht_capab |= VHT_CAP_MAX_MPDU_LENGTH_11454;
+    if (os_strstr(capab, "[VHT160]"))
+        conf->vht_capab |= VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
+    if (os_strstr(capab, "[VHT160-80PLUS80]"))
+        conf->vht_capab |= VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ;
+    if (os_strstr(capab, "[VHT160-80PLUS80]"))
+        conf->vht_capab |= VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ;
+    if (os_strstr(capab, "[RXLDPC]"))
+        conf->vht_capab |= VHT_CAP_RXLDPC;
+    if (os_strstr(capab, "[SHORT-GI-80]"))
+        conf->vht_capab |= VHT_CAP_SHORT_GI_80;
+    if (os_strstr(capab, "[SHORT-GI-160]"))
+        conf->vht_capab |= VHT_CAP_SHORT_GI_160;
+    if (os_strstr(capab, "[TX-STBC-2BY1]"))
+        conf->vht_capab |= VHT_CAP_TXSTBC;
+    if (os_strstr(capab, "[RX-STBC-1]"))
+        conf->vht_capab |= VHT_CAP_RXSTBC_1;
+    if (os_strstr(capab, "[RX-STBC-12]"))
+        conf->vht_capab |= VHT_CAP_RXSTBC_2;
+    if (os_strstr(capab, "[RX-STBC-123]"))
+        conf->vht_capab |= VHT_CAP_RXSTBC_3;
+    if (os_strstr(capab, "[RX-STBC-1234]"))
+        conf->vht_capab |= VHT_CAP_RXSTBC_4;
+    if (os_strstr(capab, "[SU-BEAMFORMER]"))
+        conf->vht_capab |= VHT_CAP_MU_BEAMFORMER_CAPABLE;
+    if (os_strstr(capab, "[SU-BEAMFORMEE]"))
+        conf->vht_capab |= VHT_CAP_MU_BEAMFORMEE_CAPABLE;
+    if (os_strstr(capab, "[BF-ANTENNA-2]") &&
+        (conf->vht_capab & VHT_CAP_MU_BEAMFORMER_CAPABLE))
+        conf->vht_capab |= VHT_CAP_BEAMFORMER_ANTENNAS_MAX;
+    if (os_strstr(capab, "[SOUNDING-DIMENSION-2]") &&
+        (conf->vht_capab & VHT_CAP_MU_BEAMFORMER_CAPABLE))
+        conf->vht_capab |= VHT_CAP_SOUNDING_DIMENTION_MAX;
+    if (os_strstr(capab, "[MU-BEAMFORMER]"))
+        conf->vht_capab |= VHT_CAP_MU_BEAMFORMER_CAPABLE;
+    if (os_strstr(capab, "[MU-BEAMFORMEE]"))
+        conf->vht_capab |= VHT_CAP_MU_BEAMFORMEE_CAPABLE;
+    if (os_strstr(capab, "[VHT-TXOP-PS]"))
+        conf->vht_capab |= VHT_CAP_VHT_TXOP_PS;
+    if (os_strstr(capab, "[HTC-VHT]"))
+        conf->vht_capab |= VHT_CAP_HTC_VHT;
+    if (os_strstr(capab, "[MAX-A-MPDU-LEN-EXP0]"))
+        conf->vht_capab |= VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT;
+    if (os_strstr(capab, "[VHT-LINK-ADAPT2]") &&
+        (conf->vht_capab & VHT_CAP_HTC_VHT))
+        conf->vht_capab |= VHT_CAP_VHT_LINK_ADAPTATION_VHT_UNSOL_MFB;
+    if (os_strstr(capab, "[VHT-LINK-ADAPT3]") &&
+        (conf->vht_capab & VHT_CAP_HTC_VHT))
+        conf->vht_capab |= VHT_CAP_VHT_LINK_ADAPTATION_VHT_MRQ_MFB;
+    if (os_strstr(capab, "[RX-ANTENNA-PATTERN]"))
+        conf->vht_capab |= VHT_CAP_RX_ANTENNA_PATTERN;
+    if (os_strstr(capab, "[TX-ANTENNA-PATTERN]"))
+        conf->vht_capab |= VHT_CAP_TX_ANTENNA_PATTERN;
+    return 0;
+}
+#endif /* CONFIG_IEEE80211AC */
 
 static int hostapd_config_check_bss(struct hostapd_bss_config *bss,
                     struct hostapd_config *conf)
@@ -2096,6 +2159,18 @@ static int hostapd_config_fill(struct hostapd_config *conf,
         } else if (os_strcmp(buf, "require_ht") == 0) {
             conf->require_ht = atoi(pos);
 #endif /* CONFIG_IEEE80211N */
+#ifdef CONFIG_IEEE80211AC
+        } else if (os_strcmp(buf, "ieee80211ac") == 0) {
+            conf->ieee80211ac = atoi(pos);
+        } else if (os_strcmp(buf, "vht_capab") == 0) {
+            if (hostapd_config_vht_capab(conf, pos) < 0) {
+                wpa_printf(MSG_ERROR, "Line %d: invalid "
+                       "vht_capab", line);
+                errors++;
+            }
+        } else if (os_strcmp(buf, "vht_oper_chwidth") == 0) {
+            conf->vht_oper_chwidth = atoi(pos);
+#endif /* CONFIG_IEEE80211AC */
         } else if (os_strcmp(buf, "max_listen_interval") == 0) {
             bss->max_listen_interval = atoi(pos);
         } else if (os_strcmp(buf, "disable_pmksa_caching") == 0) {
diff --git a/hostapd/defconfig b/hostapd/defconfig
index 3cf0d13..01c44ac 100644
--- a/hostapd/defconfig
+++ b/hostapd/defconfig
@@ -136,6 +136,9 @@ CONFIG_IPV6=y
 # IEEE 802.11n (High Throughput) support
 #CONFIG_IEEE80211N=y
 
+# IEEE 802.11ac (Very High Throughput) support
+#CONFIG_IEEE80211AC=y
+
 # Remove debugging code that is printing out debug messages to stdout.
 # This can be used to reduce the size of the hostapd considerably if debugging
 # code is not needed.
diff --git a/hostapd/hostapd.conf b/hostapd/hostapd.conf
index 611ce95..404a42d 100644
--- a/hostapd/hostapd.conf
+++ b/hostapd/hostapd.conf
@@ -416,6 +416,133 @@ wmm_ac_vo_acm=0
 # Require stations to support HT PHY (reject association if they do not)
 #require_ht=1
 
+##### IEEE 802.11ac related configuration ######################################
+
+# ieee80211ac: Whether IEEE 802.11ac (VHT) is enabled
+# 0 = disabled (default)
+# 1 = enabled
+# Note: You will also need to enable WMM for full VHT functionality.
+#ieee80211ac=1
+
+# vht_capab: VHT capabilities (list of flags)
+#
+# maxMpduLength: [MAX-MPDU-7991] [MAX-MPDU-11454]
+# Indicates maximum MPDU length
+# 0 = 3895 octets (default)
+# 1 = 7991 octets
+# 2 = 11454 octets
+# 3 = reserved
+#
+# suppChanWidth: [VHT160] [VHT160-80PLUS80]
+# Indicates supported Channel widths
+# 0 = 160Mhz & 80+80 channel widths are not supported (default)
+# 1 = 160Mhz channel width is supported
+# 2 = 160Mhz & 80+80 channel widths are supported
+# 3 = reserved
+#
+# Rx LDPC coding capability: [RXLDPC]
+# Indicates support for receiving LDPC coded pkts
+# 0 = Not supported (default)
+# 1 = Supported
+#
+# Short GI for 80 MHz: [SHORT-GI-80]
+# Indicates short GI support for reception of packets transmitted with TXVECTOR
+# params format equal to VHT and CBW = 80Mhz
+# 0 = Not supported (default)
+# 1 = Supported
+#
+# Short GI for 160 MHz: [SHORT-GI-160]
+# Indicates short GI support for reception of packets transmitted with TXVECTOR
+# params format equal to VHT and CBW = 160Mhz
+# 0 = Not supported (default)
+# 1 = Supported
+#
+# Tx STBC: [TX-STBC-2BY1]
+# Indicates support for the transmission of at least 2x1 STBC 
+# 0 = Not supported (default)
+# 1 = Supported
+#
+# Rx STBC: [RX-STBC-1] [RX-STBC-12] [RX-STBC-123] [RX-STBC-1234]
+# Indicates support for the reception of PPDUs using STBC 
+# 0 = Not supported (default)
+# 1 = support of one spatial stream
+# 2 = support of one and two spatial streams
+# 3 = support of one, two and three spatial streams
+# 4 = support of one, two, three and four spatial streams
+# 5,6,7 = reserved
+#
+# SU Beamformer Capable: [SU-BEAMFORMER]
+# Indicates support for operation as a single user beamformer
+# 0 = Not supported (default)
+# 1 = Supported
+#
+# SU Beamformee Capable: [SU-BEAMFORMEE]
+# Indicates support for operation as a single user beamformee
+# 0 = Not supported (default)
+# 1 = Supported
+#
+# Compressed Steering Number of Beamformer Antennas Supported: [BF-ANTENNA-2]
+#   Beamformee’s capability indicating the maximum number of beamformer anten- 
+#   nas the beamformee can support when sending compressed beamforming feedback 
+# If SU beamformer capable, set to maximum value minus 1
+# else reserved (default)
+#
+# Number of Sounding Dimensions: [SOUNDING-DIMENSION-2]
+# Beamformer’s capability indicating the maximum value of the NUM_STS parameter
+# in the TXVECTOR of a VHT NDP
+# If SU beamformer capable, set to maximum value minus 1
+# else reserved (default)
+#
+# MU Beamformer Capable: [MU-BEAMFORMER]
+# Indicates support for operation as an MU beamformer 
+# 0 = Not supported or sent by Non-AP STA (default)
+# 1 = Supported
+# 
+# MU Beamformee Capable: [MU-BEAMFORMEE]
+# Indicates support for operation as an MU beamformee 
+# 0 = Not supported or sent by AP (default)
+# 1 = Supported
+#
+# VHT TXOP PS: [VHT-TXOP-PS]
+# Indicates whether or not the AP supports VHT TXOP Power Save Mode
+#  or whether or not the STA is in VHT TXOP Power Save mode 
+# 0 = VHT AP doesnt support VHT TXOP PS mode (OR) VHT Sta not in VHT TXOP PS mode
+# 1 = VHT AP supports VHT TXOP PS mode (OR) VHT Sta is in VHT TXOP power save mode
+# 
+# +HTC-VHT Capable: [HTC-VHT]
+# Indicates whether or not the STA supports receiving a VHT variant HT Control field.
+# 0 = Not supported (default)
+# 1 = supported
+#
+# Maximum A-MPDU Length Exponent: [MAX-A-MPDU-LEN-EXP0] TO [MAX-A-MPDU-LEN-EXP7]
+# Indicates the maximum length of A-MPDU pre-EOF padding that the STA can recv
+# This field is an integer in the range of 0 to 7.
+# The length defined by this field is equal to 
+# 2 pow(13 + Maximum A-MPDU Length Exponent) –1 octets
+#
+# VHT Link Adaptation Capable: [VHT-LINK-ADAPT2] [VHT-LINK-ADAPT3]
+# Indicates whether or not the STA supports link adaptation using VHT variant 
+# HT Control field
+# If +HTC-VHTcapable is 1
+#  0 = (no feedback) if the STA does not provide VHT MFB (default)
+#  1 = reserved
+#  2 = (Unsolicited) if the STA provides only unsolicited VHT MFB
+#  3 = (Both) if the STA can provide VHT MFB in response to VHT MRQ and if the
+#      STA provides unsolicited VHT MFB
+# Reserved if +HTC-VHTcapable is 0
+#
+# Rx Antenna Pattern Consistency: [RX-ANTENNA-PATTERN]
+# Indicates the possibility of Rx antenna pattern change
+# 0 = Rx antenna pattern might change during the lifetime of an association
+# 1 = Rx antenna pattern does not change during the lifetime of an association
+#
+# Tx Antenna Pattern Consistency: [TX-ANTENNA-PATTERN]
+# Indicates the possibility of Tx antenna pattern change
+# 0 = Tx antenna pattern might change during the lifetime of an association
+# 1 = Tx antenna pattern does not change during the lifetime of an association
+#vht_capab=[SHORT-GI-80][HTC-VHT]
+#vht_oper_chwidth=1
+
 ##### IEEE 802.1X-2004 related configuration ##################################
 
 # Require IEEE 802.1X authorization
diff --git a/src/ap/ap_config.h b/src/ap/ap_config.h
index 78c9068..cd92614 100644
--- a/src/ap/ap_config.h
+++ b/src/ap/ap_config.h
@@ -359,6 +359,7 @@ struct hostapd_bss_config {
 #define TDLS_PROHIBIT_CHAN_SWITCH BIT(1)
     int tdls;
     int disable_11n;
+    int disable_11ac;
 
     /* IEEE 802.11v */
     int time_advertisement;
@@ -446,6 +447,9 @@ struct hostapd_config {
     int ieee80211n;
     int secondary_channel;
     int require_ht;
+    u32 vht_capab;
+    int ieee80211ac;
+    u8 vht_oper_chwidth;
 };
 
 
diff --git a/src/ap/beacon.c b/src/ap/beacon.c
index b711063..d6c9729 100644
--- a/src/ap/beacon.c
+++ b/src/ap/beacon.c
@@ -253,6 +253,11 @@ static u8 * hostapd_gen_probe_resp(struct hostapd_data *hapd,
     pos = hostapd_eid_ht_operation(hapd, pos);
 #endif /* CONFIG_IEEE80211N */
 
+#ifdef CONFIG_IEEE80211AC
+    pos = hostapd_eid_vht_capabilities(hapd, pos);
+    pos = hostapd_eid_vht_operation(hapd, pos);
+#endif /* CONFIG_IEEE80211AC */
+
     pos = hostapd_eid_ext_capab(hapd, pos);
 
     pos = hostapd_eid_time_adv(hapd, pos);
@@ -583,6 +588,11 @@ void ieee802_11_set_beacon(struct hostapd_data *hapd)
     tailpos = hostapd_eid_ht_operation(hapd, tailpos);
 #endif /* CONFIG_IEEE80211N */
 
+#ifdef CONFIG_IEEE80211AC
+    tailpos = hostapd_eid_vht_capabilities(hapd, tailpos);
+    tailpos = hostapd_eid_vht_operation(hapd, tailpos);
+#endif /* CONFIG_IEEE80211AC */
+
     tailpos = hostapd_eid_ext_capab(hapd, tailpos);
 
     /*
diff --git a/src/ap/ieee802_11.h b/src/ap/ieee802_11.h
index d30e90f..f2b8f63 100644
--- a/src/ap/ieee802_11.h
+++ b/src/ap/ieee802_11.h
@@ -45,6 +45,8 @@ u8 * hostapd_eid_supp_rates(struct hostapd_data *hapd, u8 *eid);
 u8 * hostapd_eid_ext_supp_rates(struct hostapd_data *hapd, u8 *eid);
 u8 * hostapd_eid_ht_capabilities(struct hostapd_data *hapd, u8 *eid);
 u8 * hostapd_eid_ht_operation(struct hostapd_data *hapd, u8 *eid);
+u8 * hostapd_eid_vht_capabilities(struct hostapd_data *hapd, u8 *eid);
+u8 * hostapd_eid_vht_operation(struct hostapd_data *hapd, u8 *eid);
 int hostapd_ht_operation_update(struct hostapd_iface *iface);
 void ieee802_11_send_sa_query_req(struct hostapd_data *hapd,
                   const u8 *addr, const u8 *trans_id);
diff --git a/src/common/ieee802_11_defs.h b/src/common/ieee802_11_defs.h
index 27b9e61..4efbe16 100644
--- a/src/common/ieee802_11_defs.h
+++ b/src/common/ieee802_11_defs.h
@@ -237,6 +237,15 @@
 #define WLAN_EID_ADV_PROTO 108
 #define WLAN_EID_ROAMING_CONSORTIUM 111
 #define WLAN_EID_EXT_CAPAB 127
+#define WLAN_EID_VHT_CAP 191
+#define WLAN_EID_VHT_OPERATION 192
+#define WLAN_EID_VHT_EXTENDED_BSS_LOAD 193
+#define WLAN_EID_VHT_WIDE_BW_CHSWITCH  194
+#define WLAN_EID_VHT_TRANSMIT_POWER_ENVELOPE 195
+#define WLAN_EID_VHT_EXTENDED_POWER_CONSTRAINT 196
+#define WLAN_EID_VHT_AID 197
+#define WLAN_EID_VHT_QUIET_CHANNEL 198
+#define WLAN_EID_VHT_OPERATING_MODE_NOTIFICATION 199
 #define WLAN_EID_VENDOR_SPECIFIC 221
 
 
@@ -549,6 +558,24 @@ struct ieee80211_ht_operation {
     u8 basic_set[16];
 } STRUCT_PACKED;
 
+struct ieee80211_vht_capabilities {
+    le32 vht_capabilities_info;
+    u8 vht_supported_mcs_set[8];
+} STRUCT_PACKED;
+
+struct ieee80211_vht_operation {
+    u8 vht_operation_information_chwidth;
+    u8 vht_operation_information_chan_center_freq1;
+    u8 vht_operation_information_chan_center_freq2;
+    le16 vht_basic_mcs_set; 
+} STRUCT_PACKED;
+
+struct ieee80211_vht_tx_power_envelope {
+    u8 vht_max_tx_power;
+    u8 vht_chan_center_freq_segment;
+    u8 vht_segment_chan_width;
+} STRUCT_PACKED;
+
 #ifdef _MSC_VER
 #pragma pack(pop)
 #endif /* _MSC_VER */
@@ -645,6 +672,33 @@ struct ieee80211_ht_operation {
 
 #define BSS_MEMBERSHIP_SELECTOR_HT_PHY 127
 
+/* VHT Defines */
+#define VHT_CAP_MAX_MPDU_LENGTH_7991                ((u32) BIT(0))
+#define VHT_CAP_MAX_MPDU_LENGTH_11454               ((u32) BIT(1))
+#define VHT_CAP_SUPP_CHAN_WIDTH_160MHZ              ((u32) BIT(2))
+#define VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ     ((u32) BIT(3))
+#define VHT_CAP_RXLDPC                              ((u32) BIT(4))
+#define VHT_CAP_SHORT_GI_80                         ((u32) BIT(5))
+#define VHT_CAP_SHORT_GI_160                        ((u32) BIT(6))
+#define VHT_CAP_TXSTBC                              ((u32) BIT(7))
+#define VHT_CAP_RXSTBC_1                            ((u32) BIT(8))
+#define VHT_CAP_RXSTBC_2                            ((u32) BIT(9))
+#define VHT_CAP_RXSTBC_3                            ((u32) BIT(8) | BIT(9))
+#define VHT_CAP_RXSTBC_4                            ((u32) BIT(10))
+#define VHT_CAP_SU_BEAMFORMER_CAPABLE               ((u32) BIT(11))
+#define VHT_CAP_SU_BEAMFORMEE_CAPABLE               ((u32) BIT(12))
+#define VHT_CAP_BEAMFORMER_ANTENNAS_MAX             ((u32) BIT(13) | BIT(14))
+#define VHT_CAP_SOUNDING_DIMENTION_MAX              ((u32) BIT(16) | BIT(17))
+#define VHT_CAP_MU_BEAMFORMER_CAPABLE               ((u32) BIT(19))
+#define VHT_CAP_MU_BEAMFORMEE_CAPABLE               ((u32) BIT(20))
+#define VHT_CAP_VHT_TXOP_PS                         ((u32) BIT(21))
+#define VHT_CAP_HTC_VHT                             ((u32) BIT(22))
+#define VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT          ((u32) BIT(23))
+#define VHT_CAP_VHT_LINK_ADAPTATION_VHT_UNSOL_MFB   ((u32) BIT(27))
+#define VHT_CAP_VHT_LINK_ADAPTATION_VHT_MRQ_MFB     ((u32) BIT(26) | BIT(27))
+#define VHT_CAP_RX_ANTENNA_PATTERN                  ((u32) BIT(28))
+#define VHT_CAP_TX_ANTENNA_PATTERN                  ((u32) BIT(29))
+
 #define OUI_MICROSOFT 0x0050f2 /* Microsoft (also used in Wi-Fi specs)
                 * 00:50:F2 */
 #define WPA_IE_VENDOR_TYPE 0x0050f201
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index f7fb2ef..550f1a4 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -100,6 +100,16 @@ struct hostapd_hw_modes {
      */
     u8 a_mpdu_params;
 
+    /**
+     * vht_capab - VHT (IEEE 802.11ac) capabilities
+     */
+    u32 vht_capab;
+
+    /**
+     * vht_mcs_set - VHT MCS (IEEE 802.11ac) rate parameters
+     */
+    u8 vht_mcs_set[8];
+
     unsigned int flags; /* HOSTAPD_MODE_FLAG_* */
 };
 
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 693a885..ac1dc4e 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -4757,6 +4757,18 @@ static int phy_info_handler(struct nl_msg *msg, void *arg)
             os_memcpy(mode->mcs_set, mcs, 16);
         }
 
+        if (tb_band[NL80211_BAND_ATTR_VHT_CAPA]) {
+            mode->vht_capab = nla_get_u32(
+                tb_band[NL80211_BAND_ATTR_VHT_CAPA]);
+        }
+
+        if (tb_band[NL80211_BAND_ATTR_VHT_MCS_SET] &&
+            nla_len(tb_band[NL80211_BAND_ATTR_VHT_MCS_SET])) {
+            u8 *mcs;
+            mcs = nla_data(tb_band[NL80211_BAND_ATTR_VHT_MCS_SET]);
+            os_memcpy(mode->vht_mcs_set, mcs, 8);
+        }
+
         nla_for_each_nested(nl_freq, tb_band[NL80211_BAND_ATTR_FREQS], rem_freq) {
             nla_parse(tb_freq, NL80211_FREQUENCY_ATTR_MAX, nla_data(nl_freq),
                   nla_len(nl_freq), freq_policy);
diff --git a/src/drivers/nl80211_copy.h b/src/drivers/nl80211_copy.h
index 1335084..1885247 100644
--- a/src/drivers/nl80211_copy.h
+++ b/src/drivers/nl80211_copy.h
@@ -1786,6 +1786,9 @@ enum nl80211_mpath_info {
  * @NL80211_BAND_ATTR_HT_CAPA: HT capabilities, as in the HT information IE
  * @NL80211_BAND_ATTR_HT_AMPDU_FACTOR: A-MPDU factor, as in 11n
  * @NL80211_BAND_ATTR_HT_AMPDU_DENSITY: A-MPDU density, as in 11n
+ * @NL80211_BAND_ATTR_VHT_CAPA: VHT capabilities, as in the VHT capabilities IE
+ * @NL80211_BAND_ATTR_VHT_MCS_SET: 8-byte attribute containing the MCS set as
+ *    defined in 802.11ac
  * @NL80211_BAND_ATTR_MAX: highest band attribute currently defined
  * @__NL80211_BAND_ATTR_AFTER_LAST: internal use
  */
@@ -1798,6 +1801,8 @@ enum nl80211_band_attr {
     NL80211_BAND_ATTR_HT_CAPA,
     NL80211_BAND_ATTR_HT_AMPDU_FACTOR,
     NL80211_BAND_ATTR_HT_AMPDU_DENSITY,
+    NL80211_BAND_ATTR_VHT_CAPA,
+    NL80211_BAND_ATTR_VHT_MCS_SET,
 
     /* keep last */
     __NL80211_BAND_ATTR_AFTER_LAST,

Thanks,
Mahesh




