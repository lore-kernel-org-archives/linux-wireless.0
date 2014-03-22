Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43882 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaCVJCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 05:02:36 -0400
Received: by mail-wg0-f52.google.com with SMTP id k14so2184261wgh.23
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 02:02:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/10] staging: vt6656: vnt_fill_ieee80211_rts replace TYPE_CTL_RTS macro
Date: Sat, 22 Mar 2014 09:01:31 +0000
Message-Id: <1395478892-3419-9-git-send-email-tvboxspy@gmail.com> (sfid-20140322_100243_786357_C2436BC1)
In-Reply-To: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
References: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS from linux/ieee80211.h
to get value of TYPE_CTL_RTS and endian correct to frame_control.

Remove old macros in tether.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c   | 3 ++-
 drivers/staging/vt6656/tether.h | 2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 2b67b1b..ac60999 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -551,7 +551,8 @@ static int vnt_fill_ieee80211_rts(struct vnt_private *priv,
 		__le16 duration)
 {
 	rts->duration = duration;
-	rts->frame_control = TYPE_CTL_RTS;
+	rts->frame_control =
+		cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
 
 	if (priv->op_mode == NL80211_IFTYPE_ADHOC ||
 				priv->op_mode == NL80211_IFTYPE_AP)
diff --git a/drivers/staging/vt6656/tether.h b/drivers/staging/vt6656/tether.h
index aec6b56..f42edda 100644
--- a/drivers/staging/vt6656/tether.h
+++ b/drivers/staging/vt6656/tether.h
@@ -60,7 +60,6 @@
 #define TYPE_DATE_NULL      0x4800
 
 #define TYPE_CTL_PSPOLL     0xa400
-#define TYPE_CTL_RTS        0xb400
 #define TYPE_CTL_CTS        0xc400
 #define TYPE_CTL_ACK        0xd400
 
@@ -91,7 +90,6 @@
 #define TYPE_DATE_NULL      0x0048
 
 #define TYPE_CTL_PSPOLL     0x00a4
-#define TYPE_CTL_RTS        0x00b4
 #define TYPE_CTL_CTS        0x00c4
 #define TYPE_CTL_ACK        0x00d4
 
-- 
1.9.0

