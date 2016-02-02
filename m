Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9095 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbcBBMFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:05:24 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/26] staging: wilc1000: remove typedef from pstrNetworkInfo
Date: Tue, 2 Feb 2016 21:02:15 +0900
Message-ID: <1454414556-9822-5-git-send-email-leo.kim@atmel.com> (sfid-20160202_130528_489193_44CA7213)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct pstrNetworkInfo and
renames it to network_info.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  7 ++++---
 drivers/staging/wilc1000/coreconfigurator.h       |  7 ++++---
 drivers/staging/wilc1000/host_interface.c         |  6 +++---
 drivers/staging/wilc1000/host_interface.h         |  4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++++-------
 5 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index e9f6262..0d0a4ec 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -270,9 +270,10 @@ static u8 get_current_channel_802_11n(u8 *pu8msa, u16 rx_len)
 	return 0;
 }
 
-s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
+s32 wilc_parse_network_info(u8 *msg_buffer,
+			    struct network_info **ret_network_info)
 {
-	tstrNetworkInfo *network_info = NULL;
+	struct network_info *network_info = NULL;
 	u8 msg_type = 0;
 	u8 msg_id = 0;
 	u16 msg_len = 0;
@@ -304,7 +305,7 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
 		u32 tsf_lo;
 		u32 tsf_hi;
 
-		network_info = kzalloc(sizeof(tstrNetworkInfo), GFP_KERNEL);
+		network_info = kzalloc(sizeof(*network_info), GFP_KERNEL);
 		if (!network_info)
 			return -ENOMEM;
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index aa9aee6..214b43b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -76,7 +76,7 @@ typedef struct {
 	s8 as8RSSI[NUM_RSSI];
 } tstrRSSI;
 
-typedef struct {
+struct network_info {
 	s8 s8rssi;
 	u16 u16CapInfo;
 	u8 au8ssid[MAX_SSID_LEN];
@@ -95,7 +95,7 @@ typedef struct {
 	void *pJoinParams;
 	tstrRSSI strRssi;
 	u64 u64Tsf;
-} tstrNetworkInfo;
+};
 
 struct connect_resp_info {
 	u16 capability;
@@ -120,7 +120,8 @@ typedef struct {
 	size_t ie_len;
 } tstrDisconnectNotifInfo;
 
-s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info);
+s32 wilc_parse_network_info(u8 *msg_buffer,
+			    struct network_info **ret_network_info);
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 			       struct connect_resp_info **ret_connect_resp_info);
 void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f8dc657..355bee7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -272,7 +272,7 @@ static struct wilc_vif *join_req_vif;
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79
 
-static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
+static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo);
 
 /* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
  * special purpose in wilc device, so we add 1 to the index to starts from 1.
@@ -1352,7 +1352,7 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 	u32 i;
 	bool bNewNtwrkFound;
 	s32 result = 0;
-	tstrNetworkInfo *pstrNetworkInfo = NULL;
+	struct network_info *pstrNetworkInfo = NULL;
 	void *pJoinParams = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -4256,7 +4256,7 @@ s32 wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
 	return result;
 }
 
-static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
+static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 {
 	struct join_bss_param *pNewJoinBssParam = NULL;
 	u8 *pu8IEs;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7724ade..6fae371 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -168,8 +168,8 @@ enum KEY_TYPE {
 	PMKSA,
 };
 
-typedef void (*wilc_scan_result)(enum scan_event, tstrNetworkInfo *,
-				  void *, void *);
+typedef void (*wilc_scan_result)(enum scan_event, struct network_info *,
+				 void *, void *);
 
 typedef void (*wilc_connect_result)(enum conn_event,
 				     tstrConnectInfo *,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4310abe..8a007743 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -93,7 +93,7 @@ static const struct wiphy_wowlan_support wowlan_support = {
 extern int wilc_mac_open(struct net_device *ndev);
 extern int wilc_mac_close(struct net_device *ndev);
 
-static tstrNetworkInfo last_scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
+static struct network_info last_scanned_shadow[MAX_NUM_SCANNED_NETWORKS_SHADOW];
 static u32 last_scanned_cnt;
 struct timer_list wilc_during_ip_timer;
 static struct timer_list hAgingTimer;
@@ -206,7 +206,7 @@ static void clear_shadow_scan(void)
 	}
 }
 
-static u32 get_rssi_avg(tstrNetworkInfo *network_info)
+static u32 get_rssi_avg(struct network_info *network_info)
 {
 	u8 i;
 	int rssi_v = 0;
@@ -231,7 +231,7 @@ static void refresh_scan(void *user_void, u8 all, bool direct_scan)
 	wiphy = priv->dev->ieee80211_ptr->wiphy;
 
 	for (i = 0; i < last_scanned_cnt; i++) {
-		tstrNetworkInfo *network_info;
+		struct network_info *network_info;
 
 		network_info = &last_scanned_shadow[i];
 
@@ -310,7 +310,7 @@ static void clear_duringIP(unsigned long arg)
 	wilc_optaining_ip = false;
 }
 
-static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo,
+static int is_network_in_shadow(struct network_info *pstrNetworkInfo,
 				void *user_void)
 {
 	int state = -1;
@@ -333,7 +333,7 @@ static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo,
 	return state;
 }
 
-static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo,
+static void add_network_to_shadow(struct network_info *pstrNetworkInfo,
 				  void *user_void, void *pJoinParams)
 {
 	int ap_found = is_network_in_shadow(pstrNetworkInfo, user_void);
@@ -384,7 +384,7 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo,
 }
 
 static void CfgScanResult(enum scan_event scan_event,
-			  tstrNetworkInfo *network_info,
+			  struct network_info *network_info,
 			  void *user_void,
 			  void *join_params)
 {
@@ -693,7 +693,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	struct wilc_priv *priv;
 	struct host_if_drv *pstrWFIDrv;
-	tstrNetworkInfo *pstrNetworkInfo = NULL;
+	struct network_info *pstrNetworkInfo = NULL;
 	struct wilc_vif *vif;
 
 	wilc_connecting = 1;
-- 
1.9.1

