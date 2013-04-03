Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4456 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760345Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 18/25] brcmfmac: avoid error output on header only
 packet
Date: Wed, 3 Apr 2013 12:40:43 +0200
Message-ID: <1364985650-11719-19-git-send-email-arend@broadcom.com> (sfid-20130403_124306_971587_6F7E592B)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

During SDIO layer flow control signalling firmware can issue
invalid packets. Prevent printing of parsing errors in such case.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index e224bcb..59c77aa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -303,8 +303,8 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 
 	/* Pop BDC header used to convey priority for buses that don't */
 
-	if (pktbuf->len < BDC_HEADER_LEN) {
-		brcmf_err("rx data too short (%d < %d)\n",
+	if (pktbuf->len <= BDC_HEADER_LEN) {
+		brcmf_dbg(INFO, "rx data too short (%d <= %d)\n",
 			  pktbuf->len, BDC_HEADER_LEN);
 		return -EBADE;
 	}
-- 
1.7.10.4


