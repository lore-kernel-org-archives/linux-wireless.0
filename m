Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:47873 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946272AbcBSIjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 03:39:53 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/6] staging: wilc1000: replaces wilc_debug with netdev_err
Date: Fri, 19 Feb 2016 17:37:08 +0900
Message-ID: <1455871032-7625-2-git-send-email-leo.kim@atmel.com> (sfid-20160219_093956_929209_029365C8)
In-Reply-To: <1455871032-7625-1-git-send-email-leo.kim@atmel.com>
References: <1455871032-7625-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches replaces wilc_debug with netdev_err.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 81a40e8..2719c3d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1401,18 +1401,18 @@ static u32 init_chip(struct net_device *dev)
 	if ((chipid & 0xfff) != 0xa0) {
 		ret = wilc->hif_func->hif_read_reg(wilc, 0x1118, &reg);
 		if (!ret) {
-			wilc_debug(N_ERR, "[wilc start]: fail read reg 0x1118 ...\n");
+			netdev_err(dev, "fail read reg 0x1118\n");
 			return ret;
 		}
 		reg |= BIT(0);
 		ret = wilc->hif_func->hif_write_reg(wilc, 0x1118, reg);
 		if (!ret) {
-			wilc_debug(N_ERR, "[wilc start]: fail write reg 0x1118 ...\n");
+			netdev_err(dev, "fail write reg 0x1118\n");
 			return ret;
 		}
 		ret = wilc->hif_func->hif_write_reg(wilc, 0xc0000, 0x71);
 		if (!ret) {
-			wilc_debug(N_ERR, "[wilc start]: fail write reg 0xc0000 ...\n");
+			netdev_err(dev, "fail write reg 0xc0000\n");
 			return ret;
 		}
 	}
-- 
1.9.1

