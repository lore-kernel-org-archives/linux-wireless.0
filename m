Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2570 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab3ABOXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:14 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 18/18] brcmfmac: Update init code routines from
 interface up.
Date: Wed, 2 Jan 2013 15:22:51 +0100
Message-ID: <1357136572-18273-19-git-send-email-arend@broadcom.com> (sfid-20130102_155322_409568_66CA30D6)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

On interface up dongle gets inialized. Move UP command to common
routine and update these common init routines using ifp.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    9 ++----
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   30 +++++++++-----------
 2 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index d655501..e3326a5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -585,14 +585,9 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	/* Get current TOE mode from dongle */
 	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
 	    && (toe_ol & TOE_TX_CSUM_OL) != 0)
-		drvr->iflist[ifp->idx]->ndev->features |=
-			NETIF_F_IP_CSUM;
+		ndev->features |= NETIF_F_IP_CSUM;
 	else
-		drvr->iflist[ifp->idx]->ndev->features &=
-			~NETIF_F_IP_CSUM;
-
-	/* make sure RF is ready for work */
-	brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 0);
+		ndev->features &= ~NETIF_F_IP_CSUM;
 
 	/* Allow transmit calls */
 	netif_start_queue(ndev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 1ec2d57..730da84 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4265,9 +4265,8 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 }
 
 static s32
-brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
+brcmf_dongle_roam(struct brcmf_if *ifp, u32 roamvar, u32 bcn_timeout)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 	__le32 roamtrigger[2];
 	__le32 roam_delta[2];
@@ -4318,10 +4317,9 @@ dongle_rom_out:
 }
 
 static s32
-brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
+brcmf_dongle_scantime(struct brcmf_if *ifp, s32 scan_assoc_time,
 		      s32 scan_unassoc_time, s32 scan_passive_time)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_CHANNEL_TIME,
@@ -4391,6 +4389,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 {
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
+	struct brcmf_if *ifp;
 	s32 power_mode;
 	s32 err = 0;
 
@@ -4399,35 +4398,34 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 
 	ndev = cfg_to_ndev(cfg);
 	wdev = ndev->ieee80211_ptr;
+	ifp = netdev_priv(ndev);
+
+	/* make sure RF is ready for work */
+	brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 0);
 
-	brcmf_dongle_scantime(ndev, WL_SCAN_CHANNEL_TIME,
-			WL_SCAN_UNASSOC_TIME, WL_SCAN_PASSIVE_TIME);
+	brcmf_dongle_scantime(ifp, WL_SCAN_CHANNEL_TIME,
+			      WL_SCAN_UNASSOC_TIME, WL_SCAN_PASSIVE_TIME);
 
 	power_mode = cfg->pwr_save ? PM_FAST : PM_OFF;
-	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCMF_C_SET_PM,
-				    power_mode);
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, power_mode);
 	if (err)
 		goto default_conf_out;
 	brcmf_dbg(INFO, "power save set to %s\n",
 		  (power_mode ? "enabled" : "disabled"));
 
-	err = brcmf_dongle_roam(ndev, (cfg->roam_on ? 0 : 1),
-				WL_BEACON_TIMEOUT);
+	err = brcmf_dongle_roam(ifp, (cfg->roam_on ? 0 : 1), WL_BEACON_TIMEOUT);
 	if (err)
 		goto default_conf_out;
 	err = brcmf_cfg80211_change_iface(wdev->wiphy, ndev, wdev->iftype,
 					  NULL, NULL);
-	if (err && err != -EINPROGRESS)
+	if (err)
 		goto default_conf_out;
 	err = brcmf_dongle_probecap(cfg);
 	if (err)
 		goto default_conf_out;
 
-	/* -EINPROGRESS: Call commit handler */
-
-default_conf_out:
-
 	cfg->dongle_up = true;
+default_conf_out:
 
 	return err;
 
@@ -4436,8 +4434,6 @@ default_conf_out:
 static s32 __brcmf_cfg80211_up(struct brcmf_if *ifp)
 {
 	set_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state);
-	if (ifp->idx)
-		return 0;
 
 	return brcmf_config_dongle(ifp->drvr->config);
 }
-- 
1.7.10.4


