Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1648 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab2KFAWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:45 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/24] brcmfmac: remove obsolete structure ap_info
Date: Mon, 5 Nov 2012 16:22:09 -0800
Message-ID: <1352161352-30405-2-git-send-email-frankyl@broadcom.com> (sfid-20121106_013118_058047_2C8D8499)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The data stored in ap_info structure is no longer used so remove
it from the driver.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   28 --------------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   13 ---------
 2 files changed, 41 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index cb30fea..9da9d05 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -486,13 +486,6 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (ap) {
 		set_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
-		if (!cfg->ap_info)
-			cfg->ap_info = kzalloc(sizeof(*cfg->ap_info),
-					       GFP_KERNEL);
-		if (!cfg->ap_info) {
-			err = -ENOMEM;
-			goto done;
-		}
 		WL_INFO("IF Type = AP\n");
 	} else {
 		err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
@@ -3990,11 +3983,6 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	wpa_ie = brcmf_find_wpaie((u8 *)settings->beacon.tail,
 				  settings->beacon.tail_len);
 
-	kfree(cfg->ap_info->rsn_ie);
-	cfg->ap_info->rsn_ie = NULL;
-	kfree(cfg->ap_info->wpa_ie);
-	cfg->ap_info->wpa_ie = NULL;
-
 	if ((wpa_ie != NULL || rsn_ie != NULL)) {
 		WL_TRACE("WPA(2) IE is found\n");
 		if (wpa_ie != NULL) {
@@ -4003,26 +3991,16 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 						    bssidx);
 			if (err < 0)
 				goto exit;
-			cfg->ap_info->wpa_ie = kmemdup(wpa_ie,
-							    wpa_ie->len +
-							    TLV_HDR_LEN,
-							    GFP_KERNEL);
 		} else {
 			/* RSN IE */
 			err = brcmf_configure_wpaie(ndev,
 				(struct brcmf_vs_tlv *)rsn_ie, true, bssidx);
 			if (err < 0)
 				goto exit;
-			cfg->ap_info->rsn_ie = kmemdup(rsn_ie,
-							    rsn_ie->len +
-							    TLV_HDR_LEN,
-							    GFP_KERNEL);
 		}
-		cfg->ap_info->security_mode = true;
 	} else {
 		WL_TRACE("No WPA(2) IEs found\n");
 		brcmf_configure_opensecurity(ndev, bssidx);
-		cfg->ap_info->security_mode = false;
 	}
 	/* Set Beacon IEs to FW */
 	err = brcmf_set_management_ie(cfg, ndev,
@@ -4766,12 +4744,6 @@ static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
 	cfg->iscan = NULL;
 	kfree(cfg->pmk_list);
 	cfg->pmk_list = NULL;
-	if (cfg->ap_info) {
-		kfree(cfg->ap_info->wpa_ie);
-		kfree(cfg->ap_info->rsn_ie);
-		kfree(cfg->ap_info);
-		cfg->ap_info = NULL;
-	}
 }
 
 static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_info *cfg)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 1dd96f1..d7d473c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -323,17 +323,6 @@ struct escan_info {
 	struct net_device *ndev;
 };
 
-/* Structure to hold WPS, WPA IEs for a AP */
-struct ap_info {
-	u8 probe_res_ie[IE_MAX_LEN];
-	u8 beacon_ie[IE_MAX_LEN];
-	u32 probe_res_ie_len;
-	u32 beacon_ie_len;
-	u8 *wpa_ie;
-	u8 *rsn_ie;
-	bool security_mode;
-};
-
 /**
  * struct brcmf_pno_param_le - PNO scan configuration parameters
  *
@@ -455,7 +444,6 @@ struct brcmf_pno_scanresults_le {
  * @escan_timeout: Timer for catch scan timeout.
  * @escan_timeout_work: scan timeout worker.
  * @escan_ioctl_buf: dongle command buffer for escan commands.
- * @ap_info: host ap information.
  * @vif_list: linked list of vif instances.
  * @vif_cnt: number of vif instances.
  */
@@ -497,7 +485,6 @@ struct brcmf_cfg80211_info {
 	struct timer_list escan_timeout;
 	struct work_struct escan_timeout_work;
 	u8 *escan_ioctl_buf;
-	struct ap_info *ap_info;
 	struct list_head vif_list;
 	u8 vif_cnt;
 };
-- 
1.7.9.5


