Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:37008 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932664AbdA0MUe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 07:20:34 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 3/5] brcmfmac: fix handling firmware results for wowl netdetect
Date: Fri, 27 Jan 2017 12:09:29 +0000
Message-Id: <1485518971-28183-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170127_132222_765748_EDDED036)
In-Reply-To: <1485518971-28183-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1485518971-28183-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For wowl netdetect the event data changed for newer chips. This
was recently fixed for scheduled scan, but same change is needed
for wowl netdetect. Removing now pointles += operation from both
result handlers.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 302a78d..c81d78f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3330,7 +3330,6 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 		goto out_err;
 	}
 
-	data += sizeof(struct brcmf_pno_scanresults_le);
 	netinfo_start = brcmf_get_netinfo_array(pfn_result);
 
 	for (i = 0; i < result_count; i++) {
@@ -3478,8 +3477,7 @@ static s32 brcmf_config_wowl_pattern(struct brcmf_if *ifp, u8 cmd[4],
 		return -EINVAL;
 	}
 
-	data += sizeof(struct brcmf_pno_scanresults_le);
-	netinfo = (struct brcmf_pno_net_info_le *)data;
+	netinfo = brcmf_get_netinfo_array(pfn_result);
 	memcpy(cfg->wowl.nd->ssid.ssid, netinfo->SSID, netinfo->SSID_len);
 	cfg->wowl.nd->ssid.ssid_len = netinfo->SSID_len;
 	cfg->wowl.nd->n_channels = 1;
-- 
1.9.1
