Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:36386 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbbCMDgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 23:36:42 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: m.v.b@runbox.com
Subject: [PATCH 01/16] staging: rtl8723au: Reformat whitespace to increase readability
Date: Thu, 12 Mar 2015 23:15:17 -0400
Message-Id: <1426216532-24058-2-git-send-email-m.v.b@runbox.com> (sfid-20150313_044151_055522_801DB3BD)
In-Reply-To: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adjust the whitespace in the local variable declaration and initialization
part of a number of functions to increase readability in rtl8723au's
rtw_security.c.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 79 +++++++++++++--------------
 1 file changed, 38 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 0610d5f1bd..ebda3adc89 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -31,11 +31,11 @@ struct arc4context {
 
 static void arcfour_init(struct arc4context *parc4ctx, u8 *key, u32 key_len)
 {
-	u32	t, u;
-	u32	keyindex;
-	u32	stateindex;
+	u32 t, u;
+	u32 keyindex;
+	u32 stateindex;
 	u8 *state;
-	u32	counter;
+	u32 counter;
 
 	state = parc4ctx->state;
 	parc4ctx->x = 0;
@@ -55,7 +55,8 @@ static void arcfour_init(struct arc4context *parc4ctx, u8 *key, u32 key_len)
 	}
 
 }
-static u32 arcfour_byte(	struct arc4context	*parc4ctx)
+
+static u32 arcfour_byte(struct arc4context *parc4ctx)
 {
 	u32 x;
 	u32 y;
@@ -75,16 +76,13 @@ static u32 arcfour_byte(	struct arc4context	*parc4ctx)
 	return state[(sx + sy) & 0xff];
 }
 
-static void arcfour_encrypt(	struct arc4context	*parc4ctx,
-	u8 *dest,
-	u8 *src,
-	u32 len)
+static void arcfour_encrypt(struct arc4context *parc4ctx,
+		u8 *dest, u8 *src, u32 len)
 {
-	u32	i;
+	u32 i;
 
 	for (i = 0; i < len; i++)
 		dest[i] = src[i] ^ (unsigned char)arcfour_byte(parc4ctx);
-
 }
 
 static int bcrc32initialized = 0;
@@ -368,7 +366,7 @@ void rtw_seccalctkipmic23a(u8 *key, u8 *header, u8 *data, u32 data_len,
 			   u8 *mic_code, u8 pri)
 {
 
-	struct mic_data	micdata;
+	struct mic_data micdata;
 	u8 priority[4]={0x0, 0x0, 0x0, 0x0};
 
 	rtw_secmicsetkey23a(&micdata, key);
@@ -604,21 +602,21 @@ static void phase2(u8 *rc4key, const u8 *tk, const u16 *p1k, u16 iv16)
 int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 			struct xmit_frame *pxmitframe)
 {
-	u16	pnl;
-	u32	pnh;
-	u8	rc4key[16];
-	u8   ttkey[16];
-	u8	crc[4];
-	u8   hw_hdr_offset = 0;
+	u16 pnl;
+	u32 pnh;
+	u8 rc4key[16];
+	u8 ttkey[16];
+	u8 crc[4];
+	u8 hw_hdr_offset = 0;
 	struct arc4context mycontext;
-	int			curfragnum, length;
-	u32	prwskeylen;
-	u8	*pframe, *payload, *iv, *prwskey;
+	int curfragnum, length;
+	u32 prwskeylen;
+	u8 *pframe, *payload, *iv, *prwskey;
 	union pn48 dot11txpn;
-	struct	sta_info		*stainfo;
-	struct	pkt_attrib	 *pattrib = &pxmitframe->attrib;
-	struct	security_priv	*psecuritypriv = &padapter->securitypriv;
-	struct	xmit_priv		*pxmitpriv = &padapter->xmitpriv;
+	struct sta_info *stainfo;
+	struct pkt_attrib *pattrib = &pxmitframe->attrib;
+	struct security_priv *psecuritypriv = &padapter->securitypriv;
+	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 	int res = _SUCCESS;
 
 	if (!pxmitframe->buf_addr)
@@ -706,17 +704,17 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 {
 	u16 pnl;
 	u32 pnh;
-	u8   rc4key[16];
-	u8   ttkey[16];
-	u8	crc[4];
+	u8 rc4key[16];
+	u8 ttkey[16];
+	u8 crc[4];
 	struct arc4context mycontext;
-	int	length;
-	u32	prwskeylen;
-	u8	*pframe, *payload, *iv, *prwskey;
+	int length;
+	u32 prwskeylen;
+	u8 *pframe, *payload, *iv, *prwskey;
 	union pn48 dot11txpn;
-	struct	sta_info		*stainfo;
-	struct	rx_pkt_attrib *prxattrib = &precvframe->attrib;
-	struct	security_priv *psecuritypriv = &padapter->securitypriv;
+	struct sta_info *stainfo;
+	struct rx_pkt_attrib *prxattrib = &precvframe->attrib;
+	struct security_priv *psecuritypriv = &padapter->securitypriv;
 	struct sk_buff *skb = precvframe->pkt;
 	int res = _SUCCESS;
 
@@ -1128,8 +1126,8 @@ static void bitwise_xor(u8 *ina, u8 *inb, u8 *out)
 
 static int aes_cipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 {
-	uint	qc_exists, a4_exists, i, j, payload_remainder,
-		num_blocks, payload_index;
+	uint qc_exists, a4_exists, i, j, payload_remainder,
+	     num_blocks, payload_index;
 	u8 pn_vector[6];
 	u8 mic_iv[16];
 	u8 mic_header1[16];
@@ -1345,12 +1343,11 @@ out:
 	return res;
 }
 
-static int aes_decipher(u8 *key, uint	hdrlen,
-			u8 *pframe, uint plen)
+static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 {
-	static u8	message[MAX_MSG_SIZE];
-	uint	qc_exists, a4_exists, i, j, payload_remainder,
-			num_blocks, payload_index;
+	static u8 message[MAX_MSG_SIZE];
+	uint qc_exists, a4_exists, i, j, payload_remainder,
+	     num_blocks, payload_index;
 	int res = _SUCCESS;
 	u8 pn_vector[6];
 	u8 mic_iv[16];
-- 
2.1.4

