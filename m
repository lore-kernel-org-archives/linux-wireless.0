Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54163 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaHTVcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 17:32:01 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so7758115wib.8
        for <linux-wireless@vger.kernel.org>; Wed, 20 Aug 2014 14:31:59 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/6] staging: vt6655: baseband add new function vnt_get_phy_field
Date: Wed, 20 Aug 2014 22:30:28 +0100
Message-Id: <1408570231-10320-3-git-send-email-tvboxspy@gmail.com> (sfid-20140820_233205_702231_87D0B4FE)
In-Reply-To: <1408570231-10320-1-git-send-email-tvboxspy@gmail.com>
References: <1408570231-10320-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a replacement for BBvCalculateParameter for getting
the phy fields via struct vnt_phy_field

This is a direct copy from the vt6656 driver.

BBvCalculateParameter will removed later.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c | 145 ++++++++++++++++++++++++++++++++++++--
 drivers/staging/vt6655/baseband.h |   3 +
 2 files changed, 142 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 7dd866e..5842206 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1810,17 +1810,150 @@ BBuGetFrameTime(
  *
  * Parameters:
  *  In:
- *      pDevice         - Device Structure
- *      cbFrameLength   - Tx Frame Length
- *      wRate           - Tx Rate
+ *      priv         - Device Structure
+ *      frame_length   - Tx Frame Length
+ *      tx_rate           - Tx Rate
  *  Out:
- *      pwPhyLen        - pointer to Phy Length field
- *      pbyPhySrv       - pointer to Phy Service field
- *      pbyPhySgn       - pointer to Phy Signal field
+ *	struct vnt_phy_field *phy
+ *		- pointer to Phy Length field
+ *		- pointer to Phy Service field
+ *		- pointer to Phy Signal field
  *
  * Return Value: none
  *
  */
+void vnt_get_phy_field(struct vnt_private *priv, u32 frame_length,
+		       u16 tx_rate, u8 pkt_type, struct vnt_phy_field *phy)
+{
+	u32 bit_count;
+	u32 count = 0;
+	u32 tmp;
+	int ext_bit;
+	u8 preamble_type = priv->byPreambleType;
+
+	bit_count = frame_length * 8;
+	ext_bit = false;
+
+	switch (tx_rate) {
+	case RATE_1M:
+		count = bit_count;
+
+		phy->signal = 0x00;
+
+		break;
+	case RATE_2M:
+		count = bit_count / 2;
+
+		if (preamble_type == 1)
+			phy->signal = 0x09;
+		else
+			phy->signal = 0x01;
+
+		break;
+	case RATE_5M:
+		count = (bit_count * 10) / 55;
+		tmp = (count * 55) / 10;
+
+		if (tmp != bit_count)
+			count++;
+
+		if (preamble_type == 1)
+			phy->signal = 0x0a;
+		else
+			phy->signal = 0x02;
+
+		break;
+	case RATE_11M:
+		count = bit_count / 11;
+		tmp = count * 11;
+
+		if (tmp != bit_count) {
+			count++;
+
+			if ((bit_count - tmp) <= 3)
+				ext_bit = true;
+		}
+
+		if (preamble_type == 1)
+			phy->signal = 0x0b;
+		else
+			phy->signal = 0x03;
+
+		break;
+	case RATE_6M:
+		if (pkt_type == PK_TYPE_11A)
+			phy->signal = 0x9b;
+		else
+			phy->signal = 0x8b;
+
+		break;
+	case RATE_9M:
+		if (pkt_type == PK_TYPE_11A)
+			phy->signal = 0x9f;
+		else
+			phy->signal = 0x8f;
+
+		break;
+	case RATE_12M:
+		if (pkt_type == PK_TYPE_11A)
+			phy->signal = 0x9a;
+		else
+			phy->signal = 0x8a;
+
+		break;
+	case RATE_18M:
+		if (pkt_type == PK_TYPE_11A)
+			phy->signal = 0x9e;
+		else
+			phy->signal = 0x8e;
+
+		break;
+	case RATE_24M:
+		if (pkt_type == PK_TYPE_11A)
+			phy->signal = 0x99;
+		else
+			phy->signal = 0x89;
+
+		break;
+	case RATE_36M:
+		if (pkt_type == PK_TYPE_11A)
+			phy->signal = 0x9d;
+		else
+			phy->signal = 0x8d;
+
+		break;
+	case RATE_48M:
+		if (pkt_type == PK_TYPE_11A)
+			phy->signal = 0x98;
+		else
+			phy->signal = 0x88;
+
+		break;
+	case RATE_54M:
+		if (pkt_type == PK_TYPE_11A)
+			phy->signal = 0x9c;
+		else
+			phy->signal = 0x8c;
+		break;
+	default:
+		if (pkt_type == PK_TYPE_11A)
+			phy->signal = 0x9c;
+		else
+			phy->signal = 0x8c;
+		break;
+	}
+
+	if (pkt_type == PK_TYPE_11B) {
+		phy->service = 0x00;
+		if (ext_bit)
+			phy->service |= 0x80;
+		phy->len = cpu_to_le16((u16)count);
+	} else {
+		phy->service = 0x00;
+		phy->len = cpu_to_le16((u16)frame_length);
+	}
+}
+
 void
 BBvCalculateParameter(
 	struct vnt_private *pDevice,
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index 6b43885..049e6b4 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -87,6 +87,9 @@ BBvCalculateParameter(
 	unsigned char *pbyPhySgn
 );
 
+void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
+		       u16 tx_rate, u8 pkt_type, struct vnt_phy_field *);
+
 bool BBbReadEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char *pbyData);
 bool BBbWriteEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byData);
 
-- 
1.9.1

