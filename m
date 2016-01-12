Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:52732 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbcALHh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 02:37:29 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 18/26] staging: wilc1000: handle connecting error
Date: Tue, 12 Jan 2016 16:39:47 +0900
Message-ID: <1452584395-24910-19-git-send-email-glen.lee@atmel.com> (sfid-20160112_083733_263214_A0168A21)
In-Reply-To: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If connection fails, wilc1000_connecting needs to be set false also and return
immediately because goto lable 'done' doesn't do anything. Remove lable 'done'
as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index fe99a13..b5731af 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -757,8 +757,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			PRINT_D(CFG80211_DBG, "No Scan results yet\n");
 		else
 			PRINT_D(CFG80211_DBG, "Required bss not in scan results: Error(%d)\n", s32Error);
-
-		goto done;
+		wilc_connecting = 0;
+		return s32Error;
 	}
 
 	priv->WILC_WFI_wep_default = 0;
@@ -845,8 +845,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		} else {
 			s32Error = -ENOTSUPP;
 			PRINT_ER("Not supported cipher: Error(%d)\n", s32Error);
-
-			goto done;
+			wilc_connecting = 0;
+			return s32Error;
 		}
 	}
 
@@ -912,11 +912,10 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0) {
 		PRINT_ER("wilc_set_join_req(): Error(%d)\n", s32Error);
 		s32Error = -ENOENT;
-		goto done;
+		wilc_connecting = 0;
+		return s32Error;
 	}
 
-done:
-
 	return s32Error;
 }
 
-- 
1.9.1

