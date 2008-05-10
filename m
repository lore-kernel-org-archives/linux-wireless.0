Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:54673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbYEJMJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:09:52 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1148254fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:09:50 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 02/16] rt2x00: Fix broken recover-on-error path
Date: Sat, 10 May 2008 13:38:53 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805101338.53435.IvDoorn@gmail.com> (sfid-20080510_141011_319577_7932E91E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During initialization the initialize() callback function
in rt2x00pci and rt2x00usb will cleanup the mess they made.

rt2x00lib shouldn't call uninitialize because the callback function already
cleaned up _and_ the DEVICE_INITIALIZED isn't set which causes the
rt2x00lib_uninitialize() to halt directly anyway. All that is required
to be cleaned up by rt2x00lib is the queue, and that can be done by
calling rt2x00queue_uninitialize() directly.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9929b15..61510c5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1028,8 +1028,10 @@ static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 	 * Initialize the device.
 	 */
 	status = rt2x00dev->ops->lib->initialize(rt2x00dev);
-	if (status)
-		goto exit;
+	if (status) {
+		rt2x00queue_uninitialize(rt2x00dev);
+		return status;
+	}
 
 	__set_bit(DEVICE_INITIALIZED, &rt2x00dev->flags);
 
@@ -1039,11 +1041,6 @@ static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 	rt2x00rfkill_register(rt2x00dev);
 
 	return 0;
-
-exit:
-	rt2x00lib_uninitialize(rt2x00dev);
-
-	return status;
 }
 
 int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
-- 
1.5.5.1

