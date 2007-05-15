Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3101 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbXEOUck (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2007 16:32:40 -0400
Date: Tue, 15 May 2007 16:14:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] mac80211: avoid null ptr deref in ieee80211_ibss_add_sta
Message-ID: <20070515201439.GE15105@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

avoid sdata null pointer dereference in ieee80211_ibss_add_sta.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index a36c6f3..dd36cc6 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3154,7 +3154,7 @@ struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata = NULL;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	/* TODO: Could consider removing the least recently used entry and
 	 * allow new one to be added. */
-- 
1.5.0.6

-- 
John W. Linville
linville@tuxdriver.com
