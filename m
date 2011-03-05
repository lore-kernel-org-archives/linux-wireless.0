Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46312 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1CEFTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 00:19:32 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: remove struct ieee_bssco_2040
Date: Fri,  4 Mar 2011 21:22:22 -0800
Message-Id: <1299302545-9672-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This struct is not necessary.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c  |    2 +-
 drivers/net/wireless/mwifiex/fw.h   |    2 +-
 drivers/net/wireless/mwifiex/ieee.h |    6 +-----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 49876e7..ffc005a 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -771,7 +771,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		       sizeof(struct mwifiex_ie_types_2040bssco));
 		bss_co_2040->header.type = cpu_to_le16(WLAN_EID_BSS_COEX_2040);
 		bss_co_2040->header.len =
-		       cpu_to_le16(sizeof(struct ieee_bssco_2040));
+		       cpu_to_le16(sizeof(bss_co_2040->bss_co_2040));
 
 		memcpy((u8 *) bss_co_2040 +
 		       sizeof(struct mwifiex_ie_types_header),
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 50f6df6..038d7d6 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1167,7 +1167,7 @@ struct mwifiex_ie_types_htinfo {
 
 struct mwifiex_ie_types_2040bssco {
 	struct mwifiex_ie_types_header header;
-	struct ieee_bssco_2040 bss_co_2040;
+	u8 bss_co_2040;
 } __packed;
 
 struct mwifiex_ie_types_extcap {
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index c9f0964..877a9f8 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -152,10 +152,6 @@ struct ieee_types_wmm_parameter {
 #define MWIFIEX_MAX_TRIPLET_802_11D		83
 #define COUNTRY_CODE_LEN			3
 
-struct ieee_bssco_2040 {
-	u8 bss_co_2040_value;
-} __packed;
-
 struct ieee_obss_scan_param {
 	u16 obss_scan_passive_dwell;
 	u16 obss_scan_active_dwell;
@@ -168,7 +164,7 @@ struct ieee_obss_scan_param {
 
 struct ieee_types_2040bssco {
 	struct ieee_types_header ieee_hdr;
-	struct ieee_bssco_2040 bss_co_2040;
+	u8 bss_co_2040;
 } __packed;
 
 struct ieee_types_obss_scan_param {
-- 
1.7.0.2

