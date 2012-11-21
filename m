Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41961 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab2KUTbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 14:31:22 -0500
Date: Wed, 21 Nov 2012 14:15:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2012-11-21
Message-ID: <20121121191538.GE2066@tuxdriver.com> (sfid-20121121_203126_416255_4AD98BED)
References: <1353508227.10444.33.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1353508227.10444.33.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmmm...more breakage...

  CC      drivers/net/wireless/rtlwifi/rtl8723ae/trx.o
drivers/net/wireless/rtlwifi/rtl8723ae/trx.c: In function ‘rtl8723ae_rx_query_desc’:
drivers/net/wireless/rtlwifi/rtl8723ae/trx.c:324:21: error: ‘RX_FLAG_MACTIME_MPDU’ undeclared (first use in this function)
drivers/net/wireless/rtlwifi/rtl8723ae/trx.c:324:21: note: each undeclared identifier is reported only once for each function it appears in
make[3]: *** [drivers/net/wireless/rtlwifi/rtl8723ae/trx.o] Error 1

On Wed, Nov 21, 2012 at 03:30:27PM +0100, Johannes Berg wrote:
> John,
> 
> Third (and last for today) pull request :-)
> 
> This one contains the mac80211-next material. Apart from a few small new
> features and cleanups I have two fixes for the channel context code. The
> RX_END timestamp support will probably be reworked again as Simon Barber
> noted the calculations weren't really valid, but the discussions there
> are still going on and it's better than what we had before.
> 
> I haven't included the VHT changes yet, I want them to have a bit more
> review time on the mailing list (only posted yesterday), and I also
> think I might want to hold them for 3.9. OTOH, channel contexts are new
> in 3.8 so if I put them into 3.8 we don't have two versions of channel
> contexts. Haven't made up my mind yet, any thoughts? :-)
> 
> Please pull.
> 
> Thanks,
> johannes
> 
> The following changes since commit 6352c87ff69daa2211419ec2c34ddb8bc116c505:
> 
>   mac80211: reassign channel contexts before stations (2012-11-09 17:34:36 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 77d2ece6fde80631193054edc9c9a3edad519565:
> 
>   mac80211: Add debugfs callbacks for station addition/removal (2012-11-21 11:46:25 +0100)
> 
> ----------------------------------------------------------------
> Amitkumar Karwar (1):
>       nl/cfg80211: advertise OBSS scan requirement
> 
> Arend van Spriel (1):
>       mac80211: check add_chanctx callback before use in ieee80211_reconfig
> 
> Eliad Peller (1):
>       mac80211: make remain_on_channel() op pass vif param
> 
> Johannes Berg (4):
>       mac80211: use CMAC_PN_LEN
>       mac80211: introduce IEEE80211_NUM_TIDS and use it
>       mac80211: support radiotap vendor namespace RX data
>       mac80211: fix channel context suspend/reconfig handling
> 
> Jouni Malinen (1):
>       cfg80211: Add TDLS event to allow drivers to request operations
> 
> Sujith Manoharan (1):
>       mac80211: Add debugfs callbacks for station addition/removal
> 
> Thomas Pedersen (1):
>       mac80211: support RX_FLAG_MACTIME_END
> 
>  drivers/net/wireless/ath/ath5k/base.c          |  2 +-
>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c  |  2 +-
>  drivers/net/wireless/ath/ath9k/recv.c          |  2 +-
>  drivers/net/wireless/b43/xmit.c                |  2 +-
>  drivers/net/wireless/b43legacy/xmit.c          |  2 +-
>  drivers/net/wireless/brcm80211/brcmsmac/main.c |  2 +-
>  drivers/net/wireless/iwlegacy/4965-mac.c       |  2 +-
>  drivers/net/wireless/iwlwifi/dvm/mac80211.c    |  1 +
>  drivers/net/wireless/iwlwifi/dvm/rx.c          |  2 +-
>  drivers/net/wireless/mac80211_hwsim.c          | 36 ++++++++++-
>  drivers/net/wireless/p54/txrx.c                |  2 +-
>  drivers/net/wireless/rtl818x/rtl8180/dev.c     |  2 +-
>  drivers/net/wireless/rtl818x/rtl8187/dev.c     |  2 +-
>  drivers/net/wireless/rtlwifi/rtl8192ce/trx.c   |  2 +-
>  drivers/net/wireless/rtlwifi/rtl8192cu/trx.c   |  2 +-
>  drivers/net/wireless/rtlwifi/rtl8192de/trx.c   |  2 +-
>  drivers/net/wireless/rtlwifi/rtl8192se/trx.c   |  2 +-
>  drivers/net/wireless/ti/wl1251/rx.c            |  2 +-
>  include/linux/ieee80211.h                      |  2 +
>  include/net/cfg80211.h                         | 19 ++++++
>  include/net/mac80211.h                         | 39 +++++++++++-
>  include/uapi/linux/nl80211.h                   | 10 +++
>  net/mac80211/agg-rx.c                          |  2 +-
>  net/mac80211/agg-tx.c                          | 12 ++--
>  net/mac80211/cfg.c                             |  6 +-
>  net/mac80211/debugfs_key.c                     |  6 +-
>  net/mac80211/debugfs_sta.c                     | 19 ++++--
>  net/mac80211/driver-ops.h                      | 39 +++++++++++-
>  net/mac80211/ht.c                              |  4 +-
>  net/mac80211/ibss.c                            | 29 ++-------
>  net/mac80211/ieee80211_i.h                     | 11 ++++
>  net/mac80211/key.c                             | 15 ++---
>  net/mac80211/key.h                             |  8 +--
>  net/mac80211/mesh_sync.c                       | 44 +++----------
>  net/mac80211/offchannel.c                      |  2 +-
>  net/mac80211/pm.c                              | 44 ++++++++++++-
>  net/mac80211/rx.c                              | 87 +++++++++++++++++++++-----
>  net/mac80211/sta_info.c                        | 10 +--
>  net/mac80211/sta_info.h                        | 19 +++---
>  net/mac80211/trace.h                           | 13 ++--
>  net/mac80211/util.c                            | 76 ++++++++++++++++++++--
>  net/wireless/nl80211.c                         | 47 ++++++++++++++
>  net/wireless/trace.h                           | 23 +++++++
>  43 files changed, 497 insertions(+), 158 deletions(-)
> 



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
