Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:44591 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbbCOAP5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 20:15:57 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	m.v.b@runbox.com
Subject: [PATCH v2 12/16] staging: rtl8723au: Adjust whitespace in and around comments
Date: Sat, 14 Mar 2015 20:10:37 -0400
Message-Id: <1426378241-32469-13-git-send-email-m.v.b@runbox.com> (sfid-20150315_011641_183282_51554484)
In-Reply-To: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the subject indicates, adjust whitespace in and around comments
in rtl8723au's rtw_security.c.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 114 +++++++++++++-------------
 1 file changed, 57 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 3da9205254..9d6e7d6a17 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -135,12 +135,12 @@ static u32 getcrc32(u8 *buf, int len)
 	if (bcrc32initialized == 0)
 		crc32_init();
 
-	crc = 0xffffffff;       /* preload shift register, per CRC-32 spec */
+	crc = 0xffffffff; /* preload shift register, per CRC-32 spec */
 
 	for (p = buf; len > 0; ++p, --len)
 		crc = crc32_table[(crc ^ *p) & 0xff] ^ (crc >> 8);
 
-	return ~crc;    /* transmit complement, per CRC-32 spec */
+	return ~crc; /* transmit complement, per CRC-32 spec */
 }
 
 /* Need to consider the fragment  situation */
