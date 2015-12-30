Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33971 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbbL3MQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:10 -0500
Received: by mail-pa0-f51.google.com with SMTP id uo6so116319729pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:10 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/20] staging: wilc1000: rename bIsEnabled in wilc_set_power_mgmt
Date: Wed, 30 Dec 2015 21:15:31 +0900
Message-Id: <1451477744-11975-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_131627_348003_9CC100F6)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames bIsEnabled to enabled to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8b1e535..3ed8275 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4393,14 +4393,14 @@ s32 wilc_edit_station(struct wilc_vif *vif,
 	return result;
 }
 
-int wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout)
+int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 u32Timeout)
 {
 	int result = 0;
 	struct host_if_msg msg;
 	struct power_mgmt_param *pstrPowerMgmtParam = &msg.body.pwr_mgmt_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
+	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", enabled);
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4414,7 +4414,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout)
 	msg.id = HOST_IF_MSG_POWER_MGMT;
 	msg.vif = vif;
 
-	pstrPowerMgmtParam->enabled = bIsEnabled;
+	pstrPowerMgmtParam->enabled = enabled;
 	pstrPowerMgmtParam->timeout = u32Timeout;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index fb9c0ea..89765b8 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -351,7 +351,7 @@ s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN]);
 int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
 s32 wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *pstrStaParams);
-int wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout);
+int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 u32Timeout);
 s32 wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
 				u32 u32count);
 s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
-- 
2.6.4

