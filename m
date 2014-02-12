Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60789 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaBLTFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 14:05:01 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi5so7427463wib.8
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 11:05:00 -0800 (PST)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 2/9] wcn36xx: Improve feature caps exchange
Date: Wed, 12 Feb 2014 19:04:41 +0000
Message-Id: <1392231888-2191-2-git-send-email-k.eugene.e@gmail.com> (sfid-20140212_200508_246403_399050DF)
In-Reply-To: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
References: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontus.fuchs@gmail.com>

* Response format is not in the canonical format.
  wcn36xx_smd_rsp_status_check cannot be used.

* Save the FW caps in wcn36xx struct for later use.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/hal.h     |  4 +++-
 drivers/net/wireless/ath/wcn36xx/smd.c     | 15 +++++++++------
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  1 +
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 3c2ef0c..a1f1127 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -4384,11 +4384,13 @@ enum place_holder_in_cap_bitmap {
 	MAX_FEATURE_SUPPORTED = 128,
 };
 
+#define WCN36XX_HAL_CAPS_SIZE 4
+
 struct wcn36xx_hal_feat_caps_msg {
 
 	struct wcn36xx_hal_msg_header header;
 
-	u32 feat_caps[4];
+	u32 feat_caps[WCN36XX_HAL_CAPS_SIZE];
 } __packed;
 
 /* status codes to help debug rekey failures */
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 8a57dfe..425365c 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1731,8 +1731,8 @@ static inline void clear_feat_caps(u32 *bitmap,
 
 int wcn36xx_smd_feature_caps_exchange(struct wcn36xx *wcn)
 {
-	struct wcn36xx_hal_feat_caps_msg msg_body;
-	int ret = 0;
+	struct wcn36xx_hal_feat_caps_msg msg_body, *rsp;
+	int ret = 0, i;
 
 	mutex_lock(&wcn->hal_mutex);
 	INIT_HAL_MSG(msg_body, WCN36XX_HAL_FEATURE_CAPS_EXCHANGE_REQ);
@@ -1746,12 +1746,15 @@ int wcn36xx_smd_feature_caps_exchange(struct wcn36xx *wcn)
 		wcn36xx_err("Sending hal_feature_caps_exchange failed\n");
 		goto out;
 	}
-	ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
-	if (ret) {
-		wcn36xx_err("hal_feature_caps_exchange response failed err=%d\n",
-			    ret);
+	if (wcn->hal_rsp_len != sizeof(*rsp)) {
+		wcn36xx_err("Invalid hal_feature_caps_exchange response");
 		goto out;
 	}
+
+	rsp = (struct wcn36xx_hal_feat_caps_msg *) wcn->hal_buf;
+
+	for (i = 0; i < WCN36XX_HAL_CAPS_SIZE; i++)
+		wcn->fw_feat_caps[i] = rsp->feat_caps[i];
 out:
 	mutex_unlock(&wcn->hal_mutex);
 	return ret;
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 8fa5cba..c5bd61c 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -175,6 +175,7 @@ struct wcn36xx {
 	u8			fw_version;
 	u8			fw_minor;
 	u8			fw_major;
+	u32			fw_feat_caps[WCN36XX_HAL_CAPS_SIZE];
 
 	/* extra byte for the NULL termination */
 	u8			crm_version[WCN36XX_HAL_VERSION_LENGTH + 1];
-- 
1.8.3.2

