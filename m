Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3754 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/19] brcm80211: util: move brcmu_pkttotlen() function
 to brcmfmac
Date: Thu, 10 Nov 2011 20:30:29 +0100
Message-ID: <1320953434-16859-16-git-send-email-arend@broadcom.com> (sfid-20111110_203127_703893_39BADFF2)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions brcmu_pkttotlen() is only used in brcmfmac driver
so it has been moved there. It also does not use the sk_buff
next pointer anymore but walks a skb queue to determine the total
length.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   14 +++++++++++++-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   13 -------------
 .../net/wireless/brcm80211/include/brcmu_utils.h   |    3 ---
 3 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a5d1c35..c406b46 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1107,6 +1107,18 @@ static uint brcmf_sdbrcm_glom_from_buf(struct brcmf_bus *bus, uint len)
 	return ret;
 }
 
+/* return total length of buffer chain */
+static uint brcmf_sdbrcm_glom_len(struct brcmf_bus *bus)
+{
+	struct sk_buff *p;
+	uint total;
+
+	total = 0;
+	skb_queue_walk(&bus->glom, p)
+		total += p->len;
+	return total;
+}
+
 static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 {
 	u16 dlen, totlen;
@@ -1218,7 +1230,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		}
 
 		pfirst = skb_peek(&bus->glom);
-		dlen = (u16) brcmu_pkttotlen(pfirst);
+		dlen = (u16) brcmf_sdbrcm_glom_len(bus);
 
 		/* Do an SDIO read for the superframe.  Configurable iovar to
 		 * read directly into the chained packet, or allocate a large
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 57e656f..3a92f72 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -66,19 +66,6 @@ void brcmu_pkt_buf_free_skb(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(brcmu_pkt_buf_free_skb);
 
-
-/* return total length of buffer chain */
-uint brcmu_pkttotlen(struct sk_buff *p)
-{
-	uint total;
-
-	total = 0;
-	for (; p; p = p->next)
-		total += p->len;
-	return total;
-}
-EXPORT_SYMBOL(brcmu_pkttotlen);
-
 /*
  * osl multiple-precedence packet queue
  * hi_prec is always >= the number of the highest non-empty precedence
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index cae4e51..ad249a0 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -170,9 +170,6 @@ extern void brcmu_pktq_flush(struct pktq *pq, bool dir,
 		bool (*fn)(struct sk_buff *, void *), void *arg);
 
 /* externs */
-/* packet */
-extern uint brcmu_pkttotlen(struct sk_buff *p);
-
 /* ip address */
 struct ipv4_addr;
 
-- 
1.7.5.4


