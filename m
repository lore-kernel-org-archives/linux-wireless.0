Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2519 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbXI1Cjk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 22:39:40 -0400
Date: Thu, 27 Sep 2007 22:01:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, David Miller <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Zhu Yi <yi.zhu@intel.com>, Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Please pull mac80211-misc
Message-ID: <20070928020113.GH7991@tuxdriver.com>
References: <200709181842.47419.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200709181842.47419.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry it took me a while to respond -- it has been a busy couple of
weeks for me...

On Tue, Sep 18, 2007 at 06:42:43PM -0400, Michael Wu wrote:

> As you can see, most of the updates this time are from Johannes and fix a 
> number of issues. Some of them are locking issues. One is an update to the 
> driver API which breaks every mac80211 driver. I have fixed the drivers which 
> were in net-2.6.24 when I pulled a few days ago, but it appears that b43 and 
> iwlwifi are going in too.. which is somewhat unfortunate timing. Johannes has 
> an update for b43 but there isn't an api update for b43legacy or iwlwifi yet.

The filter api change went to net-2.6.24 this evening.  Most of the
drivers (i.e. all the ones already in net-2.6.24) have patches to
adapt to the change, which I rolled into a single patch with the
change itself.

The ath5k and zd1211rw-mac80211 driver do not have patches for the
new filter api.  I know Luis is working on one for ath5k, but I don't
know of anyone working on one for the other driver.  Hopefully Daniel,
Ulrich, or someone will get on that ASAP (hint, hint).

> I also did not include Johannes' patch adding himself to the maintainers list, 
> but it seems like a good idea. However, I don't think that directing the 
> mac80211 git repo to wireless-dev is what we want to do. (so I'll post a 
> patch just adding Johannes later) Jiri Benc has been very busy so he has been 
> unable to merge patches to his mac80211 tree, but I do think there's value in 
> having a separate mac80211 development tree (with both patches ready to go 
> upstream and patches that aren't). The mac80211-misc tree which I'm using 
> right now is just temporary for me to push some patches, however. I'll put 
> together a real mac80211 tree later.

I would really prefer that you do not do this.  The mac80211 code is
upstream now and has been for a whole release cycle.  If there ever
was a time to do core mac80211 development in a cave and throw big
hunks over the wall, it is now past.  Almost any patch that needs
long-term out-of-stream testing is either too big or too unfocused
to dump upstream afterwards.  Get the patches to me and I'll get them
to Dave and Andrew.  If a whole release cycle is not enough testing,
then something is probably wrong.

I won't go into any detail on the inherent slow-down of having an
additional git stree stage between patch authors and upstream --
the negatives should be obvious.

Further, adding another git tree layer to the process will only
create more confusion.  It is bad enough that the iwlwifi people
still insist on their own mac80211 package[*], and I can't count
the number of times I've been asked whether someone should use
wireless-2.6 or wireless-dev for mac80211 development.  At least
wireless-dev is dying/dead (see forthcoming email on that topic).
But I see no reason to prolong or promote the problem by introducing
yet another tree, let alone one that asserts itself as authoritative.

So, please, _please_, _PLEASE_ send patches to linux-wireless and
promptly review mac80211 patches that others post there.  This will
yield the best results for the community.

Thanks,

John

P.S.  Yes, I have encouraged Johannes to maintain a tree for
mac80211 hostapd support.  I think this is a special goal-oriented
case requiring both significant development and cooperation with an
external project (i.e. hostapd).  I think that situation justifies
a separate tree.  General mac80211 development does not justify such
a tree.

[*] Yes, I understand that the iwlwifi people want to support old
kernel versions.  They are of course free to do so.  Still, it
creates confusion and pain.  They could at least make it more clear
to their users that their mac80211 package is a snapshot, and not
the authoritative version...
-- 
John W. Linville
linville@tuxdriver.com
