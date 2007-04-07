Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:49793 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966281AbXDGS5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 14:57:09 -0400
Date: Sat, 07 Apr 2007 13:54:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Fix 802.11b/g scan limits to match regulatory  requirements
Message-ID: <4617e8eb.8Y1vYMQ0EdBtHlLP%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In 802.11b/g mode, bcm43xx actively scans channels 1-14 no matter what locale has been set,
either in the sprom or by the locale option. This behaviorviolates regulatory rules
everywhere in the world except Japan. This patch changes the default range to the correct
value if the locale has been set, and to channels 1-13 if no locale has been set.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This should be applied to wireless-2.6.

Larry

 bcm43xx_main.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -946,6 +946,7 @@ static int bcm43xx_geo_init(struct bcm43
 	u8 channel;
 	struct bcm43xx_phyinfo *phy;
 	const char *iso_country;
+	u8 max_bg_channel;
 
 	geo = kzalloc(sizeof(*geo), GFP_KERNEL);
 	if (!geo)
@@ -967,6 +968,23 @@ static int bcm43xx_geo_init(struct bcm43
 	}
 	iso_country = bcm43xx_locale_iso(bcm->sprom.locale);
 
+/* set the maximum channel based on locale set in sprom or witle locale option */
+	switch (bcm->sprom.locale) {
+	case BCM43xx_LOCALE_THAILAND:
+	case BCM43xx_LOCALE_ISRAEL:
+	case BCM43xx_LOCALE_JORDAN:
+	case BCM43xx_LOCALE_USA_CANADA_ANZ:
+	case BCM43xx_LOCALE_USA_LOW:
+		max_bg_channel = 11;
+		break;
+	case BCM43xx_LOCALE_JAPAN:
+	case BCM43xx_LOCALE_JAPAN_HIGH:
+		max_bg_channel = 14;
+		break;
+	default:
+		max_bg_channel = 13;
+	}
+
  	if (have_a) {
 		for (i = 0, channel = IEEE80211_52GHZ_MIN_CHANNEL;
 		      channel <= IEEE80211_52GHZ_MAX_CHANNEL; channel++) {
@@ -978,7 +996,7 @@ static int bcm43xx_geo_init(struct bcm43
 	}
 	if (have_bg) {
 		for (i = 0, channel = IEEE80211_24GHZ_MIN_CHANNEL;
-		      channel <= IEEE80211_24GHZ_MAX_CHANNEL; channel++) {
+		      channel <= max_bg_channel; channel++) {
 			chan = &geo->bg[i++];
 			chan->freq = bcm43xx_channel_to_freq_bg(channel);
 			chan->channel = channel;
