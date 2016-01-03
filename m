Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35087 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbcACIgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:51 -0500
Received: by mail-pf0-f181.google.com with SMTP id 78so187622202pfw.2
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:51 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 12/30] staging: wilc1000: fix return type of wilc_edit_station
Date: Sun,  3 Jan 2016 17:35:44 +0900
Message-Id: <1451810162-16993-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095251_149562_6B8E6F11)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_edit_station from s32 to int.
The result variable gets return value from wilc_mq_send that has data
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 409d910..eb2d664 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4350,10 +4350,10 @@ s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN])
 	return result;
 }
 
-s32 wilc_edit_station(struct wilc_vif *vif,
+int wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *pstrStaParams)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 6c8fe3a..f60bebb 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -349,7 +349,7 @@ int wilc_del_beacon(struct wilc_vif *vif);
 int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param);
 s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN]);
 int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
-s32 wilc_edit_station(struct wilc_vif *vif,
+int wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *pstrStaParams);
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
-- 
2.6.4

