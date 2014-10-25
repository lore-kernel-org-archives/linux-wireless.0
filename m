Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47191 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaJYT7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:59:46 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so24481wiv.9
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:59:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 20/48] staging: vt6655: deadcode remove aes_ccmp/rc4/tkip
Date: Sat, 25 Oct 2014 09:39:58 +0100
Message-Id: <1414226426-5811-21-git-send-email-tvboxspy@gmail.com> (sfid-20141025_215950_817804_38CCD306)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/Makefile   |   3 -
 drivers/staging/vt6655/aes_ccmp.c | 374 --------------------------------------
 drivers/staging/vt6655/aes_ccmp.h |  37 ----
 drivers/staging/vt6655/device.h   |   2 -
 drivers/staging/vt6655/rc4.c      |  88 ---------
 drivers/staging/vt6655/rc4.h      |  47 -----
 drivers/staging/vt6655/rxtx.c     |   1 -
 drivers/staging/vt6655/tkip.c     | 268 ---------------------------
 drivers/staging/vt6655/tkip.h     |  57 ------
 9 files changed, 877 deletions(-)
 delete mode 100644 drivers/staging/vt6655/aes_ccmp.c
 delete mode 100644 drivers/staging/vt6655/aes_ccmp.h
 delete mode 100644 drivers/staging/vt6655/rc4.c
 delete mode 100644 drivers/staging/vt6655/rc4.h
 delete mode 100644 drivers/staging/vt6655/tkip.c
 delete mode 100644 drivers/staging/vt6655/tkip.h

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index 7286e32..f49f12b 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -14,14 +14,11 @@ vt6655_stage-y +=	device_main.o \
 	power.o \
 	srom.o \
 	mib.o \
-	rc4.o \
 	tether.o \
 	tcrc.o \
 	key.o \
-	tkip.o \
 	michael.o \
 	rf.o \
-	aes_ccmp.o \
 	vntwifi.o
 
 obj-$(CONFIG_VT6655) +=	vt6655_stage.o
