Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51153 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0JPPJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Oct 2010 11:09:30 -0400
Received: by bwz15 with SMTP id 15so1769979bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 16 Oct 2010 08:09:06 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.36] mac80211: don't sanitize invalid rates
Date: Sat, 16 Oct 2010 18:49:15 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010161849.15787.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found this bug while poking around with a pure-gn AP.

Commit:
cfg80211/mac80211: Use more generic bitrate mask for rate control

Added some sanity checks to ensure that each tx rate index
is included in the configured mask and it would change any
rate indexes if it wasn't.

But, the current implementation doesn't take into account
that the invalid rate index "-1" has a special meaning
(= no further attempts) and it should not be "changed".

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 4f772de..50a1200 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -328,6 +328,9 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 		 * if needed.
 		 */
 		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+			/* Skip invalid rates */
+			if (info->control.rates[i].idx < 0)
+				break;
 			/* Rate masking supports only legacy rates for now */
 			if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS)
 				continue;
