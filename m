Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:35961 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934027AbcEDBdL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 21:33:11 -0400
From: Kangjie Lu <kangjielu@gmail.com>
To: johnny.kim@atmel.com
Cc: austin.shin@atmel.com, chris.park@atmel.com,
	gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	taesoo@gatech.edu, insu@gatech.edu, csong84@gatech.edu,
	Kangjie Lu <kjlu@gatech.edu>
Subject: [PATCH] fix infoleak in wilc_wfi_cfgoperations
Date: Tue,  3 May 2016 21:36:11 -0400
Message-Id: <1462325771-8981-1-git-send-email-kjlu@gatech.edu> (sfid-20160504_033330_867477_0633F011)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"mac" is an array allocated in stack without being initialized,
and will be sent out via "nla_put". The dump_station() is supposed
to initialize the mac address; otherwise, sensitive data in kernel
stack will be leaked. To fix this, copy the mac address to it.

Signed-off-by: Kangjie Lu <kjlu@gatech.edu>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 448a5c8..c6e71d9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1797,6 +1797,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 
 	wilc_get_rssi(vif, &sinfo->signal);
 
+	memcpy(mac, priv->au8AssociatedBss, ETH_ALEN);
 	return 0;
 }
 
-- 
1.9.1

