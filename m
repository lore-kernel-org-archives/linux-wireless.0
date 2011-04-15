Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4107 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab1DOMki (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 08:40:38 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] staging: brcm80211: removed ASSERTs from util dir,
 part 1
Date: Fri, 15 Apr 2011 14:40:30 +0200
Message-ID: <1302871231-8739-2-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1302871231-8739-1-git-send-email-rvossen@broadcom.com>
References: <1302871231-8739-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/util/bcmotp.c   |   36 +++++++------------------
 drivers/staging/brcm80211/util/bcmsrom.c  |   40 +----------------------------
 drivers/staging/brcm80211/util/bcmutils.c |   26 +++----------------
 3 files changed, 15 insertions(+), 87 deletions(-)

diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/util/bcmotp.c
index d150c05..49464af 100644
--- a/drivers/staging/brcm80211/util/bcmotp.c
+++ b/drivers/staging/brcm80211/util/bcmotp.c
@@ -177,9 +177,6 @@ static u16 ipxotp_otpr(void *oh, chipcregs_t *cc, uint wn)
 
 	oi = (otpinfo_t *) oh;
 
-	ASSERT(wn < oi->wsize);
-	ASSERT(cc != NULL);
-
 	return R_REG(&cc->sromotp[wn]);
 }
 
@@ -229,7 +226,7 @@ static int ipxotp_max_rgnsz(si_t *sih, int osizew)
 		ret = osizew * 2 - OTP_SZ_FU_72 - OTP_SZ_CHECKSUM;
 		break;
 	default:
-		ASSERT(0);	/* Don't konw about this chip */
+		break;	/* Don't know about this chip */
 	}
 
 	return ret;
@@ -313,7 +310,6 @@ static void *ipxotp_init(si_t *sih)
 	otpinfo_t *oi;
 
 	/* Make sure we're running IPX OTP */
-	ASSERT(OTPTYPE_IPX(sih->ccrev));
 	if (!OTPTYPE_IPX(sih->ccrev))
 		return NULL;
 
@@ -360,7 +356,6 @@ static void *ipxotp_init(si_t *sih)
 	/* Retrieve OTP region info */
 	idx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	_ipxotp_init(oi, cc);
 
@@ -444,7 +439,6 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 
 	idx = ai_coreidx(oi->sih);
 	cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	/* Read the data */
 	for (i = 0; i < sz; i++)
@@ -565,14 +559,8 @@ static int hndotp_size(void *oh)
 
 static u16 hndotp_otpr(void *oh, chipcregs_t *cc, uint wn)
 {
-#ifdef BCMDBG
-	otpinfo_t *oi = (otpinfo_t *) oh;
-#endif
 	volatile u16 *ptr;
 
-	ASSERT(wn < ((oi->size / 2) + OTP_RC_LIM_OFF));
-	ASSERT(cc != NULL);
-
 	ptr = (volatile u16 *)((volatile char *)cc + CC_SROM_OTP);
 	return R_REG(&ptr[wn]);
 }
@@ -582,10 +570,6 @@ static u16 hndotp_otproff(void *oh, chipcregs_t *cc, int woff)
 	otpinfo_t *oi = (otpinfo_t *) oh;
 	volatile u16 *ptr;
 
-	ASSERT(woff >= (-((int)oi->size / 2)));
-	ASSERT(woff < OTP_LIM_OFF);
-	ASSERT(cc != NULL);
-
 	ptr = (volatile u16 *)((volatile char *)cc + CC_SROM_OTP);
 
 	return R_REG(&ptr[(oi->size / 2) + woff]);
@@ -640,11 +624,7 @@ static void *hndotp_init(si_t *sih)
 			goto out;
 		}
 
