Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34881 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab2KNTbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 14:31:19 -0500
Date: Wed, 14 Nov 2012 14:16:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2012-11-12
Message-ID: <20121114191625.GB6128@tuxdriver.com> (sfid-20121114_203123_737779_66A9FD03)
References: <1352490162.9238.23.camel@jlt4.sipsolutions.net>
 <1352534041.9759.0.camel@jlt4.sipsolutions.net>
 <1352710901.9525.3.camel@jlt4.sipsolutions.net>
 <1352734061.9445.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1352734061.9445.3.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 04:27:41PM +0100, Johannes Berg wrote:
> On Mon, 2012-11-12 at 10:01 +0100, Johannes Berg wrote:
> > Another day, updated pull request. I'm going to let you merge this one,
> > even if somebody sends me new fixes right now :)
> > 
> > I have a locking fix for some SKB queues, a variable initialization to
> > avoid crashes in a certain failure case, another free_txskb fix from
> > Felix and another fix from him to avoid calling a stopped driver, a fix
> > for a (very unlikely) memory leak and a fix to not send null data
> > packets when resuming while not associated.
> 
> I've amended the branch again, with the regulatory fix. Sorry about
> that!
> 
> johannes

I pulled this one... :-)
 
> The following changes since commit 6dbda2d00d466225f9db1dc695ff852443f28832:
> 
>   mac80211: make sure data is accessible in EAPOL check (2012-10-26 22:52:42 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 43c771a1963ab461a2f194e3c97fded1d5fe262f:
> 
>   wireless: allow 40 MHz on world roaming channels 12/13 (2012-11-12 16:26:06 +0100)
> 
> ----------------------------------------------------------------
> Arik Nemtsov (1):
>       mac80211: sync acccess to tx_filtered/ps_tx_buf queues
> 
> David Spinadel (1):
>       mac80211: init sched_scan_ies
> 
> Felix Fietkau (2):
>       mac80211: do not call ieee80211_configure_filter if no interfaces are up
>       mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queue_purge
> 
> Johannes Berg (3):
>       mac80211: fix memory leak in device registration error path
>       mac80211: don't send null data packet when not associated
>       wireless: allow 40 MHz on world roaming channels 12/13
> 
>  net/mac80211/cfg.c         |  3 +++
>  net/mac80211/ieee80211_i.h |  2 ++
>  net/mac80211/main.c        |  6 ++++--
>  net/mac80211/scan.c        |  2 +-
>  net/mac80211/sta_info.c    | 11 ++++++++---
>  net/mac80211/status.c      |  9 +++++++++
>  net/mac80211/tx.c          |  9 ++++++---
>  net/mac80211/util.c        |  2 ++
>  net/wireless/reg.c         |  5 ++---
>  9 files changed, 37 insertions(+), 12 deletions(-)
> 



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
