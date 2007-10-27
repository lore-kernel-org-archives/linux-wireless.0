Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:3327 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbXJ0LZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:17 -0400
Received: by nf-out-0910.google.com with SMTP id g13so973056nfb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:17 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/21] rt2x00: Detect initial rfkill state on register
Date: Sat, 27 Oct 2007 13:40:51 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271340.51618.IvDoorn@gmail.com> (sfid-20071027_124131_168631_4D493122)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When registering rfkill, make sure a initial
poll event is directly executed to detect the initial
rfkill state and send the event to the rfkill layer.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index db513f1..16d365d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -94,6 +94,13 @@ int rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 		return retval;
 	}
 
+	/*
+	 * Force initial poll which will detect the initial device state,
+	 * and correctly sends the signal to the rfkill layer about this
+	 * state.
+	 */
+	rt2x00rfkill_poll(rt2x00dev->poll_dev);
+
 	return 0;
 }
 
@@ -121,7 +128,7 @@ int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00dev->rfkill->name = rt2x00dev->ops->name;
 	rt2x00dev->rfkill->data = rt2x00dev;
-	rt2x00dev->rfkill->state = rt2x00dev->ops->lib->rfkill_poll(rt2x00dev);
+	rt2x00dev->rfkill->state = -1;
 	rt2x00dev->rfkill->toggle_radio = rt2x00rfkill_toggle_radio;
 
 	rt2x00dev->poll_dev = input_allocate_polled_device();
-- 
1.5.3.4

