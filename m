Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58209 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaGPVXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:20 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so6037450wiw.12
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/21] staging: vt6656: rename BBvExitDeepSleep to vnt_exit_deep_sleep
Date: Wed, 16 Jul 2014 22:21:57 +0100
Message-Id: <1405545731-6082-7-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232413_199212_6C793376)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dropping BB

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 2 +-
 drivers/staging/vt6656/baseband.h | 2 +-
 drivers/staging/vt6656/card.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 2a6c6ea..39e2629 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -575,7 +575,7 @@ void vnt_set_deep_sleep(struct vnt_private *priv)
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0xB9);/* CR13 */
 }
 
-void BBvExitDeepSleep(struct vnt_private *priv)
+void vnt_exit_deep_sleep(struct vnt_private *priv)
 {
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0c, 0x00);/* CR12 */
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0x01);/* CR13 */
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index f246700..aee51a1 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -98,7 +98,7 @@ void vnt_set_vga_gain_offset(struct vnt_private *, u8);
 void vnt_set_antenna_mode(struct vnt_private *, u8);
 int vnt_vt3184_init(struct vnt_private *);
 void vnt_set_deep_sleep(struct vnt_private *);
-void BBvExitDeepSleep(struct vnt_private *);
+void vnt_exit_deep_sleep(struct vnt_private *);
 void BBvUpdatePreEDThreshold(struct vnt_private *, int scanning);
 
 #endif /* __BASEBAND_H__ */
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index fd6f6e2..34ca2a6 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -776,7 +776,7 @@ int vnt_radio_power_on(struct vnt_private *priv)
 
 	priv->bRadioOff = false;
 
-	BBvExitDeepSleep(priv);
+	vnt_exit_deep_sleep(priv);
 
 	vnt_mac_reg_bits_on(priv, MAC_REG_HOSTCR, HOSTCR_RXON);
 
-- 
2.0.1

