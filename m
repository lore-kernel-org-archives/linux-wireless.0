Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40707 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbcAYHmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:42:15 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 01/26] staging: wilc1000: fix bug when changing virtual interface
Date: Mon, 25 Jan 2016 16:35:05 +0900
Message-ID: <1453707330-13526-2-git-send-email-glen.lee@atmel.com> (sfid-20160125_084218_282373_56F18488)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug connection error when changing virtual interface to p2p.
Variable quit needs to be set 0 when wilc is reinitialized again.

Fixes : 67e2a07ed800 ("staging: wilc1000: move all of wilc_wlan_dev_t to struct wilc")
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 83af51b..07460ff 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1588,6 +1588,8 @@ int wilc_wlan_init(struct net_device *dev)
 
 	PRINT_D(INIT_DBG, "Initializing WILC_Wlan ...\n");
 
+	wilc->quit = 0;
+
 	if (!wilc->hif_func->hif_init(wilc)) {
 		ret = -EIO;
 		goto _fail_;
-- 
1.9.1

