Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34079 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932489AbeCMKIR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 06:08:17 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com
Cc: hariprasath.elango@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: replace switch statement by simple if condition
Date: Tue, 13 Mar 2018 15:37:51 +0530
Message-Id: <20180313100752.11593-1-hariprasath.elango@gmail.com> (sfid-20180313_110831_365114_54878F00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

In this case,there is only a single switch case statement.So replacing
by a simple if condition.

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c901108..17bd762 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -772,14 +772,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (sme->crypto.n_akm_suites) {
-		switch (sme->crypto.akm_suites[0]) {
-		case WLAN_AKM_SUITE_8021X:
+		if (sme->crypto.akm_suites[0] == WLAN_AKM_SUITE_8021X)
 			auth_type = IEEE8021;
-			break;
-
-		default:
-			break;
-		}
 	}
 
 	curr_channel = pstrNetworkInfo->ch;
-- 
2.10.0.GIT
