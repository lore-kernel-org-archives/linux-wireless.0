Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2966 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab2JVRgh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:37 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 04/14] brcmfmac: remove redundant function
 brcmf_c_mkiovar_bsscfg
Date: Mon, 22 Oct 2012 10:36:17 -0700
Message-ID: <1350927387-25608-5-git-send-email-frankyl@broadcom.com> (sfid-20121022_193642_214619_54825147)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

function brcmf_c_mkiovar_bsscfg became redundant with refactoring
of firmware interface layer.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 -
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   46 --------------------
 2 files changed, 0 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 1589c1b..faa81ef 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -709,8 +709,6 @@ extern const struct bcmevent_name bcmevent_names[];
 
 extern uint brcmf_c_mkiovar(char *name, char *data, uint datalen,
 			  char *buf, uint len);
-extern uint brcmf_c_mkiovar_bsscfg(char *name, char *data, uint datalen,
-				   char *buf, uint buflen, s32 bssidx);
 
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index a081e68..aa4f719 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -88,52 +88,6 @@ brcmf_c_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
 	return len;
 }
 
-uint
-brcmf_c_mkiovar_bsscfg(char *name, char *data, uint datalen,
-		       char *buf, uint buflen, s32 bssidx)
-{
-	const s8 *prefix = "bsscfg:";
-	s8 *p;
-	u32 prefixlen;
-	u32 namelen;
-	u32 iolen;
-	__le32 bssidx_le;
-
-	if (bssidx == 0)
-		return brcmf_c_mkiovar(name, data, datalen, buf, buflen);
-
-	prefixlen = (u32) strlen(prefix); /* lengh of bsscfg prefix */
-	namelen = (u32) strlen(name) + 1; /* lengh of iovar  name + null */
-	iolen = prefixlen + namelen + sizeof(bssidx_le) + datalen;
-
-	if ((u32)buflen < iolen) {
-		brcmf_dbg(ERROR, "buffer is too short\n");
-		return 0;
-	}
-
-	p = buf;
-
-	/* copy prefix, no null */
-	memcpy(p, prefix, prefixlen);
-	p += prefixlen;
-
-	/* copy iovar name including null */
-	memcpy(p, name, namelen);
-	p += namelen;
-
-	/* bss config index as first data */
-	bssidx_le = cpu_to_le32(bssidx);
-	memcpy(p, &bssidx_le, sizeof(bssidx_le));
-	p += sizeof(bssidx_le);
-
-	/* parameter buffer follows */
-	if (datalen)
-		memcpy(p, data, datalen);
-
-	return iolen;
-
-}
-
 bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 		      struct sk_buff *pkt, int prec)
 {
-- 
1.7.6


