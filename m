Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34247 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab3BKTae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 14:30:34 -0500
Date: Mon, 11 Feb 2013 14:27:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-02-11
Message-ID: <20130211192728.GD10986@tuxdriver.com> (sfid-20130211_203225_092366_869A6845)
References: <1360168561.7910.24.camel@jlt4.sipsolutions.net>
 <1360267300.8038.13.camel@jlt4.sipsolutions.net>
 <1360580674.8738.14.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360580674.8738.14.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 11, 2013 at 12:04:34PM +0100, Johannes Berg wrote:
> Hi,
> 
> I feel stupid now, I was testing corner cases and found *another*
> bug ... :( So here's a new pull request.
> 
> Here are three fixes still for the 3.8 stream, the fix from Cong Ding
> for the bad sizeof (Stephen Hemminger had pointed it out before but I'd
> promptly forgotten), a mac80211 managed-mode channel context usage fix
> where a downgrade would never stop until reaching non-HT and a bug in
> the channel determination that could cause invalid channels like HT40+
> on channel 11 to be used.
> 
> Please pull or let me know of any problems.
> 
> johannes
> 
> The following changes since commit c49dc9008b1c641a86837297df7c90cef070571b:
> 
>   cfg80211: off by one in ieee80211_bss() (2013-01-24 15:47:22 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 3d9646d0abd02c552f6f15c302b31aa321c2fa8b:
> 
>   mac80211: fix channel selection bug (2013-02-11 11:12:26 +0100)
> 
> ----------------------------------------------------------------
> Cong Ding (1):
>       mac80211: fix error in sizeof() usage
> 
> Johannes Berg (2):
>       mac80211: fix managed mode channel context use
>       mac80211: fix channel selection bug
> 
>  net/mac80211/cfg.c  |  3 ++-
>  net/mac80211/mlme.c | 11 +++++++----
>  2 files changed, 9 insertions(+), 5 deletions(-)

Pulling now -- no guarantees that it will make the loop before 3.8
is released!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
