Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933244AbXGaSe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:28 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:28 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 21/24] rt2x00: Don't check for preamble in RXdone
Date: Tue, 31 Jul 2007 20:37:38 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.38691.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 0ad766f217ff7be662dd1da4b55dc19de4ac0018 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 31 Jul 2007 16:05:20 +0200
Subject: [PATCH 21/24] rt2x00: Don't check for preamble in RXdone

Don't return rate->val2 to mac80211 as the rate
value for a received frame. Not only will this
falsely identify frames received at 1Mbs and 11Mbs
as preamble. But it will also confuse mac80211
who will only search for rate->val.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00dev.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 42308ed..8e860a8 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -288,13 +288,7 @@ void rt2x00lib_rxdone(struct data_entry *entry, char *data,
 			val = DEVICE_GET_RATE_FIELD(rate->val, PLCP);
 
 		if (val == signal) {
-			/*
-			 * Check for preamble bit.
-			 */
-			if (signal & 0x08)
-				val = rate->val2;
-			else
-				val = rate->val;
+			val = rate->val;
 			break;
 		}
 	}
-- 
1.5.2.4

