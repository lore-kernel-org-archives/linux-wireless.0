Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:36079 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1AGE6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 23:58:32 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove struct ieee_types_erp_info
Date: Thu,  6 Jan 2011 20:59:14 -0800
Message-Id: <1294376354-13438-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This structure is not necessary.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/ieee.h |    6 ------
 drivers/net/wireless/mwifiex/scan.c |    5 +----
 2 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index 70af50c..2282c0c 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -93,12 +93,6 @@ union ieee_types_phy_param_set {
 	struct ieee_types_ds_param_set ds_param_set;
 } __packed;
 
-struct ieee_types_erp_info {
-	u8 element_id;
-	u8 len;
-	u8 erp_flags;
-} __packed;
-
 struct ieee_types_assoc_rsp {
 	__le16 cap_info_bitmap;
 	__le16 status_code;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 104589e..83e466e 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1348,8 +1348,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	u16 beacon_size;
 	u8 found_data_rate_ie;
 	u32 bytes_left_for_current_beacon;
-	struct ieee_types_erp_info *erp_info;
-
 	struct ieee_types_vendor_specific *vendor_ie;
 	const u8 wpa_oui[4] = { 0x00, 0x50, 0xf2, 0x01 };
 	const u8 wmm_oui[4] = { 0x00, 0x50, 0xf2, 0x02 };
@@ -1532,8 +1530,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_ERP_INFO:
-			erp_info = (struct ieee_types_erp_info *) current_ptr;
-			bss_entry->erp_flags = erp_info->erp_flags;
+			bss_entry->erp_flags = *(current_ptr + 2);
 			break;
 
 		case WLAN_EID_EXT_SUPP_RATES:
-- 
1.7.0.2

