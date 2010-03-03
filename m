Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:17390 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755204Ab0CCJpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 04:45:45 -0500
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0235099543
	for <linux-wireless@vger.kernel.org>; Wed,  3 Mar 2010 18:45:43 +0900 (JST)
Subject: [PATCH v2] mac80211: fix rates setup on IBSS merge
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, awozniak@irobot.com,
	benoit.papillault@free.fr
Date: Wed, 03 Mar 2010 18:45:42 +0900
Message-ID: <20100303094542.13968.96481.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

when an IBSS merge happened, the supported rates for the newly added station
were left empty, causing the rate control module to be initialized with only
the basic rates.

the section of the ibss code which deals with updating supported rates for
an already existing station failed to inform the rate control module about the
new rates. as both minstrel and pid don't have an update function i just use
the init function.

also remove unnecessary (unsigned long long) casts and edit debug message.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 net/mac80211/ibss.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f3e9424..01974c2 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -264,17 +264,16 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			sta->sta.supp_rates[band] = supp_rates |
 				ieee80211_mandatory_rates(local, band);
 
+			if (sta->sta.supp_rates[band] != prev_rates) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-			if (sta->sta.supp_rates[band] != prev_rates)
 				printk(KERN_DEBUG "%s: updated supp_rates set "
-				    "for %pM based on beacon info (0x%llx | "
-				    "0x%llx -> 0x%llx)\n",
-				    sdata->name,
-				    sta->sta.addr,
-				    (unsigned long long) prev_rates,
-				    (unsigned long long) supp_rates,
-				    (unsigned long long) sta->sta.supp_rates[band]);
+				    "for %pM based on beacon/probe_response "
+				    "(0x%x -> 0x%x)\n",
+				    sdata->name, sta->sta.addr,
+				    prev_rates, sta->sta.supp_rates[band]);
 #endif
+				rate_control_rate_init(sta);
+			}
 			rcu_read_unlock();
 		} else {
 			rcu_read_unlock();
@@ -370,6 +369,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		       sdata->name, mgmt->bssid);
 #endif
 		ieee80211_sta_join_ibss(sdata, bss);
+		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
 				       supp_rates, GFP_KERNEL);
 	}

