Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbYCIVuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:50:46 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:50:45 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 04/24] rt2x00: Don't use uninitialized desc_len
Date: Sun, 9 Mar 2008 22:40:06 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092240.06525.IvDoorn@gmail.com> (sfid-20080309_215050_026222_82F8A638)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skbdesc->desc_len is uninitialized at the start
of the function. So it is a _bad_ idea to use it...

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt73usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index b4b7085..a48c82f 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1381,7 +1381,7 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	skb_push(entry->skb, offset);
 	memcpy(entry->skb->data, rxd, entry->queue->desc_size);
 	rxd = (__le32 *)entry->skb->data;
-	skb_pull(entry->skb, offset + skbdesc->desc_len);
+	skb_pull(entry->skb, offset + entry->queue->desc_size);
 	skb_trim(entry->skb, rxdesc->size);
 
 	/*
-- 
1.5.4.3

