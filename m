Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab1DRNf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:35:59 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833789fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:35:58 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/23] rt2800usb: handle TX status timeouts
Date: Mon, 18 Apr 2011 15:30:01 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181529.13131.IvDoorn@gmail.com> <201104181529.39237.IvDoorn@gmail.com>
In-Reply-To: <201104181529.39237.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181530.02029.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Stezenbach <js@sig21.net>

The watchdog just triggers rt2800usb_work_txdone() when it
detects a TX status timeout, thus rt2800usb_work_txdone() needs to
handle this case.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 862430e..69004b9 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -449,11 +449,14 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 		while (!rt2x00queue_empty(queue)) {
 			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 
-			if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
-			    !test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
+			if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+				break;
+			if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
+				rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
+			else if (rt2x00queue_status_timeout(entry))
+				rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
+			else
 				break;
-
-			rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
 		}
 	}
 }
-- 
1.7.2.3

