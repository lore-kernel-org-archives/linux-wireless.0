Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38875 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbcADVC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 16:02:29 -0500
From: Hugo Camboulive <hugo.camboulive@gmail.com>
To: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Hugo Camboulive <hugo.camboulive@gmail.com>
Subject: [PATCH] staging: wilc1000: make some variables static
Date: Mon,  4 Jan 2016 22:02:23 +0000
Message-Id: <1451944943-7136-1-git-send-email-hugo.camboulive@gmail.com> (sfid-20160104_220243_241729_61A0E175)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

terminated_handle is used only in host_interface.c
wilc1000_spi_driver is exported by module_spi_driver()

This fixes a few Sparse warnings.

Signed-off-by: Hugo Camboulive <hugo.camboulive@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/wilc_spi.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8c77520..886b30c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -225,7 +225,7 @@ struct join_bss_param {
 	u8 start_time[4];
 };
 
-struct host_if_drv *terminated_handle;
+static struct host_if_drv *terminated_handle;
 bool wilc_optaining_ip;
 static u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 86de50c..b9dc91d 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -153,7 +153,7 @@ static const struct of_device_id wilc1000_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, wilc1000_of_match);
 
-struct spi_driver wilc1000_spi_driver = {
+static struct spi_driver wilc1000_spi_driver = {
 	.driver = {
 		.name = MODALIAS,
 		.of_match_table = wilc1000_of_match,
-- 
2.6.4

