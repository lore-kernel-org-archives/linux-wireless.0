Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20722 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbbKRGJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:09:27 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/16] staging: wilc1000: add struct wilc to host_if_drv
Date: Wed, 18 Nov 2015 15:11:32 +0900
Message-ID: <1447827097-9436-12-git-send-email-glen.lee@atmel.com> (sfid-20151118_070930_893565_C1F08653)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds struct wilc to host_if_dev and assign wilc to use driver's
primary structure in host_if_dev.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 +
 drivers/staging/wilc1000/host_interface.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2531d20..3609949 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3848,6 +3848,7 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		result = -ENOMEM;
 		goto _fail_;
 	}
+	hif_drv->wilc = wilc;
 	*hif_drv_handler = hif_drv;
 	err = add_handler_in_list(hif_drv);
 	if (err) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index efeb9e2..004467c6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -259,7 +259,9 @@ enum p2p_listen_state {
 	P2P_GRP_FORMATION
 };
 
+struct wilc;
 struct host_if_drv {
+	struct wilc *wilc;
 	struct user_scan_req usr_scan_req;
 	struct user_conn_req usr_conn_req;
 	struct remain_ch remain_on_ch;
-- 
1.9.1

