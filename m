Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36318 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbcDDLF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 07:05:26 -0400
Received: by mail-pa0-f67.google.com with SMTP id 1so19880080pal.3
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 04:05:26 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 8/8] staging: wilc1000: rename pu8Buffer in handle_scan
Date: Mon,  4 Apr 2016 20:04:50 +0900
Message-Id: <1459767890-9709-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20160404_130541_560188_24CB2AC2)
In-Reply-To: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu8Buffer to buffer to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a5f109a..1fe811f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -737,7 +737,7 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	struct wid wid_list[5];
 	u32 index = 0;
 	u32 i;
-	u8 *pu8Buffer;
+	u8 *buffer;
 	u8 valuesize = 0;
 	u8 *pu8HdnNtwrksWidVal = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -768,14 +768,14 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
 	wid_list[index].val = pu8HdnNtwrksWidVal;
 	if (wid_list[index].val) {
-		pu8Buffer = wid_list[index].val;
+		buffer = wid_list[index].val;
 
-		*pu8Buffer++ = scan_info->hidden_network.n_ssids;
+		*buffer++ = scan_info->hidden_network.n_ssids;
 
 		for (i = 0; i < scan_info->hidden_network.n_ssids; i++) {
-			*pu8Buffer++ = scan_info->hidden_network.net_info[i].ssid_len;
-			memcpy(pu8Buffer, scan_info->hidden_network.net_info[i].ssid, scan_info->hidden_network.net_info[i].ssid_len);
-			pu8Buffer += scan_info->hidden_network.net_info[i].ssid_len;
+			*buffer++ = scan_info->hidden_network.net_info[i].ssid_len;
+			memcpy(buffer, scan_info->hidden_network.net_info[i].ssid, scan_info->hidden_network.net_info[i].ssid_len);
+			buffer += scan_info->hidden_network.net_info[i].ssid_len;
 		}
 
 		wid_list[index].size = (s32)(valuesize + 1);
-- 
2.8.0

