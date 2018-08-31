Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45564 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727207AbeHaNEB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 09:04:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Fri, 31 Aug 2018 11:31:16 +0300
Message-Id: <20180831083130.15525-15-luca@coelho.fi> (sfid-20180831_105820_009688_DD86DE0E)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 14/28] ieee80211: add new VHT capability fields/parsing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

IEEE 802.11-2016 extended the VHT capability fields to allow
indicating the number of spatial streams depending on the
actually used bandwidth, add support for decoding this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h |  35 +++++++++++-
 net/wireless/util.c       | 109 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 0c9d6d0a9d47..13a73ff12cfa 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1460,13 +1460,16 @@ struct ieee80211_ht_operation {
  *	STA can receive. Rate expressed in units of 1 Mbps.
  *	If this field is 0 this value should not be used to
  *	consider the highest RX data rate supported.
- *	The top 3 bits of this field are reserved.
+ *	The top 3 bits of this field indicate the Maximum NSTS,total
+ *	(a beamformee capability.)
  * @tx_mcs_map: TX MCS map 2 bits for each stream, total 8 streams
  * @tx_highest: Indicates highest long GI VHT PPDU data rate
  *	STA can transmit. Rate expressed in units of 1 Mbps.
  *	If this field is 0 this value should not be used to
  *	consider the highest TX data rate supported.
- *	The top 3 bits of this field are reserved.
+ *	The top 2 bits of this field are reserved, the
+ *	3rd bit from the top indiciates VHT Extended NSS BW
+ *	Capability.
  */
 struct ieee80211_vht_mcs_info {
 	__le16 rx_mcs_map;
@@ -1475,6 +1478,13 @@ struct ieee80211_vht_mcs_info {
 	__le16 tx_highest;
 } __packed;
 
+/* for rx_highest */
+#define IEEE80211_VHT_MAX_NSTS_TOTAL_SHIFT	13
+#define IEEE80211_VHT_MAX_NSTS_TOTAL_MASK	(7 << IEEE80211_VHT_MAX_NSTS_TOTAL_SHIFT)
+
+/* for tx_highest */
+#define IEEE80211_VHT_EXT_NSS_BW_CAPABLE	(1 << 13)
+
 /**
  * enum ieee80211_vht_mcs_support - VHT MCS support definitions
  * @IEEE80211_VHT_MCS_SUPPORT_0_7: MCSes 0-7 are supported for the
@@ -1650,6 +1660,7 @@ struct ieee80211_mu_edca_param_set {
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ		0x00000004
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ	0x00000008
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK			0x0000000C
+#define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_SHIFT			2
 #define IEEE80211_VHT_CAP_RXLDPC				0x00000010
 #define IEEE80211_VHT_CAP_SHORT_GI_80				0x00000020
 #define IEEE80211_VHT_CAP_SHORT_GI_160				0x00000040
@@ -1678,6 +1689,26 @@ struct ieee80211_mu_edca_param_set {
 #define IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_MRQ_MFB	0x0c000000
 #define IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN			0x10000000
 #define IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN			0x20000000
+#define IEEE80211_VHT_CAP_EXT_NSS_BW_SHIFT			30
+#define IEEE80211_VHT_CAP_EXT_NSS_BW_MASK			0xc0000000
+
+/**
+ * ieee80211_get_vht_max_nss - return max NSS for a given bandwidth/MCS
+ * @cap: VHT capabilities of the peer
+ * @bw: bandwidth to use
+ * @mcs: MCS index to use
+ * @ext_nss_bw_capable: indicates whether or not the local transmitter
+ *	(rate scaling algorithm) can deal with the new logic
+ *	(dot11VHTExtendedNSSBWCapable)
+ *
+ * Due to the VHT Extended NSS Bandwidth Support, the maximum NSS can
+ * vary for a given BW/MCS. This function parses the data.
+ *
+ * Note: This function is exported by cfg80211.
+ */
+int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
+			      enum ieee80211_vht_chanwidth bw,
+			      int mcs, bool ext_nss_bw_capable);
 
 /* 802.11ax HE MAC capabilities */
 #define IEEE80211_HE_MAC_CAP0_HTC_HE				0x01
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 2a89db5f2db7..97b4095ed4d8 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -5,17 +5,20 @@
  * Copyright 2007-2009	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2017	Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  */
 #include <linux/export.h>
 #include <linux/bitops.h>
 #include <linux/etherdevice.h>
 #include <linux/slab.h>
+#include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include <net/ip.h>
 #include <net/dsfield.h>
 #include <linux/if_vlan.h>
 #include <linux/mpls.h>
 #include <linux/gcd.h>
+#include <linux/bitfield.h>
 #include "core.h"
 #include "rdev-ops.h"
 
@@ -1938,3 +1941,109 @@ void cfg80211_send_layer2_update(struct net_device *dev, const u8 *addr)
 	netif_rx_ni(skb);
 }
 EXPORT_SYMBOL(cfg80211_send_layer2_update);
