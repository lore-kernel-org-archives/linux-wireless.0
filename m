Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:2192 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYFCS0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:26:11 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644294nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 11:26:09 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/11] rt2x00: Don't kill guardian_urb when it wasn't created
Date: Tue, 3 Jun 2008 20:29:50 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032026.40506.IvDoorn@gmail.com> <200806032027.06094.IvDoorn@gmail.com>
In-Reply-To: <200806032027.06094.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200806032029.51057.IvDoorn@gmail.com> (sfid-20080603_202615_927155_56F9186A)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a "BUG: unable to handle kernel paging request"
bug in rt73usb which was caused by killing the guardian_urb
while it had never been allocated for rt73usb.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 52d12fd..36a087a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -394,8 +394,11 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
-	 * Kill guardian urb.
+	 * Kill guardian urb (if required by driver).
 	 */
+	if (!test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags))
+		return;
+
 	for (i = 0; i < rt2x00dev->bcn->limit; i++) {
 		bcn_priv = rt2x00dev->bcn->entries[i].priv_data;
 		if (bcn_priv->guardian_urb)
-- 
1.5.5.3

