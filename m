Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8909 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbbKCHS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 02:18:28 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/5] staging: wilc1000: send_config_pkt: return linux error number
Date: Tue, 3 Nov 2015 16:21:00 +0900
Message-ID: <1446535262-19817-3-git-send-email-glen.lee@atmel.com> (sfid-20151103_082136_897363_B3FD442C)
In-Reply-To: <1446535262-19817-1-git-send-email-glen.lee@atmel.com>
References: <1446535262-19817-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use proper linux error number instead of -1.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 637e8ca..1842f8f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -600,7 +600,7 @@ s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
 					       wids[counter].id,
 					       (counter == count - 1),
 					       drv)) {
-				ret = -1;
+				ret = -EBUSY;
 				netdev_err(dev,
 					   "[Sendconfigpkt]Get Timed out\n");
 				break;
@@ -625,7 +625,7 @@ s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
 					       wids[counter].size,
 					       (counter == count - 1),
 					       drv)) {
-				ret = -1;
+				ret = -EBUSY;
 				netdev_err(dev,
 					   "[Sendconfigpkt]Set Timed out\n");
 				break;
-- 
1.9.1

