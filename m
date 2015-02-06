Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:43354 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666AbbBFRhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 12:37:06 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/6] brcmfmac: Fix escan timer causing oops.
Date: Fri, 6 Feb 2015 18:36:47 +0100
Message-ID: <1423244207-9707-7-git-send-email-arend@broadcom.com> (sfid-20150206_183720_761510_DB6FF496)
In-Reply-To: <1423244207-9707-1-git-send-email-arend@broadcom.com>
References: <1423244207-9707-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

In some rare circumstances the escan protection timer can expire
before the setup completed (due to long timeouts on IOCTL). This
patch avoids this situation by setting the timer after the setup
completed correctly.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index bc86009..33245bb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -1050,10 +1050,6 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 	if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
 		vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
 
-	/* Arm scan timeout timer */
-	mod_timer(&cfg->escan_timeout, jiffies +
-			WL_ESCAN_TIMER_INTERVAL_MS * HZ / 1000);
-
 	escan_req = false;
 	if (request) {
 		/* scan bss */
@@ -1112,12 +1108,14 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 		}
 	}
 
+	/* Arm scan timeout timer */
+	mod_timer(&cfg->escan_timeout, jiffies +
+			WL_ESCAN_TIMER_INTERVAL_MS * HZ / 1000);
+
 	return 0;
 
 scan_out:
 	clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
-	if (timer_pending(&cfg->escan_timeout))
-		del_timer_sync(&cfg->escan_timeout);
 	cfg->scan_request = NULL;
 	return err;
 }
-- 
1.9.1

