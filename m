Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33300 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192AbbLXHxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:38 -0500
Received: by mail-pf0-f182.google.com with SMTP id q63so29065771pfb.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:37 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 17/21] staging: wilc1000: remove wilc_free_join_params
Date: Thu, 24 Dec 2015 16:52:35 +0900
Message-Id: <1450943559-20937-17-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_085343_847483_3B9C1FC6)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_free_join_params call kfree. There is no need to use
wrapper function, so use kfree directly.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         | 8 --------
 drivers/staging/wilc1000/host_interface.h         | 3 ---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6e5bccc..724b4bd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4609,14 +4609,6 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 	return (void *)pNewJoinBssParam;
 }
 
-void wilc_free_join_params(void *pJoinParams)
-{
-	if ((struct bss_param *)pJoinParams)
-		kfree((struct bss_param *)pJoinParams);
-	else
-		PRINT_ER("Unable to FREE null pointer\n");
-}
-
 s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID)
 {
 	s32 result = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index fa5d292..7ac85f2 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -365,9 +365,6 @@ s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
 s32 wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
-
-void wilc_free_join_params(void *pJoinParams);
-
 s32 wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics);
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);
 int wilc_get_vif_idx(struct wilc_vif *vif);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 53fb2d4..be5704b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -196,7 +196,7 @@ static void clear_shadow_scan(void)
 				last_scanned_shadow[last_scanned_cnt].pu8IEs = NULL;
 			}
 
-			wilc_free_join_params(last_scanned_shadow[i].pJoinParams);
+			kfree(last_scanned_shadow[i].pJoinParams);
 			last_scanned_shadow[i].pJoinParams = NULL;
 		}
 		last_scanned_cnt = 0;
@@ -282,7 +282,7 @@ static void remove_network_from_shadow(unsigned long arg)
 			kfree(last_scanned_shadow[i].pu8IEs);
 			last_scanned_shadow[i].pu8IEs = NULL;
 
-			wilc_free_join_params(last_scanned_shadow[i].pJoinParams);
+			kfree(last_scanned_shadow[i].pJoinParams);
 
 			for (j = i; (j < last_scanned_cnt - 1); j++)
 				last_scanned_shadow[j] = last_scanned_shadow[j + 1];
@@ -376,7 +376,7 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo,
 	last_scanned_shadow[ap_index].u32TimeRcvdInScanCached = jiffies;
 	last_scanned_shadow[ap_index].u8Found = 1;
 	if (ap_found != -1)
-		wilc_free_join_params(last_scanned_shadow[ap_index].pJoinParams);
+		kfree(last_scanned_shadow[ap_index].pJoinParams);
 	last_scanned_shadow[ap_index].pJoinParams = pJoinParams;
 }
 
-- 
2.6.4

