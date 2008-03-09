Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:58979 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbYCIVvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:13 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1362530fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:13 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 15/24] rt2x00: Check IEEE80211_TXCTL_SEND_AFTER_DTIM flag
Date: Sun, 9 Mar 2008 22:45:47 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092245.47294.IvDoorn@gmail.com> (sfid-20080309_215422_426190_CE72516A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac sets the IEEE80211_TXCTL_SEND_AFTER_DTIM flag, we should
check if the ATIM queue is available in the driver and put the
frame in that queue for proper behavior (send frame after beacon interval).
Unfortunately not all drivers have this ATIM queue, and will lack
this feature for now.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index a54f687..76a2a7c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -99,7 +99,11 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	/*
 	 * Determine which queue to put packet on.
 	 */
-	queue = rt2x00queue_get_queue(rt2x00dev, control->queue);
+	if (control->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM &&
+	    test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags))
+		queue = rt2x00queue_get_queue(rt2x00dev, RT2X00_BCN_QUEUE_ATIM);
+	else
+		queue = rt2x00queue_get_queue(rt2x00dev, control->queue);
 	if (unlikely(!queue)) {
 		ERROR(rt2x00dev,
 		      "Attempt to send packet over invalid queue %d.\n"
-- 
1.5.4.3

