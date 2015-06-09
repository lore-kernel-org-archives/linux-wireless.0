Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0125.outbound.protection.outlook.com ([157.56.112.125]:7455
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933018AbbFILwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 07:52:01 -0400
From: "Ravindran, Madhusudhanan (M.)" <mravindr@visteon.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>
Subject: [PATCH] staging: wilc1000: remove unused variables
Date: Tue, 9 Jun 2015 11:19:06 +0000
Message-ID: <20150609111846.GA30803@madhu-OptiPlex-7010> (sfid-20150609_135223_237435_7519226B)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Madhusudhanan Ravindran <mravindr@visteon.com>

removed few variables which are assigned but
never used.

Signed-off-by: Madhusudhanan Ravindran <mravindr@visteon.com>
---
 drivers/staging/wilc1000/linux_wlan.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 592b8ae..860f336 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -259,7 +259,6 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 	tstrWILC_WFIDrv *pstrWFIDrv;
 	struct net_device *dev;
 	u8 *pIP_Add_buff;
-	WILC_Sint32 s32status = WILC_FAIL;
 	perInterface_wlan_t *nic;
 	u8 null_ip[4] = {0};
 	char wlan_dev_name[5] = "wlan0";
@@ -317,7 +316,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 		pIP_Add_buff = (char *) (&(dev_iface->ifa_address));
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d \n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
-		s32status = host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
@@ -341,7 +340,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		pIP_Add_buff = null_ip;
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d \n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
 
-		s32status = host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		host_int_setup_ipaddress((WILC_WFIDrvHandle)pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
@@ -1102,7 +1101,6 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	#ifndef STATIC_MACADDRESS
 	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
 	#endif
-	unsigned int chipid = 0;
 
 	/*BugID_5077*/
 	struct WILC_WFI_priv *priv;
@@ -1118,7 +1116,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	PRINT_D(INIT_DBG, "Host = %x\n", (WILC_Uint32)pstrWFIDrv);
 
 	PRINT_D(INIT_DBG, "MAC address is : %02x-%02x-%02x-%02x-%02x-%02x\n", mac_add[0], mac_add[1], mac_add[2], mac_add[3], mac_add[4], mac_add[5]);
-	chipid = wilc_get_chipid(0);
+	wilc_get_chipid(0);
 
 
 	if (g_linux_wlan->oup.wlan_cfg_set == NULL) {
@@ -2066,7 +2064,6 @@ int mac_open(struct net_device *ndev)
 	/*No need for setting mac address here anymore,*/
 	/*Just set it in init_test_config()*/
 	unsigned char mac_add[ETH_ALEN] = {0};
-	int status;
 	int ret = 0;
 	int i = 0;
 	struct WILC_WFI_priv *priv;
@@ -2095,7 +2092,7 @@ int mac_open(struct net_device *ndev)
 
 	Set_machw_change_vir_if(WILC_FALSE);
 
-	status = host_int_get_MacAddress(priv->hWILCWFIDrv, mac_add);
+	host_int_get_MacAddress(priv->hWILCWFIDrv, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %x:%x:%x:%x:%x:%x\n", mac_add[0], mac_add[1], mac_add[2],
 		mac_add[3], mac_add[4], mac_add[5]);
 
-- 
1.7.9.5
