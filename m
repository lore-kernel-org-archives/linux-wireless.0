Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34212 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaGPVXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:18 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so1528680wgh.22
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/21] staging: vt6656: rename BBvSetDeepSleep to vnt_set_deep_sleep
Date: Wed, 16 Jul 2014 22:21:56 +0100
Message-Id: <1405545731-6082-6-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232331_790335_F4BB5B6E)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dropping BB

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 4 ++--
 drivers/staging/vt6656/baseband.h | 2 +-
 drivers/staging/vt6656/card.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 184f416..2a6c6ea 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -558,7 +558,7 @@ void vnt_set_vga_gain_offset(struct vnt_private *priv, u8 data)
 }
 
 /*
- * Description: BBvSetDeepSleep
+ * Description: vnt_set_deep_sleep
  *
  * Parameters:
  *  In:
@@ -569,7 +569,7 @@ void vnt_set_vga_gain_offset(struct vnt_private *priv, u8 data)
  * Return Value: none
  *
  */
-void BBvSetDeepSleep(struct vnt_private *priv)
+void vnt_set_deep_sleep(struct vnt_private *priv)
 {
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0c, 0x17);/* CR12 */
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0xB9);/* CR13 */
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index a3aff07..f246700 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -97,7 +97,7 @@ void vnt_set_short_slot_time(struct vnt_private *);
 void vnt_set_vga_gain_offset(struct vnt_private *, u8);
 void vnt_set_antenna_mode(struct vnt_private *, u8);
 int vnt_vt3184_init(struct vnt_private *);
-void BBvSetDeepSleep(struct vnt_private *);
+void vnt_set_deep_sleep(struct vnt_private *);
 void BBvExitDeepSleep(struct vnt_private *);
 void BBvUpdatePreEDThreshold(struct vnt_private *, int scanning);
 
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 1cbdfee..fd6f6e2 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -750,7 +750,7 @@ int vnt_radio_power_off(struct vnt_private *priv)
 
 	vnt_mac_reg_bits_off(priv, MAC_REG_HOSTCR, HOSTCR_RXON);
 
-	BBvSetDeepSleep(priv);
+	vnt_set_deep_sleep(priv);
 
 	return ret;
 }
-- 
2.0.1

