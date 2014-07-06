Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35560 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaGFWUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 18:20:21 -0400
Received: by mail-wg0-f49.google.com with SMTP id a1so177697wgh.8
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 15:20:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/3] staging: vt6656: vnt_update_ifs vendor changes to uSIFS/uDIFS
Date: Sun,  6 Jul 2014 23:19:48 +0100
Message-Id: <1404685188-3182-3-git-send-email-tvboxspy@gmail.com> (sfid-20140707_002027_620955_FAECB081)
In-Reply-To: <1404685188-3182-1-git-send-email-tvboxspy@gmail.com>
References: <1404685188-3182-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest vendor code makes changes to uSIFS and uDIFS.

The orginal codes have been rearranged into a fall through switch
statement.

These reduce the time that device allows to TX packets and
improves throughput.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index a5f8df1..ea06b63 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -408,6 +408,36 @@ void vnt_update_ifs(struct vnt_private *priv)
 	priv->uCwMax = C_CWMAX;
 	priv->uEIFS = C_EIFS;
 
+	switch (priv->byRFType) {
+	case RF_VT3226D0:
+		if (priv->byBBType != BB_TYPE_11B) {
+			priv->uSIFS -= 1;
+			priv->uDIFS -= 1;
+			break;
+		}
+	case RF_AIROHA7230:
+	case RF_AL2230:
+	case RF_AL2230S:
+		if (priv->byBBType != BB_TYPE_11B)
+			break;
+	case RF_RFMD2959:
+	case RF_VT3226:
+	case RF_VT3342A0:
+		priv->uSIFS -= 3;
+		priv->uDIFS -= 3;
+		break;
+	case RF_MAXIM2829:
+		if (priv->byBBType == BB_TYPE_11A) {
+			priv->uSIFS -= 5;
+			priv->uDIFS -= 5;
+		} else {
+			priv->uSIFS -= 2;
+			priv->uDIFS -= 2;
+		}
+
+		break;
+	}
+
 	data[0] = (u8)priv->uSIFS;
 	data[1] = (u8)priv->uDIFS;
 	data[2] = (u8)priv->uEIFS;
-- 
1.9.1

