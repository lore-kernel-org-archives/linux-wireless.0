Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242AbYCSTas (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/3] mac80211: fixing delba debug print
Date: Tue, 18 Mar 2008 15:00:30 -0700
Message-Id: <1205877632-11680-2-git-send-email-reinette.chatre@intel.com> (sfid-20080319_193128_837335_C985A188)
In-Reply-To: <1205877632-11680-1-git-send-email-reinette.chatre@intel.com>
References: <1205877632-11680-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fixes a wrong debug print when receiving delba

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211_sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 8b991eb..6e673df 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1427,7 +1427,7 @@ static void ieee80211_sta_process_delba(struct net_device *dev,
 	if (net_ratelimit())
 		printk(KERN_DEBUG "delba from %s (%s) tid %d reason code %d\n",
 			print_mac(mac, mgmt->sa),
-			initiator ? "recipient" : "initiator", tid,
+			initiator ? "initiator" : "recipient", tid,
 			mgmt->u.action.u.delba.reason_code);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-- 
1.5.3.4

