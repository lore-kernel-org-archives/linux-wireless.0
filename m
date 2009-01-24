Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2514 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbZAXSVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 13:21:22 -0500
Date: Sat, 24 Jan 2009 13:21:14 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] mac80211: flush workqueue a second time in suspend()
Message-ID: <20090124182114.GA15199@hash.localnet> (sfid-20090124_192130_031348_9EB02D18)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers can theoretically queue more work in one of their callbacks
from mac80211 suspend, so let's flush it once more to be on the safe
side, just before calling ->stop().

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/pm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 6d17ed7..44525f5 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -44,6 +44,9 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 		}
 	}
 
+	/* flush again, in case driver queued work */
+	flush_workqueue(local->hw.workqueue);
+
 	/* stop hardware */
 	if (local->open_count) {
 		ieee80211_led_radio(local, false);
-- 
1.6.0.6

-- 
Bob Copeland %% www.bobcopeland.com

