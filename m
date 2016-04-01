Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15654 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcDAIry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 04:47:54 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 7/7] staging: wilc1000: adds a check routine when performed del_key()
Date: Fri, 1 Apr 2016 17:44:19 +0900
Message-ID: <1459500259-27873-7-git-send-email-leo.kim@atmel.com> (sfid-20160401_104758_619529_7DD44EDD)
In-Reply-To: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
References: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is adds a check routine when performed del_key().
We was find this situation while test the 'rmmod sdio'.
That is received inform a .del_key cmd from cfg80211.
If is not exist wep keys, must be ignore a wilc_remove_wep_key() function.
Thus, adds a check routine that key length of wep.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1ac835b..85031f7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1122,9 +1122,12 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	}
 
 	if (key_index >= 0 && key_index <= 3) {
-		memset(priv->WILC_WFI_wep_key[key_index], 0, priv->WILC_WFI_wep_key_len[key_index]);
-		priv->WILC_WFI_wep_key_len[key_index] = 0;
-		wilc_remove_wep_key(vif, key_index);
+		if (priv->WILC_WFI_wep_key_len[key_index]) {
+			memset(priv->WILC_WFI_wep_key[key_index], 0,
+			       priv->WILC_WFI_wep_key_len[key_index]);
+			priv->WILC_WFI_wep_key_len[key_index] = 0;
+			wilc_remove_wep_key(vif, key_index);
+		}
 	} else {
 		wilc_remove_key(priv->hif_drv, mac_addr);
 	}
-- 
1.9.1