-		/* As of right now, support only 4320a2, 4311a1 and 4312 */
-		ASSERT((oi->ccrev == 12) || (oi->ccrev == 17)
-		       || (oi->ccrev == 22));
-		if (!
-		    ((oi->ccrev == 12) || (oi->ccrev == 17)
+		if (!((oi->ccrev == 12) || (oi->ccrev == 17)
 		     || (oi->ccrev == 22)))
 			return NULL;
 
@@ -700,8 +680,14 @@ static int hndotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 	chipcregs_t *cc;
 	int i;
 
-	/* Only support HW region (no active chips use HND OTP SW region) */
-	ASSERT(region == OTP_HW_REGION);
+
+	if (region != OTP_HW_REGION) {
+		/*
+		 * Only support HW region
+		 * (no active chips use HND OTP SW region)
+		 * */
+		return -ENOTSUPP;
+	}
 
 	/* Region empty? */
 	st = oi->hwprot | oi->signvalid;
@@ -713,7 +699,6 @@ static int hndotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 
 	idx = ai_coreidx(oi->sih);
 	cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	for (i = 0; i < (int)*wlen; i++)
 		data[i] = hndotp_otpr(oh, cc, i);
@@ -737,7 +722,6 @@ static int hndotp_nvread(void *oh, char *data, uint *len)
 	/* save the orig core */
 	idx = ai_coreidx(oi->sih);
 	cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	st = hndotp_status(oh);
 	if (!(st & (OTP_HW_REGION | OTP_SW_REGION))) {
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index bf058e4..61cee36 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -139,7 +139,6 @@ int srom_var_init(si_t *sih, uint bustype, void *curmap,
 
 	len = 0;
 
-	ASSERT(bustype == bustype);
 	if (vars == NULL || count == NULL)
 		return 0;
 
@@ -152,14 +151,13 @@ int srom_var_init(si_t *sih, uint bustype, void *curmap,
 		return initvars_srom_si(sih, curmap, vars, count);
 
 	case PCI_BUS:
-		ASSERT(curmap != NULL);
 		if (curmap == NULL)
 			return -1;
 
 		return initvars_srom_pci(sih, curmap, vars, count);
 
 	default:
-		ASSERT(0);
+		break;
 	}
 	return -1;
 }
@@ -276,8 +274,6 @@ static int otp_read_pci(si_t *sih, u16 *buf, uint bufsz)
 	uint sz = OTP_SZ_MAX / 2;	/* size in words */
 	int err = 0;
 
-	ASSERT(bufsz <= OTP_SZ_MAX);
-
 	otp = kzalloc(OTP_SZ_MAX, GFP_ATOMIC);
 	if (otp == NULL) {
 		return -EBADE;
@@ -322,7 +318,6 @@ static int initvars_table(char *start, char *end,
 	/* do it only when there is more than just the null string */
 	if (c > 1) {
 		char *vp = kmalloc(c, GFP_ATOMIC);
-		ASSERT(vp != NULL);
 		if (!vp)
 			return -ENOMEM;
 		memcpy(vp, start, c);
@@ -404,11 +399,7 @@ static int initvars_flash_si(si_t *sih, char **vars, uint *count)
 	char *vp, *base;
 	int err;
 
-	ASSERT(vars != NULL);
-	ASSERT(count != NULL);
-
 	base = vp = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
-	ASSERT(vp != NULL);
 	if (!vp)
 		return -ENOMEM;
 
@@ -434,7 +425,6 @@ static uint mask_shift(u16 mask)
 		if (mask & (1 << i))
 			return i;
 	}
-	ASSERT(mask);
 	return 0;
 }
 
@@ -445,19 +435,9 @@ static uint mask_width(u16 mask)
 		if (mask & (1 << i))
 			return (uint) (i - mask_shift(mask) + 1);
 	}
-	ASSERT(mask);
 	return 0;
 }
 
-#if defined(BCMDBG)
-static bool mask_valid(u16 mask)
-{
-	uint shift = mask_shift(mask);
-	uint width = mask_width(mask);
-	return mask == ((~0 << shift) & ~(~0 << (shift + width)));
-}
-#endif				/* BCMDBG */
-
 static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, varbuf_t *b)
 {
 	u16 w;
@@ -497,23 +477,15 @@ static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, varbuf_t *b)
 
 			varbuf_append(b, "%s=%pM", name, ea);
 		} else {
-			ASSERT(mask_valid(srv->mask));
-			ASSERT(mask_width(srv->mask));
-
 			w = srom[srv->off - off];
 			val = (w & srv->mask) >> mask_shift(srv->mask);
 			width = mask_width(srv->mask);
 
 			while (srv->flags & SRFL_MORE) {
 				srv++;
-				ASSERT(srv->name != NULL);
-
 				if (srv->off == 0 || srv->off < off)
 					continue;
 
-				ASSERT(mask_valid(srv->mask));
-				ASSERT(mask_width(srv->mask));
-
 				w = srom[srv->off - off];
 				val +=
 				    ((w & srv->mask) >> mask_shift(srv->
@@ -577,8 +549,6 @@ static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, varbuf_t *b)
 					continue;
 
 				w = srom[pb + srv->off - off];
-
-				ASSERT(mask_valid(srv->mask));
 				val = (w & srv->mask) >> mask_shift(srv->mask);
 				width = mask_width(srv->mask);
 
@@ -621,7 +591,6 @@ static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count)
 	 * from flash.
 	 */
 	srom = kmalloc(SROM_MAX, GFP_ATOMIC);
-	ASSERT(srom != NULL);
 	if (!srom)
 		return -2;
 
@@ -703,11 +672,7 @@ static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count)
 		goto errout;
 	}
 
