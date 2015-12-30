Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35347 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbbL3MQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:23 -0500
Received: by mail-pa0-f48.google.com with SMTP id do7so4199257pab.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:22 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/20] staging: wilc1000: rename bIsEnabled in wilc_setup_multicast_filter
Date: Wed, 30 Dec 2015 21:15:35 +0900
Message-Id: <1451477744-11975-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_131632_487850_4C2063A8)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames bIsEnabled to enabled to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8e8e70e..a32e930 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4423,7 +4423,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 	return result;
 }
 
-int wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
+int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 u32count)
 {
 	int result = 0;
@@ -4443,7 +4443,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
 	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
 	msg.vif = vif;
 
-	pstrMulticastFilterParam->enabled = bIsEnabled;
+	pstrMulticastFilterParam->enabled = enabled;
 	pstrMulticastFilterParam->cnt = u32count;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 52032be..9abdd3f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -352,7 +352,7 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
 s32 wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *pstrStaParams);
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
-int wilc_setup_multicast_filter(struct wilc_vif *vif, bool bIsEnabled,
+int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 u32count);
 s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
 s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
-- 
2.6.4

