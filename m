Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1DALul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 07:50:41 -0400
Subject: [PATCH v2] mac80211: fix comment regarding aggregation buf_size
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 13:52:34 +0200
Message-ID: <1301658754.3832.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The description for buf_size was misleading and
just said you couldn't TX larger aggregates, but
of course you can't TX aggregates in a way that
would exceed the window either, which is possible
even if the aggregates are shorter than that.

Expand the description, thanks to Emmanuel for
explaining this to me.

Cc: Emmanuel Grumbach <egrumbach@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: fix explanation bug :)

 include/net/mac80211.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/include/net/mac80211.h	2011-03-31 12:26:15.000000000 +0200
+++ b/include/net/mac80211.h	2011-04-01 13:49:33.000000000 +0200
@@ -1753,8 +1753,19 @@ enum ieee80211_ampdu_mlme_action {
  * 	that TX/RX_STOP can pass NULL for this parameter.
  *	The @buf_size parameter is only valid when the action is set to
  *	%IEEE80211_AMPDU_TX_OPERATIONAL and indicates the peer's reorder
- *	buffer size (number of subframes) for this session -- aggregates
- *	containing more subframes than this may not be transmitted to the peer.
+ *	buffer size (number of subframes) for this session -- the driver
+ *	may neither send aggregates containing more subframes than this
+ *	nor send aggregates in a way that lost frames would exceed the
+ *	buffer size. If just limiting the aggregate size, this would be
+ *	possible with a buf_size of 8:
+ *	 - TX: 1.....7
+ *	 - RX:  2....7 (lost frame #1)
+ *	 - TX:        8..1...
+ *	which is invalid since #1 was now re-transmitted well past the
+ *	buffer size of 8. Correct ways to retransmit #1 would be:
+ *	 - TX:       1 or 18 or 81
+ *	Even "189" would be wrong since 1 could be lost again.
+ *
  *	Returns a negative error code on failure.
  *	The callback can sleep.
  *


