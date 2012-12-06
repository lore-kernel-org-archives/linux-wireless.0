Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56857 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2LFUQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 15:16:42 -0500
Date: Thu, 6 Dec 2012 15:11:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2012-12-03
Message-ID: <20121206201155.GB2246@tuxdriver.com> (sfid-20121206_211644_704351_2428244D)
References: <1354567428.9717.18.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1354567428.9717.18.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 03, 2012 at 09:43:48PM +0100, Johannes Berg wrote:
> John,
> 
> Linus tagged -rc8, so maybe I have a chance of getting a few more things
> into -next :-)
> 
> If you think there's any chance this might make it still, please pull my
> mac80211-next tree (per below). This contains a relatively large number
> of fixes to the previous code, as well as a few small features:
>  * VHT association in mac80211
>  * some new debugfs files
>  * P2P GO powersave configuration
>  * masked MAC address verification
> 
> The biggest patch is probably the BSS struct changes to use RCU for
> their IE buffers to fix potential races. I've not tagged this for stable
> because it's pretty invasive and nobody has ever seen any bugs in this
> area as far as I know.
> 
> johannes

Pulled...

> 
> ----
> 
> The following changes since commit ec816087e8978b74c1bd5fae0e335dd97d964e9f:
> 
>   cfg80211: fix some tracing output issues (2012-11-26 12:48:17 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to da29d2a5780d80857773d7776b7603a449b0b6e0:
> 
>   cfg80211: fix channel error on mesh join (2012-12-03 11:24:49 +0100)
> 
> ----------------------------------------------------------------
> Antonio Quartulli (1):
>       mac80211: allow userspace registration for probe requests in IBSS
> 
> Dan Carpenter (1):
>       mac80211: fix potential NULL dereference
> 
> Helmut Schaa (2):
>       mac80211: reject setting masked mac addresses
>       mac80211: don't reinit rate control when mesh sta exists
> 
> Johannes Berg (13):
>       cfg80211: rework chandef checking and export it
>       mac80211: support VHT association
>       mac80211: support (partial) VHT radiotap information
>       nl80211: support P2P GO powersave configuration
>       mac80211: support P2P GO powersave configuration
>       nl80211: remove unnecessary checks
>       cfg80211: don't BUG_ON BSS struct issues
>       cfg80211: fix whitespace in scan handling
>       cfg80211: fix cmp_hidden_bss
>       mac80211: make ieee80211_build_preq_ies safer
>       mac80211: remove probe response temporary buffer allocation
>       cfg80211: fix BSS struct IE access races
>       mac80211: simplify loop in minstrel_ht
> 
> Mahesh Palivela (1):
>       cfg80211: Remove unused VHT chan code
> 
> Marco Porsch (2):
>       mac80211: fix for mesh sync to indicate TBTT adjustment
>       cfg80211: fix channel error on mesh join
> 
> Saravana (4):
>       mac80211: add debugfs file for last ack signal
>       mac80211: add debugfs file for current tx rate
>       mac80211: re-organize the rx rate calculation logic
>       mac80211: add debugfs file for last rx rate
> 
> Simon Wunderlich (3):
>       nl80211: Fix HT_IBSS feature check in ibss_join
>       mac80211: Fix typo in mac80211.h
>       mac80211: return if CSA is not handle
> 
>  drivers/net/wireless/libertas/cfg.c      |   9 +-
>  drivers/net/wireless/mac80211_hwsim.c    |   7 +-
>  drivers/net/wireless/mwifiex/sta_ioctl.c |  35 ++-
>  drivers/net/wireless/ti/wl1251/main.c    |   4 +-
>  drivers/net/wireless/ti/wlcore/cmd.c     |   4 +-
>  include/linux/ieee80211.h                |  15 +
>  include/net/cfg80211.h                   |  69 +++--
>  include/net/ieee80211_radiotap.h         |  24 ++
>  include/net/mac80211.h                   |  12 +-
>  include/uapi/linux/nl80211.h             |  16 ++
>  net/mac80211/cfg.c                       |  77 ++++--
>  net/mac80211/debugfs_sta.c               |  36 +++
>  net/mac80211/ieee80211_i.h               |   5 +-
>  net/mac80211/iface.c                     |  45 +++
>  net/mac80211/main.c                      |   5 +-
>  net/mac80211/mesh_plink.c                |   3 +-
>  net/mac80211/mesh_sync.c                 |   4 +
>  net/mac80211/mlme.c                      | 431 ++++++++++++++++++++++-------
>  net/mac80211/rc80211_minstrel_ht.c       |   8 +-
>  net/mac80211/rx.c                        |  42 ++-
>  net/mac80211/scan.c                      |  21 +-
>  net/mac80211/sta_info.h                  |   4 +
>  net/mac80211/status.c                    |   3 +
>  net/mac80211/tx.c                        |   9 +-
>  net/mac80211/util.c                      |  58 ++--
>  net/wireless/chan.c                      |  92 +++++--
>  net/wireless/core.h                      |   8 -
>  net/wireless/mesh.c                      |   3 +-
>  net/wireless/nl80211.c                   | 155 ++++++-----
>  net/wireless/reg.c                       |   2 +-
>  net/wireless/reg.h                       |   2 +-
>  net/wireless/scan.c                      | 452 +++++++++++++++----------------
>  net/wireless/sme.c                       |  13 +-
>  net/wireless/util.c                      |   9 +-
>  net/wireless/wext-sme.c                  |   8 +-
>  35 files changed, 1139 insertions(+), 551 deletions(-)
> 



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
