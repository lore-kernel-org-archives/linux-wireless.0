Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51073 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbZHJODc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 10:03:32 -0400
Subject: [PATCH] mac80211: sequence number micro-optimisation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 16:02:40 +0200
Message-Id: <1249912960.32614.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to mask the variable with 0xFFF0
since we ever only use it as a u16 and the lowest
four bits can't ever be non-zero. The compiler
cannot infer the latter, and therefore has to emit
code to do the masking.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    1 -
 1 file changed, 1 deletion(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-08-10 13:34:45.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-08-10 13:34:58.000000000 +0200
@@ -700,7 +700,6 @@ ieee80211_tx_h_sequence(struct ieee80211
 		/* for pure STA mode without beacons, we can do it */
 		hdr->seq_ctrl = cpu_to_le16(tx->sdata->sequence_number);
 		tx->sdata->sequence_number += 0x10;
-		tx->sdata->sequence_number &= IEEE80211_SCTL_SEQ;
 		return TX_CONTINUE;
 	}
 


