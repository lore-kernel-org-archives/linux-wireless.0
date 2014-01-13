Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:23732 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaAMVUg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 16:20:36 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 7/8] brcmfmac: initialize escan function pointer during scheduled scan
Date: Mon, 13 Jan 2014 22:20:28 +0100
Message-ID: <1389648029-23560-8-git-send-email-arend@broadcom.com> (sfid-20140113_222041_162520_C3399F64)
In-Reply-To: <1389648029-23560-1-git-send-email-arend@broadcom.com>
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For scheduled scan results the driver does a escan to obtain BSS
details from the firmware. However, the escan uses a dynamically
determined function. This needs to be set appropriately when handling
scheduled scan results to avoid NULL pointer access.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index aad83ae..d7718a5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2989,6 +2989,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 		}
 
 		set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
+		cfg->escan_info.run = brcmf_run_escan;
 		err = brcmf_do_escan(cfg, wiphy, ifp, request);
 		if (err) {
 			clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
-- 
1.7.10.4

