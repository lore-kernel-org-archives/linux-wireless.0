Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:11944 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752043Ab0BWJ54 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 04:57:56 -0500
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0834218674
	for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2010 18:51:15 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH] mac80211: fix rates setup on IBSS merge
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 23 Feb 2010 18:51:13 +0900
Message-ID: <20100223095113.25360.75291.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

when an IBSS merge happened, the supported rates for the newly added station
were left empty, causing the rate control module to be initialized with only
the basic rates.

also the section of the ibss code which deals with updating supported rates for
an already existing station fails to inform the rate control module about the
new rates. as i don't know how to fix this (minstrel does not have an update
function), i have just added a comment for now.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 net/mac80211/ibss.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f3e9424..b840d90 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -276,6 +276,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				    (unsigned long long) sta->sta.supp_rates[band]);
 #endif
 			rcu_read_unlock();
+
+			/* FIXME: update rate control */
 		} else {
 			rcu_read_unlock();
 			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
@@ -370,6 +372,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		       sdata->name, mgmt->bssid);
 #endif
 		ieee80211_sta_join_ibss(sdata, bss);
+		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
 				       supp_rates, GFP_KERNEL);
 	}

