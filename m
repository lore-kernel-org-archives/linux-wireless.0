Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64564 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaJYT6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:58:38 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so3096711wgh.28
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:58:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/31] staging: vt6655: mac80211 conversion: s_vFillRTSHead convert to using struct ieee80211_hdr
Date: Sat, 25 Oct 2014 09:20:16 +0100
Message-Id: <1414225241-5480-7-git-send-email-tvboxspy@gmail.com> (sfid-20141025_215844_287803_28908F06)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing PSEthernetHeader

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 91 ++++++-------------------------------------
 1 file changed, 12 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 09df536..a1a594f 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -127,7 +127,7 @@ s_vFillRTSHead(
 	unsigned int	cbFrameLength,
 	bool bNeedAck,
 	bool bDisCRC,
-	PSEthernetHeader psEthHeader,
+	struct ieee80211_hdr *hdr,
 	unsigned short wCurrentRate,
 	unsigned char byFBOption
 );
@@ -789,7 +789,7 @@ s_vFillRTSHead(
 	unsigned int cbFrameLength,
 	bool bNeedAck,
 	bool bDisCRC,
-	PSEthernetHeader psEthHeader,
+	struct ieee80211_hdr *hdr,
 	unsigned short wCurrentRate,
 	unsigned char byFBOption
 )
@@ -841,22 +841,8 @@ s_vFillRTSHead(
 					cpu_to_le16(IEEE80211_FTYPE_CTL |
 						    IEEE80211_STYPE_RTS);
 
-
-			if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
-			    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
-				ether_addr_copy(buf->data.ra,
-						psEthHeader->abyDstAddr);
-			} else {
-				ether_addr_copy(buf->data.ra,
-						pDevice->abyBSSID);
-			}
-			if (pDevice->op_mode == NL80211_IFTYPE_AP)
-				ether_addr_copy(buf->data.ta,
-						pDevice->abyBSSID);
-			else
-				ether_addr_copy(buf->data.ta,
-						psEthHeader->abySrcAddr);
-
+			ether_addr_copy(buf->data.ra, hdr->addr1);
+			ether_addr_copy(buf->data.ta, hdr->addr2);
 		} else {
 			struct vnt_rts_g_fb *buf = pvRTS;
 			/* Get SignalField, ServiceField & Length */
@@ -909,23 +895,8 @@ s_vFillRTSHead(
 					cpu_to_le16(IEEE80211_FTYPE_CTL |
 						    IEEE80211_STYPE_RTS);
 
-
-			if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
-			    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
-				ether_addr_copy(buf->data.ra,
-						psEthHeader->abyDstAddr);
-			} else {
-				ether_addr_copy(buf->data.ra,
-						pDevice->abyBSSID);
-			}
-
-			if (pDevice->op_mode == NL80211_IFTYPE_AP)
-				ether_addr_copy(buf->data.ta,
-						pDevice->abyBSSID);
-			else
-				ether_addr_copy(buf->data.ta,
-						psEthHeader->abySrcAddr);
-
+			ether_addr_copy(buf->data.ra, hdr->addr1);
+			ether_addr_copy(buf->data.ta, hdr->addr2);
 		} // if (byFBOption == AUTO_FB_NONE)
 	} else if (byPktType == PK_TYPE_11A) {
 		if (byFBOption == AUTO_FB_NONE) {
@@ -946,23 +917,8 @@ s_vFillRTSHead(
 					cpu_to_le16(IEEE80211_FTYPE_CTL |
 						    IEEE80211_STYPE_RTS);
 
-
-			if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
-			    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
-				ether_addr_copy(buf->data.ra,
-						psEthHeader->abyDstAddr);
-			} else {
-				ether_addr_copy(buf->data.ra,
-						pDevice->abyBSSID);
-			}
-
-			if (pDevice->op_mode == NL80211_IFTYPE_AP)
-				ether_addr_copy(buf->data.ta,
-						pDevice->abyBSSID);
-			else
-				ether_addr_copy(buf->data.ta,
-						psEthHeader->abySrcAddr);
-
+			ether_addr_copy(buf->data.ra, hdr->addr1);
+			ether_addr_copy(buf->data.ta, hdr->addr2);
 		} else {
 			struct vnt_rts_a_fb *buf = pvRTS;
 			/* Get SignalField, ServiceField & Length */
@@ -991,20 +947,8 @@ s_vFillRTSHead(
 					cpu_to_le16(IEEE80211_FTYPE_CTL |
 						    IEEE80211_STYPE_RTS);
 
-			if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
-			    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
-				ether_addr_copy(buf->data.ra,
-						psEthHeader->abyDstAddr);
-			} else {
-				ether_addr_copy(buf->data.ra,
-						pDevice->abyBSSID);
-			}
-			if (pDevice->op_mode == NL80211_IFTYPE_AP)
-				ether_addr_copy(buf->data.ta,
-						pDevice->abyBSSID);
-			else
-				ether_addr_copy(buf->data.ta,
-						psEthHeader->abySrcAddr);
+			ether_addr_copy(buf->data.ra, hdr->addr1);
+			ether_addr_copy(buf->data.ta, hdr->addr2);
 		}
 	} else if (byPktType == PK_TYPE_11B) {
 		struct vnt_rts_ab *buf = pvRTS;
@@ -1023,19 +967,8 @@ s_vFillRTSHead(
 		buf->data.frame_control =
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
 
-		if ((pDevice->op_mode == NL80211_IFTYPE_ADHOC) ||
-		    (pDevice->op_mode == NL80211_IFTYPE_AP)) {
-			ether_addr_copy(buf->data.ra,
-					psEthHeader->abyDstAddr);
-		} else {
-			ether_addr_copy(buf->data.ra, pDevice->abyBSSID);
-		}
-
-		if (pDevice->op_mode == NL80211_IFTYPE_AP)
-			ether_addr_copy(buf->data.ta, pDevice->abyBSSID);
-		else
-			ether_addr_copy(buf->data.ta,
-					psEthHeader->abySrcAddr);
+		ether_addr_copy(buf->data.ra, hdr->addr1);
+		ether_addr_copy(buf->data.ta, hdr->addr2);
 	}
 }
 
-- 
1.9.1

