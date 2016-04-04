Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36207 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbcDDLFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 07:05:06 -0400
Received: by mail-pa0-f65.google.com with SMTP id 1so19879303pal.3
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 04:05:05 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/8] staging: wilc1000: rename goto label in handle_cfg_param
Date: Mon,  4 Apr 2016 20:04:43 +0900
Message-Id: <1459767890-9709-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160404_130514_274148_EF284AF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes goto label from ERRORHANDLER to unlock.
unlock is a more meaningful name than ERRORHANDLER.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 38 +++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 04cbff5..b8dae09 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -456,7 +456,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "check value 6 over\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -472,7 +472,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Impossible value\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -487,7 +487,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Range(1 ~ 65535) over\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -501,7 +501,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Invalid power mode\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -516,7 +516,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Range(1~256) over\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -531,7 +531,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Range(1~256) over\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -546,7 +546,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Threshold Range fail\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -561,7 +561,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Threshold Range fail\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -575,7 +575,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Preamle Range(0~2) over\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -589,7 +589,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Short slot(2) over\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -603,7 +603,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "TXOP prot disable\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -618,7 +618,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Beacon interval(1~65535)fail\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -633,7 +633,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "DTIM range(1~255) fail\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -647,7 +647,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Site survey disable\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -662,7 +662,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Site scan time(1~65535) over\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -677,7 +677,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Active time(1~65535) over\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -692,7 +692,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "Passive time(1~65535) over\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -714,7 +714,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		} else {
 			netdev_err(vif->ndev, "out of TX rate\n");
 			result = -EINVAL;
-			goto ERRORHANDLER;
+			goto unlock;
 		}
 		i++;
 	}
@@ -725,7 +725,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 	if (result)
 		netdev_err(vif->ndev, "Error in setting CFG params\n");
 
-ERRORHANDLER:
+unlock:
 	mutex_unlock(&hif_drv->cfg_values_lock);
 	return result;
 }
-- 
2.8.0

