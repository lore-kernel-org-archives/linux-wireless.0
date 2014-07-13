Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54449 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaGMJnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:45 -0400
Received: by mail-wi0-f178.google.com with SMTP id hi2so1183405wib.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/13] staging: vt6656: Drop u8 pointer and rename bScheduleCommand.
Date: Sun, 13 Jul 2014 10:42:50 +0100
Message-Id: <1405244573-10978-10-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114413_770240_BBE73384)
In-Reply-To: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
References: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename to vnt_schedule_command removing unused u8 pointer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c      | 12 +++++-------
 drivers/staging/vt6656/main_usb.c |  2 +-
 drivers/staging/vt6656/rxtx.c     |  2 +-
 drivers/staging/vt6656/wcmd.c     |  4 ++--
 drivers/staging/vt6656/wcmd.h     |  2 +-
 5 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 77bd9dd..15841b8 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -172,20 +172,18 @@ void INTnsProcessData(struct vnt_private *priv)
 	if (int_data->isr0 != 0) {
 		if (int_data->isr0 & ISR_BNTX &&
 				priv->op_mode == NL80211_IFTYPE_AP)
-			bScheduleCommand(priv, WLAN_CMD_BECON_SEND, NULL);
+			vnt_schedule_command(priv, WLAN_CMD_BECON_SEND);
 
 		if (int_data->isr0 & ISR_TBTT) {
 			if (priv->hw->conf.flags & IEEE80211_CONF_PS)
-				bScheduleCommand((void *) priv,
-						WLAN_CMD_TBTT_WAKEUP,
-						NULL);
+				vnt_schedule_command(priv,
+							WLAN_CMD_TBTT_WAKEUP);
 #if 0 /* TODO channel switch */
 			if (priv->bChannelSwitch) {
 				priv->byChannelSwitchCount--;
 				if (priv->byChannelSwitchCount == 0)
-					bScheduleCommand((void *) priv,
-							WLAN_CMD_11H_CHSW,
-							NULL);
+					vnt_schedule_command(priv,
+							WLAN_CMD_11H_CHSW);
 			}
 #endif
 		}
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index d9b5210..ceef9ef 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1137,7 +1137,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	MP_CLEAR_FLAG(priv, fMP_DISCONNECTED);
 	vResetCommandTimer(priv);
 
-	bScheduleCommand(priv, WLAN_CMD_INIT_MAC80211, NULL);
+	vnt_schedule_command(priv, WLAN_CMD_INIT_MAC80211);
 
 	return 0;
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 3dc6d07..1f1ec04 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -767,7 +767,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	if (priv->wCurrentRate != current_rate &&
 			!(priv->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)) {
 		priv->wCurrentRate = current_rate;
-		bScheduleCommand(priv, WLAN_CMD_SETPOWER, NULL);
+		vnt_schedule_command(priv, WLAN_CMD_SETPOWER);
 	}
 
 	if (current_rate > RATE_11M)
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 864d5e5..b217efb 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -29,7 +29,7 @@
  *      s_MgrMakeProbeRequest - Make ProbeRequest packet
  *      CommandTimer - Timer function to handle command
  *	vnt_cmd_complete - Command Complete function
- *      bScheduleCommand - Push Command and wait Command Scheduler to do
+ *      vnt_schedule_command - Push Command and wait Command Scheduler to do
  *      vCommandTimer- Command call back functions
  *	vnt_cmd_timer_wait- Call back timer
  *      s_bClearBSSID_SCAN- Clear BSSID_SCAN cmd in CMD Queue
@@ -184,7 +184,7 @@ void vnt_run_command(struct work_struct *work)
 	return;
 }
 
-int bScheduleCommand(struct vnt_private *priv, enum vnt_cmd command, u8 *item0)
+int vnt_schedule_command(struct vnt_private *priv, enum vnt_cmd command)
 {
 
 	if (priv->free_cmd_queue == 0)
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index 783d6c9..3248c95 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -61,7 +61,7 @@ struct vnt_private;
 
 void vResetCommandTimer(struct vnt_private *);
 
-int bScheduleCommand(struct vnt_private *, enum vnt_cmd, u8 *);
+int vnt_schedule_command(struct vnt_private *, enum vnt_cmd);
 
 void vnt_run_command(struct work_struct *work);
 
-- 
1.9.1

