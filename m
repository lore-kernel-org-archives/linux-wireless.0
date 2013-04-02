Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3438 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037Ab3DBTGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 15:06:37 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.9 2/4] brcmfmac: fix stopping AP.
Date: Tue, 2 Apr 2013 21:06:18 +0200
Message-ID: <1364929580-6206-3-git-send-email-arend@broadcom.com> (sfid-20130402_210657_550737_711E781F)
In-Reply-To: <1364929580-6206-1-git-send-email-arend@broadcom.com>
References: <1364929580-6206-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

on stop_ap the dongle was not properly shutdown. As a result it was
not possible to restart AP or STA after AP operation without
restarting the device. This patch will fix that.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   25 ++++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 3bc47ea..b9dbf2c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3827,8 +3827,9 @@ exit:
 static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	s32 err = -EPERM;
+	s32 err;
 	struct brcmf_fil_bss_enable_le bss_enable;
+	struct brcmf_join_params join_params;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3836,16 +3837,21 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		/* Due to most likely deauths outstanding we sleep */
 		/* first to make sure they get processed by fw. */
 		msleep(400);
-		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
-		if (err < 0) {
-			brcmf_err("setting AP mode failed %d\n", err);
-			goto exit;
-		}
+
+		memset(&join_params, 0, sizeof(join_params));
+		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
+					     &join_params, sizeof(join_params));
+		if (err < 0)
+			brcmf_err("SET SSID error (%d)\n", err);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 0);
-		if (err < 0) {
+		if (err < 0)
 			brcmf_err("BRCMF_C_UP error %d\n", err);
-			goto exit;
-		}
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
+		if (err < 0)
+			brcmf_err("setting AP mode failed %d\n", err);
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 0);
+		if (err < 0)
+			brcmf_err("setting INFRA mode failed %d\n", err);
 	} else {
 		bss_enable.bsscfg_idx = cpu_to_le32(ifp->bssidx);
 		bss_enable.enable = cpu_to_le32(0);
@@ -3858,7 +3864,6 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 	set_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
 	clear_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 
-exit:
 	return err;
 }
 
-- 
1.7.10.4


