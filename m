Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbYCIVvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:20 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:19 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 18/24] rt2x00: Make rt2x00leds_register return void
Date: Sun, 9 Mar 2008 22:47:08 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092247.08308.IvDoorn@gmail.com> (sfid-20080309_222527_839693_6A87458B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00dev isn't interested in the rt2x00leds_register() value
anyway. So lets make it return void to even prevent people from
assuming there is anybody interested in the returnvalue.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00leds.c |    7 +++----
 drivers/net/wireless/rt2x00/rt2x00lib.h  |    5 ++---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
index 9c29d17..ca2d282 100644
--- a/drivers/net/wireless/rt2x00/rt2x00leds.c
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
@@ -109,7 +109,7 @@ static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
 	return 0;
 }
 
-int rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
+void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 {
 	char *trigger;
 	char dev_name[16];
@@ -117,7 +117,7 @@ int rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 	int retval;
 
 	if (!rt2x00dev->ops->lib->led_brightness)
-		return 0;
+		return;
 
 	snprintf(dev_name, sizeof(dev_name), "%s-%s",
 		 rt2x00dev->ops->name, wiphy_name(rt2x00dev->hw->wiphy));
@@ -161,11 +161,10 @@ int rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 			goto exit_fail;
 	}
 
-	return 0;
+	return;
 
 exit_fail:
 	rt2x00leds_unregister(rt2x00dev);
-	return retval;
 }
 
 static void rt2x00leds_unregister_trigger(struct rt2x00_trigger *trigger)
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index b9d7e0e..1596aa3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -192,7 +192,7 @@ static inline void rt2x00rfkill_resume(struct rt2x00_dev *rt2x00dev);
  */
 #ifdef CONFIG_RT2X00_LIB_LEDS
 void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev, int rssi);
-int rt2x00leds_register(struct rt2x00_dev *rt2x00dev);
+void rt2x00leds_register(struct rt2x00_dev *rt2x00dev);
 void rt2x00leds_unregister(struct rt2x00_dev *rt2x00dev);
 void rt2x00leds_suspend(struct rt2x00_dev *rt2x00dev);
 void rt2x00leds_resume(struct rt2x00_dev *rt2x00dev);
@@ -202,9 +202,8 @@ static inline void rt2x00leds_led_quality(struct rt2x00_dev *rt2x00dev,
 {
 }
 
-static inline int rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
+static inline void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
 {
-	return 0;
 }
 
 static inline void rt2x00leds_unregister(struct rt2x00_dev *rt2x00dev)
-- 
1.5.4.3

