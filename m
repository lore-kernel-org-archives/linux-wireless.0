Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:9242 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbcBDJXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:23:17 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 04/70] staging: wilc1000: handle connecting error
Date: Thu, 4 Feb 2016 18:15:21 +0900
Message-ID: <1454577387-509-5-git-send-email-glen.lee@atmel.com> (sfid-20160204_102322_342420_3ED2DBBF)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
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
index b0350da..4d63282 100644
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

