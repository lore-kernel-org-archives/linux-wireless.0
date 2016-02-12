Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36400 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbcBLOFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 09:05:19 -0500
Received: by mail-pa0-f66.google.com with SMTP id gc2so110590pab.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 06:05:19 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/11] staging: wilc1000: rename result in handle_set_channel
Date: Fri, 12 Feb 2016 23:04:46 +0900
Message-Id: <1455285887-29946-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20160212_150549_032459_F9A8A105)
In-Reply-To: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames result to ret that is used to get return value from
wilc_send_config_pkt.
Some handle_*() function are used as result, others are used as ret.
It will start to rename as ret in all handle_*() function to sync up
with this variable name.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0f7a36c..10c5e4ef 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -302,7 +302,7 @@ static struct wilc_vif *wilc_get_vif_from_idx(struct wilc *wilc, int idx)
 static void handle_set_channel(struct wilc_vif *vif,
 			       struct channel_attr *hif_set_ch)
 {
-	int result = 0;
+	int ret = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_CURRENT_CHANNEL;
@@ -310,10 +310,10 @@ static void handle_set_channel(struct wilc_vif *vif,
 	wid.val = (char *)&hif_set_ch->set_ch;
 	wid.size = sizeof(char);
 
-	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-				      wilc_get_vif_idx(vif));
+	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+				   wilc_get_vif_idx(vif));
 
-	if (result)
+	if (ret)
 		PRINT_ER("Failed to set channel\n");
 }
 
-- 
2.7.1

