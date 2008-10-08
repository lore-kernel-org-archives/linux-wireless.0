Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:45890 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYJHBOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 21:14:23 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 and IEEE80211_CONF_SHORT_SLOT_TIME
Date: Tue, 7 Oct 2008 22:14:12 -0300
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chr <chunkeey@web.de>, Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>
References: <1223370325.3778.69.camel@johannes.berg>
In-Reply-To: <1223370325.3778.69.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810072214.13206.herton@mandriva.com.br> (sfid-20081008_031428_282768_F74E145D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 07 October 2008 06:05:24 Johannes Berg wrote:
> Hi,
>
> I just realised that for whatever reason mac80211 isn't setting the
> IEEE80211_CONF_SHORT_SLOT_TIME flag. I'm not sure when or why that was
> removed, but clearly it isn't used.
>
> Can you please fix the drivers using it (b43, b43legacy, iwlwifi, p54,
> rt2x00, rtl8180, rtl8187) to use the bss_conf's use_short_slot instead?
> I'll fix mac80211 to set that appropriately.

About 8187 and 8187b, I think the changes below may handle it, I have yet to 
test them, just posting to have some feedback in case there is something 
missing or wrong. I'll try to review the other things too (like 
use_short_preamble warned in the other thread):

diff --git a/drivers/net/wireless/rtl8187_dev.c 
b/drivers/net/wireless/rtl8187_dev.c
index e990261..7f1cac8 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -870,6 +870,32 @@ static void rtl8187_remove_interface(struct ieee80211_hw 
*dev,
 	mutex_unlock(&priv->conf_mutex);
 }
 
+static void rtl8187_conf_slot(struct rtl8187_priv *priv, bool use_short_slot)
+{
+	if (priv->is_rtl8187b) {
+		if (use_short_slot) {
+			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
+			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x1c);
+		} else {
+			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x14);
+			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x32);
+		}
+		rtl818x_iowrite8(priv, &priv->map->EIFS, 0x5b);
+	} else {
+		if (use_short_slot) {
+			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
+			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
+			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x14);
+			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
+		} else {
+			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x14);
+			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x24);
+			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x24);
+			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0xa5);
+		}
+	}
+}
+
 static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf 
*conf)
 {
 	struct rtl8187_priv *priv = dev->priv;
@@ -888,21 +914,8 @@ static int rtl8187_config(struct ieee80211_hw *dev, 
struct ieee80211_conf *conf)
 	msleep(10);
 	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
 
-	if (!priv->is_rtl8187b) {
-		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
-
-		if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
-			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
-			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
-			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x14);
-			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
-		} else {
-			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x14);
-			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x24);
-			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x24);
-			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0xa5);
-		}
-	}
+	rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
+	rtl8187_conf_slot(priv, conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME);
 
 	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
 	rtl818x_iowrite16(priv, &priv->map->ATIMTR_INTERVAL, 100);
@@ -938,6 +951,15 @@ static int rtl8187_config_interface(struct ieee80211_hw 
*dev,
 	return 0;
 }
 
+static void rtl8187_bss_info_changed(struct ieee80211_hw *dev,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_bss_conf *info,
+				    u32 changed)
+{
+	if (changed & BSS_CHANGED_ERP_SLOT)
+		rtl8187_conf_slot(dev->priv, info->use_short_slot);
+}
+
 static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 				     unsigned int changed_flags,
 				     unsigned int *total_flags,
@@ -978,6 +1000,7 @@ static const struct ieee80211_ops rtl8187_ops = {
 	.remove_interface	= rtl8187_remove_interface,
 	.config			= rtl8187_config,
 	.config_interface	= rtl8187_config_interface,
+	.bss_info_changed	= rtl8187_bss_info_changed,
 	.configure_filter	= rtl8187_configure_filter,
 };
 

The values used for SLOT etc. are kept for 8187, for 8187b I got the values 
from realtek GPL driver (nothing is specified in the datasheet).

>
> johannes

--
[]'s
Herton
