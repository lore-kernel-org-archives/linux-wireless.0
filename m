Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4273 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413Ab1GNVaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:30:02 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 19/35] staging: brcm80211: remove duplicated code from
 brcmf_init_iscan
Date: Thu, 14 Jul 2011 14:29:15 -0700
Message-ID: <1310678971-28952-20-git-send-email-frankyl@broadcom.com> (sfid-20110714_233100_676312_D2B717ED)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Part of the code in brcmf_init_scan was identical to the code in
brcmf_invoke_iscan and has been replaced by a call to it.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index e9ccf06..a69fa93 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3343,7 +3343,6 @@ static void brcmf_iscan_timer(unsigned long data)
 static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
-	int err = 0;
 
 	if (cfg_priv->iscan_on && !iscan->tsk) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
@@ -3356,7 +3355,7 @@ static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 		}
 	}
 
-	return err;
+	return 0;
 }
 
 static void brcmf_init_iscan_eloop(struct brcmf_cfg80211_iscan_eloop *el)
@@ -3376,20 +3375,14 @@ static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 
 	if (cfg_priv->iscan_on) {
 		iscan->dev = cfg_to_ndev(cfg_priv);
-		iscan->state = WL_ISCAN_STATE_IDLE;
 		brcmf_init_iscan_eloop(&iscan->el);
 		iscan->timer_ms = WL_ISCAN_TIMER_INTERVAL_MS;
 		init_timer(&iscan->timer);
 		iscan->timer.data = (unsigned long) iscan;
 		iscan->timer.function = brcmf_iscan_timer;
-		sema_init(&iscan->sync, 0);
-		iscan->tsk = kthread_run(brcmf_iscan_thread, iscan, "wl_iscan");
-		if (IS_ERR(iscan->tsk)) {
-			WL_ERR("Could not create iscan thread\n");
-			iscan->tsk = NULL;
-			return -ENOMEM;
-		}
-		iscan->data = cfg_priv;
+		err = brcmf_invoke_iscan(cfg_priv);
+		if (!err)
+			iscan->data = cfg_priv;
 	}
 
 	return err;
-- 
1.7.1


