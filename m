Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44639 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1EDTmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 15:42:49 -0400
Received: by eyx24 with SMTP id 24so461591eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 12:42:48 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] rt2x00: Fix transfer speed regression for USB hardware
Date: Wed, 4 May 2011 21:42:05 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201105042141.37135.IvDoorn@gmail.com>
In-Reply-To: <201105042141.37135.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105042142.06091.IvDoorn@gmail.com> (sfid-20110504_214252_090290_695C7847)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

Patch:
  rt2x00: Make rt2x00_queue_entry_for_each more flexible
  commit: 10e11568ca8b8a15f7478f6a4ceebabcbdba1018

introduced a severe regression on the throughput
for USB hardware. It turns out that the exiting of
the rt2x00queue_for_each_entry() was done too early.

The exact cause for this regression is unknown,
but by disabling the premature exiting of the loop
seems to resolve the issue.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Reported-by: Yasushi SHOJI <yashi@atmark-techno.com>
Reported-by: Balint Viragh <bviragh@dension.com>
Tested-by: Balint Viragh <bviragh@dension.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index e027ebd..dc6b662 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -298,7 +298,7 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void* data)
 
 	if (!test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags) ||
 	    test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
-		return true;
+		return false;
 
 	/*
 	 * USB devices cannot blindly pass the skb->len as the
@@ -392,7 +392,7 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void* data)
 
 	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
 	    test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
-		return true;
+		return false;
 
 	rt2x00lib_dmastart(entry);
 
@@ -447,7 +447,7 @@ static bool rt2x00usb_flush_entry(struct queue_entry *entry, void* data)
 	struct queue_entry_priv_usb_bcn *bcn_priv = entry->priv_data;
 
 	if (!test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
-		return true;
+		return false;
 
 	usb_kill_urb(entry_priv->urb);
 
-- 
1.7.2.3

