Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44380 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbbGaHka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:40:30 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/28] staging: wilc1000: remove unnecessary type cast in host_int_set_wfi_drv_handler
Date: Fri, 31 Jul 2015 16:38:22 +0900
Message-ID: <1438328316-30197-15-git-send-email-tony.cho@atmel.com> (sfid-20150731_094033_047790_A13CBBA0)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch removes unnecessary type cast since the u32 type parameter in
host_int_set_wfi_drv_handler was changed with WILC_WFIDrvHandle.
Therefore, No need to cast u32.

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c2ef46f..d077aed 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -736,7 +736,7 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
 
 	priv->u32RcvdChCount = 0;
 
-	host_int_set_wfi_drv_handler((u32)priv->hWILCWFIDrv);
+	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
 
 	reset_shadow_found(priv);
@@ -831,7 +831,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 	priv = wiphy_priv(wiphy);
 	pstrWFIDrv = (tstrWILC_WFIDrv *)(priv->hWILCWFIDrv);
 
-	host_int_set_wfi_drv_handler((u32)priv->hWILCWFIDrv);
+	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
 	#ifdef WILC_P2P
-- 
1.9.1

