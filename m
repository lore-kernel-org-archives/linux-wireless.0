Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63895 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965246Ab2CBXF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 18:05:29 -0500
Received: by pbcun15 with SMTP id un15so605344pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 15:05:29 -0800 (PST)
MIME-Version: 1.0
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 1/3] mac80211: expose sta_set_sinfo()
Date: Fri,  2 Mar 2012 15:05:22 -0800
Message-Id: <1330729524-1010-1-git-send-email-thomas@cozybit.com> (sfid-20120303_000541_125113_0DC2953C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Expose sta_set_sinfo() in sta_info.h so other code (i.e. mesh) can take
advantage of some cfg80211 utility functions.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/cfg.c      |    2 +-
 net/mac80211/sta_info.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6a77d4c..4ae0197 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -336,7 +336,7 @@ static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, in
 		rate->mcs = idx;
 }
 
-static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
+void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct timespec uptime;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 23a97c9..c6f46c3 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -528,6 +528,7 @@ void sta_info_init(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
 int sta_info_flush(struct ieee80211_local *local,
 		   struct ieee80211_sub_if_data *sdata);
+void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo);
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 
-- 
1.7.5.4