diff --git a/drivers/staging/vt6655/aes_ccmp.c b/drivers/staging/vt6655/aes_ccmp.c
deleted file mode 100644
index 1dfcfcb..0000000
--- a/drivers/staging/vt6655/aes_ccmp.c
+++ /dev/null
@@ -1,374 +0,0 @@
-/*
- * Copyright (c) 1996, 2003 VIA Networking Technologies, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- *
- * File: aes_ccmp.c
- *
- * Purpose: AES_CCMP decryption
- *
- * Author: Warren Hsu
- *
- * Date: Feb 15, 2005
- *
- * Functions:
- *      AESbGenCCMP - Parsing RX-packet
- *
- *
- * Revision History:
- *
- */
-
-#include "device.h"
-#include "80211hdr.h"
-#include "aes_ccmp.h"
-
-/*---------------------  Static Definitions -------------------------*/
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
-/*
- * SBOX Table
- */
-
-static unsigned char sbox_table[256] = {
-	0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
-	0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
-	0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
-	0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
-	0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
-	0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
-	0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
-	0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
-	0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
-	0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
-	0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
-	0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
-	0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
-	0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
-	0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
-	0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
-};
-
-static unsigned char dot2_table[256] = {
-	0x00, 0x02, 0x04, 0x06, 0x08, 0x0a, 0x0c, 0x0e, 0x10, 0x12, 0x14, 0x16, 0x18, 0x1a, 0x1c, 0x1e,
-	0x20, 0x22, 0x24, 0x26, 0x28, 0x2a, 0x2c, 0x2e, 0x30, 0x32, 0x34, 0x36, 0x38, 0x3a, 0x3c, 0x3e,
-	0x40, 0x42, 0x44, 0x46, 0x48, 0x4a, 0x4c, 0x4e, 0x50, 0x52, 0x54, 0x56, 0x58, 0x5a, 0x5c, 0x5e,
-	0x60, 0x62, 0x64, 0x66, 0x68, 0x6a, 0x6c, 0x6e, 0x70, 0x72, 0x74, 0x76, 0x78, 0x7a, 0x7c, 0x7e,
-	0x80, 0x82, 0x84, 0x86, 0x88, 0x8a, 0x8c, 0x8e, 0x90, 0x92, 0x94, 0x96, 0x98, 0x9a, 0x9c, 0x9e,
-	0xa0, 0xa2, 0xa4, 0xa6, 0xa8, 0xaa, 0xac, 0xae, 0xb0, 0xb2, 0xb4, 0xb6, 0xb8, 0xba, 0xbc, 0xbe,
-	0xc0, 0xc2, 0xc4, 0xc6, 0xc8, 0xca, 0xcc, 0xce, 0xd0, 0xd2, 0xd4, 0xd6, 0xd8, 0xda, 0xdc, 0xde,
-	0xe0, 0xe2, 0xe4, 0xe6, 0xe8, 0xea, 0xec, 0xee, 0xf0, 0xf2, 0xf4, 0xf6, 0xf8, 0xfa, 0xfc, 0xfe,
-	0x1b, 0x19, 0x1f, 0x1d, 0x13, 0x11, 0x17, 0x15, 0x0b, 0x09, 0x0f, 0x0d, 0x03, 0x01, 0x07, 0x05,
-	0x3b, 0x39, 0x3f, 0x3d, 0x33, 0x31, 0x37, 0x35, 0x2b, 0x29, 0x2f, 0x2d, 0x23, 0x21, 0x27, 0x25,
-	0x5b, 0x59, 0x5f, 0x5d, 0x53, 0x51, 0x57, 0x55, 0x4b, 0x49, 0x4f, 0x4d, 0x43, 0x41, 0x47, 0x45,
-	0x7b, 0x79, 0x7f, 0x7d, 0x73, 0x71, 0x77, 0x75, 0x6b, 0x69, 0x6f, 0x6d, 0x63, 0x61, 0x67, 0x65,
-	0x9b, 0x99, 0x9f, 0x9d, 0x93, 0x91, 0x97, 0x95, 0x8b, 0x89, 0x8f, 0x8d, 0x83, 0x81, 0x87, 0x85,
-	0xbb, 0xb9, 0xbf, 0xbd, 0xb3, 0xb1, 0xb7, 0xb5, 0xab, 0xa9, 0xaf, 0xad, 0xa3, 0xa1, 0xa7, 0xa5,
-	0xdb, 0xd9, 0xdf, 0xdd, 0xd3, 0xd1, 0xd7, 0xd5, 0xcb, 0xc9, 0xcf, 0xcd, 0xc3, 0xc1, 0xc7, 0xc5,
-	0xfb, 0xf9, 0xff, 0xfd, 0xf3, 0xf1, 0xf7, 0xf5, 0xeb, 0xe9, 0xef, 0xed, 0xe3, 0xe1, 0xe7, 0xe5
-};
-
-static unsigned char dot3_table[256] = {
-	0x00, 0x03, 0x06, 0x05, 0x0c, 0x0f, 0x0a, 0x09, 0x18, 0x1b, 0x1e, 0x1d, 0x14, 0x17, 0x12, 0x11,
-	0x30, 0x33, 0x36, 0x35, 0x3c, 0x3f, 0x3a, 0x39, 0x28, 0x2b, 0x2e, 0x2d, 0x24, 0x27, 0x22, 0x21,
-	0x60, 0x63, 0x66, 0x65, 0x6c, 0x6f, 0x6a, 0x69, 0x78, 0x7b, 0x7e, 0x7d, 0x74, 0x77, 0x72, 0x71,
-	0x50, 0x53, 0x56, 0x55, 0x5c, 0x5f, 0x5a, 0x59, 0x48, 0x4b, 0x4e, 0x4d, 0x44, 0x47, 0x42, 0x41,
-	0xc0, 0xc3, 0xc6, 0xc5, 0xcc, 0xcf, 0xca, 0xc9, 0xd8, 0xdb, 0xde, 0xdd, 0xd4, 0xd7, 0xd2, 0xd1,
-	0xf0, 0xf3, 0xf6, 0xf5, 0xfc, 0xff, 0xfa, 0xf9, 0xe8, 0xeb, 0xee, 0xed, 0xe4, 0xe7, 0xe2, 0xe1,
-	0xa0, 0xa3, 0xa6, 0xa5, 0xac, 0xaf, 0xaa, 0xa9, 0xb8, 0xbb, 0xbe, 0xbd, 0xb4, 0xb7, 0xb2, 0xb1,
-	0x90, 0x93, 0x96, 0x95, 0x9c, 0x9f, 0x9a, 0x99, 0x88, 0x8b, 0x8e, 0x8d, 0x84, 0x87, 0x82, 0x81,
-	0x9b, 0x98, 0x9d, 0x9e, 0x97, 0x94, 0x91, 0x92, 0x83, 0x80, 0x85, 0x86, 0x8f, 0x8c, 0x89, 0x8a,
-	0xab, 0xa8, 0xad, 0xae, 0xa7, 0xa4, 0xa1, 0xa2, 0xb3, 0xb0, 0xb5, 0xb6, 0xbf, 0xbc, 0xb9, 0xba,
-	0xfb, 0xf8, 0xfd, 0xfe, 0xf7, 0xf4, 0xf1, 0xf2, 0xe3, 0xe0, 0xe5, 0xe6, 0xef, 0xec, 0xe9, 0xea,
-	0xcb, 0xc8, 0xcd, 0xce, 0xc7, 0xc4, 0xc1, 0xc2, 0xd3, 0xd0, 0xd5, 0xd6, 0xdf, 0xdc, 0xd9, 0xda,
-	0x5b, 0x58, 0x5d, 0x5e, 0x57, 0x54, 0x51, 0x52, 0x43, 0x40, 0x45, 0x46, 0x4f, 0x4c, 0x49, 0x4a,
-	0x6b, 0x68, 0x6d, 0x6e, 0x67, 0x64, 0x61, 0x62, 0x73, 0x70, 0x75, 0x76, 0x7f, 0x7c, 0x79, 0x7a,
-	0x3b, 0x38, 0x3d, 0x3e, 0x37, 0x34, 0x31, 0x32, 0x23, 0x20, 0x25, 0x26, 0x2f, 0x2c, 0x29, 0x2a,
-	0x0b, 0x08, 0x0d, 0x0e, 0x07, 0x04, 0x01, 0x02, 0x13, 0x10, 0x15, 0x16, 0x1f, 0x1c, 0x19, 0x1a
-};
-
-/*---------------------  Static Functions  --------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-static void xor_128(unsigned char *a, unsigned char *b, unsigned char *out)
-{
-	unsigned long *dwPtrA = (unsigned long *)a;
-	unsigned long *dwPtrB = (unsigned long *)b;
-	unsigned long *dwPtrOut = (unsigned long *)out;
-
-	(*dwPtrOut++) = (*dwPtrA++) ^ (*dwPtrB++);
-	(*dwPtrOut++) = (*dwPtrA++) ^ (*dwPtrB++);
-	(*dwPtrOut++) = (*dwPtrA++) ^ (*dwPtrB++);
-	(*dwPtrOut++) = (*dwPtrA++) ^ (*dwPtrB++);
-}
-
-static void xor_32(unsigned char *a, unsigned char *b, unsigned char *out)
-{
-	unsigned long *dwPtrA = (unsigned long *)a;
-	unsigned long *dwPtrB = (unsigned long *)b;
-	unsigned long *dwPtrOut = (unsigned long *)out;
-
-	(*dwPtrOut++) = (*dwPtrA++) ^ (*dwPtrB++);
-}
-
-static void AddRoundKey(unsigned char *key, int round)
-{
-	unsigned char sbox_key[4];
-	unsigned char rcon_table[10] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};
-
-	sbox_key[0] = sbox_table[key[13]];
-	sbox_key[1] = sbox_table[key[14]];
-	sbox_key[2] = sbox_table[key[15]];
-	sbox_key[3] = sbox_table[key[12]];
-
-	key[0] = key[0] ^ rcon_table[round];
-	xor_32(&key[0], sbox_key, &key[0]);
-
-	xor_32(&key[4], &key[0], &key[4]);
-	xor_32(&key[8], &key[4], &key[8]);
-	xor_32(&key[12], &key[8], &key[12]);
-}
-
-static void SubBytes(unsigned char *in, unsigned char *out)
-{
-	int i;
-
-	for (i = 0; i < 16; i++)
-		out[i] = sbox_table[in[i]];
-}
-
-static void ShiftRows(unsigned char *in, unsigned char *out)
-{
-	out[0]  = in[0];
-	out[1]  = in[5];
-	out[2]  = in[10];
-	out[3]  = in[15];
-	out[4]  = in[4];
-	out[5]  = in[9];
-	out[6]  = in[14];
-	out[7]  = in[3];
-	out[8]  = in[8];
-	out[9]  = in[13];
-	out[10] = in[2];
-	out[11] = in[7];
-	out[12] = in[12];
-	out[13] = in[1];
-	out[14] = in[6];
-	out[15] = in[11];
-}
-
-static void MixColumns(unsigned char *in, unsigned char *out)
-{
-	out[0] = dot2_table[in[0]] ^ dot3_table[in[1]] ^ in[2] ^ in[3];
-	out[1] = in[0] ^ dot2_table[in[1]] ^ dot3_table[in[2]] ^ in[3];
-	out[2] = in[0] ^ in[1] ^ dot2_table[in[2]] ^ dot3_table[in[3]];
-	out[3] = dot3_table[in[0]] ^ in[1] ^ in[2] ^ dot2_table[in[3]];
-}
-
-static void AESv128(unsigned char *key, unsigned char *data, unsigned char *ciphertext)
-{
-	int  i;
-	int  round;
-	unsigned char TmpdataA[16];
-	unsigned char TmpdataB[16];
-	unsigned char abyRoundKey[16];
-
-	for (i = 0; i < 16; i++)
-		abyRoundKey[i] = key[i];
-
-	for (round = 0; round < 11; round++) {
-		if (round == 0) {
-			xor_128(abyRoundKey, data, ciphertext);
-			AddRoundKey(abyRoundKey, round);
-		} else if (round == 10) {
-			SubBytes(ciphertext, TmpdataA);
-			ShiftRows(TmpdataA, TmpdataB);
-			xor_128(TmpdataB, abyRoundKey, ciphertext);
-		} else /* round 1 ~ 9 */{
-			SubBytes(ciphertext, TmpdataA);
-			ShiftRows(TmpdataA, TmpdataB);
-			MixColumns(&TmpdataB[0], &TmpdataA[0]);
-			MixColumns(&TmpdataB[4], &TmpdataA[4]);
-			MixColumns(&TmpdataB[8], &TmpdataA[8]);
-			MixColumns(&TmpdataB[12], &TmpdataA[12]);
-			xor_128(TmpdataA, abyRoundKey, ciphertext);
-			AddRoundKey(abyRoundKey, round);
-		}
-	}
-}
-
-/*
- * Description: AES decryption
- *
- * Parameters:
- *  In:
- *      pbyRxKey            - The key used to decrypt
- *      pbyFrame            - Starting address of packet header
- *      wFrameSize          - Total packet size including CRC
- *  Out:
- *      none
- *
- * Return Value: MIC compare result
- *
- */
-bool AESbGenCCMP(unsigned char *pbyRxKey, unsigned char *pbyFrame, unsigned short wFrameSize)
-{
-	unsigned char abyNonce[13];
-	unsigned char MIC_IV[16];
-	unsigned char MIC_HDR1[16];
-	unsigned char MIC_HDR2[16];
-	unsigned char abyMIC[16];
-	unsigned char abyCTRPLD[16];
-	unsigned char abyTmp[16];
-	unsigned char abyPlainText[16];
-	unsigned char abyLastCipher[16];
-
-	PS802_11Header  pMACHeader = (PS802_11Header) pbyFrame;
-	unsigned char *pbyIV;
-	unsigned char *pbyPayload;
-	unsigned short wHLen = 22;
-	unsigned short wPayloadSize = wFrameSize - 8 - 8 - 4 - WLAN_HDR_ADDR3_LEN;/* 8 is IV, 8 is MIC, 4 is CRC */
-	bool bA4 = false;
-	unsigned char byTmp;
-	unsigned short wCnt;
-	int ii, jj, kk;
-
-	pbyIV = pbyFrame + WLAN_HDR_ADDR3_LEN;
-	if (WLAN_GET_FC_TODS(*(unsigned short *)pbyFrame) &&
-	    WLAN_GET_FC_FROMDS(*(unsigned short *)pbyFrame)) {
-		bA4 = true;
-		pbyIV += 6;             /* 6 is 802.11 address4 */
-		wHLen += 6;
-		wPayloadSize -= 6;
-	}
-	pbyPayload = pbyIV + 8; /* IV-length */
-
-	abyNonce[0]  = 0x00; /* now is 0, if Qos here will be priority */
-	memcpy(&(abyNonce[1]), pMACHeader->abyAddr2, ETH_ALEN);
-	abyNonce[7]  = pbyIV[7];
-	abyNonce[8]  = pbyIV[6];
-	abyNonce[9]  = pbyIV[5];
-	abyNonce[10] = pbyIV[4];
-	abyNonce[11] = pbyIV[1];
-	abyNonce[12] = pbyIV[0];
-
-	/* MIC_IV */
-	MIC_IV[0] = 0x59;
-	memcpy(&(MIC_IV[1]), &(abyNonce[0]), 13);
-	MIC_IV[14] = (unsigned char)(wPayloadSize >> 8);
-	MIC_IV[15] = (unsigned char)(wPayloadSize & 0xff);
-
-	/* MIC_HDR1 */
-	MIC_HDR1[0] = (unsigned char)(wHLen >> 8);
-	MIC_HDR1[1] = (unsigned char)(wHLen & 0xff);
-	byTmp = (unsigned char)(pMACHeader->wFrameCtl & 0xff);
-	MIC_HDR1[2] = byTmp & 0x8f;
-	byTmp = (unsigned char)(pMACHeader->wFrameCtl >> 8);
-	byTmp &= 0x87;
-	MIC_HDR1[3] = byTmp | 0x40;
-	memcpy(&(MIC_HDR1[4]), pMACHeader->abyAddr1, ETH_ALEN);
-	memcpy(&(MIC_HDR1[10]), pMACHeader->abyAddr2, ETH_ALEN);
-
-	/* MIC_HDR2 */
-	memcpy(&(MIC_HDR2[0]), pMACHeader->abyAddr3, ETH_ALEN);
-	byTmp = (unsigned char)(pMACHeader->wSeqCtl & 0xff);
-	MIC_HDR2[6] = byTmp & 0x0f;
-	MIC_HDR2[7] = 0;
-	if (bA4) {
-		memcpy(&(MIC_HDR2[8]), pMACHeader->abyAddr4, ETH_ALEN);
-	} else {
-		MIC_HDR2[8]  = 0x00;
-		MIC_HDR2[9]  = 0x00;
-		MIC_HDR2[10] = 0x00;
-		MIC_HDR2[11] = 0x00;
-		MIC_HDR2[12] = 0x00;
-		MIC_HDR2[13] = 0x00;
-	}
-	MIC_HDR2[14] = 0x00;
-	MIC_HDR2[15] = 0x00;
-
-	/* CCMP */
-	AESv128(pbyRxKey, MIC_IV, abyMIC);
-	for (kk = 0; kk < 16; kk++)
-		abyTmp[kk] = MIC_HDR1[kk] ^ abyMIC[kk];
-	AESv128(pbyRxKey, abyTmp, abyMIC);
-	for (kk = 0; kk < 16; kk++)
-		abyTmp[kk] = MIC_HDR2[kk] ^ abyMIC[kk];
-	AESv128(pbyRxKey, abyTmp, abyMIC);
-
-	wCnt = 1;
-	abyCTRPLD[0] = 0x01;
-	memcpy(&(abyCTRPLD[1]), &(abyNonce[0]), 13);
-
-	for (jj = wPayloadSize; jj > 16; jj = jj - 16) {
-		abyCTRPLD[14] = (unsigned char)(wCnt >> 8);
-		abyCTRPLD[15] = (unsigned char)(wCnt & 0xff);
-
-		AESv128(pbyRxKey, abyCTRPLD, abyTmp);
-
-		for (kk = 0; kk < 16; kk++)
-			abyPlainText[kk] = abyTmp[kk] ^ pbyPayload[kk];
-		for (kk = 0; kk < 16; kk++)
-			abyTmp[kk] = abyMIC[kk] ^ abyPlainText[kk];
-		AESv128(pbyRxKey, abyTmp, abyMIC);
-
-		memcpy(pbyPayload, abyPlainText, 16);
-		wCnt++;
-		pbyPayload += 16;
-	} /* for wPayloadSize */
-
-	/* last payload */
-	memcpy(&(abyLastCipher[0]), pbyPayload, jj);
-	for (ii = jj; ii < 16; ii++)
-		abyLastCipher[ii] = 0x00;
-
-	abyCTRPLD[14] = (unsigned char)(wCnt >> 8);
-	abyCTRPLD[15] = (unsigned char)(wCnt & 0xff);
-
-	AESv128(pbyRxKey, abyCTRPLD, abyTmp);
-	for (kk = 0; kk < 16; kk++)
-		abyPlainText[kk] = abyTmp[kk] ^ abyLastCipher[kk];
-	memcpy(pbyPayload, abyPlainText, jj);
-	pbyPayload += jj;
-
-	/* for MIC calculation */
-	for (ii = jj; ii < 16; ii++)
-		abyPlainText[ii] = 0x00;
-	for (kk = 0; kk < 16; kk++)
-		abyTmp[kk] = abyMIC[kk] ^ abyPlainText[kk];
-	AESv128(pbyRxKey, abyTmp, abyMIC);
-
-	/* =>above is the calculate MIC */
-	/* -------------------------------------------- */
-
-	wCnt = 0;
-	abyCTRPLD[14] = (unsigned char)(wCnt >> 8);
-	abyCTRPLD[15] = (unsigned char)(wCnt & 0xff);
-	AESv128(pbyRxKey, abyCTRPLD, abyTmp);
-	for (kk = 0; kk < 8; kk++)
-		abyTmp[kk] = abyTmp[kk] ^ pbyPayload[kk];
-	/* =>above is the dec-MIC from packet */
-	/* -------------------------------------------- */
-
-	return !memcmp(abyMIC, abyTmp, 8);
-}
diff --git a/drivers/staging/vt6655/aes_ccmp.h b/drivers/staging/vt6655/aes_ccmp.h
deleted file mode 100644
index fe0c506..0000000
--- a/drivers/staging/vt6655/aes_ccmp.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * Copyright (c) 1996, 2003 VIA Networking Technologies, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- *
- * File: aes_ccmp.h
- *
- * Purpose: AES_CCMP Decryption
- *
- * Author: Warren Hsu
- *
- * Date: Feb 15, 2005
- *
- */
-
-#ifndef __AES_H__
-#define __AES_H__
-
-#include "ttype.h"
-
-bool AESbGenCCMP(unsigned char *pbyRxKey, unsigned char *pbyFrame, unsigned short wFrameSize);
-
-#endif /* __AES_H__ */
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index a3020d7..c83b9c2 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -78,7 +78,6 @@
 #include "wcmd.h"
 #include "mib.h"
 #include "srom.h"
