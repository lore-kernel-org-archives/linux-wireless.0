Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:40132 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbeCLNBH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 09:01:07 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com
Cc: hariprasath.elango@gmail.com,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: Fix code block alignment
Date: Mon, 12 Mar 2018 18:30:44 +0530
Message-Id: <20180312130044.11815-1-hariprasath.elango@gmail.com> (sfid-20180312_140121_808488_6E1CE861)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

Fix the code alignment for a block of code to adhere to coding
guidelines

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
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
