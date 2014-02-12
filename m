Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59387 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaBLTFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 14:05:04 -0500
Received: by mail-we0-f174.google.com with SMTP id w61so722106wes.5
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 11:05:03 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 4/9] Cache nv to avoid request_firmware on resume path
Date: Wed, 12 Feb 2014 19:04:43 +0000
Message-Id: <1392231888-2191-4-git-send-email-k.eugene.e@gmail.com> (sfid-20140212_200511_183833_33A77008)
In-Reply-To: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
References: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

If wowlan if off mac80211 will stop / start the driver on suspend /
resume. This causes problems on resume since request_firmware is called
from start. Fix this by caching the nv.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c    |  2 ++
 drivers/net/wireless/ath/wcn36xx/smd.c     | 22 ++++++++++------------
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  2 ++
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index e64a678..a801aaa 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -17,6 +17,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#include <linux/firmware.h>
 #include <linux/platform_device.h>
 #include "wcn36xx.h"
 
@@ -992,6 +993,7 @@ static int wcn36xx_remove(struct platform_device *pdev)
 	struct wcn36xx *wcn = hw->priv;
 	wcn36xx_dbg(WCN36XX_DBG_MAC, "platform remove\n");
 
+	release_firmware(wcn->nv);
 	mutex_destroy(&wcn->hal_mutex);
 
 	ieee80211_unregister_hw(hw);
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index ad93cc7..d5e90c4 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -251,21 +251,22 @@ static int wcn36xx_smd_rsp_status_check(void *buf, size_t len)
 
 int wcn36xx_smd_load_nv(struct wcn36xx *wcn)
 {
-	const struct firmware *nv;
 	struct nv_data *nv_d;
 	struct wcn36xx_hal_nv_img_download_req_msg msg_body;
 	int fw_bytes_left;
 	int ret;
 	u16 fm_offset = 0;
 
-	ret = request_firmware(&nv, WLAN_NV_FILE, wcn->dev);
-	if (ret) {
-		wcn36xx_err("Failed to load nv file %s: %d\n",
-			      WLAN_NV_FILE, ret);
-		goto out_free_nv;
+	if (!wcn->nv) {
+		ret = request_firmware(&wcn->nv, WLAN_NV_FILE, wcn->dev);
+		if (ret) {
+			wcn36xx_err("Failed to load nv file %s: %d\n",
+				      WLAN_NV_FILE, ret);
+			goto out;
+		}
 	}
 
-	nv_d = (struct nv_data *)nv->data;
+	nv_d = (struct nv_data *)wcn->nv->data;
 	INIT_HAL_MSG(msg_body, WCN36XX_HAL_DOWNLOAD_NV_REQ);
 
 	msg_body.header.len += WCN36XX_NV_FRAGMENT_SIZE;
@@ -275,7 +276,7 @@ int wcn36xx_smd_load_nv(struct wcn36xx *wcn)
 	mutex_lock(&wcn->hal_mutex);
 
 	do {
-		fw_bytes_left = nv->size - fm_offset - 4;
+		fw_bytes_left = wcn->nv->size - fm_offset - 4;
 		if (fw_bytes_left > WCN36XX_NV_FRAGMENT_SIZE) {
 			msg_body.last_fragment = 0;
 			msg_body.nv_img_buffer_size = WCN36XX_NV_FRAGMENT_SIZE;
@@ -313,10 +314,7 @@ int wcn36xx_smd_load_nv(struct wcn36xx *wcn)
 
 out_unlock:
 	mutex_unlock(&wcn->hal_mutex);
-out_free_nv:
-	release_firmware(nv);
-
-	return ret;
+out:	return ret;
 }
 
 static int wcn36xx_smd_start_rsp(struct wcn36xx *wcn, void *buf, size_t len)
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index c5bd61c..0c5413f 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -171,6 +171,8 @@ struct wcn36xx {
 	struct device		*dev;
 	struct list_head	vif_list;
 
+	const struct firmware	*nv;
+
 	u8			fw_revision;
 	u8			fw_version;
 	u8			fw_minor;
-- 
1.8.3.2

