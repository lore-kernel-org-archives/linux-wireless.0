Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:60228 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbYLQNCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 08:02:11 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] ath9k: Fix a NULL pointer dereference in ath_rate_get
Date: Wed, 17 Dec 2008 14:02:00 +0100
Cc: Jouni Malinen <j@w1.fi>, Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20081217113031.GA18060@jm.kir.nu> <200812171325.26310.chunkeey@web.de> <1229516464.5175.2.camel@localhost>
In-Reply-To: <1229516464.5175.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812171402.00354.chunkeey@web.de> (sfid-20081217_140222_089463_129E8FC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 17 December 2008 13:21:04 Johannes Berg wrote:
> On Wed, 2008-12-17 at 13:25 +0100, Christian Lamparter wrote:
> 
> > hostapd: wlan1: STA XX:XX:XX:XX:0d IEEE 802.11: authenticated
> > kernel: [ 3130.431067] ------------[ cut here ]------------
> > kernel: [ 3130.431076] WARNING: at net/mac80211/rc80211_minstrel.c:69 minstrel_rate_init+0xb8/0x320 [mac80211]()
> > kernel: [ 3130.431081] Modules linked in: p54usb p54pci p54common [...]
> > kernel: [ 3130.431300] Pid: 16961, comm: hostapd2 Tainted: P           2.6.28-rc7-wl #3
> > [ 3130.431305] Call Trace:
> > [ 3130.431318]  [<ffffffff802343c1>] warn_on_slowpath+0x51/0x75
> > [ 3130.431329]  [<ffffffff803d74b0>] rb_insert_color+0xba/0xe2
> > [ 3130.431338]  [<ffffffff802480ef>] __remove_hrtimer+0x7c/0x88
> > [ 3130.431375]  [<ffffffffa00bd30e>] minstrel_rate_init+0xb8/0x320 [mac80211]
> > [ 3130.431417]  [<ffffffffa00ae713>] ieee80211_add_station+0x145/0x17d [mac80211]
> > hostapd: wlan1: STA XX:XX:XX:XX:0d IEEE 802.11: associated (aid 1, accounting session 494187DD-00000000)
> > kernel: [ 3130.431440]  [<ffffffffa00897af>] nl80211_new_station+0x1b3/0x20b [cfg80211]
> > kernel: [ 3130.431450]  [<ffffffff80595691>] mutex_lock+0xd/0x1e
> > kernel: [ 3130.431459]  [<ffffffff804f6f86>] nla_parse+0x4b/0xb2
> > 
> > yup, the Warning just happend right between auth and assoc
> 
> This, umm, seems totally unrelated since Jouni was fixing something in
> ath9k's RC algorithm.
> 
hmm, I wanted to point out that not only ath9k's RC algorithm has problems with
uninitialized/dereferenced sta... as he said in his patch description:

"It looks like mac80211 may try to send unicast frames to a STA that does not have a STA entry. "

But if this is a unrelated problem... Sorry!!!

Regards,
	Chr
