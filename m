Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:57140 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbaEaKv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:28 -0400
Received: by mail-we0-f180.google.com with SMTP id q58so3098417wes.39
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/14] staging: vt6656: rename MACvSetBBType to vnt_mac_set_bb_type
Date: Sat, 31 May 2014 11:50:38 +0100
Message-Id: <1401533449-2972-3-git-send-email-tvboxspy@gmail.com> (sfid-20140531_125136_393433_A41E390C)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 4 ++--
 drivers/staging/vt6656/mac.c  | 2 +-
 drivers/staging/vt6656/mac.h  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index ffd6a01..03b0cf3 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -832,9 +832,9 @@ int vnt_radio_power_on(struct vnt_private *priv)
 void vnt_set_bss_mode(struct vnt_private *priv)
 {
 	if (priv->byRFType == RF_AIROHA7230 && priv->byBBType == BB_TYPE_11A)
-		MACvSetBBType(priv, BB_TYPE_11G);
+		vnt_mac_set_bb_type(priv, BB_TYPE_11G);
 	else
-		MACvSetBBType(priv, priv->byBBType);
+		vnt_mac_set_bb_type(priv, priv->byBBType);
 
 	priv->byPacketType = vnt_get_pkt_type(priv);
 
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 5ee5376..136c263 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -74,7 +74,7 @@ void vnt_mac_shutdown(struct vnt_private *priv)
 	vnt_control_out(priv, MESSAGE_TYPE_MACSHUTDOWN, 0, 0, 0, NULL);
 }
 
-void MACvSetBBType(struct vnt_private *priv, u8 type)
+void vnt_mac_set_bb_type(struct vnt_private *priv, u8 type)
 {
 	u8 data[2];
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 9eee6d7..ac3d794 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -416,7 +416,7 @@ struct vnt_mac_set_key {
 
 void vnt_mac_set_filter(struct vnt_private *, u64);
 void vnt_mac_shutdown(struct vnt_private *);
-void MACvSetBBType(struct vnt_private *, u8);
+void vnt_mac_set_bb_type(struct vnt_private *, u8);
 void MACvDisableKeyEntry(struct vnt_private *, u8);
 void MACvSetKeyEntry(struct vnt_private *, u16, u32, u32, u8 *, u8 *);
 void MACvRegBitsOff(struct vnt_private *, u8, u8);
-- 
1.9.1

