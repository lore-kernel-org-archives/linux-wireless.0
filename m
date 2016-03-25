Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:49896 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbcCYMUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 08:20:34 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/11] staging: wilc1000: replaces memcmp with ether_addr_equal_unaligned
Date: Fri, 25 Mar 2016 21:16:53 +0900
Message-ID: <1458908216-12100-8-git-send-email-leo.kim@atmel.com> (sfid-20160325_132037_634151_EA01900D)
In-Reply-To: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
References: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces memcmp with ether_addr_equal_unaligned.
Warning reported by checkpatch.pl
 - Prefer ether_addr_equal() or ether_addr_equal_unaligned() over memcmp()

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index db624ef..8f0a74d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -259,10 +259,12 @@ static struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 
 	for (i = 0; i < wilc->vif_num; i++) {
 		if (wilc->vif[i]->mode == STATION_MODE)
-			if (!memcmp(bssid, wilc->vif[i]->bssid, ETH_ALEN))
+			if (ether_addr_equal_unaligned(bssid,
+						       wilc->vif[i]->bssid))
 				return wilc->vif[i]->ndev;
 		if (wilc->vif[i]->mode == AP_MODE)
-			if (!memcmp(bssid1, wilc->vif[i]->bssid, ETH_ALEN))
+			if (ether_addr_equal_unaligned(bssid1,
+						       wilc->vif[i]->bssid))
 				return wilc->vif[i]->ndev;
 	}
 
-- 
1.9.1

