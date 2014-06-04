Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39546 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaFDR0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:33 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so8852695wgh.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/15] staging: vt6656: rename PSbIsNextTBTTWakeUp to vnt_next_tbtt_wakeup
Date: Wed,  4 Jun 2014 18:25:26 +0100
Message-Id: <1401902735-3882-6-git-send-email-tvboxspy@gmail.com> (sfid-20140604_192637_628170_258E1589)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/power.c | 4 ++--
 drivers/staging/vt6656/power.h | 2 +-
 drivers/staging/vt6656/wcmd.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index e5462ed..cc28192 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -31,7 +31,7 @@
  *      PSbConsiderPowerDown - Decide if we can Power Down
  *      PSvSendPSPOLL - Send PS-POLL packet
  *      PSbSendNullPacket - Send Null packet
- *      PSbIsNextTBTTWakeUp - Decide if we need to wake up at next Beacon
+ *      vnt_next_tbtt_wakeup - Decide if we need to wake up at next Beacon
  *
  * Revision History:
  *
@@ -312,7 +312,7 @@ int PSbSendNullPacket(struct vnt_private *pDevice)
  *
  */
 
-int PSbIsNextTBTTWakeUp(struct vnt_private *priv)
+int vnt_next_tbtt_wakeup(struct vnt_private *priv)
 {
 	struct vnt_manager *mgmt = &priv->vnt_mgmt;
 	int wake_up = false;
diff --git a/drivers/staging/vt6656/power.h b/drivers/staging/vt6656/power.h
index ef669b7..313f077 100644
--- a/drivers/staging/vt6656/power.h
+++ b/drivers/staging/vt6656/power.h
@@ -42,6 +42,6 @@ void vnt_disable_power_saving(struct vnt_private *);
 void vnt_enable_power_saving(struct vnt_private *, u16);
 void PSvSendPSPOLL(struct vnt_private *);
 int PSbSendNullPacket(struct vnt_private *);
-int PSbIsNextTBTTWakeUp(struct vnt_private *);
+int vnt_next_tbtt_wakeup(struct vnt_private *);
 
 #endif /* __POWER_H__ */
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index b2d7865..4c37908 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -826,7 +826,7 @@ void vRunCommand(struct work_struct *work)
 		break;
 
 	case WLAN_CMD_TBTT_WAKEUP_START:
-		PSbIsNextTBTTWakeUp(pDevice);
+		vnt_next_tbtt_wakeup(pDevice);
 		break;
 
 	case WLAN_CMD_BECON_SEND_START:
-- 
1.9.1

