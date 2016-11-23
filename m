Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:52759 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934324AbcKWK1E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 05:27:04 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 10/12] brcmfmac: remove restriction from .sched_scan_start() callback
Date: Wed, 23 Nov 2016 10:25:29 +0000
Message-Id: <1479896731-5091-11-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161123_112732_000912_334253D6)
In-Reply-To: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the .sched_scan_start() callback a condition was checked whether a
normal scan was ongoing. However, there is no need for this check as
it is ok to start the scheduled scan irrespective whether or not a
normal scan is ongoing.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 6ca954e..ad526e1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3351,10 +3351,7 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 
 	brcmf_dbg(SCAN, "Enter n_match_sets:%d n_ssids:%d\n",
 		  req->n_match_sets, req->n_ssids);
-	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
-		return -EAGAIN;
-	}
+
 	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
 		brcmf_err("Scanning suppressed: status (%lu)\n",
 			  cfg->scan_status);
-- 
1.9.1
