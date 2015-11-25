Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:10195 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbbKYC44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 21:56:56 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/10] staging: wilc1000: wilc_init(): fixes inconsistent returns
Date: Wed, 25 Nov 2015 11:59:45 +0900
Message-ID: <1448420389-4192-6-git-send-email-glen.lee@atmel.com> (sfid-20151125_035659_287536_AF702651)
In-Reply-To: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
References: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warning reported by smatch.
 - wilc_init() warn: inconsistent returns 'sem:&hif_drv->sem_cfg_values'

No need to up the sema here since down was not called before get here.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index da4f4c6..3aea6ec 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3940,7 +3940,6 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	return result;
 
 _fail_timer_2:
-	up(&hif_drv->sem_cfg_values);
 	del_timer_sync(&hif_drv->connect_timer);
 	del_timer_sync(&hif_drv->scan_timer);
 	kthread_stop(hif_thread_handler);
-- 
1.9.1

