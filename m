Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0070.outbound.protection.outlook.com ([104.47.41.70]:4066
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751673AbdG0XHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 19:07:49 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 10/12] qtnfmac: fix handling of iftype mask reported by firmware
Date: Fri, 28 Jul 2017 02:06:52 +0300
Message-Id: <20170727230654.30850-11-sergey.matyukevich.os@quantenna.com> (sfid-20170728_013043_376670_11027641)
In-Reply-To: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware sends supported interface type rather than mask. As a result,
types field of ieee80211_iface_limit structure may end up having
multiple iftype bits set. This leads to WARN_ON from
wiphy_verify_combinations.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |  9 +++++----
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  2 +-
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 23 ++++++++++++----------
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |  2 +-
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 524269d2c30c..94656106b496 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -989,7 +989,7 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 	struct ieee80211_iface_limit *limits = NULL;
 	const struct qlink_iface_limit *limit_record;
 	size_t record_count = 0, rec = 0;
-	u16 tlv_type, tlv_value_len, mask;
+	u16 tlv_type, tlv_value_len;
 	struct qlink_iface_comb_num *comb;
 	size_t tlv_full_len;
 	const struct qlink_tlv_hdr *tlv;
@@ -1042,9 +1042,10 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 
 			limit_record = (void *)tlv->val;
 			limits[rec].max = le16_to_cpu(limit_record->max_num);
-			mask = le16_to_cpu(limit_record->type_mask);
-			limits[rec].types = qlink_iface_type_mask_to_nl(mask);
-			/* only AP and STA modes are supported */
+			limits[rec].types = qlink_iface_type_to_nl_mask(
+				le16_to_cpu(limit_record->type));
+
+			/* supported modes: STA, AP */
 			limits[rec].types &= BIT(NL80211_IFTYPE_AP) |
 					     BIT(NL80211_IFTYPE_STATION);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index c529cc1994b4..ec5126362494 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -873,7 +873,7 @@ struct qlink_tlv_hdr {
 
 struct qlink_iface_limit {
 	__le16 max_num;
-	__le16 type_mask;
+	__le16 type;
 } __packed;
 
 struct qlink_iface_comb_num {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
index 49ae652ad9a3..22fa631d692d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -17,24 +17,27 @@
 
 #include "qlink_util.h"
 
-u16 qlink_iface_type_mask_to_nl(u16 qlink_mask)
+u16 qlink_iface_type_to_nl_mask(u16 qlink_type)
 {
 	u16 result = 0;
 
-	if (qlink_mask & QLINK_IFTYPE_AP)
+	switch (qlink_type) {
+	case QLINK_IFTYPE_AP:
 		result |= BIT(NL80211_IFTYPE_AP);
-
-	if (qlink_mask & QLINK_IFTYPE_STATION)
+		break;
+	case QLINK_IFTYPE_STATION:
 		result |= BIT(NL80211_IFTYPE_STATION);
-
-	if (qlink_mask & QLINK_IFTYPE_ADHOC)
+		break;
+	case QLINK_IFTYPE_ADHOC:
 		result |= BIT(NL80211_IFTYPE_ADHOC);
-
-	if (qlink_mask & QLINK_IFTYPE_MONITOR)
+		break;
+	case QLINK_IFTYPE_MONITOR:
 		result |= BIT(NL80211_IFTYPE_MONITOR);
-
-	if (qlink_mask & QLINK_IFTYPE_WDS)
+		break;
+	case QLINK_IFTYPE_WDS:
 		result |= BIT(NL80211_IFTYPE_WDS);
+		break;
+	}
 
 	return result;
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
index 90d7d09a6c63..c9e882a3a991 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -68,7 +68,7 @@ static inline void qtnf_cmd_skb_put_tlv_u16(struct sk_buff *skb,
 	memcpy(hdr->val, &tmp, sizeof(tmp));
 }
 
-u16 qlink_iface_type_mask_to_nl(u16 qlink_mask);
+u16 qlink_iface_type_to_nl_mask(u16 qlink_type);
 u8 qlink_chan_width_mask_to_nl(u16 qlink_mask);
 
 #endif /* _QTN_FMAC_QLINK_UTIL_H_ */
-- 
2.11.0
