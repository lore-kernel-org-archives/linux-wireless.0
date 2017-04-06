Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46791 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753424AbdDFMPB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 08:15:01 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5/6] brcmfmac: remove bogus check in scheduled scan result handler
Date: Thu,  6 Apr 2017 13:14:41 +0100
Message-Id: <1491480882-13877-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170406_141514_084618_B59AF666)
In-Reply-To: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Checking whether the address of an array element is null is bogus
so removing it.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 760781f..b687533 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3344,12 +3344,6 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 
 	for (i = 0; i < result_count; i++) {
 		netinfo = &netinfo_start[i];
-		if (!netinfo) {
-			brcmf_err("Invalid netinfo ptr. index: %d\n",
-				  i);
-			err = -EINVAL;
-			goto out_err;
-		}
 
 		if (netinfo->SSID_len > IEEE80211_MAX_SSID_LEN)
 			netinfo->SSID_len = IEEE80211_MAX_SSID_LEN;
-- 
1.9.1
