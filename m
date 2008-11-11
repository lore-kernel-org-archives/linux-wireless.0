Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52054 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbYKKDwE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 22:52:04 -0500
Subject: Re: scheduling while atomic: iwl3945 in mmotm 2008-09-23-11-27
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"flamingice@sourmilk.net" <flamingice@sourmilk.net>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1222588029.3798.77.camel@johannes.berg>
References: <48DE8EC9.80306@gmail.com>
	 (sfid-20080927_215201_348716_1480E298)  <1222588029.3798.77.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 11:52:04 +0800
Message-Id: <1226375524.2604.328.camel@debian.sh.intel.com> (sfid-20081111_045210_218679_E9A49491)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-09-28 at 01:47 -0600, Johannes Berg wrote:
> On Sat, 2008-09-27 at 21:51 +0200, Jiri Slaby wrote:
> 
> > BUG: scheduling while atomic: iwl3945/0/1154/0x00000002
> 
> >  [<ffffffff80257315>] synchronize_rcu+0x35/0x40
> 
> >  [<ffffffff80551d17>] sta_info_destroy+0x47/0x110
> >  [<ffffffff80559156>] ieee80211_set_disassoc+0x146/0x250
> >  [<ffffffff805593d5>] ieee80211_sta_req_auth+0x85/0x90
> >  [<ffffffff8055b156>] ieee80211_notify_mac+0x56/0xa0
> >  [<ffffffffa0054663>] iwl3945_bg_alive_start+0x2f3/0x360 [iwl3945]
> 
> > I don't know who is responsible here. Maybe ieee80211_notify_mac? Citing:
> > "It is illegal to block while in an RCU read-side critical section." from
> > rcu_read_lock comments, but synchronize_rcu() in __ieee80211_key_todo()
> > sleeps and few mutexes are locked and might_sleep() invoked on the path too.
> 
> Yup, for sure.
> 
> This is a combination of various things, when ieee80211_notify_mac was
> added ieee80211_sta_req_auth didn't destroy the sta info, later they
> fixed a different bug that started doing that and we all missed that it
> was called from here...
> 
> We can fix this by using RTNL locking instead, not sure though that'll
> work because I don't know how iwl3945 calls this, I'll let Tomas deal
> with it.

Johannes, this scheduleing in atomic has nothing to do with the caller.
iwl3945 already calls it in a workqueue. The problem is inside
ieee80211_notify_mac(). Unfortunately, iwl3945/iwlagn turns to be the
only user at this time.

Thanks,
-yi

