Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8668 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbJEG03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:26:29 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/18] staging: wilc1000: remove typedef from AUTHTYPE_T
Date: Mon, 5 Oct 2015 15:25:39 +0900
Message-ID: <1444026353-29024-4-git-send-email-tony.cho@atmel.com> (sfid-20151005_082631_637440_1A233D0A)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the enum AUTHTYPE_T.
And, rename it to AUTHTYPE.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 8 ++++----
 drivers/staging/wilc1000/host_interface.h         | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan_if.h           | 4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2e2a7819..bcfbb91 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -111,7 +111,7 @@ typedef struct _tstrHostIFwepAttr {
 	u8 u8WepKeylen;
 	u8 u8Wepidx;
 	u8 u8mode;
-	AUTHTYPE_T tenuAuth_type;
+	enum AUTHTYPE tenuAuth_type;
 
 } tstrHostIFwepAttr;
 
@@ -191,7 +191,7 @@ struct connect_attr {
 	u8 u8security;
 	wilc_connect_result pfConnectResult;
 	void *pvUserArg;
-	AUTHTYPE_T tenuAuth_type;
+	enum AUTHTYPE tenuAuth_type;
 	u8 u8channel;
 	void *pJoinParams;
 };
@@ -4455,7 +4455,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
  *  @date		28 FEB 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type)
+s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type)
 {
 
 	s32 s32Error = 0;
@@ -5000,7 +5000,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  wilc_connect_result pfConnectResult, void *pvUserArg,
-				  u8 u8security, AUTHTYPE_T tenuAuth_type,
+				  u8 u8security, enum AUTHTYPE tenuAuth_type,
 				  u8 u8channel,
 				  void *pJoinParams)
 {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index bed8f98..779ff99 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -240,7 +240,7 @@ typedef struct {
 	u8 *pu8bssid;
 	u8 *pu8ssid;
 	u8 u8security;
-	AUTHTYPE_T tenuAuth_type;
+	enum AUTHTYPE tenuAuth_type;
 	size_t ssidLen;
 	u8 *pu8ConnReqIEs;
 	size_t ConnReqIEsLen;
@@ -455,7 +455,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
  *  @date		28 Feb 2013
  *  @version		1.0
  */
-s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, AUTHTYPE_T tenuAuth_type);
+s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u8 u8WepKeylen, u8 u8Keyidx, u8 u8mode, enum AUTHTYPE tenuAuth_type);
 
 /**
  *  @brief              adds ptk Key
@@ -699,7 +699,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 				  const u8 *pu8ssid, size_t ssidLen,
 				  const u8 *pu8IEs, size_t IEsLen,
 				  wilc_connect_result pfConnectResult, void *pvUserArg,
-				  u8 u8security, AUTHTYPE_T tenuAuth_type,
+				  u8 u8security, enum AUTHTYPE tenuAuth_type,
 				  u8 u8channel,
 				  void *pJoinParams);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f3720e7..788cfaa 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -786,7 +786,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	s32 s32Error = 0;
 	u32 i;
 	u8 u8security = NO_ENCRYPT;
-	AUTHTYPE_T tenuAuth_type = ANY;
+	enum AUTHTYPE tenuAuth_type = ANY;
 	char *pcgroup_encrypt_val = NULL;
 	char *pccipher_group = NULL;
 	char *pcwpa_version = NULL;
@@ -1085,7 +1085,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	u8 u8mode = NO_ENCRYPT;
 	u8 u8gmode = NO_ENCRYPT;
 	u8 u8pmode = NO_ENCRYPT;
-	AUTHTYPE_T tenuAuth_type = ANY;
+	enum AUTHTYPE tenuAuth_type = ANY;
 
 	priv = wiphy_priv(wiphy);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 327ea03..b5b5c67 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -219,12 +219,12 @@ typedef enum {
 	WPA2_AES_TKIP		= 0x71,	/* Aes or Tkip */
 } SECURITY_T;
 
-typedef enum {
+enum AUTHTYPE {
 	OPEN_SYSTEM		= 1,
 	SHARED_KEY		= 2,
 	ANY			= 3,
 	IEEE8021		= 5
-} AUTHTYPE_T;
+};
 
 typedef enum {
 	SITE_SURVEY_1CH		= 0,
-- 
1.9.1

