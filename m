Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47304 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab0KMSOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:14:25 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2445882eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 10:14:24 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 9/9] rt2x00: Modify rt2x00queue_remove_l2pad to make skb->data two-byte alignment
Date: Sat, 13 Nov 2010 19:13:53 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131908.15595.IvDoorn@gmail.com> <201011131911.47346.IvDoorn@gmail.com> <201011131912.55384.IvDoorn@gmail.com>
In-Reply-To: <201011131912.55384.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011131913.55169.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: RA-Jay Hung <Jay_Hung@ralinktech.com>

When send out skb data to mac80211, orignal code will cause mac80211
unaligned access, so modify code to make mac80211 can natural access.

Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index dc54317..a3d79c7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -204,8 +204,10 @@ void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length)
 	if (!l2pad)
 		return;
 
-	memmove(skb->data + l2pad, skb->data, header_length);
-	skb_pull(skb, l2pad);
+	memmove(skb->data + header_length, skb->data + header_length + l2pad,
+				skb->len - header_length - l2pad);
+
+	skb_trim(skb, skb->len - l2pad);
 }
 
 static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
-- 
1.7.2.3

