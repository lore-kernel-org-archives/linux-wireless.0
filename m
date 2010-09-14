Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab0INPA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 11:00:27 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Subject: [PATCH v2 05/10] mac80211: reset connection idle when going offchannel
Date: Tue, 14 Sep 2010 11:00:27 -0400
Message-Id: <1284476427-13810-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we go offchannel mac80211 currently leaves alive the
connection idle monitor. This should be instead postponed
until we come back to our home channel, otherwise by the
time we get back to the home channel we could be triggering
unecesary probe requests. For APs that do not respond to
unicast probe requests (Nexus One is a simple example) this
means we essentially get disconnected after the probes
fails.

This patch has stable fixes for kernels [2.6.35+]

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

On this v2 I add the ifmgd on this patch, later on patch
number 07 we make that use this same variable.

 net/mac80211/offchannel.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index eeacaa5..627a33e 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -22,12 +22,15 @@
 static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	local->offchannel_ps_enabled = false;
 
 	/* FIXME: what to do when local->pspolling is true? */
 
 	del_timer_sync(&local->dynamic_ps_timer);
+	del_timer_sync(&ifmgd->conn_mon_timer);
+
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
@@ -85,6 +88,8 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 		mod_timer(&local->dynamic_ps_timer, jiffies +
 			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
+
+	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
 void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local)
-- 
1.7.0.4

