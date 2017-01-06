Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033950AbdAFNKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:10:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH 7/9] rt2800usb: mark tx failure on timeout
Date: Fri,  6 Jan 2017 14:05:16 +0100
Message-Id: <1483707918-31480-8-git-send-email-sgruszka@redhat.com> (sfid-20170106_141116_227956_6C437C65)
In-Reply-To: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we do not get TX status in reasonable time, we most likely fail to
send frame hence mark it as so.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 400f074..205a7b8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -602,10 +602,9 @@ static void rt2800usb_txdone_nostatus(struct rt2x00_dev *rt2x00dev)
 			    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
 				break;
 
-			if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
+			if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags) ||
+			    rt2800usb_entry_txstatus_timeout(entry))
 				rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
-			else if (rt2800usb_entry_txstatus_timeout(entry))
-				rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
 			else
 				break;
 		}
-- 
2.7.4
