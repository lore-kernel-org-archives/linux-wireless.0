Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:5691 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbbKYKc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:32:56 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 06/11] brcmfmac: Cleanup roaming configuration.
Date: Wed, 25 Nov 2015 11:32:42 +0100
Message-ID: <1448447567-12189-7-git-send-email-arend@broadcom.com> (sfid-20151125_113305_428011_32D51C02)
In-Reply-To: <1448447567-12189-1-git-send-email-arend@broadcom.com>
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Put all roaming configuration related code in one place and
configure timeout based upon roaming setting.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 41 ++++++++++------------
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  6 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 21 -----------
 3 files changed, 22 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 53831f5..ef0f882 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4756,7 +4756,6 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 	vif->wdev.iftype = type;
 
 	vif->pm_block = pm_block;
-	vif->roam_off = -1;
 
 	brcmf_init_prof(&vif->profile);
 
@@ -5306,35 +5305,33 @@ static void init_vif_event(struct brcmf_cfg80211_vif_event *event)
 	mutex_init(&event->vif_event_lock);
 }
 
-static s32
-brcmf_dongle_roam(struct brcmf_if *ifp, u32 bcn_timeout)
+static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 {
-	s32 err = 0;
+	s32 err;
+	u32 bcn_timeout;
 	__le32 roamtrigger[2];
 	__le32 roam_delta[2];
 
-	/*
-	 * Setup timeout if Beacons are lost and roam is
-	 * off to report link down
-	 */
-	if (brcmf_roamoff) {
-		err = brcmf_fil_iovar_int_set(ifp, "bcn_timeout", bcn_timeout);
-		if (err) {
-			brcmf_err("bcn_timeout error (%d)\n", err);
-			goto dongle_rom_out;
-		}
+	/* Configure beacon timeout value based upon roaming setting */
+	if (brcmf_roamoff)
+		bcn_timeout = BRCMF_DEFAULT_BCN_TIMEOUT_ROAM_OFF;
+	else
+		bcn_timeout = BRCMF_DEFAULT_BCN_TIMEOUT_ROAM_ON;
+	err = brcmf_fil_iovar_int_set(ifp, "bcn_timeout", bcn_timeout);
+	if (err) {
+		brcmf_err("bcn_timeout error (%d)\n", err);
+		goto roam_setup_done;
 	}
 
-	/*
-	 * Enable/Disable built-in roaming to allow supplicant
-	 * to take care of roaming
+	/* Enable/Disable built-in roaming to allow supplicant to take care of
+	 * roaming.
 	 */
 	brcmf_dbg(INFO, "Internal Roaming = %s\n",
 		  brcmf_roamoff ? "Off" : "On");
 	err = brcmf_fil_iovar_int_set(ifp, "roam_off", !!(brcmf_roamoff));
 	if (err) {
 		brcmf_err("roam_off error (%d)\n", err);
-		goto dongle_rom_out;
+		goto roam_setup_done;
 	}
 
 	roamtrigger[0] = cpu_to_le32(WL_ROAM_TRIGGER_LEVEL);
@@ -5343,7 +5340,7 @@ brcmf_dongle_roam(struct brcmf_if *ifp, u32 bcn_timeout)
 				     (void *)roamtrigger, sizeof(roamtrigger));
 	if (err) {
 		brcmf_err("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
-		goto dongle_rom_out;
+		goto roam_setup_done;
 	}
 
 	roam_delta[0] = cpu_to_le32(WL_ROAM_DELTA);
@@ -5352,10 +5349,10 @@ brcmf_dongle_roam(struct brcmf_if *ifp, u32 bcn_timeout)
 				     (void *)roam_delta, sizeof(roam_delta));
 	if (err) {
 		brcmf_err("WLC_SET_ROAM_DELTA error (%d)\n", err);
-		goto dongle_rom_out;
+		goto roam_setup_done;
 	}
 
-dongle_rom_out:
+roam_setup_done:
 	return err;
 }
 
@@ -6070,7 +6067,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 	brcmf_dbg(INFO, "power save set to %s\n",
 		  (power_mode ? "enabled" : "disabled"));
 
-	err = brcmf_dongle_roam(ifp, WL_BEACON_TIMEOUT);
+	err = brcmf_dongle_roam(ifp);
 	if (err)
 		goto default_conf_out;
 	err = brcmf_cfg80211_change_iface(wdev->wiphy, ndev, wdev->iftype,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 3b3096b..d492163 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -28,7 +28,6 @@
 #define WL_EXTRA_BUF_MAX		2048
 #define WL_ROAM_TRIGGER_LEVEL		-75
 #define WL_ROAM_DELTA			20
-#define WL_BEACON_TIMEOUT		3
 
 #define WL_SCAN_CHANNEL_TIME		40
 #define WL_SCAN_UNASSOC_TIME		40
@@ -77,6 +76,9 @@
 
 #define BRCMF_MAX_DEFAULT_KEYS		4
 
+/* beacon loss timeout defaults */
+#define BRCMF_DEFAULT_BCN_TIMEOUT_ROAM_ON	2
+#define BRCMF_DEFAULT_BCN_TIMEOUT_ROAM_OFF	4
 
 /**
  * enum brcmf_scan_status - scan engine status
@@ -178,7 +180,6 @@ struct vif_saved_ie {
  * @ifp: lower layer interface pointer
  * @wdev: wireless device.
  * @profile: profile information.
- * @roam_off: roaming state.
  * @sme_state: SME state using enum brcmf_vif_status bits.
  * @pm_block: power-management blocked.
  * @list: linked list.
@@ -189,7 +190,6 @@ struct brcmf_cfg80211_vif {
 	struct brcmf_if *ifp;
 	struct wireless_dev wdev;
 	struct brcmf_cfg80211_profile profile;
-	s32 roam_off;
 	unsigned long sme_state;
 	bool pm_block;
 	struct vif_saved_ie saved_ie;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index fe54844..59beed2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -29,7 +29,6 @@
 
 const u8 ALLFFMAC[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
-#define BRCMF_DEFAULT_BCN_TIMEOUT	3
 #define BRCMF_DEFAULT_SCAN_CHANNEL_TIME	40
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
 
@@ -107,26 +106,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		goto done;
 	}
 
-	/*
-	 * Setup timeout if Beacons are lost and roam is off to report
-	 * link down
-	 */
-	err = brcmf_fil_iovar_int_set(ifp, "bcn_timeout",
-				      BRCMF_DEFAULT_BCN_TIMEOUT);
-	if (err) {
-		brcmf_err("bcn_timeout error (%d)\n", err);
-		goto done;
-	}
-
-	/* Enable/Disable build-in roaming to allowed ext supplicant to take
-	 * of romaing
-	 */
-	err = brcmf_fil_iovar_int_set(ifp, "roam_off", 1);
-	if (err) {
-		brcmf_err("roam_off error (%d)\n", err);
-		goto done;
-	}
-
 	/* Setup join_pref to select target by RSSI(with boost on 5GHz) */
 	join_pref_params[0].type = BRCMF_JOIN_PREF_RSSI_DELTA;
 	join_pref_params[0].len = 2;
-- 
1.9.1

