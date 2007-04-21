Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:64922 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXDUUbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 16:31:46 -0400
Date: Sat, 21 Apr 2007 15:31:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linux-wireless@vger.kernel.org
Message-ID: <462a74af.G6W/yBS27WPF7eds%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The routines that interrogate the ieee80211_geo struct are missing a
channel to frequency entry. This patch adds it.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/net/ieee80211/ieee80211_geo.c
===================================================================
--- wireless-2.6.orig/net/ieee80211/ieee80211_geo.c
+++ wireless-2.6/net/ieee80211/ieee80211_geo.c
@@ -94,6 +94,21 @@ int ieee80211_channel_to_index(struct ie
 	return -1;
 }
 
+u32 ieee80211_channel_to_freq(struct ieee80211_device * ieee, u8 channel)
+{
+	const struct ieee80211_channel * ch;
+
+	/* Driver needs to initialize the geography map before using
+	 * these helper functions */
+	if (ieee->geo.bg_channels == 0 && ieee->geo.a_channels == 0)
+		return 0;
+
+	ch = ieee80211_get_channel(ieee, channel);
+	if (!ch->channel)
+		return 0;
+	return ch->freq;
+}
+
 u8 ieee80211_freq_to_channel(struct ieee80211_device * ieee, u32 freq)
 {
 	int i;
@@ -174,6 +189,7 @@ EXPORT_SYMBOL(ieee80211_get_channel);
 EXPORT_SYMBOL(ieee80211_get_channel_flags);
 EXPORT_SYMBOL(ieee80211_is_valid_channel);
 EXPORT_SYMBOL(ieee80211_freq_to_channel);
+EXPORT_SYMBOL(ieee80211_channel_to_freq);
 EXPORT_SYMBOL(ieee80211_channel_to_index);
 EXPORT_SYMBOL(ieee80211_set_geo);
 EXPORT_SYMBOL(ieee80211_get_geo);
Index: wireless-2.6/include/net/ieee80211.h
===================================================================
--- wireless-2.6.orig/include/net/ieee80211.h
+++ wireless-2.6/include/net/ieee80211.h
@@ -1291,6 +1291,8 @@ extern u8 ieee80211_get_channel_flags(st
 extern const struct ieee80211_channel *ieee80211_get_channel(struct
 							     ieee80211_device
 							     *ieee, u8 channel);
+extern u32 ieee80211_channel_to_freq(struct ieee80211_device * ieee,
+				      u8 channel);
 
 /* ieee80211_wx.c */
 extern int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
