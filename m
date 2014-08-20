Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42013 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaHTVb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 17:31:59 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so8241877wgh.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 Aug 2014 14:31:57 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/6] staging: vt6655: add new stucture struct vnt_phy_field for rts/cts/data structures
Date: Wed, 20 Aug 2014 22:30:27 +0100
Message-Id: <1408570231-10320-2-git-send-email-tvboxspy@gmail.com> (sfid-20140820_233203_545519_7F4A7C49)
In-Reply-To: <1408570231-10320-1-git-send-email-tvboxspy@gmail.com>
References: <1408570231-10320-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will replace bySignalField*, byServiceField* and wTransmitLength_b
members of these strutures, these are removed in the last patch.

The len member is of little endian type.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index d3c9b0c..1dd38f7 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -377,7 +377,16 @@ typedef struct tagSRTSData {
 SRTSData, *PSRTSData;
 typedef const SRTSData *PCSRTSData;
 
+/* Length, Service, and Signal fields of Phy for Tx */
+struct vnt_phy_field {
+	u8 signal;
+	u8 service;
+	__le16 len;
+} __packed;
+
 typedef struct tagSRTS_g {
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
 	unsigned char bySignalField_b;
 	unsigned char byServiceField_b;
 	unsigned short wTransmitLength_b;
@@ -394,6 +403,8 @@ SRTS_g, *PSRTS_g;
 typedef const SRTS_g *PCSRTS_g;
 
 typedef struct tagSRTS_g_FB {
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
 	unsigned char bySignalField_b;
 	unsigned char byServiceField_b;
 	unsigned short wTransmitLength_b;
@@ -414,6 +425,7 @@ SRTS_g_FB, *PSRTS_g_FB;
 typedef const SRTS_g_FB *PCSRTS_g_FB;
 
 typedef struct tagSRTS_ab {
+	struct vnt_phy_field ab;
 	unsigned char bySignalField;
 	unsigned char byServiceField;
 	unsigned short wTransmitLength;
@@ -425,6 +437,7 @@ SRTS_ab, *PSRTS_ab;
 typedef const SRTS_ab *PCSRTS_ab;
 
 typedef struct tagSRTS_a_FB {
+	struct vnt_phy_field a;
 	unsigned char bySignalField;
 	unsigned char byServiceField;
 	unsigned short wTransmitLength;
@@ -449,6 +462,7 @@ typedef struct tagSCTSData {
 SCTSData, *PSCTSData;
 
 typedef struct tagSCTS {
+	struct vnt_phy_field b;
 	unsigned char bySignalField_b;
 	unsigned char byServiceField_b;
 	unsigned short wTransmitLength_b;
@@ -460,6 +474,7 @@ SCTS, *PSCTS;
 typedef const SCTS *PCSCTS;
 
 typedef struct tagSCTS_FB {
+	struct vnt_phy_field b;
 	unsigned char bySignalField_b;
 	unsigned char byServiceField_b;
 	unsigned short wTransmitLength_b;
@@ -497,6 +512,8 @@ typedef const STxShortBufHead *PCSTxShortBufHead;
 // Tx data header
 //
 typedef struct tagSTxDataHead_g {
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
 	unsigned char bySignalField_b;
 	unsigned char byServiceField_b;
 	unsigned short wTransmitLength_b;
@@ -512,6 +529,8 @@ STxDataHead_g, *PSTxDataHead_g;
 typedef const STxDataHead_g *PCSTxDataHead_g;
 
 typedef struct tagSTxDataHead_g_FB {
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
 	unsigned char bySignalField_b;
 	unsigned char byServiceField_b;
 	unsigned short wTransmitLength_b;
@@ -529,6 +548,7 @@ STxDataHead_g_FB, *PSTxDataHead_g_FB;
 typedef const STxDataHead_g_FB *PCSTxDataHead_g_FB;
 
 typedef struct tagSTxDataHead_ab {
+	struct vnt_phy_field ab;
 	unsigned char bySignalField;
 	unsigned char byServiceField;
 	unsigned short wTransmitLength;
@@ -539,6 +559,7 @@ STxDataHead_ab, *PSTxDataHead_ab;
 typedef const STxDataHead_ab *PCSTxDataHead_ab;
 
 typedef struct tagSTxDataHead_a_FB {
+	struct vnt_phy_field a;
 	unsigned char bySignalField;
 	unsigned char byServiceField;
 	unsigned short wTransmitLength;
-- 
1.9.1

