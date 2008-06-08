Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:45728 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbYFHVhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 17:37:50 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1023035ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 14:37:49 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 10/10]  rt2x00: Rework alignment check.
Date: Sun, 8 Jun 2008 23:46:48 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200806082341.58616.IvDoorn@gmail.com> <200806082346.06848.IvDoorn@gmail.com> <200806082346.27372.IvDoorn@gmail.com>
In-Reply-To: <200806082346.27372.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082346.49080.IvDoorn@gmail.com> (sfid-20080608_233752_973714_78F1B9B7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

Rework the alignment check in rt2x00dev.c to be independent of any potential
alignment measures that may be taken before. Just check whether the payload is
aligned based on the pointer addresses.

Note: This is preparatory for the dynamically mapped skb buffers for the PCI
drivers, as these need 4-byte alignment instead of the currently enforced offset
by 2 bytes.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index ce1f7bb..9ea6773 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -565,13 +565,9 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 
 	/*
 	 * The data behind the ieee80211 header must be
-	 * aligned on a 4 byte boundary. We already reserved
-	 * 2 bytes for header_size % 4 == 2 optimization.
-	 * To determine the number of bytes which the data
-	 * should be moved to the left, we must add these
-	 * 2 bytes to the header_size.
+	 * aligned on a 4 byte boundary.
 	 */
-	align = (header_size + 2) % 4;
+	align = ((unsigned long)(entry->skb->data + header_size)) & 3;
 
 	if (align) {
 		skb_push(entry->skb, align);
-- 
1.5.5.3

