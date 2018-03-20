Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:40628 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752700AbeCTLoN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 07:44:13 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, dan.carpenter@oracle.com
Cc: gehariprasath@gmail.com,
        HariPrasath Elango <hariprasath.elango@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] staging: wilc1000: replace switch statement by simple if condition
Date: Tue, 20 Mar 2018 17:13:31 +0530
Message-Id: <20180320114331.4084-1-hariprasath.elango@gmail.com> (sfid-20180320_124429_145254_E049AF37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

In this case,there is only a single switch case statement.So replacing
by a simple if condition

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9d8d5d0..730d64f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -776,14 +776,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
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
 
 	curr_channel = nw_info->ch;
-- 
2.10.0.GIT
