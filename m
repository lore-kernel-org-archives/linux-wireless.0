Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36584 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbcACIhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:07 -0500
Received: by mail-pa0-f42.google.com with SMTP id yy13so89272242pab.3
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:06 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 17/30] staging: wilc1000: fix return type of wilc_del_allstation
Date: Sun,  3 Jan 2016 17:35:49 +0900
Message-Id: <1451810162-16993-17-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095247_571716_3F9FA0EB)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_del_allstation from s32 to int.
The result variable gets return value from wilc_mq_send that has data
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 57d59dc..3f410b2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4299,9 +4299,9 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 	return result;
 }
 
-s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN])
+int wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN])
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct del_all_sta *pstrDelAllStationMsg = &msg.body.del_all_sta_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index abb626e..6d424e7 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -347,7 +347,7 @@ s32 wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
 		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail);
 int wilc_del_beacon(struct wilc_vif *vif);
 int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param);
-s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN]);
+int wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN]);
 int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
 int wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *sta_param);
-- 
2.6.4

