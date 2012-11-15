Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60636 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119Ab2KNWBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 17:01:49 -0500
Received: by mail-lb0-f174.google.com with SMTP id gp3so826471lbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2012 14:01:47 -0800 (PST)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] net/wireless: ipw2x00: remove unreachable code
Date: Thu, 15 Nov 2012 03:07:47 +0000
Message-Id: <1352948867-548-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20121114_230153_173612_BBAA6D9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary if statements because libipw_set_geo always
returns success.  Also change function's return value from int
to void.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c    | 5 +----
 drivers/net/wireless/ipw2x00/ipw2200.c    | 5 +----
 drivers/net/wireless/ipw2x00/libipw.h     | 2 +-
 drivers/net/wireless/ipw2x00/libipw_geo.c | 3 +--
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 29b8fa1..46938bc 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -1788,10 +1788,7 @@ static int ipw2100_up(struct ipw2100_priv *priv, int deferred)
 	}
 
 	/* Initialize the geo */
-	if (libipw_set_geo(priv->ieee, &ipw_geos[0])) {
-		printk(KERN_WARNING DRV_NAME "Could not set geo\n");
-		return 0;
-	}
+	libipw_set_geo(priv->ieee, &ipw_geos[0]);
 	priv->ieee->freq_band = LIBIPW_24GHZ_BAND;
 
 	lock = LOCK_NONE;
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 768bf61..fea96b5 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11322,10 +11322,7 @@ static int ipw_up(struct ipw_priv *priv)
 				    priv->eeprom[EEPROM_COUNTRY_CODE + 2]);
 			j = 0;
 		}
-		if (libipw_set_geo(priv->ieee, &ipw_geos[j])) {
-			IPW_WARNING("Could not set geography.");
-			return 0;
-		}
+		libipw_set_geo(priv->ieee, &ipw_geos[j]);
 
 		if (priv->status & STATUS_RF_KILL_SW) {
 			IPW_WARNING("Radio disabled by module parameter.\n");
diff --git a/drivers/net/wireless/ipw2x00/libipw.h b/drivers/net/wireless/ipw2x00/libipw.h
index 0b22fb4..6eede52 100644
--- a/drivers/net/wireless/ipw2x00/libipw.h
+++ b/drivers/net/wireless/ipw2x00/libipw.h
@@ -978,7 +978,7 @@ extern void libipw_network_reset(struct libipw_network *network);
 /* libipw_geo.c */
 extern const struct libipw_geo *libipw_get_geo(struct libipw_device
 						     *ieee);
-extern int libipw_set_geo(struct libipw_device *ieee,
+extern void libipw_set_geo(struct libipw_device *ieee,
 			     const struct libipw_geo *geo);
 
 extern int libipw_is_valid_channel(struct libipw_device *ieee,
diff --git a/drivers/net/wireless/ipw2x00/libipw_geo.c b/drivers/net/wireless/ipw2x00/libipw_geo.c
index c9fe3c9..218f2a3 100644
--- a/drivers/net/wireless/ipw2x00/libipw_geo.c
+++ b/drivers/net/wireless/ipw2x00/libipw_geo.c
@@ -132,7 +132,7 @@ u8 libipw_freq_to_channel(struct libipw_device * ieee, u32 freq)
 	return 0;
 }
 
-int libipw_set_geo(struct libipw_device *ieee,
+void libipw_set_geo(struct libipw_device *ieee,
 		      const struct libipw_geo *geo)
 {
 	memcpy(ieee->geo.name, geo->name, 3);
@@ -143,7 +143,6 @@ int libipw_set_geo(struct libipw_device *ieee,
 	       sizeof(struct libipw_channel));
 	memcpy(ieee->geo.a, geo->a, ieee->geo.a_channels *
 	       sizeof(struct libipw_channel));
-	return 0;
 }
 
 const struct libipw_geo *libipw_get_geo(struct libipw_device *ieee)
-- 
1.7.11.7

