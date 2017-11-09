Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750869AbdKIK7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 05:59:25 -0500
Date: Thu, 9 Nov 2017 11:59:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] rt2x00usb: mark device removed when get ENOENT usb error
Message-ID: <20171109105917.GA3206@redhat.com> (sfid-20171109_115940_587273_AA3A4184)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ENOENT usb error mean "specified interface or endpoint does not exist or
is not enabled". Mark device not present when we encounter this error
similar like we do with ENODEV error.

Otherwise we can have infinite loop in rt2x00usb_work_rxdone(), because
we remove and put again RX entries to the queue infinitely.

We can have similar situation when submit urb will fail all the time
with other error, so we need consider to limit number of entries
processed by rxdone work. But for now, since the patch fixes
reproducible soft lockup issue on single processor systems
and taken ENOENT error meaning, let apply this fix.

Patch adds additional ENOENT check not only in rx kick routine, but
also on other places where we check for ENODEV error.

Reported-by: Richard Genoud <richard.genoud@gmail.com>
Debugged-by: Richard Genoud <richard.genoud@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index e2f4f5778267..086aad22743d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -57,7 +57,7 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 		if (status >= 0)
 			return 0;
 
-		if (status == -ENODEV) {
+		if (status == -ENODEV || status == -ENOENT) {
 			/* Device has disappeared. */
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 			break;
@@ -321,7 +321,7 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void *data)
 
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
-		if (status == -ENODEV)
+		if (status == -ENODEV || status == -ENOENT)
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);
@@ -410,7 +410,7 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void *data)
 
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
-		if (status == -ENODEV)
+		if (status == -ENODEV || status == -ENOENT)
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);
-- 
2.7.5
