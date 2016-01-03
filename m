Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35182 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbcACIgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:48 -0500
Received: by mail-pa0-f51.google.com with SMTP id do7so1062874pab.2
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:48 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/30] staging: wilc1000: rename pBASessionInfo in wilc_del_all_rx_ba_session
Date: Sun,  3 Jan 2016 17:35:43 +0900
Message-Id: <1451810162-16993-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095249_604090_1C4589BA)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pBASessionInfo to ba_session_info to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 265c42b..409d910 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4609,7 +4609,7 @@ int wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *bssid, char tid)
 {
 	int result = 0;
 	struct host_if_msg msg;
-	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
+	struct ba_session_info *ba_session_info = &msg.body.session_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -4621,8 +4621,8 @@ int wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *bssid, char tid)
 
 	msg.id = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
 
-	memcpy(pBASessionInfo->bssid, bssid, ETH_ALEN);
-	pBASessionInfo->tid = tid;
+	memcpy(ba_session_info->bssid, bssid, ETH_ALEN);
+	ba_session_info->tid = tid;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-- 
2.6.4

