Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:37587 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaKGTGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:06:44 -0500
Received: by mail-wg0-f45.google.com with SMTP id x12so4475299wgg.4
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2014 11:06:43 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/10] staging: vt6655: s_vCalculateOFDMRParameter use bb_type for CARD_PHY_TYPE
Date: Fri,  7 Nov 2014 19:06:04 +0000
Message-Id: <1415387169-3843-5-git-send-email-tvboxspy@gmail.com> (sfid-20141107_200648_767032_65C0461E)
In-Reply-To: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
References: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

using u8 for bb_type and replacing PHY_TYPE_11A with BB_TYPE_11A

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 24ba9d4..e6e5f63 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -78,7 +78,7 @@ static
 void
 s_vCalculateOFDMRParameter(
 	unsigned char byRate,
-	CARD_PHY_TYPE ePHYType,
+	u8 bb_type,
 	unsigned char *pbyTxRate,
 	unsigned char *pbyRsvTime
 );
@@ -102,14 +102,14 @@ static
 void
 s_vCalculateOFDMRParameter(
 	unsigned char byRate,
-	CARD_PHY_TYPE ePHYType,
+	u8 bb_type,
 	unsigned char *pbyTxRate,
 	unsigned char *pbyRsvTime
 )
 {
 	switch (byRate) {
 	case RATE_6M:
-		if (ePHYType == PHY_TYPE_11A) { /* 5GHZ */
+		if (bb_type == BB_TYPE_11A) { /* 5GHZ */
 			*pbyTxRate = 0x9B;
 			*pbyRsvTime = 44;
 		} else {
@@ -119,7 +119,7 @@ s_vCalculateOFDMRParameter(
 		break;
 
 	case RATE_9M:
-		if (ePHYType == PHY_TYPE_11A) { /* 5GHZ */
+		if (bb_type == BB_TYPE_11A) { /* 5GHZ */
 			*pbyTxRate = 0x9F;
 			*pbyRsvTime = 36;
 		} else {
@@ -129,7 +129,7 @@ s_vCalculateOFDMRParameter(
 		break;
 
 	case RATE_12M:
-		if (ePHYType == PHY_TYPE_11A) { /* 5GHZ */
+		if (bb_type == BB_TYPE_11A) { /* 5GHZ */
 			*pbyTxRate = 0x9A;
 			*pbyRsvTime = 32;
 		} else {
@@ -139,7 +139,7 @@ s_vCalculateOFDMRParameter(
 		break;
 
 	case RATE_18M:
-		if (ePHYType == PHY_TYPE_11A) { /* 5GHZ */
+		if (bb_type == BB_TYPE_11A) { /* 5GHZ */
 			*pbyTxRate = 0x9E;
 			*pbyRsvTime = 28;
 		} else {
@@ -149,7 +149,7 @@ s_vCalculateOFDMRParameter(
 		break;
 
 	case RATE_36M:
-		if (ePHYType == PHY_TYPE_11A) { /* 5GHZ */
+		if (bb_type == BB_TYPE_11A) { /* 5GHZ */
 			*pbyTxRate = 0x9D;
 			*pbyRsvTime = 24;
 		} else {
@@ -159,7 +159,7 @@ s_vCalculateOFDMRParameter(
 		break;
 
 	case RATE_48M:
-		if (ePHYType == PHY_TYPE_11A) { /* 5GHZ */
+		if (bb_type == BB_TYPE_11A) { /* 5GHZ */
 			*pbyTxRate = 0x98;
 			*pbyRsvTime = 24;
 		} else {
@@ -169,7 +169,7 @@ s_vCalculateOFDMRParameter(
 		break;
 
 	case RATE_54M:
-		if (ePHYType == PHY_TYPE_11A) { /* 5GHZ */
+		if (bb_type == BB_TYPE_11A) { /* 5GHZ */
 			*pbyTxRate = 0x9C;
 			*pbyRsvTime = 24;
 		} else {
@@ -180,7 +180,7 @@ s_vCalculateOFDMRParameter(
 
 	case RATE_24M:
 	default:
-		if (ePHYType == PHY_TYPE_11A) { /* 5GHZ */
+		if (bb_type == BB_TYPE_11A) { /* 5GHZ */
 			*pbyTxRate = 0x99;
 			*pbyRsvTime = 28;
 		} else {
-- 
2.1.0

