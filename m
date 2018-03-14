Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:34451 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbeCNMpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 08:45:44 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com
Cc: hariprasath.elango@gmail.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] staging: wilc1000: replace switch statement by simple if condition
Date: Wed, 14 Mar 2018 18:15:03 +0530
Message-Id: <2a46a5cc8ab69c1143c480bbac1f7e921011d982.1521030891.git.hariprasath.elango@gmail.com> (sfid-20180314_134633_911747_C2E22B03)
In-Reply-To: <cover.1521030891.git.hariprasath.elango@gmail.com>
References: <cover.1521030891.git.hariprasath.elango@gmail.com>
In-Reply-To: <cover.1521030891.git.hariprasath.elango@gmail.com>
References: <cover.1521030891.git.hariprasath.elango@gmail.com>
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
