Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36145 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbbL3MQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:17 -0500
Received: by mail-pf0-f174.google.com with SMTP id 65so96829021pff.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:16 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/20] staging: wilc1000: rename pstrPowerMgmtParam in wilc_set_power_mgmt
Date: Wed, 30 Dec 2015 21:15:33 +0900
Message-Id: <1451477744-11975-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_132248_439810_985BD2AF)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrPowerMgmtParam to pwr_mgmt_info to avoid
camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dc1773d..83ac21a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4397,7 +4397,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 {
 	int result = 0;
 	struct host_if_msg msg;
-	struct power_mgmt_param *pstrPowerMgmtParam = &msg.body.pwr_mgmt_info;
+	struct power_mgmt_param *pwr_mgmt_info = &msg.body.pwr_mgmt_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", enabled);
@@ -4414,8 +4414,8 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 	msg.id = HOST_IF_MSG_POWER_MGMT;
 	msg.vif = vif;
 
-	pstrPowerMgmtParam->enabled = enabled;
-	pstrPowerMgmtParam->timeout = timeout;
+	pwr_mgmt_info->enabled = enabled;
+	pwr_mgmt_info->timeout = timeout;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-- 
2.6.4

