Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab1KCJlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 05:41:49 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/3] mac80211: simplify ieee80211_work_work
Date: Thu,  3 Nov 2011 10:40:47 +0100
Message-Id: <1320313247-23167-3-git-send-email-sgruszka@redhat.com> (sfid-20111103_104151_581363_B64FDF07)
In-Reply-To: <1320313247-23167-1-git-send-email-sgruszka@redhat.com>
References: <1320313247-23167-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since local->tmp_channel is always NULL in one branch, some code paths
will newer be taken in that branch, so remove them.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/work.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 6c53b6d..788b96e 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -969,10 +969,9 @@ static void ieee80211_work_work(struct work_struct *work)
 		}
 
 		if (!started && !local->tmp_channel) {
-			bool on_oper_chan;
-			bool tmp_chan_changed = false;
-			bool on_oper_chan2;
+			bool on_oper_chan, on_oper_chan2;
 			enum nl80211_channel_type wk_ct;
+
 			on_oper_chan = ieee80211_cfg_on_oper_channel(local);
 
 			/* Work with existing channel type if possible. */
@@ -981,11 +980,6 @@ static void ieee80211_work_work(struct work_struct *work)
 				wk_ct = ieee80211_calc_ct(wk->chan_type,
 						local->hw.conf.channel_type);
 
-			if (local->tmp_channel)
-				if ((local->tmp_channel != wk->chan) ||
-				    (local->tmp_channel_type != wk_ct))
-					tmp_chan_changed = true;
-
 			local->tmp_channel = wk->chan;
 			local->tmp_channel_type = wk_ct;
 			/*
@@ -1008,12 +1002,7 @@ static void ieee80211_work_work(struct work_struct *work)
 								    true,
 								    false);
 				}
-			} else if (tmp_chan_changed)
-				/* Still off-channel, but on some other
-				 * channel, so update hardware.
-				 * PS should already be off-channel.
-				 */
-				ieee80211_hw_config(local, 0);
+			}
 
 			started = true;
 			wk->timeout = jiffies;
-- 
1.7.1

