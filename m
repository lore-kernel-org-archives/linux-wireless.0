Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:38346 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbXIPMI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:26 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1643781wah
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:25 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/24] rt2x00: Fix rfkill handling
Date: Sun, 16 Sep 2007 14:19:13 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161419.14416.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the rfkill key has been pressed rt2x00 should send out an rfkill
event instead of toggling all keys. This will make sure the event
will go through all correct rfkill layers.

Also initialize the rfkill->state field to make sure we correctly
notice key changes.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 7dde53c..dc5b696 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -68,9 +68,10 @@ static int rt2x00rfkill_toggle_radio(void *data, enum rfkill_state state)
 static void rt2x00rfkill_poll(struct input_polled_dev *poll_dev)
 {
 	struct rt2x00_dev *rt2x00dev = poll_dev->private;
-	int status = rt2x00dev->ops->lib->rfkill_poll(rt2x00dev);
+	int state = rt2x00dev->ops->lib->rfkill_poll(rt2x00dev);
 
-	rfkill_switch_all(rt2x00dev->rfkill->type, status);
+	if (rt2x00dev->rfkill->state != state)
+		input_report_key(poll_dev->input, KEY_WLAN, 1);
 }
 
 int rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
@@ -120,6 +121,7 @@ int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00dev->rfkill->name = rt2x00dev->ops->name;
 	rt2x00dev->rfkill->data = rt2x00dev;
+	rt2x00dev->rfkill->state = rt2x00dev->ops->lib->rfkill_poll(rt2x00dev);
 	rt2x00dev->rfkill->toggle_radio = rt2x00rfkill_toggle_radio;
 
 	rt2x00dev->poll_dev = input_allocate_polled_device();
-- 
1.5.3
