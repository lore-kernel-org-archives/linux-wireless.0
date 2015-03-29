Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:60867 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbbC2BIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 21:08:19 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
	Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	mail@beyermatthias.de, m.v.b@runbox.com
Subject: [PATCH v5 02/15] staging: rtl8723au: Fix "before/around/after" whitespace issues
Date: Sat, 28 Mar 2015 21:07:45 -0400
Message-Id: <1427591278-982-3-git-send-email-m.v.b@runbox.com> (sfid-20150329_031217_950409_4BEF76AE)
In-Reply-To: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
References: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct a number of "space(s) required before/around/after" checkpatch.pl
issues in a number of functions in rtl8723au's rtw_security.c.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>

---

v5: Correct even more whitespace issues.

v2: Correct one more whitespace issue ("length-4") in
    rtw_tkip_decrypt23a.
---
 drivers/staging/rtl8723au/core/rtw_security.c | 219 +++++++++++++-------------
 1 file changed, 113 insertions(+), 106 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 92882f60bc0e..572fcf3f936d 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -129,14 +129,14 @@ static void crc32_init(void)
 static u32 getcrc32(u8 *buf, int len)
 {
 	u8 *p;
-	u32  crc;
+	u32 crc;
 
 	if (bcrc32initialized == 0) crc32_init();
 
 	crc = 0xffffffff;       /* preload shift register, per CRC-32 spec */
 
 	for (p = buf; len > 0; ++p, --len)
-		crc = crc32_table[ (crc ^ *p) & 0xff] ^ (crc >> 8);
+		crc = crc32_table[(crc ^ *p) & 0xff] ^ (crc >> 8);
 
 	return ~crc;    /* transmit complement, per CRC-32 spec */
 }
