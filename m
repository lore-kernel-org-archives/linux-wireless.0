Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:10213 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbbKYC5C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 21:57:02 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/10] staging: wilc1000: wilc_deinit(): fixes inconsistent returns
Date: Wed, 25 Nov 2015 11:59:46 +0900
Message-ID: <1448420389-4192-7-git-send-email-glen.lee@atmel.com> (sfid-20151125_035706_723393_BAB1E2BB)
In-Reply-To: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
References: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warning reported by smatch.
 - wilc_deinit() warn: inconsistent returns 'sem:&hif_drv->sem_cfg_values'

This semaphore protect a cfg_values variable but cfg_values variables was not
used here. So, just remove this line.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3aea6ec..8f27227 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4007,8 +4007,6 @@ s32 wilc_deinit(struct host_if_drv *hif_drv)
 		wilc_mq_destroy(&hif_msg_q);
 	}
 
-	down(&hif_drv->sem_cfg_values);
-
 	ret = remove_handler_in_list(hif_drv);
 	if (ret)
 		result = -ENOENT;
-- 
1.9.1

