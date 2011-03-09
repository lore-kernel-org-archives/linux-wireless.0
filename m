Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:43961 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab1CIBoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 20:44:17 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: use IEEE80211_MAX_SSID_LEN
Date: Tue,  8 Mar 2011 17:47:17 -0800
Message-Id: <1299635237-17913-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299635237-17913-1-git-send-email-bzhao@marvell.com>
References: <1299635237-17913-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

as IW_ESSID_MAX_SIZE is deprecated

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    4 ++--
 drivers/net/wireless/mwifiex/decl.h     |    4 ++--
 drivers/net/wireless/mwifiex/fw.h       |    6 +++---
 drivers/net/wireless/mwifiex/join.c     |    4 ++--
 drivers/net/wireless/mwifiex/scan.c     |    5 +++--
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 7948751..6aa5962 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -849,7 +849,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 	struct ieee80211_channel *chan;
 	struct mwifiex_bss_info bss_info;
 	int ie_len = 0;
-	u8 ie_buf[IW_ESSID_MAX_SIZE + sizeof(struct ieee_types_header)];
+	u8 ie_buf[IEEE80211_MAX_SSID_LEN + sizeof(struct ieee_types_header)];
 
 	ret = mwifiex_get_bss_info(priv, &bss_info);
 	if (ret)
@@ -1045,7 +1045,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	memset(&ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
 
 	req_ssid.ssid_len = ssid_len;
-	if (ssid_len > IW_ESSID_MAX_SIZE) {
+	if (ssid_len > IEEE80211_MAX_SSID_LEN) {
 		dev_err(priv->adapter->dev, "invalid SSID - aborting\n");
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index ef2fd10..ed44bfb 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -25,7 +25,7 @@
 
 #include <linux/wait.h>
 #include <linux/timer.h>
-#include <linux/wireless.h>
+#include <linux/ieee80211.h>
 
 
 #define MWIFIEX_MAX_BSS_NUM         (1)
@@ -113,7 +113,7 @@ struct mwifiex_fw_image {
 
 struct mwifiex_802_11_ssid {
 	u32 ssid_len;
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 };
 
 struct mwifiex_wait_queue {
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index a068d45..68e48b4 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -802,7 +802,7 @@ struct host_cmd_ds_802_11_associate_rsp {
 } __packed;
 
 struct host_cmd_ds_802_11_ad_hoc_start {
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 bss_mode;
 	__le16 beacon_period;
 	u8 dtim_period;
@@ -820,7 +820,7 @@ struct host_cmd_ds_802_11_ad_hoc_result {
 
 struct adhoc_bss_desc {
 	u8 bssid[ETH_ALEN];
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 bss_mode;
 	__le16 beacon_period;
 	u8 dtim_period;
@@ -998,7 +998,7 @@ struct mwifiex_user_scan_chan {
 } __packed;
 
 struct mwifiex_user_scan_ssid {
-	u8 ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 max_len;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 0cdc88d..48d2971 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -872,7 +872,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	 * and operational rates.
 	 */
 
-	memset(adhoc_start->ssid, 0, IW_ESSID_MAX_SIZE);
+	memset(adhoc_start->ssid, 0, IEEE80211_MAX_SSID_LEN);
 
 	memcpy(adhoc_start->ssid,
 	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid,
@@ -881,7 +881,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: SSID = %s\n",
 				adhoc_start->ssid);
 
-	memset(bss_desc->ssid.ssid, 0, IW_ESSID_MAX_SIZE);
+	memset(bss_desc->ssid.ssid, 0, IEEE80211_MAX_SSID_LEN);
 	memcpy(bss_desc->ssid.ssid,
 	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid,
 	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid_len);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index faa2ffd..f5e1ab4 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -43,8 +43,9 @@
 /* Memory needed to store a max number/size WildCard SSID TLV for a firmware
 	scan */
 #define WILDCARD_SSID_TLV_MAX_SIZE  \
-		(MWIFIEX_MAX_SSID_LIST_LENGTH  * (sizeof(struct \
-		mwifiex_ie_types_wildcard_ssid_params) + IW_ESSID_MAX_SIZE))
+	(MWIFIEX_MAX_SSID_LIST_LENGTH *					\
+		(sizeof(struct mwifiex_ie_types_wildcard_ssid_params)	\
+			+ IEEE80211_MAX_SSID_LEN))
 
 /* Maximum memory needed for a mwifiex_scan_cmd_config with all TLVs at max */
 #define MAX_SCAN_CFG_ALLOC (sizeof(struct mwifiex_scan_cmd_config)        \
-- 
1.7.0.2

