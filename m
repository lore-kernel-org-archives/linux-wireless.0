Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:16381 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYI3T6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 15:58:30 -0400
Received: by fg-out-1718.google.com with SMTP id 19so154209fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 12:58:28 -0700 (PDT)
Message-ID: <1ba2fa240809301258o34b77ce2p737c229be7c0a2e9@mail.gmail.com> (sfid-20080930_215835_734011_2E008106)
Date: Tue, 30 Sep 2008 22:58:28 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: pull request: wireless-next-2.6 2008-09-30
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20080930183938.GE3765@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080930183938.GE3765@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 30, 2008 at 9:39 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> Dave,
>
> Here is the latest round of wireless bits intended for 2.6.28.  Among
> them is the first round of new stuff learned from the release of the
> Atheros HAL sources...
>
> Let me know if there are problems!
>
> Thanks,
>
> John

What about this one
http://marc.info/?l=linux-wireless&m=122254550901882&w=2
It removes compilation warnings.
Tomas

> ---
>
> Individual patches are available here:
>
>        http://www.kernel.org/pub/linux/kernel/people/linville/wireless-next-2.6/
>
> ---
>
> The following changes since commit f0db275a81ef184293ca7ef3646fe065b336efb7:
>  Stephen Hemminger (1):
>        netdev: docbook comment update (revised)
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git master
>
> Anna Neal (1):
>      libertas: Improvements on automatic tx power control via SIOCSIWTXPOW (fixups)
>
> Bob Copeland (1):
>      ath5k: write beacon control register twice when resetting tsf
>
> Davide Pesavento (1):
>      Fix modpost failure when rx handlers are not inlined.
>
> Ester Kummer (1):
>      iwlwifi: enable power save setting upon config
>
> Gertjan van Wingerde (1):
>      rt2x00: Fix build errors due to modularized rfkill or leds and built-in rt2x00.
>
> Johannes Berg (1):
>      mac80211: fixups for "make master iface not wireless"
>
> John W. Linville (1):
>      ieee80211.h: remove superfluous ETH_P_PAE definition
>
> Larry Finger (4):
>      b43: Fix Bluetooth coexistence SPROM coding error for Motorola 7010 variant of BCM4306
>      p54: Fix sparse warnings
>      b43: Fix Bluetooth Coexistence SPROM programming error for HP 12f8 version of BCM4306
>      b43: Increase loop tries in do_dummy_tx
>
> Nick Kossifidis (5):
>      ath5k: Update registers and SREV ids v2
>      ath5k: Use new srevs to properly attach radio chips
>      ath5k: Use QUIET mechanism on tx dma stop
>      ath5k: Fix SREV reporting after SREV updates
>      ath5k: Add support for AR2417 v2
>
> Rami Rosen (1):
>      mac80211: remove wme_tx_queue and wme_rx_queue from net/mac80211/sta_info.h
>
> Winkler, Tomas (2):
>      iwlwifi: refactor rx register initialization
>      iwlwifi: use correct DMA_MASK
>
>  drivers/net/wireless/ath5k/ath5k.h     |   59 ++--
>  drivers/net/wireless/ath5k/attach.c    |  184 +++++++----
>  drivers/net/wireless/ath5k/base.c      |   61 ++--
>  drivers/net/wireless/ath5k/dma.c       |   49 +++-
>  drivers/net/wireless/ath5k/pcu.c       |   14 +-
>  drivers/net/wireless/ath5k/qcu.c       |    8 +-
>  drivers/net/wireless/ath5k/reg.h       |  577 ++++++++++++++++++++++----------
>  drivers/net/wireless/ath5k/reset.c     |    8 +-
>  drivers/net/wireless/b43/main.c        |    6 +-
>  drivers/net/wireless/iwlwifi/iwl-agn.c |   15 +-
>  drivers/net/wireless/iwlwifi/iwl-csr.h |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-fh.h  |    9 +-
>  drivers/net/wireless/iwlwifi/iwl-rx.c  |   30 +-
>  drivers/net/wireless/libertas/cmd.c    |    2 +-
>  drivers/net/wireless/libertas/cmd.h    |    6 +
>  drivers/net/wireless/libertas/defs.h   |    1 -
>  drivers/net/wireless/libertas/wext.c   |   12 +
>  drivers/net/wireless/p54/p54common.c   |   33 +-
>  drivers/net/wireless/p54/p54common.h   |    3 +-
>  drivers/net/wireless/p54/p54usb.c      |    8 +-
>  drivers/net/wireless/rt2x00/Kconfig    |   69 ++--
>  include/net/ieee80211.h                |    4 -
>  net/mac80211/iface.c                   |    9 +-
>  net/mac80211/rx.c                      |    2 +-
>  net/mac80211/sta_info.h                |   12 -
>  net/mac80211/wme.c                     |    8 +-
>  26 files changed, 782 insertions(+), 409 deletions(-)
>
> Omnibus patch available here:
>
>        http://www.kernel.org/pub/linux/kernel/people/linville/wireless-next-2.6-2008-09-30.patch.bz2
>
> --
> John W. Linville                Linux should be at the core
> linville@tuxdriver.com                  of your literate lifestyle.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
