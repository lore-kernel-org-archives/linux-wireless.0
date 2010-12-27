Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38767 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab0L0OIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 09:08:23 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so8482816wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 06:08:22 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/10] rt2x00: Simplify intf->delayed_flags locking
Date: Mon, 27 Dec 2010 15:06:57 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012271504.30848.IvDoorn@gmail.com> <201012271506.18101.IvDoorn@gmail.com> <201012271506.37080.IvDoorn@gmail.com>
In-Reply-To: <201012271506.37080.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012271506.58485.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Instead of protecting delayed_flags with a spinlock use atomic bitops to
make the code more readable.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    7 +++++--
 drivers/net/wireless/rt2x00/rt2x00dev.c |   15 +--------------
 drivers/net/wireless/rt2x00/rt2x00mac.c |    4 +---
 3 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 755b723..b3f77d4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -347,6 +347,10 @@ struct link {
 	struct delayed_work watchdog_work;
 };
 
+enum rt2x00_delayed_flags {
+	DELAYED_UPDATE_BEACON,
+};
+
 /*
  * Interface structure
  * Per interface configuration details, this structure
@@ -374,8 +378,7 @@ struct rt2x00_intf {
 	/*
 	 * Actions that needed rescheduling.
 	 */
-	unsigned int delayed_flags;
-#define DELAYED_UPDATE_BEACON		0x00000001
+	unsigned long delayed_flags;
 
 	/*
 	 * Software sequence counter, this is only required
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 97a8911..9597a03 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -110,19 +110,6 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 {
 	struct rt2x00_dev *rt2x00dev = data;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
-	int delayed_flags;
-
-	/*
-	 * Copy all data we need during this action under the protection
-	 * of a spinlock. Otherwise race conditions might occur which results
-	 * into an invalid configuration.
-	 */
-	spin_lock(&intf->lock);
-
-	delayed_flags = intf->delayed_flags;
-	intf->delayed_flags = 0;
-
-	spin_unlock(&intf->lock);
 
 	/*
 	 * It is possible the radio was disabled while the work had been
@@ -133,7 +120,7 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return;
 
-	if (delayed_flags & DELAYED_UPDATE_BEACON)
+	if (test_and_clear_bit(DELAYED_UPDATE_BEACON, &intf->delayed_flags))
 		rt2x00queue_update_beacon(rt2x00dev, vif, true);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index a2266c7..297d972 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -444,9 +444,7 @@ static void rt2x00mac_set_tim_iter(void *data, u8 *mac,
 	    vif->type != NL80211_IFTYPE_WDS)
 		return;
 
-	spin_lock(&intf->lock);
-	intf->delayed_flags |= DELAYED_UPDATE_BEACON;
-	spin_unlock(&intf->lock);
+	set_bit(DELAYED_UPDATE_BEACON, &intf->delayed_flags);
 }
 
 int rt2x00mac_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
-- 
1.7.2.3

