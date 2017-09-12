Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:60774 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751251AbdILIsY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 04:48:24 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH for-4.14 1/2] brcmfmac: add length check in brcmf_cfg80211_escan_handler()
Date: Tue, 12 Sep 2017 10:47:53 +0200
Message-Id: <1505206074-28781-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170912_104830_790320_4DBD362B)
In-Reply-To: <1505206074-28781-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1505206074-28781-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon handling the firmware notification for scans the length was
checked properly and may result in corrupting kernel heap memory
due to buffer overruns. This fix addresses CVE-2017-0786.

Cc: stable@vger.kernel.org # v4.0.x
Cc: Kevin Cernekee <cernekee@chromium.org>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index aaed4ab..26a0de3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3162,6 +3162,7 @@ static void brcmf_escan_timeout(unsigned long data)
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	s32 status;
 	struct brcmf_escan_result_le *escan_result_le;
+	u32 escan_buflen;
 	struct brcmf_bss_info_le *bss_info_le;
 	struct brcmf_bss_info_le *bss = NULL;
 	u32 bi_length;
@@ -3181,11 +3182,23 @@ static void brcmf_escan_timeout(unsigned long data)
 
 	if (status == BRCMF_E_STATUS_PARTIAL) {
 		brcmf_dbg(SCAN, "ESCAN Partial result\n");
+		if (e->datalen < sizeof(*escan_result_le)) {
+			brcmf_err("invalid event data length\n");
+			goto exit;
+		}
 		escan_result_le = (struct brcmf_escan_result_le *) data;
 		if (!escan_result_le) {
 			brcmf_err("Invalid escan result (NULL pointer)\n");
 			goto exit;
 		}
+		escan_buflen = le32_to_cpu(escan_result_le->buflen);
+		if (escan_buflen > BRCMF_ESCAN_BUF_SIZE ||
+		    escan_buflen > e->datalen ||
+		    escan_buflen < sizeof(*escan_result_le)) {
+			brcmf_err("Invalid escan buffer length: %d\n",
+				  escan_buflen);
+			goto exit;
+		}
 		if (le16_to_cpu(escan_result_le->bss_count) != 1) {
 			brcmf_err("Invalid bss_count %d: ignoring\n",
 				  escan_result_le->bss_count);
@@ -3202,9 +3215,8 @@ static void brcmf_escan_timeout(unsigned long data)
 		}
 
 		bi_length = le32_to_cpu(bss_info_le->length);
-		if (bi_length != (le32_to_cpu(escan_result_le->buflen) -
-					WL_ESCAN_RESULTS_FIXED_SIZE)) {
-			brcmf_err("Invalid bss_info length %d: ignoring\n",
+		if (bi_length != escan_buflen -	WL_ESCAN_RESULTS_FIXED_SIZE) {
+			brcmf_err("Ignoring invalid bss_info length: %d\n",
 				  bi_length);
 			goto exit;
 		}
-- 
1.9.1
