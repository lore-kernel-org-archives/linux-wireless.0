Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:44746 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729891AbeGSGqO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:14 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/23] staging: wilc1000: rename enum AUTHTYPE to use lowercase
Date: Thu, 19 Jul 2018 04:15:04 +0530
Message-ID: <1531953919-20804-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080459_958240_AC0AE990)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to rename enum AUTHTYPE to lowercase.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 8 ++++----
 drivers/staging/wilc1000/host_interface.h         | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           | 2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a5c0ac5..0ffe205 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -26,7 +26,7 @@ struct host_if_wep_attr {
 	u8 key_len;
 	u8 index;
 	u8 mode;
-	enum AUTHTYPE auth_type;
+	enum authtype auth_type;
 };
 
 union host_if_key_attr {
@@ -62,7 +62,7 @@ struct connect_attr {
 	u8 security;
 	wilc_connect_result result;
 	void *arg;
-	enum AUTHTYPE auth_type;
+	enum authtype auth_type;
 	u8 ch;
 	void *params;
 };
@@ -2632,7 +2632,7 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 }
 
 int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
-			    u8 index, u8 mode, enum AUTHTYPE auth_type)
+			    u8 index, u8 mode, enum authtype auth_type)
 {
 	int result;
 	struct host_if_msg *msg;
@@ -2876,7 +2876,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
-		      u8 security, enum AUTHTYPE auth_type,
+		      u8 security, enum authtype auth_type,
 		      u8 channel, void *join_params)
 {
 	int result = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7f3e48c..79166a5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -207,7 +207,7 @@ struct user_conn_req {
 	u8 *bssid;
 	u8 *ssid;
 	u8 security;
-	enum AUTHTYPE auth_type;
+	enum authtype auth_type;
 	size_t ssid_len;
 	u8 *ies;
 	size_t ies_len;
@@ -298,7 +298,7 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index);
 int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 			     u8 index);
 int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
-			    u8 index, u8 mode, enum AUTHTYPE auth_type);
+			    u8 index, u8 mode, enum authtype auth_type);
 int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 		 const u8 *mac_addr, const u8 *rx_mic, const u8 *tx_mic,
 		 u8 mode, u8 cipher_mode, u8 index);
@@ -314,7 +314,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
-		      u8 security, enum AUTHTYPE auth_type,
+		      u8 security, enum authtype auth_type,
 		      u8 channel, void *join_params);
 int wilc_disconnect(struct wilc_vif *vif, u16 reason_code);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 73606c3..8f1c595 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -678,7 +678,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	u32 i;
 	u32 sel_bssi_idx = UINT_MAX;
 	u8 security = NO_ENCRYPT;
-	enum AUTHTYPE auth_type = ANY;
+	enum authtype auth_type = ANY;
 	u32 cipher_group;
 	struct wilc_priv *priv;
 	struct host_if_drv *wfi_drv;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index b82e149..73b57fb 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -131,7 +131,7 @@ enum {
 	WPA2_AES_TKIP		= 0x71,	/* Aes or Tkip */
 };
 
-enum AUTHTYPE {
+enum authtype {
 	OPEN_SYSTEM		= 1,
 	SHARED_KEY		= 2,
 	ANY			= 3,
-- 
2.7.4
