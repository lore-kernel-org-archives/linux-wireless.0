Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:34274 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1L2RVg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Dec 2011 12:21:36 -0500
Date: Thu, 29 Dec 2011 17:58:00 +0100
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Cc: Marek Lindner <lindner_marek@yahoo.de>
Subject: [PATCH] net/mac80211/sta_info.c: Fix crash in ieee80211_sta_expire.
Message-ID: <20111229165800.GA7405@zenon.in.qult.net> (sfid-20111229_182201_551081_F7154CBB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing brackets after applying ec2b774e7c91094d8c00de579646f1162b87b01e.
---
 net/mac80211/sta_info.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f0d3b48..1b085f7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -945,7 +945,7 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta, *tmp;
 
 	mutex_lock(&local->sta_mtx);
-	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
+	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
 		if (sdata != sta->sdata)
 			continue;
 
@@ -956,6 +956,7 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 #endif
 			WARN_ON(__sta_info_destroy(sta));
 		}
+	}
 	mutex_unlock(&local->sta_mtx);
 }
 
-- 
1.7.5.4
