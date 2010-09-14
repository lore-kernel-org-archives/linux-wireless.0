Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59051 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab0INXkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 19:40:39 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Subject: [PATCH v3 08/11] mac80211: disable beacon monitor while going offchannel
Date: Tue, 14 Sep 2010 19:40:21 -0400
Message-Id: <1284507624-18176-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1284507624-18176-1-git-send-email-lrodriguez@atheros.com>
References: <1284507624-18176-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon monitor should be disabled when going off channel
to prevent spurious warnings and triggering connection
deterioration work such as sending probe requests. Re-enable
the beacon monitor once we come back to the home channel.

This patch has fixes for stable kernels [2.6.34+].

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/offchannel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 627a33e..4b56409 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -29,6 +29,7 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 	/* FIXME: what to do when local->pspolling is true? */
 
 	del_timer_sync(&local->dynamic_ps_timer);
+	del_timer_sync(&ifmgd->bcn_mon_timer);
 	del_timer_sync(&ifmgd->conn_mon_timer);
 
 	cancel_work_sync(&local->dynamic_ps_enable_work);
@@ -89,6 +90,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 
+	ieee80211_sta_reset_beacon_monitor(sdata);
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-- 
1.7.0.4

