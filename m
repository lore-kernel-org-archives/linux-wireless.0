Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbYCETjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 14:39:51 -0500
Subject: [PATCH] mac80211: don't call conf_tx under RCU lock
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 20:39:31 +0100
Message-Id: <1204745971.25502.91.camel@johannes.berg> (sfid-20080305_193955_595946_39094193)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette pointed out that with the sta_info RCU-ification
the behaviour here changed and the conf_tx callback is
now invoked under RCU read lock. That is not necessary so
this patch restores the original behaviour

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Reinette Chatre <reinette.chatre@intel.com>
---
 net/mac80211/ieee80211_sta.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2008-03-05 10:17:37.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-03-05 10:18:12.000000000 +0100
@@ -1930,16 +1930,16 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
 		sta->flags |= WLAN_STA_WME;
+		rcu_read_unlock();
 		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
 					 elems.wmm_param_len);
-	}
+	} else
+		rcu_read_unlock();
 
 	/* set AID, ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
 	ieee80211_set_associated(dev, ifsta, 1);
 
-	rcu_read_unlock();
-
 	ieee80211_associated(dev, ifsta);
 }
 


