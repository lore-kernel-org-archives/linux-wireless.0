Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46792 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755303AbdDFMPB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 08:15:01 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 6/6] brcmfmac: only add channels and ssids once in scan request
Date: Thu,  6 Apr 2017 13:14:42 +0100
Message-Id: <1491480882-13877-7-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170406_141512_129529_702F3B49)
In-Reply-To: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When receiving pno results there may be duplicate channels and/or
ssids. Assure each is added only once when preparing the internal
escan request.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b687533..0a067e5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3216,7 +3216,7 @@ static int brcmf_internal_escan_add_info(struct cfg80211_scan_request *req,
 {
 	struct ieee80211_channel *chan;
 	enum nl80211_band band;
-	int freq;
+	int freq, i;
 
 	if (channel <= CH_MAX_2G_CHANNEL)
 		band = NL80211_BAND_2GHZ;
@@ -3231,10 +3231,22 @@ static int brcmf_internal_escan_add_info(struct cfg80211_scan_request *req,
 	if (!chan)
 		return -EINVAL;
 
-	req->channels[req->n_channels++] = chan;
-	memcpy(req->ssids[req->n_ssids].ssid, ssid, ssid_len);
-	req->ssids[req->n_ssids++].ssid_len = ssid_len;
+	for (i = 0; i < req->n_channels; i++) {
+		if (req->channels[i] == chan)
+			break;
+	}
+	if (i == req->n_channels)
+		req->channels[req->n_channels++] = chan;
 
+	for (i = 0; i < req->n_ssids; i++) {
+		if (req->ssids[i].ssid_len == ssid_len &&
+		    !memcmp(req->ssids[i].ssid, ssid, ssid_len))
+			break;
+	}
+	if (i == req->n_ssids) {
+		memcpy(req->ssids[req->n_ssids].ssid, ssid, ssid_len);
+		req->ssids[req->n_ssids++].ssid_len = ssid_len;
+	}
 	return 0;
 }
 
-- 
1.9.1
