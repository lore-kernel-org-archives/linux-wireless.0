Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZKIVDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 16:03:17 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2] mac80211: fix max HT rate processing on mac80211
Date: Mon,  9 Nov 2009 16:03:22 -0500
Message-Id: <1257800602-8922-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The max MCS index is 76, fix the higher check to allow through
frames received at MCS 76. This is a non-issue for current drivers
as MCS 76 is only possible with a device supporting 4 spatial
streams.

While at it change the WARN_ON() on invalid HT rates to a WARN()
to provide more useful information. This will help debug issues
when the driver is passing up a bogus HT rate value.

The rate must map to a valid MCS index which can be any of the
values in the set [0 - 76] (inclusive).

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/rx.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 28316b2..5b26d34 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2425,9 +2425,21 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		goto drop;
 
 	if (status->flag & RX_FLAG_HT) {
-		/* rate_idx is MCS index */
-		if (WARN_ON(status->rate_idx < 0 ||
-			    status->rate_idx >= 76))
+		/*
+		 * rate_idx is MCS index, which can be [0-76] as documented on:
+		 *
+		 * http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
+		 *
+		 * Anything else would be some sort of driver or hardware error.
+		 * The driver should catch hardware errors.
+		 */
+		if (WARN((status->rate_idx < 0 ||
+			 status->rate_idx > 76),
+			 "Rate marked as an HT rate but passed "
+			 "status->rate_idx is not "
+			 "an MCS index [0-76]: %d (0x%02x)\n",
+			 status->rate_idx,
+			 status->rate_idx))
 			goto drop;
 		/* HT rates are not in the table - use the highest legacy rate
 		 * for now since other parts of mac80211 may not yet be fully
-- 
1.6.5.2.143.g8cc62

