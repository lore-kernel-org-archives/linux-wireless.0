Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46824 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1CZVUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2011 17:20:10 -0400
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Herton Ronaldo Krzesinski <herton@canonical.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [RFC PATCH] rtl8187: Fix led support for rfkill
Date: Sun, 27 Mar 2011 05:19:54 +0800
Message-Id: <1301174394-12642-1-git-send-email-wuzhangjin@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

led can not be turned off normally when rfkill is blocked, the cause is
the led_turn_off() function exit as not expected:

drivers/net/wireless/rtl818x/rtl8187/leds.c:

static void led_turn_off(struct work_struct *work)
{
	[...]
	/* Don't change the LED, when the device is down. */
	if (!priv->vif || priv->vif->type == NL80211_IFTYPE_UNSPECIFIED)
		return ;
	[...]

When rfkill is blocked, the function calling order looks like this:

net/mac80211/iface.c:

ieee80211_do_stop
	-> drv_remove_interface = rtl8187_remove_interface
	-> ieee80211_stop_device
		-> led_set_brightness
			-> led_turn_off
	-> drv_stop = rtl8187_stop

rtl8187_remove_interface() set priv->vif to NULL, so, led_turn_off()
will return and will not be able to turn off the led. delay the setting
of priv->vif to rtl8187_stop() can solve it.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8187/dev.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 2bb5297..1fea0cd 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -1007,6 +1007,9 @@ static void rtl8187_stop(struct ieee80211_hw *dev)
 	u32 reg;
 
 	mutex_lock(&priv->conf_mutex);
+
+	priv->vif = NULL;
+
 	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
 
 	reg = rtl818x_ioread8(priv, &priv->map->CMD);
@@ -1067,10 +1070,7 @@ exit:
 static void rtl8187_remove_interface(struct ieee80211_hw *dev,
 				     struct ieee80211_vif *vif)
 {
-	struct rtl8187_priv *priv = dev->priv;
-	mutex_lock(&priv->conf_mutex);
-	priv->vif = NULL;
-	mutex_unlock(&priv->conf_mutex);
+	/* Nothing to do */
 }
 
 static int rtl8187_config(struct ieee80211_hw *dev, u32 changed)
-- 
1.7.1

