Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57723 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbYKKM4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 07:56:18 -0500
Subject: Re: scheduling while atomic: iwl3945 in mmotm 2008-09-23-11-27
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"flamingice@sourmilk.net" <flamingice@sourmilk.net>,
	Tomas Winkler <tomasw@gmail.com>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1226375524.2604.328.camel@debian.sh.intel.com>
References: <48DE8EC9.80306@gmail.com>
	 (sfid-20080927_215201_348716_1480E298)  <1222588029.3798.77.camel@johannes.berg>
	 <1226375524.2604.328.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 11:28:04 +0100
Message-Id: <1226399284.3890.5.camel@johannes.berg> (sfid-20081111_135622_918367_8DE432AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-11-11 at 11:52 +0800, Zhu Yi wrote:

> > >  [<ffffffff80257315>] synchronize_rcu+0x35/0x40
> > 
> > >  [<ffffffff80551d17>] sta_info_destroy+0x47/0x110
> > >  [<ffffffff80559156>] ieee80211_set_disassoc+0x146/0x250
> > >  [<ffffffff805593d5>] ieee80211_sta_req_auth+0x85/0x90
> > >  [<ffffffff8055b156>] ieee80211_notify_mac+0x56/0xa0

> > We can fix this by using RTNL locking instead, not sure though that'll
> > work because I don't know how iwl3945 calls this, I'll let Tomas deal
> > with it.
> 
> Johannes, this scheduleing in atomic has nothing to do with the caller.
> iwl3945 already calls it in a workqueue. The problem is inside
> ieee80211_notify_mac(). Unfortunately, iwl3945/iwlagn turns to be the
> only user at this time.

I see. But the suggestion above is valid nonetheless and works fine if
it's called from a workqueue. I take no blame for this though, you guys
added this function and you also changed ieee80211_set_disassoc() in
ways that made the original implementation wrong :P

John, please apply the patch below.

johannes


From: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: fix notify_mac function

The ieee80211_notify_mac() function uses ieee80211_sta_req_auth() which
in turn calls ieee80211_set_disassoc() which calls a few functions that
need to be able to sleep, so ieee80211_notify_mac() cannot use RCU
locking for the interface list and must use rtnl locking instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-11-11 11:23:09.000000000 +0100
+++ everything/net/mac80211/mlme.c	2008-11-11 11:23:24.000000000 +0100
@@ -2596,14 +2596,14 @@ void ieee80211_notify_mac(struct ieee802
 
 	switch (notif_type) {
 	case IEEE80211_NOTIFY_RE_ASSOC:
-		rcu_read_lock();
-		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		rtnl_lock();
+		list_for_each_entry(sdata, &local->interfaces, list) {
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				continue;
 
 			ieee80211_sta_req_auth(sdata, &sdata->u.sta);
 		}
-		rcu_read_unlock();
+		rtnl_unlock();
 		break;
 	}
 }