-#include "rc4.h"
 #include "desc.h"
 #include "key.h"
 #include "mac.h"
@@ -553,7 +552,6 @@ struct vnt_private {
 	u64 qwPacketNumber; /* For CCMP and TKIP as TSC(6 bytes) */
 	unsigned int	uCurrentWEPMode;
 
-	RC4Ext                  SBox;
 	unsigned char abyPRNG[WLAN_WEPMAX_KEYLEN+3];
 	unsigned char byKeyIndex;
 	unsigned int	uKeyLength;
diff --git a/drivers/staging/vt6655/rc4.c b/drivers/staging/vt6655/rc4.c
deleted file mode 100644
index b7819bc..0000000
--- a/drivers/staging/vt6655/rc4.c
+++ /dev/null
@@ -1,88 +0,0 @@
-/*
- * Copyright (c) 1996, 2003 VIA Networking Technologies, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- * File: rc4.c
- *
- * Purpose:
- *
- * Functions:
- *
- * Revision History:
- *
- * Author: Kyle Hsu
- *
- * Date: Sep 4, 2002
- *
- */
-
-#include "rc4.h"
-
-void rc4_init(PRC4Ext pRC4, unsigned char *pbyKey, unsigned int cbKey_len)
-{
-	unsigned int ust1, ust2;
-	unsigned int keyindex;
-	unsigned int stateindex;
-	unsigned char *pbyst;
-	unsigned int idx;
-
-	pbyst = pRC4->abystate;
-	pRC4->ux = 0;
-	pRC4->uy = 0;
-	for (idx = 0; idx < 256; idx++)
-		pbyst[idx] = (unsigned char)idx;
-	keyindex = 0;
-	stateindex = 0;
-	for (idx = 0; idx < 256; idx++) {
-		ust1 = pbyst[idx];
-		stateindex = (stateindex + pbyKey[keyindex] + ust1) & 0xff;
-		ust2 = pbyst[stateindex];
-		pbyst[stateindex] = (unsigned char)ust1;
-		pbyst[idx] = (unsigned char)ust2;
-		if (++keyindex >= cbKey_len)
-			keyindex = 0;
-	}
-}
-
-unsigned int rc4_byte(PRC4Ext pRC4)
-{
-	unsigned int ux;
-	unsigned int uy;
-	unsigned int ustx, usty;
-	unsigned char *pbyst;
-
-	pbyst = pRC4->abystate;
-	ux = (pRC4->ux + 1) & 0xff;
-	ustx = pbyst[ux];
-	uy = (ustx + pRC4->uy) & 0xff;
-	usty = pbyst[uy];
-	pRC4->ux = ux;
-	pRC4->uy = uy;
-	pbyst[uy] = (unsigned char)ustx;
-	pbyst[ux] = (unsigned char)usty;
-
-	return pbyst[(ustx + usty) & 0xff];
-}
-
-void rc4_encrypt(PRC4Ext pRC4, unsigned char *pbyDest,
-		 unsigned char *pbySrc, unsigned int cbData_len)
-{
-	unsigned int ii;
-
-	for (ii = 0; ii < cbData_len; ii++)
-		pbyDest[ii] = (unsigned char)(pbySrc[ii] ^ rc4_byte(pRC4));
-}
diff --git a/drivers/staging/vt6655/rc4.h b/drivers/staging/vt6655/rc4.h
deleted file mode 100644
index 74b2eed..0000000
--- a/drivers/staging/vt6655/rc4.h
+++ /dev/null
@@ -1,47 +0,0 @@
-/*
- * File: rc4.h
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- * Purpose:
- *
- * Functions:
- *
- * Revision History:
- *
- * Author: Kyle Hsu
- *
- * Date: Sep 4, 2002
- *
- */
-
-#ifndef __RC4_H__
-#define __RC4_H__
-
-#include "ttype.h"
-
-/*---------------------  Export Definitions -------------------------*/
-/*---------------------  Export Types  ------------------------------*/
-typedef struct {
-	unsigned int ux;
-	unsigned int uy;
-	unsigned char abystate[256];
-} RC4Ext, *PRC4Ext;
-
-void rc4_init(PRC4Ext pRC4, unsigned char *pbyKey, unsigned int cbKey_len);
-unsigned int rc4_byte(PRC4Ext pRC4);
-void rc4_encrypt(PRC4Ext pRC4, unsigned char *pbyDest, unsigned char *pbySrc, unsigned int cbData_len);
-
-#endif //__RC4_H__
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 6ae8594..5ece2db 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -56,7 +56,6 @@
 #include "mac.h"
 #include "baseband.h"
 #include "michael.h"
-#include "tkip.h"
 #include "tcrc.h"
 #include "wctl.h"
 #include "rf.h"
diff --git a/drivers/staging/vt6655/tkip.c b/drivers/staging/vt6655/tkip.c
deleted file mode 100644
index f758d02..0000000
--- a/drivers/staging/vt6655/tkip.c
+++ /dev/null
@@ -1,268 +0,0 @@
-/*
- * Copyright (c) 1996, 2003 VIA Networking Technologies, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- *
- * File: tkip.c
- *
- * Purpose: Implement functions for 802.11i TKIP
- *
- * Author: Jerry Chen
- *
- * Date: Mar. 11, 2003
- *
- * Functions:
- *      TKIPvMixKey - Get TKIP RC4 Key from TK,TA, and TSC
- *
- * Revision History:
- *
- */
-
-#include "tmacro.h"
-#include "tkip.h"
-
-/*---------------------  Static Definitions -------------------------*/
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
-/*---------------------  Static Functions  --------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Static Definitions -------------------------*/
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
-/* The Sbox is reduced to 2 16-bit wide tables, each with 256 entries. */
-/* The 2nd table is the same as the 1st but with the upper and lower   */
-/* bytes swapped. To allow an endian tolerant implementation, the byte */
-/* halves have been expressed independently here.                      */
-static const unsigned char TKIP_Sbox_Lower[256] = {
-	0xA5, 0x84, 0x99, 0x8D, 0x0D, 0xBD, 0xB1, 0x54,
-	0x50, 0x03, 0xA9, 0x7D, 0x19, 0x62, 0xE6, 0x9A,
-	0x45, 0x9D, 0x40, 0x87, 0x15, 0xEB, 0xC9, 0x0B,
-	0xEC, 0x67, 0xFD, 0xEA, 0xBF, 0xF7, 0x96, 0x5B,
-	0xC2, 0x1C, 0xAE, 0x6A, 0x5A, 0x41, 0x02, 0x4F,
-	0x5C, 0xF4, 0x34, 0x08, 0x93, 0x73, 0x53, 0x3F,
-	0x0C, 0x52, 0x65, 0x5E, 0x28, 0xA1, 0x0F, 0xB5,
-	0x09, 0x36, 0x9B, 0x3D, 0x26, 0x69, 0xCD, 0x9F,
-	0x1B, 0x9E, 0x74, 0x2E, 0x2D, 0xB2, 0xEE, 0xFB,
-	0xF6, 0x4D, 0x61, 0xCE, 0x7B, 0x3E, 0x71, 0x97,
-	0xF5, 0x68, 0x00, 0x2C, 0x60, 0x1F, 0xC8, 0xED,
-	0xBE, 0x46, 0xD9, 0x4B, 0xDE, 0xD4, 0xE8, 0x4A,
-	0x6B, 0x2A, 0xE5, 0x16, 0xC5, 0xD7, 0x55, 0x94,
-	0xCF, 0x10, 0x06, 0x81, 0xF0, 0x44, 0xBA, 0xE3,
-	0xF3, 0xFE, 0xC0, 0x8A, 0xAD, 0xBC, 0x48, 0x04,
-	0xDF, 0xC1, 0x75, 0x63, 0x30, 0x1A, 0x0E, 0x6D,
-	0x4C, 0x14, 0x35, 0x2F, 0xE1, 0xA2, 0xCC, 0x39,
-	0x57, 0xF2, 0x82, 0x47, 0xAC, 0xE7, 0x2B, 0x95,
-	0xA0, 0x98, 0xD1, 0x7F, 0x66, 0x7E, 0xAB, 0x83,
-	0xCA, 0x29, 0xD3, 0x3C, 0x79, 0xE2, 0x1D, 0x76,
-	0x3B, 0x56, 0x4E, 0x1E, 0xDB, 0x0A, 0x6C, 0xE4,
-	0x5D, 0x6E, 0xEF, 0xA6, 0xA8, 0xA4, 0x37, 0x8B,
-	0x32, 0x43, 0x59, 0xB7, 0x8C, 0x64, 0xD2, 0xE0,
-	0xB4, 0xFA, 0x07, 0x25, 0xAF, 0x8E, 0xE9, 0x18,
-	0xD5, 0x88, 0x6F, 0x72, 0x24, 0xF1, 0xC7, 0x51,
-	0x23, 0x7C, 0x9C, 0x21, 0xDD, 0xDC, 0x86, 0x85,
-	0x90, 0x42, 0xC4, 0xAA, 0xD8, 0x05, 0x01, 0x12,
-	0xA3, 0x5F, 0xF9, 0xD0, 0x91, 0x58, 0x27, 0xB9,
-	0x38, 0x13, 0xB3, 0x33, 0xBB, 0x70, 0x89, 0xA7,
-	0xB6, 0x22, 0x92, 0x20, 0x49, 0xFF, 0x78, 0x7A,
-	0x8F, 0xF8, 0x80, 0x17, 0xDA, 0x31, 0xC6, 0xB8,
-	0xC3, 0xB0, 0x77, 0x11, 0xCB, 0xFC, 0xD6, 0x3A
-};
-
-static const unsigned char TKIP_Sbox_Upper[256] = {
-	0xC6, 0xF8, 0xEE, 0xF6, 0xFF, 0xD6, 0xDE, 0x91,
-	0x60, 0x02, 0xCE, 0x56, 0xE7, 0xB5, 0x4D, 0xEC,
-	0x8F, 0x1F, 0x89, 0xFA, 0xEF, 0xB2, 0x8E, 0xFB,
-	0x41, 0xB3, 0x5F, 0x45, 0x23, 0x53, 0xE4, 0x9B,
-	0x75, 0xE1, 0x3D, 0x4C, 0x6C, 0x7E, 0xF5, 0x83,
-	0x68, 0x51, 0xD1, 0xF9, 0xE2, 0xAB, 0x62, 0x2A,
-	0x08, 0x95, 0x46, 0x9D, 0x30, 0x37, 0x0A, 0x2F,
-	0x0E, 0x24, 0x1B, 0xDF, 0xCD, 0x4E, 0x7F, 0xEA,
-	0x12, 0x1D, 0x58, 0x34, 0x36, 0xDC, 0xB4, 0x5B,
-	0xA4, 0x76, 0xB7, 0x7D, 0x52, 0xDD, 0x5E, 0x13,
-	0xA6, 0xB9, 0x00, 0xC1, 0x40, 0xE3, 0x79, 0xB6,
-	0xD4, 0x8D, 0x67, 0x72, 0x94, 0x98, 0xB0, 0x85,
-	0xBB, 0xC5, 0x4F, 0xED, 0x86, 0x9A, 0x66, 0x11,
-	0x8A, 0xE9, 0x04, 0xFE, 0xA0, 0x78, 0x25, 0x4B,
-	0xA2, 0x5D, 0x80, 0x05, 0x3F, 0x21, 0x70, 0xF1,
-	0x63, 0x77, 0xAF, 0x42, 0x20, 0xE5, 0xFD, 0xBF,
-	0x81, 0x18, 0x26, 0xC3, 0xBE, 0x35, 0x88, 0x2E,
-	0x93, 0x55, 0xFC, 0x7A, 0xC8, 0xBA, 0x32, 0xE6,
-	0xC0, 0x19, 0x9E, 0xA3, 0x44, 0x54, 0x3B, 0x0B,
-	0x8C, 0xC7, 0x6B, 0x28, 0xA7, 0xBC, 0x16, 0xAD,
-	0xDB, 0x64, 0x74, 0x14, 0x92, 0x0C, 0x48, 0xB8,
-	0x9F, 0xBD, 0x43, 0xC4, 0x39, 0x31, 0xD3, 0xF2,
-	0xD5, 0x8B, 0x6E, 0xDA, 0x01, 0xB1, 0x9C, 0x49,
-	0xD8, 0xAC, 0xF3, 0xCF, 0xCA, 0xF4, 0x47, 0x10,
-	0x6F, 0xF0, 0x4A, 0x5C, 0x38, 0x57, 0x73, 0x97,
-	0xCB, 0xA1, 0xE8, 0x3E, 0x96, 0x61, 0x0D, 0x0F,
-	0xE0, 0x7C, 0x71, 0xCC, 0x90, 0x06, 0xF7, 0x1C,
-	0xC2, 0x6A, 0xAE, 0x69, 0x17, 0x99, 0x3A, 0x27,
-	0xD9, 0xEB, 0x2B, 0x22, 0xD2, 0xA9, 0x07, 0x33,
-	0x2D, 0x3C, 0x15, 0xC9, 0x87, 0xAA, 0x50, 0xA5,
-	0x03, 0x59, 0x09, 0x1A, 0x65, 0xD7, 0x84, 0xD0,
-	0x82, 0x29, 0x5A, 0x1E, 0x7B, 0xA8, 0x6D, 0x2C
-};
-
-//STKIPKeyManagement  sTKIPKeyTable[MAX_TKIP_KEY];
-
-/*---------------------  Static Functions  --------------------------*/
-unsigned int tkip_sbox(unsigned int index);
-unsigned int rotr1(unsigned int a);
-
-/*---------------------  Export Variables  --------------------------*/
-
-/************************************************************/
-/* tkip_sbox()                                              */
-/* Returns a 16 bit value from a 64K entry table. The Table */
-/* is synthesized from two 256 entry byte wide tables.      */
-/************************************************************/
-unsigned int tkip_sbox(unsigned int index)
-{
-	unsigned int index_low;
-	unsigned int index_high;
-	unsigned int left, right;
-
-	index_low = (index % 256);
-	index_high = ((index >> 8) % 256);
-
-	left = TKIP_Sbox_Lower[index_low] + (TKIP_Sbox_Upper[index_low] * 256);
-	right = TKIP_Sbox_Upper[index_high] + (TKIP_Sbox_Lower[index_high] * 256);
-
-	return left ^ right;
-};
-
-unsigned int rotr1(unsigned int a)
-{
-	unsigned int b;
-
-	if ((a & 0x01) == 0x01)
-		b = (a >> 1) | 0x8000;
-	else
-		b = (a >> 1) & 0x7fff;
-
-	b = b % 65536;
-	return b;
-}
-
-/*
- * Description: Calculate RC4Key fom TK, TA, and TSC
- *
- * Parameters:
- *  In:
- *      pbyTKey         - TKey
- *      pbyTA           - TA
- *      dwTSC           - TSC
- *  Out:
- *      pbyRC4Key       - RC4Key
- *
- * Return Value: none
- *
- */
-void TKIPvMixKey(
-	unsigned char *pbyTKey,
-	unsigned char *pbyTA,
-	unsigned short wTSC15_0,
-	unsigned long dwTSC47_16,
-	unsigned char *pbyRC4Key
-)
-{
-	unsigned int p1k[5];
-	unsigned int tsc0, tsc1, tsc2;
-	unsigned int ppk0, ppk1, ppk2, ppk3, ppk4, ppk5;
-	unsigned long int pnl, pnh;
-
-	int i, j;
-
-	pnl = wTSC15_0;
-	pnh = dwTSC47_16;
-
-	tsc0 = (unsigned int)((pnh >> 16) % 65536); /* msb */
-	tsc1 = (unsigned int)(pnh % 65536);
-	tsc2 = (unsigned int)(pnl % 65536); /* lsb */
-
-	/* Phase 1, step 1 */
-	p1k[0] = tsc1;
-	p1k[1] = tsc0;
-	p1k[2] = (unsigned int)(pbyTA[0] + (pbyTA[1]*256));
-	p1k[3] = (unsigned int)(pbyTA[2] + (pbyTA[3]*256));
-	p1k[4] = (unsigned int)(pbyTA[4] + (pbyTA[5]*256));
-
-	/* Phase 1, step 2 */
-	for (i = 0; i < 8; i++) {
-		j = 2 * (i & 1);
-		p1k[0] = (p1k[0] + tkip_sbox((p1k[4] ^ ((256*pbyTKey[1+j]) + pbyTKey[j])) % 65536)) % 65536;
-		p1k[1] = (p1k[1] + tkip_sbox((p1k[0] ^ ((256*pbyTKey[5+j]) + pbyTKey[4+j])) % 65536)) % 65536;
-		p1k[2] = (p1k[2] + tkip_sbox((p1k[1] ^ ((256*pbyTKey[9+j]) + pbyTKey[8+j])) % 65536)) % 65536;
-		p1k[3] = (p1k[3] + tkip_sbox((p1k[2] ^ ((256*pbyTKey[13+j]) + pbyTKey[12+j])) % 65536)) % 65536;
-		p1k[4] = (p1k[4] + tkip_sbox((p1k[3] ^ (((256*pbyTKey[1+j]) + pbyTKey[j]))) % 65536)) % 65536;
-		p1k[4] = (p1k[4] + i) % 65536;
-	}
-	/* Phase 2, Step 1 */
-	ppk0 = p1k[0];
-	ppk1 = p1k[1];
-	ppk2 = p1k[2];
-	ppk3 = p1k[3];
-	ppk4 = p1k[4];
-	ppk5 = (p1k[4] + tsc2) % 65536;
-
-	/* Phase2, Step 2 */
-	ppk0 = ppk0 + tkip_sbox((ppk5 ^ ((256*pbyTKey[1]) + pbyTKey[0])) % 65536);
-	ppk1 = ppk1 + tkip_sbox((ppk0 ^ ((256*pbyTKey[3]) + pbyTKey[2])) % 65536);
-	ppk2 = ppk2 + tkip_sbox((ppk1 ^ ((256*pbyTKey[5]) + pbyTKey[4])) % 65536);
-	ppk3 = ppk3 + tkip_sbox((ppk2 ^ ((256*pbyTKey[7]) + pbyTKey[6])) % 65536);
-	ppk4 = ppk4 + tkip_sbox((ppk3 ^ ((256*pbyTKey[9]) + pbyTKey[8])) % 65536);
-	ppk5 = ppk5 + tkip_sbox((ppk4 ^ ((256*pbyTKey[11]) + pbyTKey[10])) % 65536);
-
-	ppk0 = ppk0 + rotr1(ppk5 ^ ((256*pbyTKey[13]) + pbyTKey[12]));
-	ppk1 = ppk1 + rotr1(ppk0 ^ ((256*pbyTKey[15]) + pbyTKey[14]));
-	ppk2 = ppk2 + rotr1(ppk1);
-	ppk3 = ppk3 + rotr1(ppk2);
-	ppk4 = ppk4 + rotr1(ppk3);
-	ppk5 = ppk5 + rotr1(ppk4);
-
-	/* Phase 2, Step 3 */
-	pbyRC4Key[0] = (tsc2 >> 8) % 256;
-	pbyRC4Key[1] = (((tsc2 >> 8) % 256) | 0x20) & 0x7f;
-	pbyRC4Key[2] = tsc2 % 256;
-	pbyRC4Key[3] = ((ppk5 ^ ((256*pbyTKey[1]) + pbyTKey[0])) >> 1) % 256;
-
-	pbyRC4Key[4] = ppk0 % 256;
-	pbyRC4Key[5] = (ppk0 >> 8) % 256;
-
-	pbyRC4Key[6] = ppk1 % 256;
-	pbyRC4Key[7] = (ppk1 >> 8) % 256;
-
-	pbyRC4Key[8] = ppk2 % 256;
-	pbyRC4Key[9] = (ppk2 >> 8) % 256;
-
-	pbyRC4Key[10] = ppk3 % 256;
-	pbyRC4Key[11] = (ppk3 >> 8) % 256;
-
-	pbyRC4Key[12] = ppk4 % 256;
-	pbyRC4Key[13] = (ppk4 >> 8) % 256;
-
-	pbyRC4Key[14] = ppk5 % 256;
-	pbyRC4Key[15] = (ppk5 >> 8) % 256;
-}
diff --git a/drivers/staging/vt6655/tkip.h b/drivers/staging/vt6655/tkip.h
deleted file mode 100644
index 3b6357ac..0000000
--- a/drivers/staging/vt6655/tkip.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
- * Copyright (c) 1996, 2003 VIA Networking Technologies, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- *
- * File: tkip.h
- *
- * Purpose: Implement functions for 802.11i TKIP
- *
- * Author: Jerry Chen
- *
- * Date: Mar. 11, 2003
- *
- */
-
-#ifndef __TKIP_H__
-#define __TKIP_H__
-
-#include "ttype.h"
-#include "tether.h"
-
-/*---------------------  Export Definitions -------------------------*/
-#define TKIP_KEY_LEN        16
-
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Macros ------------------------------*/
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-void TKIPvMixKey(
-	unsigned char *pbyTKey,
-	unsigned char *pbyTA,
-	unsigned short wTSC15_0,
-	unsigned long dwTSC47_16,
-	unsigned char *pbyRC4Key
-);
-
-#endif // __TKIP_H__
-- 
1.9.1

