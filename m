Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35254 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbbL3MQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:07 -0500
Received: by mail-pa0-f50.google.com with SMTP id do7so4196503pab.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:07 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/20] staging: wilc1000: fix return type of wilc_set_power_mgmt
Date: Wed, 30 Dec 2015 21:15:30 +0900
Message-Id: <1451477744-11975-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_131625_697701_413DA7BC)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_set_power_mgmt from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3a9a967..8b1e535 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4393,9 +4393,9 @@ s32 wilc_edit_station(struct wilc_vif *vif,
 	return result;
 }
 
-s32 wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout)
+int wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct power_mgmt_param *pstrPowerMgmtParam = &msg.body.pwr_mgmt_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 47c664e..fb9c0ea 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -351,7 +351,7 @@ s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN]);
 int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
 s32 wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *pstrStaParams);
-s32 wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout);
+int wilc_set_power_mgmt(struct wilc_vif *vif, bool bIsEnabled, u32 u32Timeout);
 s32 wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
 				u32 u32count);
 s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
-- 
2.6.4

