Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35544 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbbI0IS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 04:18:27 -0400
Received: by wicge5 with SMTP id ge5so67941491wic.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2015 01:18:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/6] staging: vt6656: implement power saving code.
Date: Sun, 27 Sep 2015 09:17:41 +0100
Message-Id: <1443341864-2756-3-git-send-email-tvboxspy@gmail.com> (sfid-20150927_101852_237278_4B36FAE1)
In-Reply-To: <1443341864-2756-1-git-send-email-tvboxspy@gmail.com>
References: <1443341864-2756-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device should ready to listen to next beacon so on count down of
wake_up_count == 1.

schedule command WLAN_CMD_TBTT_WAKEUP which calls vnt_next_tbtt_wakeup which
wakes the device.

This restores this back to vendors code with a slight difference the
count down is in the interrupt handler.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |  2 ++
 drivers/staging/vt6656/int.c    | 14 +++++++++++---
 drivers/staging/vt6656/power.c  |  2 +-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 635d931..dec36f2 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -389,6 +389,8 @@ struct vnt_private {
 	u8 bb_pre_ed_rssi;
 	u8 bb_pre_ed_index;
 
+	u16 wake_up_count;
+
 	/* command timer */
 	struct delayed_work run_command_work;
 
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 2ef70e4..14b8ebc 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -149,10 +149,18 @@ void vnt_int_process_data(struct vnt_private *priv)
 				priv->op_mode == NL80211_IFTYPE_AP)
 			vnt_schedule_command(priv, WLAN_CMD_BECON_SEND);
 
-		if (int_data->isr0 & ISR_TBTT) {
-			if (priv->hw->conf.flags & IEEE80211_CONF_PS)
+		if (int_data->isr0 & ISR_TBTT &&
+		    priv->hw->conf.flags & IEEE80211_CONF_PS) {
+			if (!priv->wake_up_count)
+				priv->wake_up_count =
+					priv->hw->conf.listen_interval;
+
+			--priv->wake_up_count;
+
+			/* Turn on wake up to listen next beacon */
+			if (priv->wake_up_count == 1)
 				vnt_schedule_command(priv,
-							WLAN_CMD_TBTT_WAKEUP);
+						     WLAN_CMD_TBTT_WAKEUP);
 		}
 		priv->current_tsf = le64_to_cpu(int_data->tsf);
 
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index 0ffbaed..d5912d2 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -134,7 +134,7 @@ int vnt_next_tbtt_wakeup(struct vnt_private *priv)
 	struct ieee80211_conf *conf = &hw->conf;
 	int wake_up = false;
 
-	if (conf->listen_interval == 1) {
+	if (conf->listen_interval > 1) {
 		/* Turn on wake up to listen next beacon */
 		vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_LNBCN);
 		wake_up = true;
-- 
2.5.0

