Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:56560 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965478AbbJ3Jov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 05:44:51 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 05/17] staging: wilc1000: wilc_wlan_cfg_commit: add argument struct net_device
Date: Fri, 30 Oct 2015 18:47:11 +0900
Message-ID: <1446198443-6623-5-git-send-email-glen.lee@atmel.com> (sfid-20151030_104454_170189_34E5EE6D)
In-Reply-To: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
References: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add argument struct net_device and pass dev to the functions as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a72fa8c..75b0616 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1732,7 +1732,8 @@ void wilc_wlan_cleanup(struct net_device *dev)
 
 }
 
-static int wilc_wlan_cfg_commit(int type, u32 drvHandler)
+static int wilc_wlan_cfg_commit(struct net_device *dev,
+				int type, u32 drvHandler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	wilc_cfg_frame_t *cfg = &p->cfg_frame;
@@ -1796,7 +1797,7 @@ int wilc_wlan_cfg_set(struct net_device *dev, int start, u32 wid, u8 *buffer,
 		PRINT_D(RX_DBG, "Processing cfg_set()\n");
 		p->cfg_frame_in_use = 1;
 
-		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drvHandler))
+		if (wilc_wlan_cfg_commit(dev, WILC_CFG_SET, drvHandler))
 			ret_size = 0;
 
 		if (linux_wlan_lock_timeout(&wilc->cfg_event,
@@ -1837,7 +1838,7 @@ int wilc_wlan_cfg_get(struct net_device *dev, int start, u32 wid, int commit,
 	if (commit) {
 		p->cfg_frame_in_use = 1;
 
-		if (wilc_wlan_cfg_commit(WILC_CFG_QUERY, drvHandler))
+		if (wilc_wlan_cfg_commit(dev, WILC_CFG_QUERY, drvHandler))
 			ret_size = 0;
 
 
-- 
1.9.1

