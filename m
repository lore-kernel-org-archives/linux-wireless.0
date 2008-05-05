Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:33577 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbYEEPRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 11:17:37 -0400
Received: by ug-out-1314.google.com with SMTP id h2so75168ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 08:17:36 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 2/3] rt2x00: Fix broken recover-on-error path
Date: Mon, 5 May 2008 17:23:47 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805051723.12127.IvDoorn@gmail.com>
In-Reply-To: <200805051723.12127.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805051723.47814.IvDoorn@gmail.com> (sfid-20080505_171657_324990_D714BD47)
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

