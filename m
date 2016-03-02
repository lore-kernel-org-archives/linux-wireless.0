Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42456 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbcCBOy4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 09:54:56 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, sven@narfation.org
Subject: [PATCH] mac80211: do not pass injected frames without a valid rate to the driver
Date: Wed,  2 Mar 2016 15:54:51 +0100
Message-Id: <1456930491-17495-1-git-send-email-nbd@openwrt.org> (sfid-20160302_155459_527167_5FE04444)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fall back to rate control if the requested bitrate was not found.

Fixes: dfdfc2beb0dd ("mac80211: Parse legacy and HT rate in injected frames")
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b294820..ea6e2d0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1808,6 +1808,9 @@ static bool ieee80211_parse_tx_radiotap(struct ieee80211_local *local,
 			}
 		}
 
+		if (info->control.rates[0].idx < 0)
+			info->control.flags &= ~IEEE80211_TX_CTRL_RATE_INJECT;
+
 		info->control.rates[0].flags = rate_flags;
 		info->control.rates[0].count = min_t(u8, rate_retries + 1,
 						     local->hw.max_rate_tries);
-- 
2.2.2

