Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33947 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbbILFhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 01:37:54 -0400
Received: by padhy16 with SMTP id hy16so93282807pad.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2015 22:37:54 -0700 (PDT)
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH] Staging: wilc1000: wilc_wfi_cfgoperations.c: replace memset(x,0,ETH_ALEN)
Date: Sat, 12 Sep 2015 11:07:39 +0530
Message-Id: <1442036259-2693-1-git-send-email-shraddha.6596@gmail.com> (sfid-20150912_073818_720532_D7160B71)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

eth_zero_addr() is a wrapper function for memset if 0 is going to
be assigned to a mac address. The aforementioned function replaces
memset.

Changes were done using Coccinelle

@eth_zero_addr@
expression e;
@@

-memset(e,0x00,\(6\|ETH_ALEN\));
+eth_zero_addr(e);

Build tested it.

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a6edc97..68482d95 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -575,7 +575,7 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 			 *  = SUCCESSFUL_STATUSCODE, while mac status is MAC_DISCONNECTED (which means something wrong happened) */
 			u16ConnectStatus = WLAN_STATUS_UNSPECIFIED_FAILURE;
 			linux_wlan_set_bssid(priv->dev, NullBssid);
-			memset(u8ConnectedSSID, 0, ETH_ALEN);
+			eth_zero_addr(u8ConnectedSSID);
 
 			/*BugID_5457*/
 			/*Invalidate u8WLANChannel value on wlan0 disconnect*/
@@ -641,9 +641,9 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 		u8P2Plocalrandom = 0x01;
 		u8P2Precvrandom = 0x00;
 		bWilc_ie = false;
-		memset(priv->au8AssociatedBss, 0, ETH_ALEN);
+		eth_zero_addr(priv->au8AssociatedBss);
 		linux_wlan_set_bssid(priv->dev, NullBssid);
-		memset(u8ConnectedSSID, 0, ETH_ALEN);
+		eth_zero_addr(u8ConnectedSSID);
 
 		/*BugID_5457*/
 		/*Invalidate u8WLANChannel value on wlan0 disconnect*/
-- 
2.1.4

