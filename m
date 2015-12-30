Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:32943 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbbL3MQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:38 -0500
Received: by mail-pf0-f174.google.com with SMTP id q63so105583962pfb.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:38 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 16/20] staging: wilc1000: remove return statement
Date: Wed, 30 Dec 2015 21:15:40 +0900
Message-Id: <1451477744-11975-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_132246_920707_5359951A)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes return statement that is always returned 0.
wilc_setup_ipaddress can not run to the end due to return statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0d41657..90fdbdd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4644,8 +4644,6 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	return 0;
-
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
-- 
2.6.4

