Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54294 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbZAPSwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 13:52:41 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 10:52:41 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <Jouni.Malinen@atheros.com>, <Jouni.Malinen@atheros.com>,
	<johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: do not TX injected frames when not allowed
Date: Fri, 16 Jan 2009 10:52:12 -0800
Message-ID: <1232131932-25044-1-git-send-email-lrodriguez@atheros.com> (sfid-20090116_195246_662337_C460CDDB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Monitor mode is able to TX by using injected frames. We should
not allow injected frames to be sent unless allowed by regulatory rules.
Since AP mode uses a monitor interfaces to transmit management frames
we have to take care to not break AP mode as well. Since hostapd
respects 'no-ibss|radar' flags we can make use of the same policy
statically for checking when to disable injected frames. Once AP
mode supports radar detection we should somehow distinguish a
regular monitor mode from an AP's monitor interface.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/tx.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 955f186..276a666 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -899,6 +899,16 @@ __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
+	/* Frame injection is not allowed if beaconing is not allowed
+	 * or if we need radar detection. Beaconing is usually not allowed when
+	 * the mode or operation (Adhoc, AP, Mesh) does not support DFS.
+	 * Since AP mode uses monitor interafaces to inject/TX management
+	 * frames once we have radar detection support we can change this
+	 * here */
+	if ((tx->channel->flags & (IEEE80211_CHAN_NO_IBSS |
+	    IEEE80211_CHAN_RADAR)))
+		return TX_DROP;
+
 	skb->do_not_encrypt = 1;
 	tx->flags &= ~IEEE80211_TX_FRAGMENTED;
 
-- 
1.6.1.rc3.51.g5832d

