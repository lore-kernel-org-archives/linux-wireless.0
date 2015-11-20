Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:53470 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934360AbbKTHxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 02:53:22 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/6] staging: wilc1000: return linux error value
Date: Fri, 20 Nov 2015 16:56:32 +0900
Message-ID: <1448006196-28555-2-git-send-email-glen.lee@atmel.com> (sfid-20151120_085325_394459_458675A3)
In-Reply-To: <1448006196-28555-1-git-send-email-glen.lee@atmel.com>
References: <1448006196-28555-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return proper linux error value -ETIMEDOUT instead of -1.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 0cd2acc..329477a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -601,7 +601,7 @@ s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 					       wids[counter].id,
 					       (counter == count - 1),
 					       drv)) {
-				ret = -1;
+				ret = -ETIMEDOUT;
 				printk("[Sendconfigpkt]Get Timed out\n");
 				break;
 			}
@@ -622,7 +622,7 @@ s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 					       wids[counter].size,
 					       (counter == count - 1),
 					       drv)) {
-				ret = -1;
+				ret = -ETIMEDOUT;
 				printk("[Sendconfigpkt]Set Timed out\n");
 				break;
 			}
-- 
1.9.1

