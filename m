Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29391 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbYEQJFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 05:05:49 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 2/2] mac80211: use multi-queue master netdevice
Date: Sat, 17 May 2008 02:05:47 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC329051ABCE0@orsmsx414.amr.corp.intel.com> (sfid-20080517_110559_229679_6672EBF0)
In-Reply-To: <20080516230007.837741000@sipsolutions.net>
References: <20080516225712.794319000@sipsolutions.net> <20080516230007.837741000@sipsolutions.net>
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	"Ron Rindjunksi" <ron.rindjunski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This patch updates mac80211 and drivers to be multi-queue aware and
> use that instead of the internal queue mapping. Also does a number
> of cleanups in various pieces of the code that fall out and reduces
> internal mac80211 state size.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> This is just ground-work. We'll be able to play with Qos much 
> more now.
> 
>  drivers/net/wireless/ath5k/base.c           |    2 
>  drivers/net/wireless/b43/dma.c              |    7 +-
>  drivers/net/wireless/b43/pio.c              |    8 +-
>  drivers/net/wireless/b43legacy/dma.c        |    3 
>  drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 -
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 -
>  drivers/net/wireless/p54/p54common.c        |    8 +-
>  drivers/net/wireless/rt2x00/rt2x00mac.c     |   10 +-
>  drivers/net/wireless/rt2x00/rt2x00queue.h   |   13 ---
>  drivers/net/wireless/rtl8180_dev.c          |    4 -
>  include/net/mac80211.h                      |   20 +++++
>  net/mac80211/Kconfig                        |   14 +++-
>  net/mac80211/Makefile                       |    2 
>  net/mac80211/ieee80211_i.h                  |   16 ++--
>  net/mac80211/iface.c                        |    2 
>  net/mac80211/main.c                         |   29 ++++++--
>  net/mac80211/sta_info.c                     |    2 
>  net/mac80211/tx.c                           |   97 
> ++++++++++++----------------
>  net/mac80211/util.c                         |   29 ++++----
>  net/mac80211/wme.c                          |   14 +---
>  net/mac80211/wme.h                          |    2 
>  21 files changed, 158 insertions(+), 132 deletions(-)

This patch looks fine to me.  Thanks for porting the wireless tree to
use these bits Johannes.

-PJ Waskiewicz
