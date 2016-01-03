Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34546 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbcACIhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:10 -0500
Received: by mail-pf0-f177.google.com with SMTP id e65so133507729pfe.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:10 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 18/30] staging: wilc1000: rename pu8MacAddr in wilc_del_allstation
Date: Sun,  3 Jan 2016 17:35:50 +0900
Message-Id: <1451810162-16993-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095251_637299_3AEAEF2B)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu8MacAddr to mac_addr to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3f410b2..37a78a3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4299,7 +4299,7 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 	return result;
 }
 
-int wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN])
+int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4322,8 +4322,8 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN])
 	msg.vif = vif;
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
-		if (memcmp(pu8MacAddr[i], au8Zero_Buff, ETH_ALEN)) {
-			memcpy(pstrDelAllStationMsg->del_all_sta[i], pu8MacAddr[i], ETH_ALEN);
+		if (memcmp(mac_addr[i], au8Zero_Buff, ETH_ALEN)) {
+			memcpy(pstrDelAllStationMsg->del_all_sta[i], mac_addr[i], ETH_ALEN);
 			PRINT_D(CFG80211_DBG, "BSSID = %x%x%x%x%x%x\n",
 				pstrDelAllStationMsg->del_all_sta[i][0],
 				pstrDelAllStationMsg->del_all_sta[i][1],
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 6d424e7..3c932e7a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -347,7 +347,7 @@ s32 wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
 		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail);
 int wilc_del_beacon(struct wilc_vif *vif);
 int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param);
-int wilc_del_allstation(struct wilc_vif *vif, u8 pu8MacAddr[][ETH_ALEN]);
+int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN]);
 int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr);
 int wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *sta_param);
-- 
2.6.4

