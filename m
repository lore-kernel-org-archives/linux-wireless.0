Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:14260 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYJCSUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 14:20:38 -0400
Received: by ey-out-2122.google.com with SMTP id 6so573966eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 11:20:36 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix rfkill structure initialization to prevent rfkill WARN_ON.
Date: Fri, 3 Oct 2008 20:20:32 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@kpnplanet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810032020.33035.IvDoorn@gmail.com> (sfid-20081003_202041_680876_9FD76EEC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

The state field of the rfkill structure was incorrectly initialized to -1, which results in rfkill
issueing a WARN_ON. Fix this by initializing the state field to the proper value as indicated by
the driver.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 55eff58..c3f53a9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -145,10 +145,15 @@ void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00dev->rfkill->name = rt2x00dev->ops->name;
 	rt2x00dev->rfkill->data = rt2x00dev;
-	rt2x00dev->rfkill->state = -1;
 	rt2x00dev->rfkill->toggle_radio = rt2x00rfkill_toggle_radio;
-	if (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
+	if (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags)) {
 		rt2x00dev->rfkill->get_state = rt2x00rfkill_get_state;
+		rt2x00dev->rfkill->state =
+			rt2x00dev->ops->lib->rfkill_poll(rt2x00dev) ?
+			    RFKILL_STATE_SOFT_BLOCKED : RFKILL_STATE_UNBLOCKED;
+	} else {
+		rt2x00dev->rfkill->state = RFKILL_STATE_UNBLOCKED;
+	}
 
 	INIT_DELAYED_WORK(&rt2x00dev->rfkill_work, rt2x00rfkill_poll);
 
-- 
1.5.6.1

