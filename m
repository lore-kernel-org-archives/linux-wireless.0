Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:35057 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaKXJjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 04:39:05 -0500
From: Vivek Natarajan <nataraja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath10k: Do not limit RTS threshold value to 2347
Date: Mon, 24 Nov 2014 15:08:49 +0530
Message-ID: <1416821930-3003-1-git-send-email-nataraja@qti.qualcomm.com> (sfid-20141124_103953_445676_EB4E859E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    6 +-----
 drivers/net/wireless/ath/ath10k/wmi.h |    1 -
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8b60749..61f7e22 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -391,15 +391,11 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	return 0;
 }
 
-static int  ath10k_mac_set_rts(struct ath10k_vif *arvif, u32 value)
+static int ath10k_mac_set_rts(struct ath10k_vif *arvif, u32 value)
 {
 	struct ath10k *ar = arvif->ar;
 	u32 vdev_param;
 
-	if (value != 0xFFFFFFFF)
-		value = min_t(u32, arvif->ar->hw->wiphy->rts_threshold,
-			      ATH10K_RTS_MAX);
-
 	vdev_param = ar->wmi.vdev_param->rts_threshold;
 	return ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param, value);
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index a38d788..8a4e779 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4547,7 +4547,6 @@ struct wmi_dbglog_cfg_cmd {
 	__le32 config_valid;
 } __packed;
 
-#define ATH10K_RTS_MAX		2347
 #define ATH10K_FRAGMT_THRESHOLD_MIN	540
 #define ATH10K_FRAGMT_THRESHOLD_MAX	2346
 
-- 
1.7.9.5

