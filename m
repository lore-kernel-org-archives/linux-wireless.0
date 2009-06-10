Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbZFJMy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 08:54:29 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/18 v2] mac80211: disable moving between PS modes during scan
Date: Wed, 10 Jun 2009 08:54:28 -0400
Message-Id: <1244638468-28662-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't want to trigger moving between PS mode during
scan. With this enabled we sometimes end up sending nullfunc
frames during scan. We're supposed to only send one prior to
scan and after scan.

This fixes an oops which occured due to an assert in ath9k:

http://marc.info/?l=linux-wireless&m=124277331319024

The assert was happening because the rate control algorithm
figures it should find at least one valid dual stream or
single stream rate. Since we allow mac80211 to send nullfunc
frames during scan and dynamic PS was enabled at times we ended
up trying to send nullfunc frames for the target sta on the
wrong band for which we have no valid rate to communicate with
it. This brakes the assumptions in rate control. We'll handle
this sanity check next, but this fix does prevent the
spurious nullfunc frames from actually being sent.

We determine we also need to disable moving between PS modes
when not associated so lets just add that now as well.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

While testing when I was sleep walking I noticed I couldn't switch
to a different AP. The new changes here fixed that.

I'm not seeing any more strange deadbeef stuff with this series now.

 net/mac80211/tx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1aed88d..e0a4e06 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1415,7 +1415,9 @@ int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
-	    local->hw.conf.dynamic_ps_timeout > 0) {
+	    local->hw.conf.dynamic_ps_timeout > 0 &&
+	    !local->sw_scanning && !local->hw_scanning && local->ps_sdata &&
+	    (local->ps_sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED)) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_QUEUE_STOP_REASON_PS);
-- 
1.5.6.3

