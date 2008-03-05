Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbYCEJXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:23:38 -0500
Subject: RE: [PATCH 4/8] mac80211: RCU-ify STA info structure access
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	linux-wireless@vger.kernel.org,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
In-Reply-To: <D936D925018D154694D8A362EEB0892003CFB0E4@orsmsx416.amr.corp.intel.com>
References: <20080222111644.183587000@sipsolutions.net>
	 <20080222111749.689180000@sipsolutions.net>
	 <D936D925018D154694D8A362EEB0892003CFB0E4@orsmsx416.amr.corp.intel.com>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 10:23:25 +0100
Message-Id: <1204709005.25502.38.camel@johannes.berg> (sfid-20080305_092408_621727_1871A9C4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This patch is causing some problems in the iwlwifi driver. Often when
> one of these RCU locks are held the driver tries to send a command to
> the device and waits for the response, or it does some other activity
> requiring sleeping. This causes numerous BUG messages as seen below:
> 
> BUG: sleeping function called from invalid context at
> /home/rchatre/wifi/repos.git/iwlwifi-2.6/kernel/mutex.c:209


>  [<dca8e637>] iwl3945_mac_conf_tx+0x1b0/0x234 [iwl3945]
>  [<dc9d186a>] ieee80211_sta_wmm_params+0x165/0x195 [mac80211]

Ouch, sorry. Try this patch please.

johannes

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
 


