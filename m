Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2280 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/15] brcm80211: fmac: changed two scan related
 structures
Date: Tue, 18 Oct 2011 14:03:03 +0200
Message-ID: <1318939391-19495-8-git-send-email-arend@broadcom.com> (sfid-20111018_140346_858670_A039C9B7)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

struct brcmf_scan_results contained a 1 element array, but in reality
the number of scan results can be 0 or more, as indicated by the
count field in the same struct. Array has be redefined to be 0 elements
length to indicate the array is purely for reference.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index cf7cc9a..54b055b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -466,14 +466,13 @@ struct brcmf_scan_results {
 	u32 buflen;
 	u32 version;
 	u32 count;
-	struct brcmf_bss_info_le bss_info_le[1];
+	struct brcmf_bss_info_le bss_info_le[];
 };
 
 struct brcmf_scan_results_le {
 	__le32 buflen;
 	__le32 version;
 	__le32 count;
-	struct brcmf_bss_info_le bss_info_le[1];
 };
 
 /* used for association with a specific BSSID and chanspec list */
@@ -493,10 +492,6 @@ struct brcmf_join_params {
 	struct brcmf_assoc_params_le params_le;
 };
 
-/* size of brcmf_scan_results not including variable length array */
-#define BRCMF_SCAN_RESULTS_FIXED_SIZE \
-	(sizeof(struct brcmf_scan_results) - sizeof(struct brcmf_bss_info_le))
-
 /* incremental scan results struct */
 struct brcmf_iscan_results {
 	union {
@@ -511,7 +506,7 @@ struct brcmf_iscan_results {
 
 /* size of brcmf_iscan_results not including variable length array */
 #define BRCMF_ISCAN_RESULTS_FIXED_SIZE \
-	(BRCMF_SCAN_RESULTS_FIXED_SIZE + \
+	(sizeof(struct brcmf_scan_results) + \
 	 offsetof(struct brcmf_iscan_results, results))
 
 struct brcmf_wsec_key {
-- 
1.7.4.1