@@ -182,7 +182,7 @@ void rtw_wep_encrypt23a(struct rtw_adapter *padapter,
 		if ((curfragnum + 1) == pattrib->nr_frags) {
 			/* the last fragment */
 			length = pattrib->last_txcmdsz - pattrib->hdrlen -
-				pattrib->iv_len- pattrib->icv_len;
+				pattrib->iv_len - pattrib->icv_len;
 
 			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
 
@@ -262,8 +262,8 @@ static u32 secmicgetuint32(u8 *p)
 	s32 i;
 	u32 res = 0;
 
-	for (i = 0; i<4; i++) {
-		res |= ((u32)(*p++)) << (8*i);
+	for (i = 0; i < 4; i++) {
+		res |= ((u32)(*p++)) << (8 * i);
 	}
 
 	return res;
@@ -274,7 +274,7 @@ static void secmicputuint32(u8 *p, u32 val)
 {
 	long i;
 
-	for (i = 0; i<4; i++) {
+	for (i = 0; i < 4; i++) {
 		*p++ = (u8) (val & 0xff);
 		val >>= 8;
 	}
@@ -307,7 +307,7 @@ void rtw_secmicappend23abyte23a(struct mic_data *pmicdata, u8 b)
 {
 
 	/*  Append the byte to our word-sized buffer */
-	pmicdata->M |= ((unsigned long)b) << (8*pmicdata->nBytesInM);
+	pmicdata->M |= ((unsigned long)b) << (8 * pmicdata->nBytesInM);
 	pmicdata->nBytesInM++;
 	/*  Process the word if it is full. */
 	if (pmicdata->nBytesInM >= 4) {
@@ -331,7 +331,7 @@ void rtw_secmicappend23a(struct mic_data *pmicdata, u8 *src, u32 nbytes)
 {
 
 	/*  This is simple */
-	while(nbytes > 0) {
+	while (nbytes > 0) {
 		rtw_secmicappend23abyte23a(pmicdata, *src++);
 		nbytes--;
 	}
@@ -348,12 +348,12 @@ void rtw_secgetmic23a(struct mic_data *pmicdata, u8 *dst)
 	rtw_secmicappend23abyte23a(pmicdata, 0);
 	rtw_secmicappend23abyte23a(pmicdata, 0);
 	/*  and then zeroes until the length is a multiple of 4 */
-	while(pmicdata->nBytesInM != 0) {
+	while (pmicdata->nBytesInM != 0) {
 		rtw_secmicappend23abyte23a(pmicdata, 0);
 	}
 	/*  The appendByte function has already computed the result. */
 	secmicputuint32(dst, pmicdata->L);
-	secmicputuint32(dst+4, pmicdata->R);
+	secmicputuint32(dst + 4, pmicdata->R);
 	/*  Reset to the empty message. */
 	secmicclear(pmicdata);
 
@@ -364,10 +364,10 @@ void rtw_seccalctkipmic23a(u8 *key, u8 *header, u8 *data, u32 data_len,
 {
 
 	struct mic_data micdata;
-	u8 priority[4]={0x0, 0x0, 0x0, 0x0};
+	u8 priority[4] = {0x0, 0x0, 0x0, 0x0};
 
 	rtw_secmicsetkey23a(&micdata, key);
-	priority[0]= pri;
+	priority[0] = pri;
 
 	/* Michael MIC pseudo header: DA, SA, 3 x 0, Priority */
 	if (header[1]&1) {   /* ToDS == 1 */
@@ -398,11 +398,11 @@ void rtw_seccalctkipmic23a(u8 *key, u8 *header, u8 *data, u32 data_len,
 #define   Lo8(v16)   ((u8)((v16)       & 0x00FF))
 #define   Hi8(v16)   ((u8)(((v16) >> 8) & 0x00FF))
 #define  Lo16(v32)   ((u16)((v32)       & 0xFFFF))
-#define  Hi16(v32)   ((u16)(((v32) >>16) & 0xFFFF))
+#define  Hi16(v32)   ((u16)(((v32) >> 16) & 0xFFFF))
 #define  Mk16(hi, lo) ((lo) ^ (((u16)(hi)) << 8))
 
 /* select the Nth 16-bit word of the temporal key unsigned char array TK[]   */
-#define  TK16(N)     Mk16(tk[2*(N)+1], tk[2*(N)])
+#define  TK16(N)     Mk16(tk[2 * (N) + 1], tk[2 * (N)])
 
 /* S-box lookup: 16 bits --> 16 bits */
 #define _S_(v16)     (Sbox1[0][Lo8(v16)] ^ Sbox1[1][Hi8(v16)])
@@ -415,7 +415,7 @@ void rtw_seccalctkipmic23a(u8 *key, u8 *header, u8 *data, u32 data_len,
 #define RC4_KEY_SIZE     16    /* 128-bit RC4KEY (104 bits unknown) */
 
 /* 2-unsigned char by 2-unsigned char subset of the full AES S-box table */
-static const unsigned short Sbox1[2][256]=       /* Sbox for hash (can be in ROM)     */
+static const unsigned short Sbox1[2][256] =       /* Sbox for hash (can be in ROM)     */
 { {
    0xC6A5, 0xF884, 0xEE99, 0xF68D, 0xFF0D, 0xD6BD, 0xDEB1, 0x9154,
    0x6050, 0x0203, 0xCEA9, 0x567D, 0xE719, 0xB562, 0x4DE6, 0xEC9A,
@@ -517,13 +517,13 @@ static void phase1(u16 *p1k, const u8 *tk, const u8 *ta, u32 iv32)
 
 	/* Now compute an unbalanced Feistel cipher with 80-bit block */
 	/* size on the 80-bit block P1K[], using the 128-bit key TK[] */
-	for (i = 0; i < PHASE1_LOOP_CNT ;i++) {
+	for (i = 0; i < PHASE1_LOOP_CNT; i++) {
 		/* Each add operation here is mod 2**16 */
-		p1k[0] += _S_(p1k[4] ^ TK16((i&1)+0));
-		p1k[1] += _S_(p1k[0] ^ TK16((i&1)+2));
-		p1k[2] += _S_(p1k[1] ^ TK16((i&1)+4));
-		p1k[3] += _S_(p1k[2] ^ TK16((i&1)+6));
-		p1k[4] += _S_(p1k[3] ^ TK16((i&1)+0));
+		p1k[0] += _S_(p1k[4] ^ TK16((i & 1) + 0));
+		p1k[1] += _S_(p1k[0] ^ TK16((i & 1) + 2));
+		p1k[2] += _S_(p1k[1] ^ TK16((i & 1) + 4));
+		p1k[3] += _S_(p1k[2] ^ TK16((i & 1) + 6));
+		p1k[4] += _S_(p1k[3] ^ TK16((i & 1) + 0));
 		p1k[4] +=  (unsigned short)i;                    /* avoid "slide attacks" */
 		}
 
@@ -558,8 +558,8 @@ static void phase2(u8 *rc4key, const u8 *tk, const u16 *p1k, u16 iv16)
 	u16 PPK[6];                          /* temporary key for mixing    */
 
 	/* Note: all adds in the PPK[] equations below are mod 2**16         */
-	for (i = 0;i<5;i++) PPK[i]= p1k[i];      /* first, copy P1K to PPK      */
-		PPK[5]  =  p1k[4] +iv16;             /* next,  add in IV16          */
+	for (i = 0; i < 5; i++) PPK[i] = p1k[i];    /* first, copy P1K to PPK      */
+		PPK[5] = p1k[4] + iv16;             /* next,  add in IV16          */
 
 	/* Bijective non-linear mixing of the 96 bits of PPK[0..5]           */
 	PPK[0] +=    _S_(PPK[5] ^ TK16(0));   /* Mix key in each "round"     */
@@ -588,9 +588,9 @@ static void phase2(u8 *rc4key, const u8 *tk, const u16 *p1k, u16 iv16)
 	rc4key[3] = Lo8((PPK[5] ^ TK16(0)) >> 1);
 
 	/* Copy 96 bits of PPK[0..5] to RC4KEY[4..15]  (little-endian)       */
-	for (i = 0;i<6;i++) {
-		rc4key[4+2*i] = Lo8(PPK[i]);
-		rc4key[5+2*i] = Hi8(PPK[i]);
+	for (i = 0; i < 6; i++) {
+		rc4key[4 + 2 * i] = Lo8(PPK[i]);
+		rc4key[5 + 2 * i] = Hi8(PPK[i]);
 	}
 
 }
@@ -632,9 +632,9 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 						     &pattrib->ra[0]);
 		}
 
-		if (stainfo!= NULL) {
+		if (stainfo != NULL) {
 
-			if (!(stainfo->state &_FW_LINKED)) {
+			if (!(stainfo->state & _FW_LINKED)) {
 				DBG_8723A("%s, psta->state(0x%x) != _FW_LINKED\n", __func__, stainfo->state);
 				return _FAIL;
 			}
@@ -649,21 +649,25 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 
 			prwskeylen = 16;
 
-			for (curfragnum = 0;curfragnum<pattrib->nr_frags;curfragnum++) {
-				iv = pframe+pattrib->hdrlen;
-				payload = pframe+pattrib->iv_len+pattrib->hdrlen;
+			for (curfragnum = 0; curfragnum < pattrib->nr_frags; curfragnum++) {
+				iv = pframe + pattrib->hdrlen;
+				payload = pframe + pattrib->iv_len + pattrib->hdrlen;
 
 				GET_TKIP_PN(iv, dot11txpn);
 
 				pnl = (u16)(dot11txpn.val);
 				pnh = (u32)(dot11txpn.val>>16);
 
-				phase1((u16 *)&ttkey[0], prwskey,&pattrib->ta[0], pnh);
+				phase1((u16 *)&ttkey[0], prwskey, &pattrib->ta[0], pnh);
 
 				phase2(&rc4key[0], prwskey, (u16 *)&ttkey[0], pnl);
 
-				if ((curfragnum+1) == pattrib->nr_frags) {	/* 4 the last fragment */
-					length = pattrib->last_txcmdsz-pattrib->hdrlen-pattrib->iv_len- pattrib->icv_len;
+				if ((curfragnum + 1) == pattrib->nr_frags) {	/* 4 the last fragment */
+					length = (pattrib->last_txcmdsz -
+						  pattrib->hdrlen -
+						  pattrib->iv_len -
+						  pattrib->icv_len);
+
 					RT_TRACE(_module_rtl871x_security_c_, _drv_info_,
 						 "pattrib->iv_len =%x, pattrib->icv_len =%x\n",
 						 pattrib->iv_len,
@@ -672,23 +676,27 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 
 					arcfour_init(&mycontext, rc4key, 16);
 					arcfour_encrypt(&mycontext, payload, payload, length);
-					arcfour_encrypt(&mycontext, payload+length, crc, 4);
+					arcfour_encrypt(&mycontext, payload + length, crc, 4);
 
 				}
-				else{
-					length = pxmitpriv->frag_len-pattrib->hdrlen-pattrib->iv_len-pattrib->icv_len ;
+				else {
+					length = (pxmitpriv->frag_len -
+						  pattrib->hdrlen -
+						  pattrib->iv_len -
+						  pattrib->icv_len);
+
 					*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));/* modified by Amy*/
 					arcfour_init(&mycontext, rc4key, 16);
 					arcfour_encrypt(&mycontext, payload, payload, length);
-					arcfour_encrypt(&mycontext, payload+length, crc, 4);
+					arcfour_encrypt(&mycontext, payload + length, crc, 4);
 
-				pframe+= pxmitpriv->frag_len;
-				pframe = PTR_ALIGN(pframe, 4);
+				pframe += pxmitpriv->frag_len;
+				pframe  = PTR_ALIGN(pframe, 4);
 				}
 			}
 
 		}
-		else{
+		else {
 			RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
 				 "rtw_tkip_encrypt23a: stainfo == NULL!!!\n");
 			DBG_8723A("%s, psta == NUL\n", __func__);
@@ -727,7 +735,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 
 		stainfo = rtw_get_stainfo23a(&padapter->stapriv,
 					     &prxattrib->ta[0]);
-		if (stainfo!= NULL) {
+		if (stainfo != NULL) {
 
 			if (is_multicast_ether_addr(prxattrib->ra)) {
 				if (psecuritypriv->binstallGrpkey == 0) {
@@ -744,32 +752,32 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 				prwskeylen = 16;
 			}
 
-			iv = pframe+prxattrib->hdrlen;
-			payload = pframe+prxattrib->iv_len+prxattrib->hdrlen;
-			length = skb->len - prxattrib->hdrlen-prxattrib->iv_len;
+			iv = pframe + prxattrib->hdrlen;
+			payload = pframe + prxattrib->iv_len + prxattrib->hdrlen;
+			length = skb->len - prxattrib->hdrlen - prxattrib->iv_len;
 
 			GET_TKIP_PN(iv, dot11txpn);
 
 			pnl = (u16)(dot11txpn.val);
 			pnh = (u32)(dot11txpn.val>>16);
 
-			phase1((u16 *)&ttkey[0], prwskey,&prxattrib->ta[0], pnh);
+			phase1((u16 *)&ttkey[0], prwskey, &prxattrib->ta[0], pnh);
 			phase2(&rc4key[0], prwskey, (unsigned short *)&ttkey[0], pnl);
 
 			/* 4 decrypt payload include icv */
 			arcfour_init(&mycontext, rc4key, 16);
 			arcfour_encrypt(&mycontext, payload, payload, length);
 
-			*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length-4));
+			*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length - 4));
 
-			if (crc[3]!= payload[length-1] || crc[2]!= payload[length-2] || crc[1]!= payload[length-3] || crc[0]!= payload[length-4])
+			if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4])
 			{
 				RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
 					 "rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
-					 crc[3], payload[length-1],
-					 crc[2], payload[length-2],
-					 crc[1], payload[length-3],
-					 crc[0], payload[length-4]);
+					 crc[3], payload[length - 1],
+					 crc[2], payload[length - 2],
+					 crc[1], payload[length - 3],
+					 crc[0], payload[length - 4]);
 				res = _FAIL;
 			}
 		} else {
@@ -835,7 +843,7 @@ static void xor_128(u8 *a, u8 *b, u8 *out)
 {
 	int i;
 
-	for (i = 0;i<16; i++)
+	for (i = 0; i < 16; i++)
 		out[i] = a[i] ^ b[i];
 }
 
@@ -882,7 +890,7 @@ static void byte_sub(u8 *in, u8 *out)
 {
 	int i;
 
-	for (i = 0; i< 16; i++) {
+	for (i = 0; i < 16; i++) {
 		out[i] = sbox(in[i]);
 	}
 
@@ -922,7 +930,7 @@ static void mix_column(u8 *in, u8 *out)
 	u8 temp[4];
 	u8 tempb[4];
 
-	for (i = 0 ; i<4; i++) {
+	for (i = 0; i < 4; i++) {
 		if ((in[i] & 0x80) == 0x80)
 		    add1b[i] = 0x1b;
 		else
@@ -944,10 +952,10 @@ static void mix_column(u8 *in, u8 *out)
 	andf7[2] = in[2] & 0x7f;
 	andf7[3] = in[3] & 0x7f;
 
-	for (i = 3; i>0; i--) { /* logical shift left 1 bit */
+	for (i = 3; i > 0; i--) { /* logical shift left 1 bit */
 		andf7[i] = andf7[i] << 1;
-		if ((andf7[i-1] & 0x80) == 0x80) {
-		    andf7[i] = (andf7[i] | 0x01);
+		if ((andf7[i - 1] & 0x80) == 0x80) {
+			andf7[i] = (andf7[i] | 0x01);
 		}
 	}
 	andf7[0] = andf7[0] << 1;
@@ -977,7 +985,7 @@ static void aes128k128d(u8 *key, u8 *data, u8 *ciphertext)
 	u8 intermediateb[16];
 	u8 round_key[16];
 
-	for (i = 0; i<16; i++) round_key[i] = key[i];
+	for (i = 0; i < 16; i++) round_key[i] = key[i];
 
 	for (round = 0; round < 11; round++) {
 		if (round == 0) {
@@ -1061,7 +1069,7 @@ static void construct_mic_header2(u8 *mic_header2, u8 *mpdu, int a4_exists,
 {
 	int i;
 
-	for (i = 0; i<16; i++) mic_header2[i]= 0x00;
+	for (i = 0; i < 16; i++) mic_header2[i] = 0x00;
 
 	mic_header2[0] = mpdu[16];    /* A3 */
 	mic_header2[1] = mpdu[17];
@@ -1074,8 +1082,7 @@ static void construct_mic_header2(u8 *mic_header2, u8 *mpdu, int a4_exists,
 	mic_header2[7] = 0x00; /* mpdu[23]; */
 
 	if (!qc_exists && a4_exists) {
-		for (i = 0;i<6;i++) mic_header2[8+i] = mpdu[24+i];   /* A4 */
-
+		for (i = 0; i < 6; i++) mic_header2[8+i] = mpdu[24+i];   /* A4 */
 	}
 
 	if (qc_exists && !a4_exists) {
@@ -1084,7 +1091,7 @@ static void construct_mic_header2(u8 *mic_header2, u8 *mpdu, int a4_exists,
 	}
 
 	if (qc_exists && a4_exists) {
-		for (i = 0;i<6;i++) mic_header2[8+i] = mpdu[24+i];   /* A4 */
+		for (i = 0; i < 6; i++) mic_header2[8+i] = mpdu[24+i];   /* A4 */
 
 		mic_header2[14] = mpdu[30] & 0x0f;
 		mic_header2[15] = mpdu[31] & 0x00;
@@ -1102,7 +1109,7 @@ static void construct_ctr_preload(u8 *ctr_preload, int a4_exists, int qc_exists,
 {
 	int i = 0;
 
-	for (i = 0; i<16; i++) ctr_preload[i] = 0x00;
+	for (i = 0; i < 16; i++) ctr_preload[i] = 0x00;
 	i = 0;
 
 	ctr_preload[0] = 0x01;                                  /* flag */
@@ -1183,12 +1190,12 @@ static int aes_cipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 	} else {
 		qc_exists = 0;
 	}
-	pn_vector[0]= pframe[hdrlen];
-	pn_vector[1]= pframe[hdrlen+1];
-	pn_vector[2]= pframe[hdrlen+4];
-	pn_vector[3]= pframe[hdrlen+5];
-	pn_vector[4]= pframe[hdrlen+6];
-	pn_vector[5]= pframe[hdrlen+7];
+	pn_vector[0] = pframe[hdrlen];
+	pn_vector[1] = pframe[hdrlen + 1];
+	pn_vector[2] = pframe[hdrlen + 4];
+	pn_vector[3] = pframe[hdrlen + 5];
+	pn_vector[4] = pframe[hdrlen + 6];
+	pn_vector[5] = pframe[hdrlen + 7];
 
 	construct_mic_iv(mic_iv, qc_exists, a4_exists, pframe, plen, pn_vector);
 
@@ -1230,12 +1237,12 @@ static int aes_cipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 
 	/* Insert MIC into payload */
 	for (j = 0; j < 8; j++)
-		pframe[payload_index+j] = mic[j];
+		pframe[payload_index + j] = mic[j];
 
 	payload_index = hdrlen + 8;
 	for (i = 0; i < num_blocks; i++) {
 		construct_ctr_preload(ctr_preload, a4_exists, qc_exists,
-				      pframe, pn_vector, i+1);
+				      pframe, pn_vector, i + 1);
 		aes128k128d(key, ctr_preload, aes_out);
 		bitwise_xor(aes_out, &pframe[payload_index], chain_buffer);
 		for (j = 0; j < 16; j++)
@@ -1247,15 +1254,15 @@ static int aes_cipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 		 * encrypt it and copy the unpadded part back
 		 */
 		construct_ctr_preload(ctr_preload, a4_exists, qc_exists, pframe,
-				      pn_vector, num_blocks+1);
+				      pn_vector, num_blocks + 1);
 
 		for (j = 0; j < 16; j++)
 			padded_buffer[j] = 0x00;
 		for (j = 0; j < payload_remainder; j++)
-			padded_buffer[j] = pframe[payload_index+j];
+			padded_buffer[j] = pframe[payload_index + j];
 		aes128k128d(key, ctr_preload, aes_out);
 		bitwise_xor(aes_out, padded_buffer, chain_buffer);
-		for (j = 0; j < payload_remainder;j++)
+		for (j = 0; j < payload_remainder; j++)
 			pframe[payload_index++] = chain_buffer[j];
 	}
 
@@ -1266,11 +1273,11 @@ static int aes_cipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 	for (j = 0; j < 16; j++)
 		padded_buffer[j] = 0x00;
 	for (j = 0; j < 8; j++)
-		padded_buffer[j] = pframe[j+hdrlen+8+plen];
+		padded_buffer[j] = pframe[j + hdrlen + 8 + plen];
 
 	aes128k128d(key, ctr_preload, aes_out);
 	bitwise_xor(aes_out, padded_buffer, chain_buffer);
-	for (j = 0; j < 8;j++)
+	for (j = 0; j < 8; j++)
 		pframe[payload_index++] = chain_buffer[j];
 
 	return _SUCCESS;
@@ -1315,7 +1322,7 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 		res = _FAIL;
 		goto out;
 	}
-	if (!(stainfo->state &_FW_LINKED)) {
+	if (!(stainfo->state & _FW_LINKED)) {
 		DBG_8723A("%s, psta->state(0x%x) != _FW_LINKED\n",
 			  __func__, stainfo->state);
 		return _FAIL;
@@ -1380,16 +1387,16 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 
 	/* start to decrypt the payload */
 
-	num_blocks = (plen-8) / 16; /* plen including llc, payload_length and mic) */
+	num_blocks = (plen - 8) / 16; /* plen including llc, payload_length and mic) */
 
-	payload_remainder = (plen-8) % 16;
+	payload_remainder = (plen - 8) % 16;
 
 	pn_vector[0]  = pframe[hdrlen];
-	pn_vector[1]  = pframe[hdrlen+1];
-	pn_vector[2]  = pframe[hdrlen+4];
-	pn_vector[3]  = pframe[hdrlen+5];
-	pn_vector[4]  = pframe[hdrlen+6];
-	pn_vector[5]  = pframe[hdrlen+7];
+	pn_vector[1]  = pframe[hdrlen + 1];
+	pn_vector[2]  = pframe[hdrlen + 4];
+	pn_vector[3]  = pframe[hdrlen + 5];
+	pn_vector[4]  = pframe[hdrlen + 6];
+	pn_vector[5]  = pframe[hdrlen + 7];
 
 	if ((hdrlen == sizeof(struct ieee80211_hdr_3addr) ||
 	    (hdrlen == sizeof(struct ieee80211_qos_hdr))))
@@ -1424,7 +1431,7 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 
 	for (i = 0; i < num_blocks; i++) {
 		construct_ctr_preload(ctr_preload, a4_exists, qc_exists,
-				      pframe, pn_vector, i+1);
+				      pframe, pn_vector, i + 1);
 
 		aes128k128d(key, ctr_preload, aes_out);
 		bitwise_xor(aes_out, &pframe[payload_index], chain_buffer);
@@ -1438,12 +1445,12 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 		 * encrypt it and copy the unpadded part back
 		 */
 		construct_ctr_preload(ctr_preload, a4_exists, qc_exists, pframe,
-				      pn_vector, num_blocks+1);
+				      pn_vector, num_blocks + 1);
 
 		for (j = 0; j < 16; j++)
 			padded_buffer[j] = 0x00;
 		for (j = 0; j < payload_remainder; j++)
-			padded_buffer[j] = pframe[payload_index+j];
+			padded_buffer[j] = pframe[payload_index + j];
 		aes128k128d(key, ctr_preload, aes_out);
 		bitwise_xor(aes_out, padded_buffer, chain_buffer);
 		for (j = 0; j < payload_remainder; j++)
@@ -1451,24 +1458,24 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 	}
 
 	/* start to calculate the mic */
-	if ((hdrlen +plen+8) <= MAX_MSG_SIZE)
-		memcpy(message, pframe, (hdrlen+plen+8)); /* 8 is for ext iv len */
+	if ((hdrlen + plen + 8) <= MAX_MSG_SIZE)
+		memcpy(message, pframe, (hdrlen + plen + 8)); /* 8 is for ext iv len */
 
 	pn_vector[0] = pframe[hdrlen];
-	pn_vector[1] = pframe[hdrlen+1];
-	pn_vector[2] = pframe[hdrlen+4];
-	pn_vector[3] = pframe[hdrlen+5];
-	pn_vector[4] = pframe[hdrlen+6];
-	pn_vector[5] = pframe[hdrlen+7];
+	pn_vector[1] = pframe[hdrlen + 1];
+	pn_vector[2] = pframe[hdrlen + 4];
+	pn_vector[3] = pframe[hdrlen + 5];
+	pn_vector[4] = pframe[hdrlen + 6];
+	pn_vector[5] = pframe[hdrlen + 7];
 
 	construct_mic_iv(mic_iv, qc_exists, a4_exists, message,
-			 plen-8, pn_vector);
+			 plen - 8, pn_vector);
 
 	construct_mic_header1(mic_header1, hdrlen, message);
 	construct_mic_header2(mic_header2, message, a4_exists, qc_exists);
 
-	payload_remainder = (plen-8) % 16;
-	num_blocks = (plen-8) / 16;
+	payload_remainder = (plen - 8) % 16;
+	num_blocks = (plen - 8) / 16;
 
 	/* Find start of payload */
 	payload_index = hdrlen + 8;
@@ -1502,12 +1509,12 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 
 	/* Insert MIC into payload */
 	for (j = 0; j < 8; j++)
-		message[payload_index+j] = mic[j];
+		message[payload_index + j] = mic[j];
 
 	payload_index = hdrlen + 8;
-	for (i = 0; i< num_blocks; i++) {
+	for (i = 0; i < num_blocks; i++) {
 		construct_ctr_preload(ctr_preload, a4_exists, qc_exists,
-				      message, pn_vector, i+1);
+				      message, pn_vector, i + 1);
 		aes128k128d(key, ctr_preload, aes_out);
 		bitwise_xor(aes_out, &message[payload_index], chain_buffer);
 		for (j = 0; j < 16; j++)
@@ -1519,12 +1526,12 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 		 * encrypt it and copy the unpadded part back
 		 */
 		construct_ctr_preload(ctr_preload, a4_exists, qc_exists,
-				      message, pn_vector, num_blocks+1);
+				      message, pn_vector, num_blocks + 1);
 
 		for (j = 0; j < 16; j++)
 			 padded_buffer[j] = 0x00;
 		for (j = 0; j < payload_remainder; j++)
-			padded_buffer[j] = message[payload_index+j];
+			padded_buffer[j] = message[payload_index + j];
 		aes128k128d(key, ctr_preload, aes_out);
 		bitwise_xor(aes_out, padded_buffer, chain_buffer);
 		for (j = 0; j < payload_remainder; j++)
@@ -1538,7 +1545,7 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 	for (j = 0; j < 16; j++)
 		padded_buffer[j] = 0x00;
 	for (j = 0; j < 8; j++)
-		padded_buffer[j] = message[j+hdrlen+8+plen-8];
+		padded_buffer[j] = message[j + hdrlen + 8 + plen - 8];
 
 	aes128k128d(key, ctr_preload, aes_out);
 	bitwise_xor(aes_out, padded_buffer, chain_buffer);
@@ -1547,13 +1554,13 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 
 	/* compare the mic */
 	for (i = 0; i < 8; i++) {
-		if (pframe[hdrlen+8+plen-8+i] != message[hdrlen+8+plen-8+i]) {
+		if (pframe[hdrlen + 8 + plen - 8 + i] != message[hdrlen + 8 + plen - 8 + i]) {
 			RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
 				 "aes_decipher:mic check error mic[%d]: pframe(%x) != message(%x)\n",
 				 i, pframe[hdrlen + 8 + plen - 8 + i],
 				 message[hdrlen + 8 + plen - 8 + i]);
 			DBG_8723A("aes_decipher:mic check error mic[%d]: pframe(%x) != message(%x)\n",
-				  i, pframe[hdrlen+8+plen-8+i], message[hdrlen+8+plen-8+i]);
+				  i, pframe[hdrlen + 8 + plen - 8 + i], message[hdrlen + 8 + plen - 8 + i]);
 			res = _FAIL;
 		}
 	}
-- 
2.1.4

