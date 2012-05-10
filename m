Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:48058 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104Ab2EJGpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 02:45:08 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/7] mac80211: add tracking of temporary offchannel sdata
Date: Thu, 10 May 2012 08:44:36 +0200
Message-ID: <1336632282-2278-2-git-send-email-michal.kazior@tieto.com> (sfid-20120510_084517_056570_CAB492E8)
In-Reply-To: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is necessary if we want to have a sdata-based
channel recalculation.

Change-Id: I223e052146893b3ae1ca46de7d90c54ffc589f1b
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/work.c        |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b5e491b..c109960 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -997,6 +997,7 @@ struct ieee80211_local {
 	struct ieee80211_channel *oper_channel, *csa_channel;
 
 	/* Temporary remain-on-channel for off-channel operations */
+	struct ieee80211_sub_if_data *tmp_sdata;
 	struct ieee80211_channel *tmp_channel;
 	enum nl80211_channel_type tmp_channel_type;
 
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index b2650a9..2a0b252 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -152,6 +152,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		if (!started && !local->tmp_channel) {
 			ieee80211_offchannel_stop_vifs(local, true);
 
+			local->tmp_sdata = wk->sdata;
 			local->tmp_channel = wk->chan;
 			local->tmp_channel_type = wk->chan_type;
 
@@ -219,6 +220,7 @@ static void ieee80211_work_work(struct work_struct *work)
 	}
 
 	if (!remain_off_channel && local->tmp_channel) {
+		local->tmp_sdata = NULL;
 		local->tmp_channel = NULL;
 		ieee80211_hw_config(local, 0);
 
-- 
1.7.0.4

