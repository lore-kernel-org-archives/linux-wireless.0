Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:41677 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaBYTap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:45 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/14] brcmfmac: Make firmeware roaming a module param.
Date: Tue, 25 Feb 2014 20:30:26 +0100
Message-ID: <1393356639-19169-3-git-send-email-arend@broadcom.com> (sfid-20140225_203128_589465_3E43E7B4)
In-Reply-To: <1393356639-19169-1-git-send-email-arend@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Internal firmware roaming is enabled by default. This patch
makes it possible to disable internal firmware roaming by
specifying roamoff=1 as module param.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   38 +++++++++++++-------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    1 -
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 51ee7f0..81be69d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -18,6 +18,7 @@
 
 #include <linux/kernel.h>
 #include <linux/etherdevice.h>
+#include <linux/module.h>
 #include <net/cfg80211.h>
 #include <net/netlink.h>
 
@@ -251,6 +252,10 @@ struct parsed_vndr_ies {
 	struct parsed_vndr_ie_info ie_info[VNDR_IE_PARSE_LIMIT];
 };
 
+static int brcmf_roamoff;
+module_param_named(roamoff, brcmf_roamoff, int, S_IRUSR);
+MODULE_PARM_DESC(roamoff, "do not use internal roaming engine");
+
 /* Quarter dBm units to mW
  * Table starts at QDBM_OFFSET, so the first entry is mW for qdBm=153
  * Table is offset so the last entry is largest mW value that fits in
@@ -4444,7 +4449,9 @@ static bool brcmf_is_linkdown(const struct brcmf_event_msg *e)
 	u32 event = e->event_code;
 	u16 flags = e->flags;
 
-	if (event == BRCMF_E_LINK && (!(flags & BRCMF_EVENT_MSG_LINK))) {
+	if ((event == BRCMF_E_DEAUTH) || (event == BRCMF_E_DEAUTH_IND) ||
+	    (event == BRCMF_E_DISASSOC_IND) ||
+	    ((event == BRCMF_E_LINK) && (!(flags & BRCMF_EVENT_MSG_LINK)))) {
 		brcmf_dbg(CONN, "Processing link down\n");
 		return true;
 	}
@@ -4688,6 +4695,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct ieee80211_channel *chan;
 	s32 err = 0;
+	u16 reason;
 
 	if (ifp->vif->mode == WL_MODE_AP) {
 		err = brcmf_notify_connect_status_ap(cfg, ndev, e, data);
@@ -4709,9 +4717,15 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 		if (!brcmf_is_ibssmode(ifp->vif)) {
 			brcmf_bss_connect_done(cfg, ndev, e, false);
 			if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTED,
-					       &ifp->vif->sme_state))
-				cfg80211_disconnected(ndev, 0, NULL, 0,
+					       &ifp->vif->sme_state)) {
+				reason = 0;
+				if (((e->event_code == BRCMF_E_DEAUTH_IND) ||
+				     (e->event_code == BRCMF_E_DISASSOC_IND)) &&
+				    (e->reason != WLAN_REASON_UNSPECIFIED))
+					reason = e->reason;
+				cfg80211_disconnected(ndev, reason, NULL, 0,
 						      GFP_KERNEL);
+			}
 		}
 		brcmf_link_down(ifp->vif);
 		brcmf_init_prof(ndev_to_prof(ndev));
@@ -4905,11 +4919,8 @@ static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 
 	cfg->scan_request = NULL;
 	cfg->pwr_save = true;
-	cfg->roam_on = true;	/* roam on & off switch.
-				 we enable roam per default */
-	cfg->active_scan = true;	/* we do active scan for
-				 specific scan per default */
-	cfg->dongle_up = false;	/* dongle is not up yet */
+	cfg->active_scan = true;	/* we do active scan per default */
+	cfg->dongle_up = false;		/* dongle is not up yet */
 	err = brcmf_init_priv_mem(cfg);
 	if (err)
 		return err;
@@ -5029,7 +5040,7 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 }
 
 static s32
-brcmf_dongle_roam(struct brcmf_if *ifp, u32 roamvar, u32 bcn_timeout)
+brcmf_dongle_roam(struct brcmf_if *ifp, u32 bcn_timeout)
 {
 	s32 err = 0;
 	__le32 roamtrigger[2];
@@ -5039,7 +5050,7 @@ brcmf_dongle_roam(struct brcmf_if *ifp, u32 roamvar, u32 bcn_timeout)
 	 * Setup timeout if Beacons are lost and roam is
 	 * off to report link down
 	 */
-	if (roamvar) {
+	if (brcmf_roamoff) {
 		err = brcmf_fil_iovar_int_set(ifp, "bcn_timeout", bcn_timeout);
 		if (err) {
 			brcmf_err("bcn_timeout error (%d)\n", err);
@@ -5051,8 +5062,9 @@ brcmf_dongle_roam(struct brcmf_if *ifp, u32 roamvar, u32 bcn_timeout)
 	 * Enable/Disable built-in roaming to allow supplicant
 	 * to take care of roaming
 	 */
-	brcmf_dbg(INFO, "Internal Roaming = %s\n", roamvar ? "Off" : "On");
-	err = brcmf_fil_iovar_int_set(ifp, "roam_off", roamvar);
+	brcmf_dbg(INFO, "Internal Roaming = %s\n",
+		  brcmf_roamoff ? "Off" : "On");
+	err = brcmf_fil_iovar_int_set(ifp, "roam_off", !!(brcmf_roamoff));
 	if (err) {
 		brcmf_err("roam_off error (%d)\n", err);
 		goto dongle_rom_out;
@@ -5408,7 +5420,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 	brcmf_dbg(INFO, "power save set to %s\n",
 		  (power_mode ? "enabled" : "disabled"));
 
-	err = brcmf_dongle_roam(ifp, (cfg->roam_on ? 0 : 1), WL_BEACON_TIMEOUT);
+	err = brcmf_dongle_roam(ifp, WL_BEACON_TIMEOUT);
 	if (err)
 		goto default_conf_out;
 	err = brcmf_cfg80211_change_iface(wdev->wiphy, ndev, wdev->iftype,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 254feed..5715bb0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -402,7 +402,6 @@ struct brcmf_cfg80211_info {
 	bool ibss_starter;
 	bool pwr_save;
 	bool dongle_up;
-	bool roam_on;
 	bool scan_tried;
 	u8 *dcmd_buf;
 	u8 *extra_buf;
-- 
1.7.10.4

