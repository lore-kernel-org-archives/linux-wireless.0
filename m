Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35931 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751165AbdJLJyV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 05:54:21 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH] brcmfmac: add length check in brcmf_cfg80211_escan_handler()
Date: Thu, 12 Oct 2017 11:54:12 +0200
Message-Id: <1507802052-14654-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171012_115425_353404_277170EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 17df6453d4be17910456e99c5a85025aa1b7a246 upstream.

Upon handling the firmware notification for scans the length was
checked properly and may result in corrupting kernel heap memory
due to buffer overruns. This fix addresses CVE-2017-0786.

Cc: Kevin Cernekee <cernekee@chromium.org>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi, Greg

This backport for stable-4.4 has been compile tested on x86_64 on
linux-4.4.y branch in the stable repo. Apparently I only checked
that the patch applied on 4.4. Lesson learned.

Thanks,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index da5826d..22676a4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -2914,6 +2914,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	s32 status;
 	struct brcmf_escan_result_le *escan_result_le;
+	u32 escan_buflen;
 	struct brcmf_bss_info_le *bss_info_le;
 	struct brcmf_bss_info_le *bss = NULL;
 	u32 bi_length;
@@ -2930,11 +2931,23 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 
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
+		if (escan_buflen > WL_ESCAN_BUF_SIZE ||
+		    escan_buflen > e->datalen ||
+		    escan_buflen < sizeof(*escan_result_le)) {
+			brcmf_err("Invalid escan buffer length: %d\n",
+				  escan_buflen);
+			goto exit;
+		}
 		if (le16_to_cpu(escan_result_le->bss_count) != 1) {
 			brcmf_err("Invalid bss_count %d: ignoring\n",
 				  escan_result_le->bss_count);
@@ -2951,9 +2964,8 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
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