@@ -152,7 +152,7 @@ void rtw_wep_encrypt23a(struct rtw_adapter *padapter,
 	struct arc4context mycontext;
 	int curfragnum, length, index;
 	u32 keylength;
-	u8 *pframe, *payload, *iv;    /* wepkey */
+	u8 *pframe, *payload, *iv; /* wepkey */
 	u8 wepkey[16];
 	u8 hw_hdr_offset = 0;
 	struct pkt_attrib *pattrib = &pxmitframe->attrib;
@@ -373,15 +373,15 @@ void rtw_seccalctkipmic23a(u8 *key, u8 *header, u8 *data, u32 data_len,
 	priority[0] = pri;
 
 	/* Michael MIC pseudo header: DA, SA, 3 x 0, Priority */
-	if (header[1]&1) {   /* ToDS == 1 */
-			rtw_secmicappend23a(&micdata, &header[16], 6);  /* DA */
-		if (header[1]&2)  /* From Ds == 1 */
+	if (header[1]&1) { /* ToDS == 1 */
+			rtw_secmicappend23a(&micdata, &header[16], 6); /* DA */
+		if (header[1]&2) /* From Ds == 1 */
 			rtw_secmicappend23a(&micdata, &header[24], 6);
 		else
 			rtw_secmicappend23a(&micdata, &header[10], 6);
-	} else {	/* ToDS == 0 */
-		rtw_secmicappend23a(&micdata, &header[4], 6);   /* DA */
-		if (header[1]&2)  /* From Ds == 1 */
+	} else { /* ToDS == 0 */
+		rtw_secmicappend23a(&micdata, &header[4], 6); /* DA */
+		if (header[1]&2) /* From Ds == 1 */
 			rtw_secmicappend23a(&micdata, &header[16], 6);
 		else
 			rtw_secmicappend23a(&micdata, &header[10], 6);
@@ -403,7 +403,7 @@ void rtw_seccalctkipmic23a(u8 *key, u8 *header, u8 *data, u32 data_len,
 #define  Hi16(v32)   ((u16)(((v32) >> 16) & 0xFFFF))
 #define  Mk16(hi, lo) ((lo) ^ (((u16)(hi)) << 8))
 
-/* select the Nth 16-bit word of the temporal key unsigned char array TK[]   */
+/* select the Nth 16-bit word of the temporal key unsigned char array TK[] */
 #define  TK16(N)     Mk16(tk[2*(N)+1], tk[2*(N)])
 
 /* S-box lookup: 16 bits --> 16 bits */
@@ -510,7 +510,7 @@ static void phase1(u16 *p1k, const u8 *tk, const u8 *ta, u32 iv32)
 {
 	int  i;
 
-	/* Initialize the 80 bits of P1K[] from IV32 and TA[0..5]     */
+	/* Initialize the 80 bits of P1K[] from IV32 and TA[0..5] */
 	p1k[0]      = Lo16(iv32);
 	p1k[1]      = Hi16(iv32);
 	p1k[2]      = Mk16(ta[1], ta[0]); /* use TA[] as little-endian */
@@ -526,7 +526,7 @@ static void phase1(u16 *p1k, const u8 *tk, const u8 *ta, u32 iv32)
 		p1k[2] += _S_(p1k[1] ^ TK16((i & 1) + 4));
 		p1k[3] += _S_(p1k[2] ^ TK16((i & 1) + 6));
 		p1k[4] += _S_(p1k[3] ^ TK16((i & 1) + 0));
-		p1k[4] +=  (unsigned short)i;                    /* avoid "slide attacks" */
+		p1k[4] +=  (unsigned short) i; /* avoid "slide attacks" */
 		}
 
 }
@@ -557,41 +557,41 @@ static void phase1(u16 *p1k, const u8 *tk, const u8 *ta, u32 iv32)
 static void phase2(u8 *rc4key, const u8 *tk, const u16 *p1k, u16 iv16)
 {
 	int  i;
-	u16 PPK[6];                          /* temporary key for mixing    */
+	u16 PPK[6]; /* temporary key for mixing    */
 
-	/* Note: all adds in the PPK[] equations below are mod 2**16         */
+	/* Note: all adds in the PPK[] equations below are mod 2**16 */
 	for (i = 0; i < 5; i++)
-		PPK[i] = p1k[i];    /* first, copy P1K to PPK      */
+		PPK[i] = p1k[i]; /* first, copy P1K to PPK */
 
-	PPK[5] = p1k[4] + iv16;     /* next,  add in IV16          */
+	PPK[5] = p1k[4] + iv16; /* next,  add in IV16 */
 
-	/* Bijective non-linear mixing of the 96 bits of PPK[0..5]           */
-	PPK[0] +=    _S_(PPK[5] ^ TK16(0));   /* Mix key in each "round"     */
-	PPK[1] +=    _S_(PPK[0] ^ TK16(1));
-	PPK[2] +=    _S_(PPK[1] ^ TK16(2));
-	PPK[3] +=    _S_(PPK[2] ^ TK16(3));
-	PPK[4] +=    _S_(PPK[3] ^ TK16(4));
-	PPK[5] +=    _S_(PPK[4] ^ TK16(5));   /* Total # S-box lookups == 6  */
+	/* Bijective non-linear mixing of the 96 bits of PPK[0..5] */
+	PPK[0] += _S_(PPK[5] ^ TK16(0)); /* Mix key in each "round" */
+	PPK[1] += _S_(PPK[0] ^ TK16(1));
+	PPK[2] += _S_(PPK[1] ^ TK16(2));
+	PPK[3] += _S_(PPK[2] ^ TK16(3));
+	PPK[4] += _S_(PPK[3] ^ TK16(4));
+	PPK[5] += _S_(PPK[4] ^ TK16(5)); /* Total # S-box lookups == 6 */
 
-	/* Final sweep: bijective, "linear". Rotates kill LSB correlations   */
+	/* Final sweep: bijective, "linear". Rotates kill LSB correlations */
 	PPK[0] +=  RotR1(PPK[5] ^ TK16(6));
-	PPK[1] +=  RotR1(PPK[0] ^ TK16(7));   /* Use all of TK[] in Phase2   */
+	PPK[1] +=  RotR1(PPK[0] ^ TK16(7)); /* Use all of TK[] in Phase2 */
 	PPK[2] +=  RotR1(PPK[1]);
 	PPK[3] +=  RotR1(PPK[2]);
 	PPK[4] +=  RotR1(PPK[3]);
 	PPK[5] +=  RotR1(PPK[4]);
 	/* Note: At this point, for a given key TK[0..15], the 96-bit output */
 	/*       value PPK[0..5] is guaranteed to be unique, as a function   */
-	/*       of the 96-bit "input" value   {TA, IV32, IV16}. That is, P1K  */
-	/*       is now a keyed permutation of {TA, IV32, IV16}.               */
+	/*       of the 96-bit "input" value   {TA, IV32, IV16}. That is,    */
+	/*       P1K is now a keyed permutation of {TA, IV32, IV16}.         */
 
 	/* Set RC4KEY[0..3], which includes "cleartext" portion of RC4 key   */
-	rc4key[0] = Hi8(iv16);                /* RC4KEY[0..2] is the WEP IV  */
-	rc4key[1] = (Hi8(iv16) | 0x20) & 0x7F; /* Help avoid weak (FMS) keys  */
+	rc4key[0] = Hi8(iv16);                 /* RC4KEY[0..2] is the WEP IV */
+	rc4key[1] = (Hi8(iv16) | 0x20) & 0x7F; /* Help avoid weak (FMS) keys */
 	rc4key[2] = Lo8(iv16);
 	rc4key[3] = Lo8((PPK[5] ^ TK16(0)) >> 1);
 
-	/* Copy 96 bits of PPK[0..5] to RC4KEY[4..15]  (little-endian)       */
+	/* Copy 96 bits of PPK[0..5] to RC4KEY[4..15]  (little-endian) */
 	for (i = 0; i < 6; i++) {
 		rc4key[4 + 2 * i] = Lo8(PPK[i]);
 		rc4key[5 + 2 * i] = Hi8(PPK[i]);
@@ -671,18 +671,17 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 
 		phase2(&rc4key[0], prwskey, (u16 *)&ttkey[0], pnl);
 
-		if ((curfragnum+1) == pattrib->nr_frags) {	/* 4 the last fragment */
+		if ((curfragnum+1) == pattrib->nr_frags) { /* 4 the last fragment */
 			length = pattrib->last_txcmdsz-pattrib->hdrlen-pattrib->iv_len - pattrib->icv_len;
 			RT_TRACE(_module_rtl871x_security_c_, _drv_info_, ("pattrib->iv_len =%x, pattrib->icv_len =%x\n", pattrib->iv_len, pattrib->icv_len));
-			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));/* modified by Amy*/
+			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length)); /* modified by Amy */
 
 			arcfour_init(&mycontext, rc4key, 16);
 			arcfour_encrypt(&mycontext, payload, payload, length);
 			arcfour_encrypt(&mycontext, payload+length, crc, 4);
-
 		} else {
 			length = pxmitpriv->frag_len-pattrib->hdrlen-pattrib->iv_len-pattrib->icv_len;
-			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));/* modified by Amy*/
+			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length)); /* modified by Amy */
 			arcfour_init(&mycontext, rc4key, 16);
 			arcfour_encrypt(&mycontext, payload, payload, length);
 			arcfour_encrypt(&mycontext, payload+length, crc, 4);
