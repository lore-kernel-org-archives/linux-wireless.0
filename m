Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:58979 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbYCIVvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:02 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1362530fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:01 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 10/24] rt2x00:correct rx packet length for USB devices
Date: Sun, 9 Mar 2008 22:43:27 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092243.27660.IvDoorn@gmail.com> (sfid-20080309_222407_850307_6CDBAEFE)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adam Baker <linux@baker-net.org.uk>

When fixing up the packet alignment, if we had to add 2 bytes to the front of
the skb we need to remember to take them off the end afterwards. This fixes
reception of encrypted packets which were otherwise failing with an invalid
ICV.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index eec9111..5a33167 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -299,6 +299,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 		memmove(entry->skb->data, entry->skb->data + 2,
 			entry->skb->len - 2);
 		skbdesc->data = entry->skb->data;
+		skb_trim(entry->skb,entry->skb->len - 2);
 	}
 
 	/*
-- 
1.5.4.3

