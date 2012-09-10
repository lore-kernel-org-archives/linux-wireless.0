Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2024 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab2IJNRT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 09:17:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/10] brcmfmac: Clean up scan related code.
Date: Mon, 10 Sep 2012 15:16:53 +0200
Message-ID: <1347283018-24223-6-git-send-email-arend@broadcom.com> (sfid-20120910_151728_012670_067D7C68)
In-Reply-To: <1347283018-24223-1-git-send-email-arend@broadcom.com>
References: <1347283018-24223-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Clean up scan related code in preparation of a new scan mechanism (e-scan)
which will follow in a separate patch.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   22 ++++++++------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 4553fa0..4a27ca0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -490,8 +490,8 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 	}
 }
 
-static void wl_iscan_prep(struct brcmf_scan_params_le *params_le,
-			  struct brcmf_ssid *ssid)
+static void brcmf_iscan_prep(struct brcmf_scan_params_le *params_le,
+			     struct brcmf_ssid *ssid)
 {
 	memcpy(params_le->bssid, ether_bcast, ETH_ALEN);
 	params_le->bss_type = DOT11_BSSTYPE_ANY;
@@ -545,7 +545,7 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 		return -ENOMEM;
 	BUG_ON(params_size >= BRCMF_DCMD_SMLEN);
 
-	wl_iscan_prep(&params->params_le, ssid);
+	brcmf_iscan_prep(&params->params_le, ssid);
 
 	params->version = cpu_to_le32(BRCMF_ISCAN_REQ_VERSION);
 	params->action = cpu_to_le16(action);
@@ -598,9 +598,9 @@ static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 }
 
 static s32
-__brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
-		   struct cfg80211_scan_request *request,
-		   struct cfg80211_ssid *this_ssid)
+brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
+		     struct cfg80211_scan_request *request,
+		     struct cfg80211_ssid *this_ssid)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	struct cfg80211_ssid *ssids;
@@ -703,7 +703,7 @@ brcmf_cfg80211_scan(struct wiphy *wiphy,
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	err = __brcmf_cfg80211_scan(wiphy, ndev, request, NULL);
+	err = brcmf_cfg80211_iscan(wiphy, ndev, request, NULL);
 	if (err)
 		WL_ERR("scan error (%d)\n", err);
 
@@ -2547,10 +2547,8 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 	clear_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
 
 	/* Turn off watchdog timer */
-	if (test_bit(WL_STATUS_READY, &cfg_priv->status)) {
-		WL_INFO("Enable MPC\n");
+	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
 		brcmf_set_mpc(ndev, 1);
-	}
 
 	WL_TRACE("Exit\n");
 
@@ -3194,10 +3192,8 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 	cfg_priv->scan_results->count = le32_to_cpu(bss_list_le->count);
 
 	err = brcmf_inform_bss(cfg_priv);
-	if (err) {
+	if (err)
 		scan_abort = true;
-		goto scan_done_out;
-	}
 
 scan_done_out:
 	if (cfg_priv->scan_request) {
-- 
1.7.9.5


