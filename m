Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40147 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570AbaDQFCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 01:02:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: fix IE parsing issues
Date: Wed, 16 Apr 2014 22:01:53 -0700
Message-ID: <1397710914-10061-1-git-send-email-bzhao@marvell.com> (sfid-20140417_070714_023527_B3DB593F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

IE's are parsed from beacon buffer and stored locally using
mwifiex_update_bss_desc_with_ie() function.
Sometimes the local pointers point to the data inside IE, but
while using them it is assumed that they are pointing to the IE
itself.

These issues are fixed in this patch.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11ac.c |  3 +--
 drivers/net/wireless/mwifiex/11n.c  |  3 +--
 drivers/net/wireless/mwifiex/scan.c | 20 +++++++-------------
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
index c92f27a..706831d 100644
--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -212,8 +212,7 @@ int mwifiex_cmd_append_11ac_tlv(struct mwifiex_private *priv,
 				      sizeof(struct mwifiex_ie_types_header));
 			memcpy((u8 *)vht_op +
 				sizeof(struct mwifiex_ie_types_header),
-			       (u8 *)bss_desc->bcn_vht_oper +
-			       sizeof(struct ieee_types_header),
+			       (u8 *)bss_desc->bcn_vht_oper,
 			       le16_to_cpu(vht_op->header.len));
 
 			/* negotiate the channel width and central freq
diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index d14ead8..2bd07d6 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -345,8 +345,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 
 			memcpy((u8 *) ht_info +
 			       sizeof(struct mwifiex_ie_types_header),
-			       (u8 *) bss_desc->bcn_ht_oper +
-			       sizeof(struct ieee_types_header),
+			       (u8 *)bss_desc->bcn_ht_oper,
 			       le16_to_cpu(ht_info->header.len));
 
 			if (!(sband->ht_cap.cap &
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 5c68173..d75f4eb 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1340,23 +1340,17 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					      bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_BSS_COEX_2040:
-			bss_entry->bcn_bss_co_2040 = current_ptr +
-				sizeof(struct ieee_types_header);
-			bss_entry->bss_co_2040_offset = (u16) (current_ptr +
-					sizeof(struct ieee_types_header) -
-						bss_entry->beacon_buf);
+			bss_entry->bcn_bss_co_2040 = current_ptr;
+			bss_entry->bss_co_2040_offset =
+				(u16) (current_ptr - bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_EXT_CAPABILITY:
-			bss_entry->bcn_ext_cap = current_ptr +
-				sizeof(struct ieee_types_header);
-			bss_entry->ext_cap_offset = (u16) (current_ptr +
-					sizeof(struct ieee_types_header) -
-					bss_entry->beacon_buf);
+			bss_entry->bcn_ext_cap = current_ptr;
+			bss_entry->ext_cap_offset =
+				(u16) (current_ptr - bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_OPMODE_NOTIF:
-			bss_entry->oper_mode =
-				(void *)(current_ptr +
-					 sizeof(struct ieee_types_header));
+			bss_entry->oper_mode = (void *)current_ptr;
 			bss_entry->oper_mode_offset =
 					(u16)((u8 *)bss_entry->oper_mode -
 					      bss_entry->beacon_buf);
-- 
1.8.2.3

