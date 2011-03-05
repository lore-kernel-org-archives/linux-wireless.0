Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46328 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1CEFTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 00:19:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: remove COUNTRY_CODE_LEN
Date: Fri,  4 Mar 2011 21:22:25 -0800
Message-Id: <1299302545-9672-4-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299302545-9672-1-git-send-email-bzhao@marvell.com>
References: <1299302545-9672-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use IEEE80211_COUNTRY_STRING_LEN instead

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h          |    2 +-
 drivers/net/wireless/mwifiex/ieee.h        |    1 -
 drivers/net/wireless/mwifiex/main.h        |    4 ++--
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    8 +++-----
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 038d7d6..861e64a 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1062,7 +1062,7 @@ struct host_cmd_ds_802_11_bg_scan_query_rsp {
 
 struct mwifiex_ietypes_domain_param_set {
 	struct mwifiex_ie_types_header header;
-	u8 country_code[COUNTRY_CODE_LEN];
+	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	struct ieee80211_country_ie_triplet triplet[1];
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index 1c95780..c4f5c79 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -150,7 +150,6 @@ struct ieee_types_wmm_parameter {
 } __packed;
 
 #define MWIFIEX_MAX_TRIPLET_802_11D		83
-#define COUNTRY_CODE_LEN			3
 
 struct ieee_obss_scan_param {
 	u16 obss_scan_passive_dwell;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 41aeebd..6503feb 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -290,7 +290,7 @@ enum state_11d_t {
 };
 
 struct mwifiex_802_11d_domain_reg {
-	u8 country_code[COUNTRY_CODE_LEN];
+	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	u8 no_of_triplet;
 	struct ieee80211_country_ie_triplet
 		triplet[MWIFIEX_MAX_TRIPLET_802_11D];
@@ -430,7 +430,7 @@ struct mwifiex_private {
 	u8 cfg_bssid[6];
 	struct workqueue_struct *workqueue;
 	struct work_struct cfg_workqueue;
-	u8 country_code[COUNTRY_CODE_LEN];
+	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	struct wps wps;
 	u8 scan_block;
 };
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index cb56489..ebd40b2 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -853,11 +853,9 @@ int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 	u16 action = le16_to_cpu(domain_info->action);
 	u8 no_of_triplet = 0;
 
-	no_of_triplet =
-		(u8) ((le16_to_cpu(domain->header.len) -
-					3) / sizeof(struct
-					ieee80211_country_ie_triplet));
-	/* Country code is 3 bytes */
+	no_of_triplet = (u8) ((le16_to_cpu(domain->header.len) -
+					IEEE80211_COUNTRY_STRING_LEN) /
+				sizeof(struct ieee80211_country_ie_triplet));
 
 	dev_dbg(priv->adapter->dev, "info: 11D Domain Info Resp:"
 			" no_of_triplet=%d\n", no_of_triplet);
-- 
1.7.0.2

