Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34039 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbcDHFf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2016 01:35:27 -0400
Date: Thu, 7 Apr 2016 22:35:24 -0700
From: Alison Schofield <amsfield22@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: move initialization of the config values
Message-ID: <20160408053515.GA10278@d830.WORKGROUP> (sfid-20160408_073558_830557_84BC7299)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the initialization of the config values so that an uninit'd
mutex is not exposed and to simplify the initialization process.

The code was allocating a structure with a lock, initializing and
taking the lock, setting some values, and then releasing the
lock.  If no other thread can get it, then the lock isn't needed.
If another thread can get it, it could find it before the mutex
is initialized.

Make it safe and simple by setting the config values and initializing
their mutex before the kthread is started.  No lock/unlock needed.

Signed-off-by: Alison Schofield <amsfield22@gmail.com>
---

Note- not verified with hardware.

 drivers/staging/wilc1000/host_interface.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 04cbff5..40f3d11 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3410,6 +3410,14 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	init_completion(&hif_drv->comp_get_rssi);
 	init_completion(&hif_drv->comp_inactive_time);
 
+	hif_drv->cfg_values.site_survey_enabled = SITE_SURVEY_OFF;
+	hif_drv->cfg_values.scan_source = DEFAULT_SCAN;
+	hif_drv->cfg_values.active_scan_time = ACTIVE_SCAN_TIME;
+	hif_drv->cfg_values.passive_scan_time = PASSIVE_SCAN_TIME;
+	hif_drv->cfg_values.curr_tx_rate = AUTORATE;
+
+	mutex_init(&hif_drv->cfg_values_lock);
+
 	if (clients_count == 0)	{
 		result = wilc_mq_create(&hif_msg_q);
 
@@ -3435,20 +3443,10 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	setup_timer(&hif_drv->connect_timer, TimerCB_Connect, 0);
 	setup_timer(&hif_drv->remain_on_ch_timer, ListenTimerCB, 0);
 
-	mutex_init(&hif_drv->cfg_values_lock);
-	mutex_lock(&hif_drv->cfg_values_lock);
-
 	hif_drv->hif_state = HOST_IF_IDLE;
-	hif_drv->cfg_values.site_survey_enabled = SITE_SURVEY_OFF;
-	hif_drv->cfg_values.scan_source = DEFAULT_SCAN;
-	hif_drv->cfg_values.active_scan_time = ACTIVE_SCAN_TIME;
-	hif_drv->cfg_values.passive_scan_time = PASSIVE_SCAN_TIME;
-	hif_drv->cfg_values.curr_tx_rate = AUTORATE;
 
 	hif_drv->p2p_timeout = 0;
 
-	mutex_unlock(&hif_drv->cfg_values_lock);
-
 	clients_count++;
 
 	return result;
-- 
2.1.4

