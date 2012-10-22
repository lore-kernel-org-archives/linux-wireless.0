Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4529 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab2JVUz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/12] brcmfmac: remove debugfs functionality from
 wl_cfg80211.c
Date: Mon, 22 Oct 2012 13:55:34 -0700
Message-ID: <1350939341-17687-6-git-send-email-frankyl@broadcom.com> (sfid-20121022_225619_083935_CA63A5DE)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

In wl_cfg80211.c debugfs directory was created to expose
dtim_period and beacon_interval. However, this can be easily
obtained using iw so it is removed from the driver.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   43 --------------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    2 -
 2 files changed, 45 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 13971d1..da48894a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2577,9 +2577,6 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 		dtim_period = (u8)var;
 	}
 
-	profile->beacon_interval = beacon_interval;
-	profile->dtim_period = dtim_period;
-
 update_bss_info_out:
 	WL_TRACE("Exit");
 	return err;
@@ -5264,42 +5261,6 @@ default_conf_out:
 
 }
 
-static int brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_info *cfg)
-{
-	struct net_device *ndev = cfg_to_ndev(cfg);
-	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
-	char buf[10+IFNAMSIZ];
-	struct dentry *fd;
-	s32 err = 0;
-
-	sprintf(buf, "netdev:%s", ndev->name);
-	cfg->debugfsdir = debugfs_create_dir(buf,
-					cfg_to_wiphy(cfg)->debugfsdir);
-
-	fd = debugfs_create_u16("beacon_int", S_IRUGO, cfg->debugfsdir,
-		(u16 *)&profile->beacon_interval);
-	if (!fd) {
-		err = -ENOMEM;
-		goto err_out;
-	}
-
-	fd = debugfs_create_u8("dtim_period", S_IRUGO, cfg->debugfsdir,
-		(u8 *)&profile->dtim_period);
-	if (!fd) {
-		err = -ENOMEM;
-		goto err_out;
-	}
-
-err_out:
-	return err;
-}
-
-static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_info *cfg)
-{
-	debugfs_remove_recursive(cfg->debugfsdir);
-	cfg->debugfsdir = NULL;
-}
-
 static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
@@ -5307,8 +5268,6 @@ static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg)
 
 	set_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state);
 
-	brcmf_debugfs_add_netdev_params(cfg);
-
 	err = brcmf_config_dongle(cfg);
 	if (err)
 		return err;
@@ -5343,8 +5302,6 @@ static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg)
 	brcmf_abort_scanning(cfg);
 	clear_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state);
 
-	brcmf_debugfs_remove_netdev(cfg);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index fca288b..851403f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -228,8 +228,6 @@ struct brcmf_cfg80211_profile {
 	u32 mode;
 	struct brcmf_ssid ssid;
 	u8 bssid[ETH_ALEN];
-	u16 beacon_interval;
-	u8 dtim_period;
 	struct brcmf_cfg80211_security sec;
 	struct brcmf_cfg80211_ibss ibss;
 	s32 band;
-- 
1.7.9.5


