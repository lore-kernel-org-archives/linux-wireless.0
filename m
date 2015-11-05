Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26650 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbbKEFe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:34:56 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 15/38] staging: wilc1000: rename pIP_Add_buff of function dev_state_ev_handler
Date: Thu, 5 Nov 2015 14:36:16 +0900
Message-ID: <1446701799-24870-15-git-send-email-glen.lee@atmel.com> (sfid-20151105_063756_944122_A6952B83)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pIP_Add_buff of function dev_state_ev_handler to ip_addr_buf
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index a8d9bcd9..2900ea7 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -124,7 +124,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 	struct wilc_priv *priv;
 	struct host_if_drv *hif_drv;
 	struct net_device *dev;
-	u8 *pIP_Add_buff;
+	u8 *ip_addr_buf;
 	perInterface_wlan_t *nic;
 	u8 null_ip[4] = {0};
 	char wlan_dev_name[5] = "wlan0";
@@ -177,9 +177,11 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
 
-		pIP_Add_buff = (char *) (&(dev_iface->ifa_address));
-		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
-		host_int_setup_ipaddress(hif_drv, pIP_Add_buff, nic->u8IfIdx);
+		ip_addr_buf = (char *)&dev_iface->ifa_address;
+		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n",
+			ip_addr_buf[0], ip_addr_buf[1],
+			ip_addr_buf[2], ip_addr_buf[3]);
+		host_int_setup_ipaddress(hif_drv, ip_addr_buf, nic->u8IfIdx);
 
 		break;
 
@@ -199,10 +201,12 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 		PRINT_D(GENERIC_DBG, "[%s] Down IP\n", dev_iface->ifa_label);
 
-		pIP_Add_buff = null_ip;
-		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
+		ip_addr_buf = null_ip;
+		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n",
+			ip_addr_buf[0], ip_addr_buf[1],
+			ip_addr_buf[2], ip_addr_buf[3]);
 
-		host_int_setup_ipaddress(hif_drv, pIP_Add_buff, nic->u8IfIdx);
+		host_int_setup_ipaddress(hif_drv, ip_addr_buf, nic->u8IfIdx);
 
 		break;
 
-- 
1.9.1

