Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39559 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaGTOee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:34 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so6625737wes.33
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:33 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/25] staging: vt6656: struct vnt_private replace wCurrentRate with current_rate
Date: Sun, 20 Jul 2014 15:33:19 +0100
Message-Id: <1405866815-2687-9-git-send-email-tvboxspy@gmail.com> (sfid-20140720_163441_061541_ED9A3093)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing type prefix and camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/main_usb.c | 8 ++++----
 drivers/staging/vt6656/rxtx.c     | 4 ++--
 drivers/staging/vt6656/wcmd.c     | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 4424d75..9e095eb 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -349,7 +349,7 @@ struct vnt_private {
 	u8 ofdm_pwr_tbl[14];
 	u8 ofdm_a_pwr_tbl[42];
 
-	u16 wCurrentRate;
+	u16 current_rate;
 	u16 tx_rate_fb0;
 	u16 tx_rate_fb1;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 8fb602a..5939f9a 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -718,11 +718,11 @@ static int vnt_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		if (priv->bb_type == BB_TYPE_11B)
-			priv->wCurrentRate = RATE_1M;
+			priv->current_rate = RATE_1M;
 		else
-			priv->wCurrentRate = RATE_54M;
+			priv->current_rate = RATE_54M;
 
-		vnt_rf_setpower(priv, priv->wCurrentRate,
+		vnt_rf_setpower(priv, priv->current_rate,
 				conf->chandef.chan->hw_value);
 	}
 
@@ -778,7 +778,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_TXPOWER)
-		vnt_rf_setpower(priv, priv->wCurrentRate,
+		vnt_rf_setpower(priv, priv->current_rate,
 					conf->chandef.chan->hw_value);
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 68e479a..0e4b773 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -764,9 +764,9 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	rate = ieee80211_get_tx_rate(priv->hw, info);
 
 	current_rate = rate->hw_value;
-	if (priv->wCurrentRate != current_rate &&
+	if (priv->current_rate != current_rate &&
 			!(priv->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)) {
-		priv->wCurrentRate = current_rate;
+		priv->current_rate = current_rate;
 		vnt_schedule_command(priv, WLAN_CMD_SETPOWER);
 	}
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 304f6d6..a63d0fd 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -139,7 +139,7 @@ void vnt_run_command(struct work_struct *work)
 
 	case WLAN_CMD_SETPOWER_START:
 
-		vnt_rf_setpower(priv, priv->wCurrentRate,
+		vnt_rf_setpower(priv, priv->current_rate,
 				priv->hw->conf.chandef.chan->hw_value);
 
 		break;
-- 
2.0.1

