Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4269 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab1GNV34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:56 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 28/35] staging: brcm80211: brcmfmac: Fixed issues with
 iscan
Date: Thu, 14 Jul 2011 14:29:24 -0700
Message-ID: <1310678971-28952-29-git-send-email-frankyl@broadcom.com> (sfid-20110714_233135_630002_3C8F4B25)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

Disabling the interface doesn't terminate undergoing
iscan in FW. When the interface is enabled immediately,
first scan request is returning the stale scan results,
which are populated during the earlier iscan. These stale
scan results are causing random failures with chromium
auto test cases.

With this patch, iscan will be terminated in FW whenever
iscan thread is terminated by the host driver.

Signed-off-by: Sukesh Srikakula <sukeshs@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 8423aad..cf57087 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -709,10 +709,14 @@ static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 	}
 	brcmf_set_mpc(ndev, 0);
 	cfg_priv->iscan_kickstart = true;
-	brcmf_run_iscan(iscan, &ssid, BRCMF_SCAN_ACTION_START);
+	err = brcmf_run_iscan(iscan, &ssid, BRCMF_SCAN_ACTION_START);
+	if (err) {
+		brcmf_set_mpc(ndev, 1);
+		cfg_priv->iscan_kickstart = false;
+		return err;
+	}
 	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
 	iscan->timer_on = 1;
-
 	return err;
 }
 
@@ -3165,12 +3169,17 @@ static void brcmf_destroy_event_handler(struct brcmf_cfg80211_priv *cfg_priv)
 static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
+	struct brcmf_ssid ssid;
 
 	if (cfg_priv->iscan_on && iscan->tsk) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
 		send_sig(SIGTERM, iscan->tsk, 1);
 		kthread_stop(iscan->tsk);
 		iscan->tsk = NULL;
+
+		/* Abort iscan running in FW */
+		memset(&ssid, 0, sizeof(ssid));
+		brcmf_run_iscan(iscan, &ssid, WL_SCAN_ACTION_ABORT);
 	}
 }
 
@@ -3237,6 +3246,7 @@ brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
 	WL_SCAN("results->count = %d\n", results->count);
 	WL_SCAN("results->buflen = %d\n", results->buflen);
 	*status = le32_to_cpu(list_buf->status);
+	WL_SCAN("status = %d\n", *status);
 	*bss_list = results;
 
 	return err;
-- 
1.7.1


