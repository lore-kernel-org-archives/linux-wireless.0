Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4109 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2I0MSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:18:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/11] brcmfmac: use define instead of hardcoded values.
Date: Thu, 27 Sep 2012 14:17:49 +0200
Message-ID: <1348748277-21460-4-git-send-email-arend@broadcom.com> (sfid-20120927_141823_170220_A139CE76)
In-Reply-To: <1348748277-21460-1-git-send-email-arend@broadcom.com>
References: <1348748277-21460-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

brcmf_parse_tlvs was using hardcoded values.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index fad6d05..63dbb2a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -48,6 +48,8 @@
 #define BRCMF_PNO_SCAN_COMPLETE		1
 #define BRCMF_PNO_SCAN_INCOMPLETE	0
 
+#define TLV_HDR_LEN			2	/* header length */
+
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
@@ -2610,15 +2612,15 @@ static struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key)
 	totlen = buflen;
 
 	/* find tagged parameter */
-	while (totlen >= 2) {
+	while (totlen >= TLV_HDR_LEN) {
 		int len = elt->len;
 
 		/* validate remaining totlen */
-		if ((elt->id == key) && (totlen >= (len + 2)))
+		if ((elt->id == key) && (totlen >= (len + TLV_HDR_LEN)))
 			return elt;
 
-		elt = (struct brcmf_tlv *) ((u8 *) elt + (len + 2));
-		totlen -= (len + 2);
+		elt = (struct brcmf_tlv *) ((u8 *) elt + (len + TLV_HDR_LEN));
+		totlen -= (len + TLV_HDR_LEN);
 	}
 
 	return NULL;
-- 
1.7.9.5