@@ -914,12 +913,12 @@ static void mix_column(u8 *in, u8 *out)
 		    add1b[i] = 0x00;
 	}
 
-	swap_halfs[0] = in[2];    /* Swap halfs */
+	swap_halfs[0] = in[2]; /* Swap halfs */
 	swap_halfs[1] = in[3];
 	swap_halfs[2] = in[0];
 	swap_halfs[3] = in[1];
 
-	rotl[0] = in[3];        /* Rotate left 8 bits */
+	rotl[0] = in[3]; /* Rotate left 8 bits */
 	rotl[1] = in[0];
 	rotl[2] = in[1];
 	rotl[3] = in[2];
@@ -941,7 +940,7 @@ static void mix_column(u8 *in, u8 *out)
 
 	xor_32(in, add1bf7, rotr);
 
-	temp[0] = rotr[0];         /* Rotate right 8 bits */
+	temp[0] = rotr[0]; /* Rotate right 8 bits */
 	rotr[0] = rotr[1];
 	rotr[1] = rotr[2];
 	rotr[2] = rotr[3];
@@ -997,9 +996,9 @@ static void construct_mic_iv(u8 *mic_iv, int qc_exists, int a4_exists, u8 *mpdu,
 
 	mic_iv[0] = 0x59;
 	if (qc_exists && a4_exists)
-		mic_iv[1] = mpdu[30] & 0x0f;    /* QoS_TC           */
+		mic_iv[1] = mpdu[30] & 0x0f; /* QoS_TC        */
 	if (qc_exists && !a4_exists)
-		mic_iv[1] = mpdu[24] & 0x0f;   /* mute bits 7-4    */
+		mic_iv[1] = mpdu[24] & 0x0f; /* mute bits 7-4 */
 	if (!qc_exists)
 		mic_iv[1] = 0x00;
 	for (i = 2; i < 8; i++)
@@ -1019,15 +1018,15 @@ static void construct_mic_header1(u8 *mic_header1, int header_length, u8 *mpdu)
 {
 	mic_header1[0] = (u8)((header_length - 2) / 256);
 	mic_header1[1] = (u8)((header_length - 2) % 256);
-	mic_header1[2] = mpdu[0] & 0xcf;    /* Mute CF poll & CF ack bits */
-	mic_header1[3] = mpdu[1] & 0xc7;    /* Mute retry, more data and pwr mgt bits */
-	mic_header1[4] = mpdu[4];       /* A1 */
+	mic_header1[2] = mpdu[0] & 0xcf; /* Mute CF poll & CF ack bits */
+	mic_header1[3] = mpdu[1] & 0xc7; /* Mute retry, more data and pwr mgt bits */
+	mic_header1[4] = mpdu[4]; /* A1 */
 	mic_header1[5] = mpdu[5];
 	mic_header1[6] = mpdu[6];
 	mic_header1[7] = mpdu[7];
 	mic_header1[8] = mpdu[8];
 	mic_header1[9] = mpdu[9];
-	mic_header1[10] = mpdu[10];     /* A2 */
+	mic_header1[10] = mpdu[10]; /* A2 */
 	mic_header1[11] = mpdu[11];
 	mic_header1[12] = mpdu[12];
 	mic_header1[13] = mpdu[13];
@@ -1037,7 +1036,7 @@ static void construct_mic_header1(u8 *mic_header1, int header_length, u8 *mpdu)
 }
 
 /************************************************/
-	/* construct_mic_header2()                      */
+/* construct_mic_header2()                      */
 /* Builds the last MIC header block from        */
 /* header fields.                               */
 /************************************************/
@@ -1049,7 +1048,7 @@ static void construct_mic_header2(u8 *mic_header2, u8 *mpdu, int a4_exists,
 	for (i = 0; i < 16; i++)
 		mic_header2[i] = 0x00;
 
-	mic_header2[0] = mpdu[16];    /* A3 */
+	mic_header2[0] = mpdu[16]; /* A3 */
 	mic_header2[1] = mpdu[17];
 	mic_header2[2] = mpdu[18];
 	mic_header2[3] = mpdu[19];
@@ -1061,7 +1060,7 @@ static void construct_mic_header2(u8 *mic_header2, u8 *mpdu, int a4_exists,
 
 	if (!qc_exists && a4_exists) {
 		for (i = 0; i < 6; i++)
-			mic_header2[8+i] = mpdu[24+i];   /* A4 */
+			mic_header2[8+i] = mpdu[24+i]; /* A4 */
 	}
 
 	if (qc_exists && !a4_exists) {
@@ -1071,7 +1070,7 @@ static void construct_mic_header2(u8 *mic_header2, u8 *mpdu, int a4_exists,
 
 	if (qc_exists && a4_exists) {
 		for (i = 0; i < 6; i++)
-			mic_header2[8+i] = mpdu[24+i];   /* A4 */
+			mic_header2[8+i] = mpdu[24+i]; /* A4 */
 
 		mic_header2[14] = mpdu[30] & 0x0f;
 		mic_header2[15] = mpdu[31] & 0x00;
@@ -1094,16 +1093,16 @@ static void construct_ctr_preload(u8 *ctr_preload, int a4_exists, int qc_exists,
 
 	i = 0;
 
-	ctr_preload[0] = 0x01;                                  /* flag */
+	ctr_preload[0] = 0x01; /* flag */
 	if (qc_exists && a4_exists)
-		ctr_preload[1] = mpdu[30] & 0x0f;   /* QoC_Control */
+		ctr_preload[1] = mpdu[30] & 0x0f; /* QoC_Control */
 	if (qc_exists && !a4_exists)
 		ctr_preload[1] = mpdu[24] & 0x0f;
 
 	for (i = 2; i < 8; i++)
-		ctr_preload[i] = mpdu[i + 8];                       /* ctr_preload[2:7] = A2[0:5] = mpdu[10:15] */
+		ctr_preload[i] = mpdu[i + 8]; /* ctr_preload[2:7] = A2[0:5] = mpdu[10:15] */
 	for (i = 8; i < 14; i++)
-		ctr_preload[i] =    pn_vector[13 - i];          /* ctr_preload[8:13] = PN[5:0] */
+		ctr_preload[i] = pn_vector[13 - i]; /* ctr_preload[8:13] = PN[5:0] */
 	ctr_preload[14] =  (unsigned char) (c / 256); /* Ctr */
 	ctr_preload[15] =  (unsigned char) (c % 256);
 
@@ -1267,11 +1266,11 @@ static int aes_cipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 
 int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 		       struct xmit_frame *pxmitframe)
-{	/*  exclude ICV */
+{	/* exclude ICV */
 	/* Intermediate Buffers */
 	int curfragnum, length;
 	u32 prwskeylen;
-	u8 *pframe, *prwskey;	/*  *payload,*iv */
+	u8 *pframe, *prwskey; /* *payload, *iv */
 	u8 hw_hdr_offset = 0;
 	struct sta_info *stainfo;
 	struct pkt_attrib *pattrib = &pxmitframe->attrib;
@@ -1407,7 +1406,7 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 		qc_exists = 0;
 	}
 
-	/*  now, decrypt pframe with hdrlen offset and plen long */
+	/* now, decrypt pframe with hdrlen offset and plen long */
 
 	payload_index = hdrlen + 8; /*  8 is for extiv */
 
@@ -1556,7 +1555,7 @@ int rtw_aes_decrypt23a(struct rtw_adapter *padapter,
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 	struct sk_buff *skb = precvframe->pkt;
 	int length;
-	u8 *pframe, *prwskey;	/*  *payload,*iv */
+	u8 *pframe, *prwskey; /* *payload, *iv */
 	int res = _SUCCESS;
 
 	pframe = skb->data;
@@ -1576,8 +1575,9 @@ int rtw_aes_decrypt23a(struct rtw_adapter *padapter,
 		 ("rtw_aes_decrypt23a: stainfo!= NULL!!!\n"));
 
 	if (is_multicast_ether_addr(prxattrib->ra)) {
-		/* in concurrent we should use sw decrypt in group key,
-		   so we remove this message */
+		/* in concurrent we should use sw decrypt in
+		 * group key, so we remove this message
+		 */
 		if (!psecuritypriv->binstallGrpkey) {
 			res = _FAIL;
 			DBG_8723A("%s:rx bc/mc packets, but didn't install "
-- 
2.1.4

