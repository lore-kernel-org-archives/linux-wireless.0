Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34055 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbbL3MQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:32 -0500
Received: by mail-pf0-f170.google.com with SMTP id e65so88860385pfe.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:32 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 14/20] staging: wilc1000: fix return type of wilc_setup_ipaddress
Date: Wed, 30 Dec 2015 21:15:38 +0900
Message-Id: <1451477744-11975-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_132248_973988_C2A90C3A)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_setup_ipaddress from s32 to int.
The result variable gets return value from wilc_mq_send that has data
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index aeb3271..dacadc9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4638,9 +4638,9 @@ s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID)
 	return result;
 }
 
-s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx)
+int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5c271b1..d36a9f5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -354,7 +354,7 @@ s32 wilc_edit_station(struct wilc_vif *vif,
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 count);
-s32 wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
+int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *u16ipadd, u8 idx);
 s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
 s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   u32 u32duration, u16 chan,
-- 
2.6.4

