Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39800 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbZIPCYh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 22:24:37 -0400
Subject: [PATCH] rc80211_minstrel: fix contention window calculation
To: Dan Halperin <dhalperi@cs.washington.edu>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 15 Sep 2009 22:24:30 -0400
Message-ID: <20090916022430.27557.93510.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The contention window is supposed to be a power of two minus one, i.e.
15, 31, 63, 127...  minstrel_rate_init() forgets to subtract 1, so the
sequence becomes 15, 32, 66, 134...

Bug reported by Dan Halperin <dhalperi@cs.washington.edu>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 net/mac80211/rc80211_minstrel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 7c51429..6e5d68b 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -418,7 +418,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 
 			/* contention window */
 			tx_time_single += t_slot + min(cw, mp->cw_max);
-			cw = (cw + 1) << 1;
+			cw = (cw << 1) | 1;
 
 			tx_time += tx_time_single;
 			tx_time_cts += tx_time_single + mi->sp_ack_dur;
