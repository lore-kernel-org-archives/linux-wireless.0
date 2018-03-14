Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:37958 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbeCNMpW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 08:45:22 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com
Cc: hariprasath.elango@gmail.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] staging: wilc1000: Fix code block alignment
Date: Wed, 14 Mar 2018 18:14:59 +0530
Message-Id: <064c29efeaa5076d2ed441406cdd8eedcf7c01ec.1521030891.git.hariprasath.elango@gmail.com> (sfid-20180314_134706_200186_B5EE1DE6)
In-Reply-To: <cover.1521030891.git.hariprasath.elango@gmail.com>
References: <cover.1521030891.git.hariprasath.elango@gmail.com>
In-Reply-To: <cover.1521030891.git.hariprasath.elango@gmail.com>
References: <cover.1521030891.git.hariprasath.elango@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

Fix the code alignment for a block of code to adhere to coding
guidelines

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index fe19bf3..1af3c14 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -861,10 +861,10 @@ static int wilc_mac_open(struct net_device *ndev)
 			break;
 		}
 	}
-			wilc_get_mac_address(vif, mac_add);
-			netdev_dbg(ndev, "Mac address: %pM\n", mac_add);
-			memcpy(wl->vif[i]->src_addr, mac_add, ETH_ALEN);
 
+	wilc_get_mac_address(vif, mac_add);
+	netdev_dbg(ndev, "Mac address: %pM\n", mac_add);
+	memcpy(wl->vif[i]->src_addr, mac_add, ETH_ALEN);
 	memcpy(ndev->dev_addr, wl->vif[i]->src_addr, ETH_ALEN);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
-- 
2.10.0.GIT
