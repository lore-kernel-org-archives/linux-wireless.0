Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:62520 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaGTOey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:54 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so6444550wes.23
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:53 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 19/25] staging: vt6656: dead code remove channel switch.
Date: Sun, 20 Jul 2014 15:33:29 +0100
Message-Id: <1405866815-2687-19-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165109_827924_9A3AF38D)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver needs to do anything special for channel switch.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 4 ----
 drivers/staging/vt6656/int.c    | 8 --------
 drivers/staging/vt6656/wcmd.c   | 8 --------
 drivers/staging/vt6656/wcmd.h   | 4 +---
 4 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 101d0ca..120d325 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -391,10 +391,6 @@ struct vnt_private {
 	/* command timer */
 	struct delayed_work run_command_work;
 
-	int bChannelSwitch;
-	u8 byNewChannel;
-	u8 byChannelSwitchCount;
-
 	struct ieee80211_low_level_stats low_stats;
 };
 
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 9c5fefc..2ef70e4 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -153,14 +153,6 @@ void vnt_int_process_data(struct vnt_private *priv)
 			if (priv->hw->conf.flags & IEEE80211_CONF_PS)
 				vnt_schedule_command(priv,
 							WLAN_CMD_TBTT_WAKEUP);
-#if 0 /* TODO channel switch */
-			if (priv->bChannelSwitch) {
-				priv->byChannelSwitchCount--;
-				if (priv->byChannelSwitchCount == 0)
-					vnt_schedule_command(priv,
-							WLAN_CMD_11H_CHSW);
-			}
-#endif
 		}
 		priv->current_tsf = le64_to_cpu(int_data->tsf);
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index a63d0fd..e4a5e2b 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -83,10 +83,6 @@ static int vnt_cmd_complete(struct vnt_private *priv)
 		priv->command_state = WLAN_CMD_CHANGE_ANTENNA_START;
 		break;
 
-	case WLAN_CMD_11H_CHSW:
-		priv->command_state = WLAN_CMD_11H_CHSW_START;
-		break;
-
 	default:
 		break;
 	}
@@ -163,10 +159,6 @@ void vnt_run_command(struct work_struct *work)
 		}
 		break;
 
-	case WLAN_CMD_11H_CHSW_START:
-		vnt_set_channel(priv, priv->hw->conf.chandef.chan->hw_value);
-		break;
-
 	default:
 		break;
 	}
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index 0fc2c40..79df04a 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -40,8 +40,7 @@ enum vnt_cmd {
 	WLAN_CMD_SETPOWER,
 	WLAN_CMD_TBTT_WAKEUP,
 	WLAN_CMD_BECON_SEND,
-	WLAN_CMD_CHANGE_ANTENNA,
-	WLAN_CMD_11H_CHSW,
+	WLAN_CMD_CHANGE_ANTENNA
 };
 
 #define CMD_Q_SIZE              32
@@ -53,7 +52,6 @@ enum vnt_cmd_state {
 	WLAN_CMD_TBTT_WAKEUP_START,
 	WLAN_CMD_BECON_SEND_START,
 	WLAN_CMD_CHANGE_ANTENNA_START,
-	WLAN_CMD_11H_CHSW_START,
 	WLAN_CMD_IDLE
 };
 
-- 
2.0.1

