Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:27313 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYGENF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 09:05:27 -0400
Received: by nf-out-0910.google.com with SMTP id d3so459318nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2008 06:05:24 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH] rt2x00: Fix NULL pointer error in adhoc/master mode
Date: Sat, 5 Jul 2008 15:11:57 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807051511.57995.IvDoorn@gmail.com> (sfid-20080705_150534_249472_AA48E81B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As soon as an interface is enabled, and that interface is in adhoc or master mode,
the device will start raising beacondone interrupts. But before the first interrupt is
raised, mac80211 will probably not have send any beacons to the device yet, which
results in a NULL pointer error when the skb is being freed.

Note that the "raise beacondone interrupts without a beacon" is also a bug,
and will be addressed later. The more important bug however is preventing
the NULL pointer failt itself, since there might be other conditions that could trigger
it as well.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 8e86611..a9aa0d5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -107,6 +107,9 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 
 void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 {
+	if (!skb)
+		return;
+
 	rt2x00queue_unmap_skb(rt2x00dev, skb);
 	dev_kfree_skb_any(skb);
 }