-	ASSERT(vars != NULL);
-	ASSERT(count != NULL);
-
 	base = vp = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
-	ASSERT(vp != NULL);
 	if (!vp) {
 		err = -2;
 		goto errout;
@@ -727,12 +692,9 @@ static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count)
 	_initvars_srom_pci(sromrev, srom, 0, &b);
 
 	/* final nullbyte terminator */
-	ASSERT(b.size >= 1);
 	vp = b.buf;
 	*vp++ = '\0';
 
-	ASSERT((vp - base) <= MAXSZ_NVRAM_VARS);
-
  varsdone:
 	err = initvars_table(base, vp, vars, count);
 
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 1acdc0e..6958ff7 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -51,8 +51,6 @@ void BCMFASTPATH pkt_buf_free_skb(struct sk_buff *skb)
 	struct sk_buff *nskb;
 	int nest = 0;
 
-	ASSERT(skb);
-
 	/* perversion: we use skb->next to chain multi-skb packets */
 	while (skb) {
 		nskb = skb->next;
@@ -122,11 +120,8 @@ struct sk_buff *BCMFASTPATH pktq_penq(struct pktq *pq, int prec,
 {
 	struct pktq_prec *q;
 
-	ASSERT(prec >= 0 && prec < pq->num_prec);
-	ASSERT(p->prev == NULL);	/* queueing chains not allowed */
-
-	ASSERT(!pktq_full(pq));
-	ASSERT(!pktq_pfull(pq, prec));
+	if (pktq_full(pq) || pktq_pfull(pq, prec))
+		return NULL;
 
 	q = &pq->q[prec];
 
@@ -151,11 +146,8 @@ struct sk_buff *BCMFASTPATH pktq_penq_head(struct pktq *pq, int prec,
 {
 	struct pktq_prec *q;
 
-	ASSERT(prec >= 0 && prec < pq->num_prec);
-	ASSERT(p->prev == NULL);	/* queueing chains not allowed */
-
-	ASSERT(!pktq_full(pq));
-	ASSERT(!pktq_pfull(pq, prec));
+	if (pktq_full(pq) || pktq_pfull(pq, prec))
+		return NULL;
 
 	q = &pq->q[prec];
 
@@ -179,8 +171,6 @@ struct sk_buff *BCMFASTPATH pktq_pdeq(struct pktq *pq, int prec)
 	struct pktq_prec *q;
 	struct sk_buff *p;
 
-	ASSERT(prec >= 0 && prec < pq->num_prec);
-
 	q = &pq->q[prec];
 
 	p = q->head;
@@ -205,8 +195,6 @@ struct sk_buff *BCMFASTPATH pktq_pdeq_tail(struct pktq *pq, int prec)
 	struct pktq_prec *q;
 	struct sk_buff *p, *prev;
 
-	ASSERT(prec >= 0 && prec < pq->num_prec);
-
 	q = &pq->q[prec];
 
 	p = q->head;
@@ -245,7 +233,6 @@ void pktq_pflush(struct pktq *pq, int prec, bool dir)
 		pq->len--;
 		p = q->head;
 	}
-	ASSERT(q->len == 0);
 	q->tail = NULL;
 }
 
@@ -254,7 +241,6 @@ void pktq_flush(struct pktq *pq, bool dir)
 	int prec;
 	for (prec = 0; prec < pq->num_prec; prec++)
 		pktq_pflush(pq, prec, dir);
-	ASSERT(pq->len == 0);
 }
 #else /* !BRCM_FULLMAC */
 void
@@ -285,7 +271,6 @@ pktq_pflush(struct pktq *pq, int prec, bool dir,
 	}
 
 	if (q->head == NULL) {
-		ASSERT(q->len == 0);
 		q->tail = NULL;
 	}
 }
@@ -477,8 +462,6 @@ const bcm_iovar_t *bcm_iovar_lookup(const bcm_iovar_t *table, const char *name)
 	else
 		lookup_name = name;
 
-	ASSERT(table != NULL);
-
 	for (vi = table; vi->name; vi++) {
 		if (!strcmp(vi->name, lookup_name))
 			return vi;
@@ -526,7 +509,6 @@ int bcm_iovar_lencheck(const bcm_iovar_t *vi, void *arg, int len, bool set)
 
 	default:
 		/* unknown type for length check in iovar info */
-		ASSERT(0);
 		bcmerror = -ENOTSUPP;
 	}
 
-- 
1.7.1


