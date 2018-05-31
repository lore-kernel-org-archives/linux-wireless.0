Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0082.outbound.protection.outlook.com ([104.47.34.82]:40832
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754183AbeEaJLY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 05:11:24 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: [PATCH 4/6] qtnfmac: enable multiple SSIDs scan support
Date: Thu, 31 May 2018 12:11:00 +0300
Message-Id: <20180531091102.28666-5-sergey.matyukevich.os@quantenna.com> (sfid-20180531_111135_038980_732175C8)
In-Reply-To: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrey Shevchenko <ashevchenko@quantenna.com>

Enable support for multiple SSIDs scans. Get max number of supported
SSIDs from firmware and report to cfg80211 core.

Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 3 ++-
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 8 +++-----
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 2 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 3 +++
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 15bc26c9933f..307ab5c59bfd 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -996,7 +996,8 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	wiphy->retry_long = macinfo->lretry_limit;
 	wiphy->coverage_class = macinfo->coverage_class;
 
-	wiphy->max_scan_ssids = QTNF_MAX_SSID_LIST_LENGTH;
+	wiphy->max_scan_ssids =
+		(hw_info->max_scan_ssids) ? hw_info->max_scan_ssids : 1;
 	wiphy->max_scan_ie_len = QTNF_MAX_VSIE_LEN;
 	wiphy->mgmt_stypes = qtnf_mgmt_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index a96d58f72c07..10836695c5f5 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1092,6 +1092,9 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 		case QTN_TLV_ID_UBOOT_VER:
 			uboot_ver = (const void *)tlv->val;
 			break;
+		case QTN_TLV_ID_MAX_SCAN_SSIDS:
+			hwinfo->max_scan_ssids = *tlv->val;
+			break;
 		default:
 			break;
 		}
@@ -2260,11 +2263,6 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 	int count = 0;
 	int ret;
 
-	if (scan_req->n_ssids > QTNF_MAX_SSID_LIST_LENGTH) {
-		pr_err("MAC%u: too many SSIDs in scan request\n", mac->macid);
-		return -EINVAL;
-	}
-
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
 					    QLINK_CMD_SCAN,
 					    sizeof(struct qlink_cmd));
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 214435448335..c4808f1ba8b0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -40,7 +40,6 @@
 #undef pr_fmt
 #define pr_fmt(fmt)	KBUILD_MODNAME ": %s: " fmt, __func__
 
-#define QTNF_MAX_SSID_LIST_LENGTH	2
 #define QTNF_MAX_VSIE_LEN		255
 #define QTNF_MAX_INTF			8
 #define QTNF_MAX_EVENT_QUEUE_LEN	255
@@ -145,6 +144,7 @@ struct qtnf_hw_info {
 	u8 total_rx_chain;
 	char fw_version[ETHTOOL_FWVERS_LEN];
 	u32 hw_version;
+	u8 max_scan_ssids;
 };
 
 struct qtnf_vif *qtnf_mac_get_free_vif(struct qtnf_wmac *mac);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index cbdebf0410df..8fbef67fbbb8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -1091,6 +1091,8 @@ struct qlink_event_radar {
  * @QTN_TLV_ID_STA_STATS: per-STA statistics as defined by
  *	&struct qlink_sta_stats. Valid values are marked as such in a bitmap
  *	carried by QTN_TLV_ID_STA_STATS_MAP.
+ * @QTN_TLV_ID_MAX_SCAN_SSIDS: maximum number of SSIDs the device can scan
+ *	for in any given scan.
  */
 enum qlink_tlv_id {
 	QTN_TLV_ID_FRAG_THRESH		= 0x0201,
@@ -1119,6 +1121,7 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_CALIBRATION_VER	= 0x0406,
 	QTN_TLV_ID_UBOOT_VER		= 0x0407,
 	QTN_TLV_ID_RANDOM_MAC_ADDR	= 0x0408,
+	QTN_TLV_ID_MAX_SCAN_SSIDS	= 0x0409,
 };
 
 struct qlink_tlv_hdr {
-- 
2.11.0
