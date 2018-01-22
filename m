Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0073.outbound.protection.outlook.com ([104.47.38.73]:37088
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751110AbeAVMrE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:47:04 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 04/11] qtnfmac: get more hardware info from card
Date: Mon, 22 Jan 2018 15:46:27 +0300
Message-Id: <20180122124634.8430-5-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134711_002746_B5D4C225)
In-Reply-To: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasily Ulyanov <vulyanov@quantenna.com>

Various bits of hardware and firmware versions are useful for debug
and troubleshooting. Get more information from the wireless card.

Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 50 +++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 12 +++++-
 2 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index b47b06bd680f..d6bfb257cdae 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -949,6 +949,16 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 	struct qtnf_hw_info *hwinfo = &bus->hw_info;
 	const struct qlink_tlv_hdr *tlv;
 	const struct qlink_tlv_reg_rule *tlv_rule;
+	const char *bld_name = NULL;
+	const char *bld_rev = NULL;
+	const char *bld_type = NULL;
+	const char *bld_label = NULL;
+	u32 bld_tmstamp = 0;
+	u32 plat_id = 0;
+	const char *hw_id = NULL;
+	const char *calibration_ver = NULL;
+	const char *uboot_ver = NULL;
+	u32 hw_ver = 0;
 	struct ieee80211_reg_rule *rule;
 	u16 tlv_type;
 	u16 tlv_value_len;
@@ -975,6 +985,10 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 	hwinfo->rd->alpha2[0] = resp->alpha2[0];
 	hwinfo->rd->alpha2[1] = resp->alpha2[1];
 
+	bld_tmstamp = le32_to_cpu(resp->bld_tmstamp);
+	plat_id = le32_to_cpu(resp->plat_id);
+	hw_ver = le32_to_cpu(resp->hw_ver);
+
 	switch (resp->dfs_region) {
 	case QLINK_DFS_FCC:
 		hwinfo->rd->dfs_region = NL80211_DFS_FCC;
@@ -1035,6 +1049,27 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 			rule->flags = qtnf_cmd_resp_reg_rule_flags_parse(
 					le32_to_cpu(tlv_rule->flags));
 			break;
+		case QTN_TLV_ID_BUILD_NAME:
+			bld_name = (const void *)tlv->val;
+			break;
+		case QTN_TLV_ID_BUILD_REV:
+			bld_rev = (const void *)tlv->val;
+			break;
+		case QTN_TLV_ID_BUILD_TYPE:
+			bld_type = (const void *)tlv->val;
+			break;
+		case QTN_TLV_ID_BUILD_LABEL:
+			bld_label = (const void *)tlv->val;
+			break;
+		case QTN_TLV_ID_HW_ID:
+			hw_id = (const void *)tlv->val;
+			break;
+		case QTN_TLV_ID_CALIBRATION_VER:
+			calibration_ver = (const void *)tlv->val;
+			break;
+		case QTN_TLV_ID_UBOOT_VER:
+			uboot_ver = (const void *)tlv->val;
+			break;
 		default:
 			break;
 		}
@@ -1057,6 +1092,21 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 		hwinfo->total_tx_chain, hwinfo->total_rx_chain,
 		hwinfo->hw_capab);
 
+	pr_info("\nBuild name:            %s"  \
+		"\nBuild revision:        %s"  \
+		"\nBuild type:            %s"  \
+		"\nBuild label:           %s"  \
+		"\nBuild timestamp:       %lu" \
+		"\nPlatform ID:           %lu" \
+		"\nHardware ID:           %s"  \
+		"\nCalibration version:   %s"  \
+		"\nU-Boot version:        %s"  \
+		"\nHardware version:      0x%08x",
+		bld_name, bld_rev, bld_type, bld_label,
+		(unsigned long)bld_tmstamp,
+		(unsigned long)plat_id,
+		hw_id, calibration_ver, uboot_ver, hw_ver);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index f4d49565161e..51cadd2a43f0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -19,7 +19,7 @@
 
 #include <linux/ieee80211.h>
 
-#define QLINK_PROTO_VER		10
+#define QLINK_PROTO_VER		11
 
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -764,6 +764,9 @@ struct qlink_resp_get_hw_info {
 	struct qlink_resp rhdr;
 	__le32 fw_ver;
 	__le32 hw_capab;
+	__le32 bld_tmstamp;
+	__le32 plat_id;
+	__le32 hw_ver;
 	__le16 ql_proto_ver;
 	u8 num_mac;
 	u8 mac_bitmap;
@@ -1074,6 +1077,13 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_IE_SET		= 0x0305,
 	QTN_TLV_ID_EXT_CAPABILITY_MASK	= 0x0306,
 	QTN_TLV_ID_ACL_DATA		= 0x0307,
+	QTN_TLV_ID_BUILD_NAME		= 0x0401,
+	QTN_TLV_ID_BUILD_REV		= 0x0402,
+	QTN_TLV_ID_BUILD_TYPE		= 0x0403,
+	QTN_TLV_ID_BUILD_LABEL		= 0x0404,
+	QTN_TLV_ID_HW_ID		= 0x0405,
+	QTN_TLV_ID_CALIBRATION_VER	= 0x0406,
+	QTN_TLV_ID_UBOOT_VER		= 0x0407,
 };
 
 struct qlink_tlv_hdr {
-- 
2.11.0
