Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:22792 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932AbbAYTbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:47 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/14] brcmfmac: pass DEAUTH/DISASSOC reason code to user-space
Date: Sun, 25 Jan 2015 20:31:33 +0100
Message-ID: <1422214303-7816-5-git-send-email-arend@broadcom.com> (sfid-20150125_204445_606780_A29537F1)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver always called cfg80211_disconnected() with reason parameter
set to zero, ie. unknown. However, firmware does provide a valid
802.11 reason code in DEAUTH and DISASSOC event message to the driver.
This patch passes the reason code to cfg80211_disconnected().

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 31 +++++++++++++++++-----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 5eba81b..b59b8c6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -1229,7 +1229,25 @@ static void brcmf_init_prof(struct brcmf_cfg80211_profile *prof)
 	memset(prof, 0, sizeof(*prof));
 }
 
-static void brcmf_link_down(struct brcmf_cfg80211_vif *vif)
+static u16 brcmf_map_fw_linkdown_reason(const struct brcmf_event_msg *e)
+{
+	u16 reason;
+
+	switch (e->event_code) {
+	case BRCMF_E_DEAUTH:
+	case BRCMF_E_DEAUTH_IND:
+	case BRCMF_E_DISASSOC_IND:
+		reason = e->reason;
+		break;
+	case BRCMF_E_LINK:
+	default:
+		reason = 0;
+		break;
+	}
+	return reason;
+}
+
+static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(vif->wdev.wiphy);
 	s32 err = 0;
@@ -1244,7 +1262,8 @@ static void brcmf_link_down(struct brcmf_cfg80211_vif *vif)
 			brcmf_err("WLC_DISASSOC failed (%d)\n", err);
 		}
 		clear_bit(BRCMF_VIF_STATUS_CONNECTED, &vif->sme_state);
-		cfg80211_disconnected(vif->wdev.netdev, 0, NULL, 0, GFP_KERNEL);
+		cfg80211_disconnected(vif->wdev.netdev, reason, NULL, 0,
+				      GFP_KERNEL);
 
 	}
 	clear_bit(BRCMF_VIF_STATUS_CONNECTING, &vif->sme_state);
@@ -1414,7 +1433,7 @@ brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
-	brcmf_link_down(ifp->vif);
+	brcmf_link_down(ifp->vif, WLAN_REASON_DEAUTH_LEAVING);
 
 	brcmf_dbg(TRACE, "Exit\n");
 
@@ -3041,7 +3060,7 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 			 * disassociate from AP to save power while system is
 			 * in suspended state
 			 */
-			brcmf_link_down(vif);
+			brcmf_link_down(vif, WLAN_REASON_UNSPECIFIED);
 			/* Make sure WPA_Supplicant receives all the event
 			 * generated due to DISASSOC call to the fw to keep
 			 * the state fw and WPA_Supplicant state consistent
@@ -4927,7 +4946,7 @@ brcmf_notify_connect_status(struct brcmf_if *ifp,
 		if (!brcmf_is_ibssmode(ifp->vif)) {
 			brcmf_bss_connect_done(cfg, ndev, e, false);
 		}
-		brcmf_link_down(ifp->vif);
+		brcmf_link_down(ifp->vif, brcmf_map_fw_linkdown_reason(e));
 		brcmf_init_prof(ndev_to_prof(ndev));
 		if (ndev != cfg_to_ndev(cfg))
 			complete(&cfg->vif_disabled);
@@ -5868,7 +5887,7 @@ static s32 __brcmf_cfg80211_down(struct brcmf_if *ifp)
 	 * from AP to save power
 	 */
 	if (check_vif_up(ifp->vif)) {
-		brcmf_link_down(ifp->vif);
+		brcmf_link_down(ifp->vif, WLAN_REASON_UNSPECIFIED);
 
 		/* Make sure WPA_Supplicant receives all the event
 		   generated due to DISASSOC call to the fw to keep
-- 
1.9.1

