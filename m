Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:32808 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbbL3MQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:13 -0500
Received: by mail-pf0-f176.google.com with SMTP id q63so105579686pfb.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:13 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/20] staging: wilc1000: rename u32Timeout in wilc_set_power_mgmt
Date: Wed, 30 Dec 2015 21:15:32 +0900
Message-Id: <1451477744-11975-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_131629_284053_F509F1B8)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32Timeout to timeout to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3ed8275..dc1773d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4393,7 +4393,7 @@ s32 wilc_edit_station(struct wilc_vif *vif,
 	return result;
 }
 
-int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 u32Timeout)
+int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4415,7 +4415,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 u32Timeout)
 	msg.vif = vif;
 
 	pstrPowerMgmtParam->enabled = enabled;
-	pstrPowerMgmtParam->timeout = u32Timeout;
+	pstrPowerMgmtParam->timeout = timeout;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 89765b8..7b12425 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -351,7 +351,7 @@ s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN]);
 int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
 s32 wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *pstrStaParams);
-int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 u32Timeout);
+int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 s32 wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
 				u32 u32count);
 s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
-- 
2.6.4

