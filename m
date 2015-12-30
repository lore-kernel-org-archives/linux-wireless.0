Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:32895 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbbL3MQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:29 -0500
Received: by mail-pf0-f174.google.com with SMTP id q63so105582430pfb.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:29 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 13/20] staging: wilc1000: rename pstrMulticastFilterParam in wilc_setup_multicast_filter
Date: Wed, 30 Dec 2015 21:15:37 +0900
Message-Id: <1451477744-11975-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_131634_229390_06565332)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrMulticastFilterParam to multicast_filter_param to
avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 489ab29..aeb3271 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4428,7 +4428,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 {
 	int result = 0;
 	struct host_if_msg msg;
-	struct set_multicast *pstrMulticastFilterParam = &msg.body.multicast_info;
+	struct set_multicast *multicast_filter_param = &msg.body.multicast_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -4443,8 +4443,8 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
 	msg.vif = vif;
 
-	pstrMulticastFilterParam->enabled = enabled;
-	pstrMulticastFilterParam->cnt = count;
+	multicast_filter_param->enabled = enabled;
+	multicast_filter_param->cnt = count;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
-- 
2.6.4

