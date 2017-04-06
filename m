Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46774 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754726AbdDFMPA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 08:15:00 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/6] brcmfmac: add length checks in scheduled scan result handler
Date: Thu,  6 Apr 2017 13:14:40 +0100
Message-Id: <1491480882-13877-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170406_141505_890092_AAAD5B67)
In-Reply-To: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Assure the event data buffer is long enough to hold the array
of netinfo items and that SSID length does not exceed the maximum
of 32 characters as per 802.11 spec.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 89ac124..760781f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3300,6 +3300,7 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 	struct brcmf_pno_scanresults_le *pfn_result;
 	u32 result_count;
 	u32 status;
+	u32 datalen;
 
 	brcmf_dbg(SCAN, "Enter\n");
 
@@ -3326,6 +3327,14 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 		brcmf_err("FALSE PNO Event. (pfn_count == 0)\n");
 		goto out_err;
 	}
+
+	netinfo_start = brcmf_get_netinfo_array(pfn_result);
+	datalen = e->datalen - ((void *)netinfo_start - (void *)pfn_result);
+	if (datalen < result_count * sizeof(*netinfo)) {
+		brcmf_err("insufficient event data\n");
+		goto out_err;
+	}
+
 	request = brcmf_alloc_internal_escan_request(wiphy,
 						     result_count);
 	if (!request) {
@@ -3333,8 +3342,6 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 		goto out_err;
 	}
 
-	netinfo_start = brcmf_get_netinfo_array(pfn_result);
-
 	for (i = 0; i < result_count; i++) {
 		netinfo = &netinfo_start[i];
 		if (!netinfo) {
@@ -3344,6 +3351,8 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 			goto out_err;
 		}
 
+		if (netinfo->SSID_len > IEEE80211_MAX_SSID_LEN)
+			netinfo->SSID_len = IEEE80211_MAX_SSID_LEN;
 		brcmf_dbg(SCAN, "SSID:%.32s Channel:%d\n",
 			  netinfo->SSID, netinfo->channel);
 		err = brcmf_internal_escan_add_info(request,
-- 
1.9.1