+
+int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
+			      enum ieee80211_vht_chanwidth bw,
+			      int mcs, bool ext_nss_bw_capable)
+{
+	u16 map = le16_to_cpu(cap->supp_mcs.rx_mcs_map);
+	int max_vht_nss = 0;
+	int ext_nss_bw;
+	int supp_width;
+	int i, mcs_encoding;
+
+	if (map == 0xffff)
+		return 0;
+
+	if (WARN_ON(mcs > 9))
+		return 0;
+	if (mcs <= 7)
+		mcs_encoding = 0;
+	else if (mcs == 8)
+		mcs_encoding = 1;
+	else
+		mcs_encoding = 2;
+
+	/* find max_vht_nss for the given MCS */
+	for (i = 7; i >= 0; i--) {
+		int supp = (map >> (2 * i)) & 3;
+
+		if (supp == 3)
+			continue;
+
+		if (supp >= mcs_encoding) {
+			max_vht_nss = i;
+			break;
+		}
+	}
+
+	if (!(cap->supp_mcs.tx_mcs_map &
+			cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE)))
+		return max_vht_nss;
+
+	ext_nss_bw = le32_get_bits(cap->vht_cap_info,
+				   IEEE80211_VHT_CAP_EXT_NSS_BW_MASK);
+	supp_width = le32_get_bits(cap->vht_cap_info,
+				   IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK);
+
+	/* if not capable, treat ext_nss_bw as 0 */
+	if (!ext_nss_bw_capable)
+		ext_nss_bw = 0;
+
+	/* This is invalid */
+	if (supp_width == 3)
+		return 0;
+
+	/* This is an invalid combination so pretend nothing is supported */
+	if (supp_width == 2 && (ext_nss_bw == 1 || ext_nss_bw == 2))
+		return 0;
+
+	/*
+	 * Cover all the special cases according to IEEE 802.11-2016
+	 * Table 9-250. All other cases are either factor of 1 or not
+	 * valid/supported.
+	 */
+	switch (bw) {
+	case IEEE80211_VHT_CHANWIDTH_USE_HT:
+	case IEEE80211_VHT_CHANWIDTH_80MHZ:
+		if ((supp_width == 1 || supp_width == 2) &&
+		    ext_nss_bw == 3)
+			return 2 * max_vht_nss;
+		break;
+	case IEEE80211_VHT_CHANWIDTH_160MHZ:
+		if (supp_width == 0 &&
+		    (ext_nss_bw == 1 || ext_nss_bw == 2))
+			return DIV_ROUND_UP(max_vht_nss, 2);
+		if (supp_width == 0 &&
+		    ext_nss_bw == 3)
+			return DIV_ROUND_UP(3 * max_vht_nss, 4);
+		if (supp_width == 1 &&
+		    ext_nss_bw == 3)
+			return 2 * max_vht_nss;
+		break;
+	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
+		if (supp_width == 0 &&
+		    (ext_nss_bw == 1 || ext_nss_bw == 2))
+			return 0; /* not possible */
+		if (supp_width == 0 &&
+		    ext_nss_bw == 2)
+			return DIV_ROUND_UP(max_vht_nss, 2);
+		if (supp_width == 0 &&
+		    ext_nss_bw == 3)
+			return DIV_ROUND_UP(3 * max_vht_nss, 4);
+		if (supp_width == 1 &&
+		    ext_nss_bw == 0)
+			return 0; /* not possible */
+		if (supp_width == 1 &&
+		    ext_nss_bw == 1)
+			return DIV_ROUND_UP(max_vht_nss, 2);
+		if (supp_width == 1 &&
+		    ext_nss_bw == 2)
+			return DIV_ROUND_UP(3 * max_vht_nss, 4);
+		break;
+	}
+
+	/* not covered or invalid combination received */
+	return max_vht_nss;
+}
+EXPORT_SYMBOL(ieee80211_get_vht_max_nss);
-- 
2.18.0
