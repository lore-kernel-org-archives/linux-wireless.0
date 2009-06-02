Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40745 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbZFBU25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:28:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: add missing RCU lock/unlock on ieee80211_rx_bss_info()
Date: Tue,  2 Jun 2009 16:28:57 -0400
Message-Id: <1243974537-12774-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/ibss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 0b30277..446cada 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -365,7 +365,9 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		       sdata->dev->name, mgmt->bssid);
 #endif
 		ieee80211_sta_join_ibss(sdata, bss);
+		rcu_read_lock();
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
+		rcu_read_unlock();
 	}
 
  put_bss:
-- 
1.6.0.6

