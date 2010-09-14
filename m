Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab0INOU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 10:20:28 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Subject: [PATCH 07/10] mac80211: disable beacon monitor while going offchannel
Date: Tue, 14 Sep 2010 10:20:28 -0400
Message-Id: <1284474028-3337-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon monitor should be disabled when going off channel
to prevent spurious warnings and triggering connection
deterioration work such as sending probe requests. Re-enable
the beacon monitor once we come back to the home channel.

This patch has fixes for stable kernels [2.6.34+]

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/offchannel.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 8b58626..b199136 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -22,12 +22,14 @@
 static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	local->offchannel_ps_enabled = false;
 
 	/* FIXME: what to do when local->pspolling is true? */
 
 	del_timer_sync(&local->dynamic_ps_timer);
+	del_timer_sync(&ifmgd->bcn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.conn_mon_timer);
 
 	cancel_work_sync(&local->dynamic_ps_enable_work);
@@ -88,6 +90,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 
+	ieee80211_sta_reset_beacon_monitor(sdata);
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-- 
1.7.0.4

