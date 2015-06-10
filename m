Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:30140 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178AbbFJIHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 04:07:23 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<Rachel.kim@atmel.com>, <dean.lee@atmel.com>, <tony.cho@atmel.com>
Subject: [PATCH 4/4] staging: wilc1000: remove uninitialized warnings
Date: Wed, 10 Jun 2015 17:06:47 +0900
Message-ID: <1433923607-20927-5-git-send-email-johnny.kim@atmel.com> (sfid-20150610_100729_321892_3156CFFF)
In-Reply-To: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
References: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is for the initialization of the local variables.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index cb0765f..10de9d7 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2778,7 +2778,7 @@ late_initcall(init_wilc_driver);
 static void __exit exit_wilc_driver(void)
 {
 	int i = 0;
-	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC];
+	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
 	#define CLOSE_TIMEOUT (12 * 1000)
 
 	if ((g_linux_wlan != NULL) && (((g_linux_wlan->strInterfaceInfo[0].wilc_netdev) != NULL)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f3068c0..aa79a5d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -829,9 +829,9 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 	WILC_Uint32 i;
 	u8 u8security = NO_ENCRYPT;
 	AUTHTYPE_T tenuAuth_type = ANY;
-	WILC_Char *pcgroup_encrypt_val;
-	WILC_Char *pccipher_group;
-	WILC_Char *pcwpa_version;
+	WILC_Char *pcgroup_encrypt_val = NULL;
+	WILC_Char *pccipher_group = NULL;
+	WILC_Char *pcwpa_version = NULL;
 
 	struct WILC_WFI_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
-- 
1.9.1

