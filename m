Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33218 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbcFLX20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2016 19:28:26 -0400
Received: by mail-pa0-f67.google.com with SMTP id ts6so2103345pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2016 16:28:26 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/6] staging: wilc1000: change handle_cfg_param's return type to void
Date: Mon, 13 Jun 2016 08:28:10 +0900
Message-Id: <20160612232815.12112-1-chaehyun.lim@gmail.com> (sfid-20160613_012835_600374_9D8FE8E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When handle_cfg_param is called in hostIFthread that is a kernel thread,
it is not checked return type of this function. This patch changes
return type to void.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9535842..aeb355e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -417,8 +417,8 @@ static void handle_get_mac_address(struct wilc_vif *vif,
 	complete(&hif_wait_response);
 }
 
-static s32 handle_cfg_param(struct wilc_vif *vif,
-			    struct cfg_param_attr *cfg_param_attr)
+static void handle_cfg_param(struct wilc_vif *vif,
+			     struct cfg_param_attr *cfg_param_attr)
 {
 	s32 result = 0;
 	struct wid wid_list[32];
@@ -436,7 +436,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.bss_type = (u8)cfg_param_attr->bss_type;
 		} else {
 			netdev_err(vif->ndev, "check value 6 over\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -452,7 +451,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.auth_type = (u8)cfg_param_attr->auth_type;
 		} else {
 			netdev_err(vif->ndev, "Impossible value\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -467,7 +465,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.auth_timeout = cfg_param_attr->auth_timeout;
 		} else {
 			netdev_err(vif->ndev, "Range(1 ~ 65535) over\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -481,7 +478,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.power_mgmt_mode = (u8)cfg_param_attr->power_mgmt_mode;
 		} else {
 			netdev_err(vif->ndev, "Invalid power mode\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -496,7 +492,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.short_retry_limit = cfg_param_attr->short_retry_limit;
 		} else {
 			netdev_err(vif->ndev, "Range(1~256) over\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -511,7 +506,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.long_retry_limit = cfg_param_attr->long_retry_limit;
 		} else {
 			netdev_err(vif->ndev, "Range(1~256) over\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -526,7 +520,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.frag_threshold = cfg_param_attr->frag_threshold;
 		} else {
 			netdev_err(vif->ndev, "Threshold Range fail\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -541,7 +534,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.rts_threshold = cfg_param_attr->rts_threshold;
 		} else {
 			netdev_err(vif->ndev, "Threshold Range fail\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -555,7 +547,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.preamble_type = cfg_param_attr->preamble_type;
 		} else {
 			netdev_err(vif->ndev, "Preamle Range(0~2) over\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -569,7 +560,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.short_slot_allowed = (u8)cfg_param_attr->short_slot_allowed;
 		} else {
 			netdev_err(vif->ndev, "Short slot(2) over\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -583,7 +573,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.txop_prot_disabled = (u8)cfg_param_attr->txop_prot_disabled;
 		} else {
 			netdev_err(vif->ndev, "TXOP prot disable\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -598,7 +587,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.beacon_interval = cfg_param_attr->beacon_interval;
 		} else {
 			netdev_err(vif->ndev, "Beacon interval(1~65535)fail\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -613,7 +601,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.dtim_period = cfg_param_attr->dtim_period;
 		} else {
 			netdev_err(vif->ndev, "DTIM range(1~255) fail\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -627,7 +614,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.site_survey_enabled = (u8)cfg_param_attr->site_survey_enabled;
 		} else {
 			netdev_err(vif->ndev, "Site survey disable\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -642,7 +628,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.site_survey_scan_time = cfg_param_attr->site_survey_scan_time;
 		} else {
 			netdev_err(vif->ndev, "Site scan time(1~65535) over\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -657,7 +642,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.active_scan_time = cfg_param_attr->active_scan_time;
 		} else {
 			netdev_err(vif->ndev, "Active time(1~65535) over\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -672,7 +656,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.passive_scan_time = cfg_param_attr->passive_scan_time;
 		} else {
 			netdev_err(vif->ndev, "Passive time(1~65535) over\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -694,7 +677,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 			hif_drv->cfg_values.curr_tx_rate = (u8)curr_tx_rate;
 		} else {
 			netdev_err(vif->ndev, "out of TX rate\n");
-			result = -EINVAL;
 			goto unlock;
 		}
 		i++;
@@ -708,7 +690,6 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 
 unlock:
 	mutex_unlock(&hif_drv->cfg_values_lock);
-	return result;
 }
 
 static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
-- 
2.8.4

