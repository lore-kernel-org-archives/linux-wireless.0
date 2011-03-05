Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46325 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1CEFTd (ORCPT
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
Subject: [PATCH 3/4] ieee80211: add IEEE80211_COUNTRY_STRING_LEN definition
Date: Fri,  4 Mar 2011 21:22:24 -0800
Message-Id: <1299302545-9672-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299302545-9672-1-git-send-email-bzhao@marvell.com>
References: <1299302545-9672-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and make use of it in wireless drivers

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/at76c50x-usb.h        |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.h     |    2 +-
 drivers/net/wireless/libertas/host.h       |    2 +-
 drivers/net/wireless/wl1251/wl12xx_80211.h |    3 +--
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    3 +--
 include/linux/ieee80211.h                  |    3 +++
 6 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.h b/drivers/net/wireless/at76c50x-usb.h
index 4a37447..f14a654 100644
--- a/drivers/net/wireless/at76c50x-usb.h
+++ b/drivers/net/wireless/at76c50x-usb.h
@@ -290,7 +290,7 @@ struct mib_mac_mgmt {
 	u8 res;
 	u8 multi_domain_capability_implemented;
 	u8 multi_domain_capability_enabled;
-	u8 country_string[3];
+	u8 country_string[IEEE80211_COUNTRY_STRING_LEN];
 	u8 reserved[3];
 } __packed;
 
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.h b/drivers/net/wireless/ipw2x00/ipw2200.h
index d7d049c..d9e1d9b 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/ipw2x00/ipw2200.h
@@ -961,7 +961,7 @@ struct ipw_country_channel_info {
 struct ipw_country_info {
 	u8 id;
 	u8 length;
-	u8 country_str[3];
+	u8 country_str[IEEE80211_COUNTRY_STRING_LEN];
 	struct ipw_country_channel_info groups[7];
 } __packed;
 
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 5eac135..6cb6935 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -387,7 +387,7 @@ struct lbs_offset_value {
 struct mrvl_ie_domain_param_set {
 	struct mrvl_ie_header header;
 
-	u8 country_code[3];
+	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	struct ieee80211_country_ie_triplet triplet[MAX_11D_TRIPLETS];
 } __packed;
 
diff --git a/drivers/net/wireless/wl1251/wl12xx_80211.h b/drivers/net/wireless/wl1251/wl12xx_80211.h
index 1846280..1417b14 100644
--- a/drivers/net/wireless/wl1251/wl12xx_80211.h
+++ b/drivers/net/wireless/wl1251/wl12xx_80211.h
@@ -54,7 +54,6 @@
 
 /* This really should be 8, but not for our firmware */
 #define MAX_SUPPORTED_RATES 32
-#define COUNTRY_STRING_LEN 3
 #define MAX_COUNTRY_TRIPLETS 32
 
 /* Headers */
@@ -98,7 +97,7 @@ struct country_triplet {
 
 struct wl12xx_ie_country {
 	struct wl12xx_ie_header header;
-	u8 country_string[COUNTRY_STRING_LEN];
+	u8 country_string[IEEE80211_COUNTRY_STRING_LEN];
 	struct country_triplet triplets[MAX_COUNTRY_TRIPLETS];
 } __packed;
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
index 67dcf8f..18fe542 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
@@ -55,7 +55,6 @@
 
 /* This really should be 8, but not for our firmware */
 #define MAX_SUPPORTED_RATES 32
-#define COUNTRY_STRING_LEN 3
 #define MAX_COUNTRY_TRIPLETS 32
 
 /* Headers */
@@ -99,7 +98,7 @@ struct country_triplet {
 
 struct wl12xx_ie_country {
 	struct wl12xx_ie_header header;
-	u8 country_string[COUNTRY_STRING_LEN];
+	u8 country_string[IEEE80211_COUNTRY_STRING_LEN];
 	struct country_triplet triplets[MAX_COUNTRY_TRIPLETS];
 } __packed;
 
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 294169e..2d1c611 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1325,6 +1325,9 @@ enum {
 /* Although the spec says 8 I'm seeing 6 in practice */
 #define IEEE80211_COUNTRY_IE_MIN_LEN	6
 
+/* The Country String field of the element shall be 3 octets in length */
+#define IEEE80211_COUNTRY_STRING_LEN	3
+
 /*
  * For regulatory extension stuff see IEEE 802.11-2007
  * Annex I (page 1141) and Annex J (page 1147). Also
-- 
1.7.0.2

