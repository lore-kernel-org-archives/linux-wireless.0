Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59055 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab0INXkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 19:40:39 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Subject: [PATCH v3 05/11] mac80211: reset probe send counter upon connection timer reset
Date: Tue, 14 Sep 2010 19:40:18 -0400
Message-Id: <1284507624-18176-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1284507624-18176-1-git-send-email-lrodriguez@atheros.com>
References: <1284507624-18176-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon beacon loss we send probe requests after 30 seconds of idle
time and we wait for each probe response 1/2 second. We send a
total of 3 probe requests before giving up on the AP. In the case
that we reset the connection idle monitor we should reset the probe
requests count to 0. Right now this won't help in any way but
the next patch will.

This patch has fixes for stable kernel [2.6.35+].

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cfdafb7..172a397 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -126,11 +126,15 @@ static void mod_beacon_timer(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
 	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
 		return;
 
 	mod_timer(&sdata->u.mgd.conn_mon_timer,
 		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
+
+	ifmgd->probe_send_count = 0;
 }
 
 static int ecw2cw(int ecw)
-- 
1.7.0.4

