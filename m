Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36045 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbbLVAtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 19:49:42 -0500
Received: by mail-pa0-f54.google.com with SMTP id q3so87133286pav.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 16:49:41 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/13] staging: wilc1000: rename pu8PmkidInfoArray in wilc_set_pmkid_info
Date: Tue, 22 Dec 2015 09:49:05 +0900
Message-Id: <1450745349-16811-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151222_014945_426473_B7E4BE95)
In-Reply-To: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450745349-16811-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes pu8PmkidInfoArray to pmkid to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3ad4b0e..485318f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3292,7 +3292,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 }
 
 int wilc_set_pmkid_info(struct wilc_vif *vif,
-			struct host_if_pmkid_attr *pu8PmkidInfoArray)
+			struct host_if_pmkid_attr *pmkid)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3311,11 +3311,11 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 	msg.body.key_info.action = ADDKEY;
 	msg.vif = vif;
 
-	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
+	for (i = 0; i < pmkid->numpmkid; i++) {
 		memcpy(msg.body.key_info.attr.pmkid.pmkidlist[i].bssid,
-		       &pu8PmkidInfoArray->pmkidlist[i].bssid, ETH_ALEN);
+		       &pmkid->pmkidlist[i].bssid, ETH_ALEN);
 		memcpy(msg.body.key_info.attr.pmkid.pmkidlist[i].pmkid,
-		       &pu8PmkidInfoArray->pmkidlist[i].pmkid, PMKID_LEN);
+		       &pmkid->pmkidlist[i].pmkid, PMKID_LEN);
 	}
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 3dfdc04..675a4e1 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -322,7 +322,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 		    const u8 *rx_mic, const u8 *tx_mic, u8 mode,
 		    u8 cipher_mode);
 int wilc_set_pmkid_info(struct wilc_vif *vif,
-			struct host_if_pmkid_attr *pu8PmkidInfoArray);
+			struct host_if_pmkid_attr *pmkid);
 s32 wilc_get_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
 s32 wilc_set_mac_address(struct wilc_vif *vif, u8 *pu8MacAddress);
 int wilc_wait_msg_queue_idle(void);
-- 
2.6.4

