Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4612 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933207Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/26] staging: brcm80211: clean up rtnl_lock in fullmac
Date: Tue, 4 Oct 2011 23:18:53 +0200
Message-ID: <1317763152-17607-8-git-send-email-arend@broadcom.com> (sfid-20111004_231959_269124_4E3AF5B2)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

rtnl lock is used improperly in fullmac. This patch intends to clean
them up.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Sukesh Srikakula <sukeshs@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |    3 ++
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   24 +--------------------
 2 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 641cd9c..804b2bc 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/wait.h>
 #include <net/cfg80211.h>
+#include <net/rtnetlink.h>
 #include <defs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
@@ -1240,7 +1241,9 @@ void brcmf_detach(struct brcmf_pub *drvr)
 
 			ifp = drvr_priv->iflist[0];
 			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
+				rtnl_lock();
 				brcmf_netdev_stop(ifp->ndev);
+				rtnl_unlock();
 				unregister_netdev(ifp->ndev);
 			}
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index f7b3077..fc643c1 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -26,7 +26,6 @@
 #include <linux/ieee80211.h>
 #include <linux/uaccess.h>
 #include <net/cfg80211.h>
-#include <net/rtnetlink.h>
 
 #include <brcmu_utils.h>
 #include <defs.h>
@@ -2223,10 +2222,8 @@ static s32 brcmf_iscan_done(struct brcmf_cfg80211_priv *cfg_priv)
 	s32 err = 0;
 
 	iscan->state = WL_ISCAN_STATE_IDLE;
-	rtnl_lock();
 	brcmf_inform_bss(cfg_priv);
 	brcmf_notify_iscan_complete(iscan, false);
-	rtnl_unlock();
 
 	return err;
 }
@@ -2248,10 +2245,8 @@ static s32 brcmf_iscan_inprogress(struct brcmf_cfg80211_priv *cfg_priv)
 	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
 	s32 err = 0;
 
-	rtnl_lock();
 	brcmf_inform_bss(cfg_priv);
 	brcmf_run_iscan(iscan, NULL, BRCMF_SCAN_ACTION_CONTINUE);
-	rtnl_unlock();
 	/* Reschedule the timer */
 	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
 	iscan->timer_on = 1;
@@ -2265,9 +2260,7 @@ static s32 brcmf_iscan_aborted(struct brcmf_cfg80211_priv *cfg_priv)
 	s32 err = 0;
 
 	iscan->state = WL_ISCAN_STATE_IDLE;
-	rtnl_lock();
 	brcmf_notify_iscan_complete(iscan, true);
-	rtnl_unlock();
 
 	return err;
 }
@@ -2286,12 +2279,10 @@ static void brcmf_cfg80211_iscan_handler(struct work_struct *work)
 		iscan->timer_on = 0;
 	}
 
-	rtnl_lock();
 	if (brcmf_get_iscan_results(iscan, &status, &cfg_priv->bss_list)) {
 		status = BRCMF_SCAN_RESULTS_ABORTED;
 		WL_ERR("Abort iscan\n");
 	}
-	rtnl_unlock();
 
 	el->handler[status](cfg_priv);
 }
@@ -2408,9 +2399,7 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 		 * generated due to DISASSOC call to the fw to keep
 		 * the state fw and WPA_Supplicant state consistent
 		 */
-		rtnl_unlock();
 		brcmf_delay(500);
-		rtnl_lock();
 	}
 
 	set_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
@@ -2978,7 +2967,6 @@ brcmf_notify_mic_status(struct brcmf_cfg80211_priv *cfg_priv,
 	u16 flags = be16_to_cpu(e->flags);
 	enum nl80211_key_type key_type;
 
-	rtnl_lock();
 	if (flags & BRCMF_EVENT_MSG_GROUP)
 		key_type = NL80211_KEYTYPE_GROUP;
 	else
@@ -2986,7 +2974,6 @@ brcmf_notify_mic_status(struct brcmf_cfg80211_priv *cfg_priv,
 
 	cfg80211_michael_mic_failure(ndev, (u8 *)&e->addr, key_type, -1,
 				     NULL, GFP_KERNEL);
-	rtnl_unlock();
 
 	return 0;
 }
@@ -3563,8 +3550,7 @@ static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_priv *cfg_priv)
 	return wl_update_wiphybands(cfg_priv);
 }
 
-static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv,
-			       bool need_lock)
+static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
@@ -3576,8 +3562,6 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv,
 
 	ndev = cfg_to_ndev(cfg_priv);
 	wdev = ndev->ieee80211_ptr;
-	if (need_lock)
-		rtnl_lock();
 
 	brcmf_dongle_scantime(ndev, WL_SCAN_CHANNEL_TIME,
 			WL_SCAN_UNASSOC_TIME, WL_SCAN_PASSIVE_TIME);
@@ -3607,8 +3591,6 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv,
 	/* -EINPROGRESS: Call commit handler */
 
 default_conf_out:
-	if (need_lock)
-		rtnl_unlock();
 
 	cfg_priv->dongle_up = true;
 
@@ -3658,7 +3640,7 @@ static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_priv *cfg_priv)
 
 	brcmf_debugfs_add_netdev_params(cfg_priv);
 
-	err = brcmf_config_dongle(cfg_priv, false);
+	err = brcmf_config_dongle(cfg_priv);
 	if (err)
 		return err;
 
@@ -3683,9 +3665,7 @@ static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv)
 		   generated due to DISASSOC call to the fw to keep
 		   the state fw and WPA_Supplicant state consistent
 		 */
-		rtnl_unlock();
 		brcmf_delay(500);
-		rtnl_lock();
 	}
 
 	set_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
-- 
1.7.4.1


