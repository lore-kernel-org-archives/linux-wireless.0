Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3067 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab2ISUVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/13] brcmfmac: extend brcmf_term_iscan() to abort
 e-scan
Date: Wed, 19 Sep 2012 22:21:07 +0200
Message-ID: <1348086078-19183-3-git-send-email-arend@broadcom.com> (sfid-20120919_222143_277151_4A793854)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the introduction of E-Scan there are two scan mechanisms
in the driver. I-Scan was aborted on suspend and bringing down
the device using brcmf_term_iscan(). The function has been
renamed to brcmf_abort_scanning() and covers e-scan abort as
well.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   44 ++++++++++----------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 8e5a01d..6536656 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2591,11 +2591,13 @@ update_bss_info_out:
 	return err;
 }
 
-static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_abort_scanning(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
+	struct escan_info *escan = &cfg_priv->escan_info;
 	struct brcmf_ssid ssid;
 
+	set_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
 	if (cfg_priv->iscan_on) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
 
@@ -2609,7 +2611,20 @@ static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 		/* Abort iscan running in FW */
 		memset(&ssid, 0, sizeof(ssid));
 		brcmf_run_iscan(iscan, &ssid, WL_SCAN_ACTION_ABORT);
+
+		if (cfg_priv->scan_request) {
+			/* Indidate scan abort to cfg80211 layer */
+			WL_INFO("Terminating scan in progress\n");
+			cfg80211_scan_done(cfg_priv->scan_request, true);
+			cfg_priv->scan_request = NULL;
+		}
+	}
+	if (cfg_priv->escan_on && cfg_priv->scan_request) {
+		escan->escan_state = WL_ESCAN_STATE_IDLE;
+		brcmf_notify_escan_complete(cfg_priv, escan->ndev, true, true);
 	}
+	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+	clear_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
 }
 
 static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
@@ -3034,18 +3049,10 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 		brcmf_delay(500);
 	}
 
-	set_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
 	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
-		brcmf_term_iscan(cfg_priv);
-
-	if (cfg_priv->scan_request) {
-		/* Indidate scan abort to cfg80211 layer */
-		WL_INFO("Terminating scan in progress\n");
-		cfg80211_scan_done(cfg_priv->scan_request, true);
-		cfg_priv->scan_request = NULL;
-	}
-	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
-	clear_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
+		brcmf_abort_scanning(cfg_priv);
+	else
+		clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
 
 	/* Turn off watchdog timer */
 	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
@@ -3952,7 +3959,7 @@ static void wl_deinit_priv(struct brcmf_cfg80211_priv *cfg_priv)
 	cfg_priv->dongle_up = false;	/* dongle down */
 	brcmf_flush_eq(cfg_priv);
 	brcmf_link_down(cfg_priv);
-	brcmf_term_iscan(cfg_priv);
+	brcmf_abort_scanning(cfg_priv);
 	brcmf_deinit_priv_mem(cfg_priv);
 }
 
@@ -4363,17 +4370,8 @@ static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv)
 		brcmf_delay(500);
 	}
 
-	set_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
-	brcmf_term_iscan(cfg_priv);
-	if (cfg_priv->scan_request) {
-		cfg80211_scan_done(cfg_priv->scan_request, true);
-		/* May need to perform this to cover rmmod */
-		/* wl_set_mpc(cfg_to_ndev(wl), 1); */
-		cfg_priv->scan_request = NULL;
-	}
+	brcmf_abort_scanning(cfg_priv);
 	clear_bit(WL_STATUS_READY, &cfg_priv->status);
-	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
-	clear_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
 
 	brcmf_debugfs_remove_netdev(cfg_priv);
 
-- 
1.7.9.5


