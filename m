Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2081 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757975Ab1F2Xss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 048/119] staging: brcm80211: removed BDC defines
Date: Wed, 29 Jun 2011 16:47:12 -0700
Message-ID: <1309391303-22741-49-git-send-email-frankyl@broadcom.com> (sfid-20110630_015029_780207_38CC5D98)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. BDC (Broadcom Device Class) protocol extension is used on top
of the USB related CDC (Communication Device Class) definition. BDC is always
used, so the #ifdefs were redundant.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile    |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c   |   10 ----------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    3 ---
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h |   13 -------------
 4 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 4963155..9fa689b 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -20,7 +20,6 @@ ccflags-y :=			\
 	-DBCMLXSDMMC		\
 	-DBCMPLATFORM_BUS	\
 	-DBCMSDIO		\
-	-DBDC			\
 	-DBRCM_FULLMAC		\
 	-DDHD_FIRSTREAD=64	\
 	-DDHD_SCHED		\
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index b229e05..156abd6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -376,13 +376,10 @@ void dhd_prot_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
 
 void dhd_prot_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
 {
-#ifdef BDC
 	struct bdc_header *h;
-#endif				/* BDC */
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-#ifdef BDC
 	/* Push BDC header used to convey priority for buses that don't */
 
 	skb_push(pktbuf, BDC_HEADER_LEN);
@@ -396,19 +393,15 @@ void dhd_prot_hdrpush(dhd_pub_t *dhd, int ifidx, struct sk_buff *pktbuf)
 	h->priority = (pktbuf->priority & BDC_PRIORITY_MASK);
 	h->flags2 = 0;
 	h->rssi = 0;
-#endif				/* BDC */
 	BDC_SET_IF_IDX(h, ifidx);
 }
 
 int dhd_prot_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 {
-#ifdef BDC
 	struct bdc_header *h;
-#endif
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-#ifdef BDC
 	/* Pop BDC header used to convey priority for buses that don't */
 
 	if (pktbuf->len < BDC_HEADER_LEN) {
@@ -443,7 +436,6 @@ int dhd_prot_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 	pktbuf->priority = h->priority & BDC_PRIORITY_MASK;
 
 	skb_pull(pktbuf, BDC_HEADER_LEN);
-#endif				/* BDC */
 
 	return 0;
 }
@@ -465,9 +457,7 @@ int dhd_prot_attach(dhd_pub_t *dhd)
 	}
 
 	dhd->prot = cdc;
-#ifdef BDC
 	dhd->hdrlen += BDC_HEADER_LEN;
-#endif
 	dhd->maxctl = BRCMF_C_IOCTL_MAXLEN +
 				sizeof(struct cdc_ioctl) + ROUND_UP_MARGIN;
 	return 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index f326071..f90a0be 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -368,9 +368,6 @@ static void dhd_dpc(unsigned long data);
 extern int dhd_wait_pend8021x(struct net_device *dev);
 
 #ifdef TOE
-#ifndef BDC
-#error TOE requires BDC
-#endif				/* !BDC */
 static int dhd_toe_get(dhd_info_t *dhd, int idx, u32 *toe_ol);
 static int dhd_toe_set(dhd_info_t *dhd, int idx, u32 toe_ol);
 #endif				/* TOE */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index fccd3dd..b2ab3ea 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -76,17 +76,4 @@ extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
 			    uint len);
 #endif		/* defined(CONFIG_HAS_EARLYSUSPEND) */
 
-/********************************
- * For version-string expansion *
- */
-#if defined(BDC)
-#define DHD_PROTOCOL "bdc"
-#elif defined(CDC)
-#define DHD_PROTOCOL "cdc"
-#elif defined(RNDIS)
-#define DHD_PROTOCOL "rndis"
-#else
-#define DHD_PROTOCOL "unknown"
-#endif				/* proto */
-
 #endif				/* _dhd_proto_h_ */
-- 
1.7.1


