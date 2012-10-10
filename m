Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3430 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756948Ab2JJSNZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 14:13:25 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 6/7] brcmfmac: remove 'always false' condition from
 brcmf_c_mkiovar_bsscfg
Date: Wed, 10 Oct 2012 11:13:11 -0700
Message-ID: <1349892792-4792-7-git-send-email-frankyl@broadcom.com> (sfid-20121010_201335_714454_58362929)
In-Reply-To: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
References: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The parameter buflen is unsigned so the condition buflen < 0 is
always false. The patch fixes the if statement checking the buffer
length.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 15c5db5..a081e68 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -106,7 +106,7 @@ brcmf_c_mkiovar_bsscfg(char *name, char *data, uint datalen,
 	namelen = (u32) strlen(name) + 1; /* lengh of iovar  name + null */
 	iolen = prefixlen + namelen + sizeof(bssidx_le) + datalen;
 
-	if (buflen < 0 || iolen > (u32)buflen) {
+	if ((u32)buflen < iolen) {
 		brcmf_dbg(ERROR, "buffer is too short\n");
 		return 0;
 	}
-- 
1.7.9.5


