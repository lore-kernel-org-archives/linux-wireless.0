Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2840 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551Ab1JRMDe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/15] brcm80211: util: move brcmu_pktfrombuf() function
 to brcmfmac
Date: Tue, 18 Oct 2011 14:03:09 +0200
Message-ID: <1318939391-19495-14-git-send-email-arend@broadcom.com> (sfid-20111018_140342_271552_A30F143E)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmu_pktfrombuf was only used in the brcmfmac source
and has been moved there. It has been refactored to match its use.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   25 ++++++++++++++-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   31 +-------------------
 .../net/wireless/brcm80211/include/brcmu_utils.h   |    2 -
 3 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 313b8bf..5ca7ae2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1222,6 +1222,28 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 		bus->drvr->busstate = BRCMF_BUS_DOWN;
 }
 
+/* copy a buffer into a pkt buffer chain */
+static uint brcmf_sdbrcm_glom_from_buf(struct brcmf_bus *bus, uint len)
+{
+	uint n, ret = 0;
+	struct sk_buff *p;
+	u8 *buf;
+
+	p = bus->glom;
+	buf = bus->dataptr;
+
+	/* copy the data */
+	for (; p && len; p = p->next) {
+		n = min_t(uint, p->len, len);
+		memcpy(p->data, buf, n);
+		buf += n;
+		len -= n;
+		ret += n;
+	}
+
+	return ret;
+}
+
 static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 {
 	u16 dlen, totlen;
@@ -1354,8 +1376,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 					SDIO_FUNC_2,
 					F2SYNC, bus->dataptr, dlen,
 					NULL);
-			sublen = (u16) brcmu_pktfrombuf(pfirst, 0, dlen,
-						bus->dataptr);
+			sublen = (u16) brcmf_sdbrcm_glom_from_buf(bus, dlen);
 			if (sublen != dlen) {
 				brcmf_dbg(ERROR, "FAILED TO COPY, dlen %d sublen %d\n",
 					  dlen, sublen);
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index f27c489..11cfbde 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -16,6 +16,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/module.h>
+
 #include <brcmu_utils.h>
 
 MODULE_AUTHOR("Broadcom Corporation");
@@ -66,36 +67,6 @@ void brcmu_pkt_buf_free_skb(struct sk_buff *skb)
 EXPORT_SYMBOL(brcmu_pkt_buf_free_skb);
 
 
-/* copy a buffer into a pkt buffer chain */
-uint brcmu_pktfrombuf(struct sk_buff *p, uint offset, int len,
-		unsigned char *buf)
-{
-	uint n, ret = 0;
-
-	/* skip 'offset' bytes */
-	for (; p && offset; p = p->next) {
-		if (offset < (uint) (p->len))
-			break;
-		offset -= p->len;
-	}
-
-	if (!p)
-		return 0;
-
-	/* copy the data */
-	for (; p && len; p = p->next) {
-		n = min((uint) (p->len) - offset, (uint) len);
-		memcpy(p->data + offset, buf, n);
-		buf += n;
-		len -= n;
-		ret += n;
-		offset = 0;
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL(brcmu_pktfrombuf);
-
 /* return total length of buffer chain */
 uint brcmu_pkttotlen(struct sk_buff *p)
 {
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index 7d0f46e..e5eac87 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -173,8 +173,6 @@ extern void brcmu_pktq_flush(struct pktq *pq, bool dir,
 
 /* externs */
 /* packet */
-extern uint brcmu_pktfrombuf(struct sk_buff *p,
-	uint offset, int len, unsigned char *buf);
 extern uint brcmu_pkttotlen(struct sk_buff *p);
 
 /* ip address */
-- 
1.7.4.1


