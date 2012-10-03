Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42820 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2JCGFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 02:05:38 -0400
Date: Wed, 3 Oct 2012 09:05:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Alwin Beukers <alwin@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: [patch 1/3] brcmfmac: cleanup casts in brcmf_c_mkiovar_bsscfg()
Message-ID: <20121003060515.GA3802@elgon.mountain> (sfid-20121003_080649_589382_FFFD069A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove some pointless casts from the return value of strlen().  The
"buflen" variable is already an unsigned int so it's never less than
zero and doesn't need to be casted to u32.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 15c5db5..ae0978c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -102,11 +102,11 @@ brcmf_c_mkiovar_bsscfg(char *name, char *data, uint datalen,
 	if (bssidx == 0)
 		return brcmf_c_mkiovar(name, data, datalen, buf, buflen);
 
-	prefixlen = (u32) strlen(prefix); /* lengh of bsscfg prefix */
-	namelen = (u32) strlen(name) + 1; /* lengh of iovar  name + null */
+	prefixlen = strlen(prefix); /* lengh of bsscfg prefix */
+	namelen = strlen(name) + 1; /* lengh of iovar name + null */
 	iolen = prefixlen + namelen + sizeof(bssidx_le) + datalen;
 
-	if (buflen < 0 || iolen > (u32)buflen) {
+	if (buflen < iolen) {
 		brcmf_dbg(ERROR, "buffer is too short\n");
 		return 0;
 	}
