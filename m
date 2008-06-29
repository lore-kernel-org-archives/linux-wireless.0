Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:25047 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbYF2RUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2008 13:20:24 -0400
Received: by ik-out-1112.google.com with SMTP id c28so521710ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2008 10:20:22 -0700 (PDT)
Message-ID: <f6ca9fed0806291020j151c64fbx7705fe568b42adff@mail.gmail.com> (sfid-20080629_192057_242707_8F5F2156)
Date: Sun, 29 Jun 2008 19:20:21 +0200
From: drago01 <drago01@gmail.com>
To: "Linux Wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43/b43legacy: add RFKILL_STATE_HARD_BLOCKED support
Cc: "Michael Buesch" <mb@bu3sch.de>, stefano.brivio@polimi.it,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The attached  patch adds RFKILL_STATE_HARD_BLOCKED to the b43/b43legacy drivers.
Note: I don't have any hardware to test on, so if you have the
hardware please test.

-----------

This patch sets the rfkill state to RFKILL_STATE_HARD_BLOCKED when the
radio is killed
by the hardware switch.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff --git a/drivers/net/wireless/b43/rfkill.c
b/drivers/net/wireless/b43/rfkill.c
index 4cca203..4c0dd99 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -43,6 +43,23 @@ static bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
 	return 0;
 }

+/* Update the rfkill state */
+static void b43_rfkill_update_state(struct b43_wldev *dev)
+{
+	struct b43_rfkill *rfk = &(dev->wl->rfkill);
+
+	if (!dev->radio_hw_enable) {
+		rfk->rfkill->state = RFKILL_STATE_HARD_BLOCKED;
+		return;
+	}
+
+	if (!dev->phy.radio_on)
+		rfk->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
+	else
+		rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
+
+}
+
 /* The poll callback for the hardware button. */
 static void b43_rfkill_poll(struct input_polled_dev *poll_dev)
 {
@@ -60,6 +77,7 @@ static void b43_rfkill_poll(struct input_polled_dev *poll_dev)
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
 		report_change = 1;
+		b43_rfkill_update_state(dev);
 		b43info(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
 	}
diff --git a/drivers/net/wireless/b43legacy/rfkill.c
b/drivers/net/wireless/b43legacy/rfkill.c
index 8935a30..19dabb7 100644
--- a/drivers/net/wireless/b43legacy/rfkill.c
+++ b/drivers/net/wireless/b43legacy/rfkill.c
@@ -44,6 +44,23 @@ static bool b43legacy_is_hw_radio_enabled(struct
b43legacy_wldev *dev)
 	return 0;
 }

+/* Update the rfkill state */
+static void b43legacy_rfkill_update_state(struct b43legacy_wldev *dev)
+{
+	struct b43_rfkill *rfk = &(dev->wl->rfkill);
+
+	if (!dev->radio_hw_enable) {
+		rfk->rfkill->state = RFKILL_STATE_HARD_BLOCKED;
+		return;
+	}
+
+	if (!dev->phy.radio_on)
+		rfk->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
+	else
+		rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
+
+}
+
 /* The poll callback for the hardware button. */
 static void b43legacy_rfkill_poll(struct input_polled_dev *poll_dev)
 {
@@ -61,6 +78,7 @@ static void b43legacy_rfkill_poll(struct
input_polled_dev *poll_dev)
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
 		report_change = 1;
+		b43legacy_rfkill_update_state(dev);
 		b43legacyinfo(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
 	}
