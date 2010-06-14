Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49407 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab0FNUPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:21 -0400
Received: by mail-ww0-f46.google.com with SMTP id 18so4215976wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:21 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/14] rt2x00: Fix tx status reporting when falling back to the lowest rate
Date: Mon, 14 Jun 2010 22:12:26 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com> <201006142211.33421.IvDoorn@gmail.com> <201006142212.02575.IvDoorn@gmail.com>
In-Reply-To: <201006142212.02575.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142212.27713.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

In some corner cases the reported tx rates/retries didn't match the really
used ones.

The hardware lowers the tx rate on each consecutive retry by 1 (but won't
fall back from MCS to legacy rates) _until_ it reaches the lowest one.

In case the frame wasn't sent succesful the number of retries is 7 and if
a rate index <7 was used the previous code reported negative rate indexes
which were then ignored by the rate control algorithm and mac80211.

Instead, report the remaining number of retries to have happened with
the lowest rate (index 0). This should give the rate control algorithm
slightly more accurate information about the used tx rates/retries.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e7a208d..918451a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -258,11 +258,22 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	/*
 	 * Frame was send with retries, hardware tried
 	 * different rates to send out the frame, at each
-	 * retry it lowered the rate 1 step.
+	 * retry it lowered the rate 1 step except when the
+	 * lowest rate was used.
 	 */
 	for (i = 0; i < retry_rates && i < IEEE80211_TX_MAX_RATES; i++) {
 		tx_info->status.rates[i].idx = rate_idx - i;
 		tx_info->status.rates[i].flags = rate_flags;
+
+		if (rate_idx - i == 0) {
+			/*
+			 * The lowest rate (index 0) was used until the
+			 * number of max retries was reached.
+			 */
+			tx_info->status.rates[i].count = retry_rates - i;
+			i++;
+			break;
+		}
 		tx_info->status.rates[i].count = 1;
 	}
 	if (i < (IEEE80211_TX_MAX_RATES - 1))
-- 
1.6.6.1

