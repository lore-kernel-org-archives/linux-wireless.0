Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33704 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731012AbeISLmq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:42:46 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 16/29] staging: wilc1000: refactor code to remove 'mac_status' from 'wilc_mac_cfg' struct
Date: Wed, 19 Sep 2018 11:35:06 +0530
Message-ID: <1537337119-14952-17-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080632_109439_C64A457F)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor the code by removing use of 'mac_status' from 'wilc_mac_cfg'
and only have the string type configuration values in 'wilc_mac_cfg'
struct. Now fetch the value 'WID_STATUS' configuration from 'g_cfg_byte'
array.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  4 ++--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c      | 23 ++++++++++++++---------
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e2669b9..d9f927e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -159,9 +159,9 @@ static void deinit_irq(struct net_device *dev)
 
 void wilc_mac_indicate(struct wilc *wilc)
 {
-	int status;
+	s8 status;
 
-	wilc_wlan_cfg_get_val(WID_STATUS, (unsigned char *)&status, 4);
+	wilc_wlan_cfg_get_val(WID_STATUS, &status, 1);
 	if (wilc->mac_status == MAC_STATUS_INIT) {
 		wilc->mac_status = status;
 		complete(&wilc->sync_event);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 30151b2..70bae3a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -155,7 +155,7 @@ struct wilc_vif {
 struct wilc {
 	const struct wilc_hif_func *hif_func;
 	int io_type;
-	int mac_status;
+	s8 mac_status;
 	struct gpio_desc *gpio_irq;
 	bool initialized;
 	int dev_irq_num;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 541251b..4434976 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -18,7 +18,6 @@ enum cfg_cmd_type {
 };
 
 struct wilc_mac_cfg {
-	int mac_status;
 	u8 mac_address[7];
 	u8 firmware_version[129];
 	u8 assoc_rsp[256];
@@ -251,15 +250,26 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 
 static void wilc_wlan_parse_info_frame(u8 *info)
 {
-	struct wilc_mac_cfg *pd = &g_mac;
 	u32 wid, len;
 
 	wid = info[0] | (info[1] << 8);
 
 	len = info[2];
 
-	if (len == 1 && wid == WID_STATUS)
-		pd->mac_status = info[3];
+	if (len == 1 && wid == WID_STATUS) {
+		int i = 0;
+
+		do {
+			if (g_cfg_byte[i].id == WID_NIL)
+				break;
+
+			if (g_cfg_byte[i].id == wid) {
+				g_cfg_byte[i].val = info[3];
+				break;
+			}
+			i++;
+		} while (1);
+	}
 }
 
 /********************************************
@@ -323,11 +333,6 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 	u32 type = (wid >> 12) & 0xf;
 	int i, ret = 0;
 
-	if (wid == WID_STATUS) {
-		*((u32 *)buffer) = g_mac.mac_status;
-		return 4;
-	}
-
 	i = 0;
 	if (type == CFG_BYTE_CMD) {
 		do {
-- 
2.7.4
