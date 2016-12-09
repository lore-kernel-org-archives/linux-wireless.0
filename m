Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:56362 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932989AbcLILeb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Dec 2016 06:34:31 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.10 2/2] brcmfmac: fix uninitialized field in scheduled scan ssid configuration
Date: Fri,  9 Dec 2016 11:34:14 +0000
Message-Id: <1481283254-17883-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161209_123448_039494_CAB56296)
In-Reply-To: <1481283254-17883-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1481283254-17883-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scheduled scan ssid configuration in firmware has a flags field that
was not initialized resulting in unexpected behaviour.

Fixes: e3bdb7cc0300 ("brcmfmac: fix handling ssids in .sched_scan_start() callback")
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index f273cab..9a25e79 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -137,6 +137,7 @@ static int brcmf_pno_add_ssid(struct brcmf_if *ifp, struct cfg80211_ssid *ssid,
 	pfn.wpa_auth = cpu_to_le32(BRCMF_PNO_WPA_AUTH_ANY);
 	pfn.wsec = cpu_to_le32(0);
 	pfn.infra = cpu_to_le32(1);
+	pfn.flags = 0;
 	if (active)
 		pfn.flags = cpu_to_le32(1 << BRCMF_PNO_HIDDEN_BIT);
 	pfn.ssid.SSID_len = cpu_to_le32(ssid->ssid_len);
--
1.9.1
