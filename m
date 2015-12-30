Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35364 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbbL3MQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:26 -0500
Received: by mail-pa0-f45.google.com with SMTP id do7so4199769pab.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:26 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 12/20] staging: wilc1000: rename u32count in wilc_setup_multicast_filter
Date: Wed, 30 Dec 2015 21:15:36 +0900
Message-Id: <1451477744-11975-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_132247_663583_079FEAAC)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32count to count to remove u32 prefix.
There is no need to use this prefix to show data type of this argument.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a32e930..489ab29 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4424,7 +4424,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 }
 
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
-				u32 u32count)
+				u32 count)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4444,7 +4444,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 	msg.vif = vif;
 
 	pstrMulticastFilterParam->enabled = enabled;
-	pstrMulticastFilterParam->cnt = u32count;
+	pstrMulticastFilterParam->cnt = count;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9abdd3f..5c271b1 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -353,7 +353,7 @@ s32 wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *pstrStaParams);
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
-				u32 u32count);
+				u32 count);
 s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
 s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
 s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
-- 
2.6.4

