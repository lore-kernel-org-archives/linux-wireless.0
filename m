Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:35363 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058Ab1CaBJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 21:09:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: remove struct mwifiex_802_11_fixed_ies
Date: Wed, 30 Mar 2011 18:12:45 -0700
Message-Id: <1301533965-10878-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1301533965-10878-1-git-send-email-bzhao@marvell.com>
References: <1301533965-10878-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct mwifiex_802_11_fixed_ies is not necessary.
struct mwifiex_event_wep_icv_err is not used any more.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h   |   14 --------------
 drivers/net/wireless/mwifiex/scan.c |   16 ++++++++--------
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index d981265..2b93811 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -343,20 +343,6 @@ enum ENH_PS_MODES {
 #define EVENT_GET_BSS_TYPE(event_cause)         \
 	(((event_cause) >> 24) & 0x00ff)
 
-struct mwifiex_event_wep_icv_err {
-	u16 reason_code;
-	u8 src_mac_addr[ETH_ALEN];
-	u8 wep_key_index;
-	u8 wep_key_length;
-	u8 key[WLAN_KEY_LEN_WEP104];
-};
-
-struct mwifiex_802_11_fixed_ies {
-	u8 time_stamp[8];
-	__le16 beacon_interval;
-	__le16 capabilities;
-};
-
 struct mwifiex_ie_types_header {
 	__le16 type;
 	__le16 len;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 69ea32f..64ed60a 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1210,7 +1210,8 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	struct ieee_types_ds_param_set *ds_param_set;
 	struct ieee_types_cf_param_set *cf_param_set;
 	struct ieee_types_ibss_param_set *ibss_param_set;
-	struct mwifiex_802_11_fixed_ies fixed_ie;
+	__le16 beacon_interval;
+	__le16 capabilities;
 	u8 *current_ptr;
 	u8 *rate;
 	u8 element_len;
@@ -1283,22 +1284,21 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	bss_entry->beacon_buf_size = bytes_left_for_current_beacon;
 
 	/* Time stamp is 8 bytes long */
-	memcpy(fixed_ie.time_stamp, current_ptr, 8);
 	memcpy(bss_entry->time_stamp, current_ptr, 8);
 	current_ptr += 8;
 	bytes_left_for_current_beacon -= 8;
 
 	/* Beacon interval is 2 bytes long */
-	memcpy(&fixed_ie.beacon_interval, current_ptr, 2);
-	bss_entry->beacon_period = le16_to_cpu(fixed_ie.beacon_interval);
+	memcpy(&beacon_interval, current_ptr, 2);
+	bss_entry->beacon_period = le16_to_cpu(beacon_interval);
 	current_ptr += 2;
 	bytes_left_for_current_beacon -= 2;
 
 	/* Capability information is 2 bytes long */
-	memcpy(&fixed_ie.capabilities, current_ptr, 2);
-	dev_dbg(adapter->dev, "info: InterpretIE: fixed_ie.capabilities=0x%X\n",
-	       fixed_ie.capabilities);
-	bss_entry->cap_info_bitmap = le16_to_cpu(fixed_ie.capabilities);
+	memcpy(&capabilities, current_ptr, 2);
+	dev_dbg(adapter->dev, "info: InterpretIE: capabilities=0x%X\n",
+	       capabilities);
+	bss_entry->cap_info_bitmap = le16_to_cpu(capabilities);
 	current_ptr += 2;
 	bytes_left_for_current_beacon -= 2;
 
-- 
1.7.0.2

