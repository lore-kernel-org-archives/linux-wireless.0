Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:32957 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbcACIgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:54 -0500
Received: by mail-pa0-f51.google.com with SMTP id cy9so181763772pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:54 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 13/30] staging: wilc1000: rename pstrStaParams in wilc_edit_station
Date: Sun,  3 Jan 2016 17:35:45 +0900
Message-Id: <1451810162-16993-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095248_377748_0527A0BA)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrStaParams to sta_param to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index eb2d664..de921fa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4351,7 +4351,7 @@ s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN])
 }
 
 int wilc_edit_station(struct wilc_vif *vif,
-		      struct add_sta_param *pstrStaParams)
+		      struct add_sta_param *sta_param)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4370,14 +4370,14 @@ int wilc_edit_station(struct wilc_vif *vif,
 	msg.id = HOST_IF_MSG_EDIT_STATION;
 	msg.vif = vif;
 
-	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
+	memcpy(pstrAddStationMsg, sta_param, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->rates_len > 0) {
 		u8 *rates = kmalloc(pstrAddStationMsg->rates_len, GFP_KERNEL);
 
 		if (!rates)
 			return -ENOMEM;
 
-		memcpy(rates, pstrStaParams->rates,
+		memcpy(rates, sta_param->rates,
 		       pstrAddStationMsg->rates_len);
 		pstrAddStationMsg->rates = rates;
 	}
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f60bebb..abb626e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -350,7 +350,7 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param);
 s32 wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN]);
 int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
 int wilc_edit_station(struct wilc_vif *vif,
-		      struct add_sta_param *pstrStaParams);
+		      struct add_sta_param *sta_param);
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 count);
-- 
2.6.4

