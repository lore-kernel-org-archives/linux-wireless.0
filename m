Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2898 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbXJCCIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 22:08:14 -0400
Date: Tue, 2 Oct 2007 21:45:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-davem' branch of wireless-2.6
Message-ID: <20071003014534.GA8380@tuxdriver.com> (sfid-20071003_030820_044149_9D2D2F51)
References: <20071003012552.GE29361@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20071003012552.GE29361@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Of course, these are intended for 2.6.24.  Also, I forgot to mention
that the individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/up=
stream-davem/

I also preserved the net-2.6.24 commit I based from as 'master-davem'
in case you need it for reference.

Hth!

John

On Tue, Oct 02, 2007 at 09:25:52PM -0400, John W. Linville wrote:
> The following changes since commit d3adbde754a9ae7a6f87612055cb20db85=
6f0721:
>   Ilpo J=E4rvinen (1):
>         [TCP]: Wrap-safed reordering detection FRTO check
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6=
=2Egit upstream-davem
>=20
> Daniel Drake (1):
>       hostap: set netdev type before registering AP interface
>=20
> Johannes Berg (9):
>       mac80211: add "invalid" interface type
>       mac80211: remove management interface
>       mac80211: move sta_process rx handler later
>       mac80211: consolidate decryption more
>       mac80211: use RX_FLAG_DECRYPTED for sw decrypted as well
>       mac80211: remove ALG_NONE
>       mac80211: improve radiotap injection
>       mac80211: make userspace-mlme a per-interface setting
>       mac80211: implement cfg80211's change_interface hook
>=20
> Michael Buesch (9):
>       rfkill: Add support for an rfkill LED.
>       rfkill: Add support for hardware-only rfkill buttons
>       b43: LED triggers support
>       b43: RF-kill support
>       b43: Use input-polldev for the rfkill switch
>       b43: Rewrite pwork locking policy.
>       mac80211: Check open_count before calling config callback.
>       mac80211: Add association LED trigger
>       mac80211: Update beacon_update callback documentation
>=20
> Tomas Winkler (1):
>       mac80211: add sta_notify callback
>=20
> Ulrich Kunitz (1):
>       zd1211rw: Removed zd_util.c and zd_util.h
>=20
>  Documentation/networking/mac80211-injection.txt |   32 ++-
>  drivers/net/wireless/adm8211.c                  |    8 +-
>  drivers/net/wireless/b43/Kconfig                |   12 +
>  drivers/net/wireless/b43/Makefile               |    5 +-
>  drivers/net/wireless/b43/b43.h                  |   11 +-
>  drivers/net/wireless/b43/leds.c                 |  399 ++++++++++---=
----------
>  drivers/net/wireless/b43/leds.h                 |   63 ++--
>  drivers/net/wireless/b43/main.c                 |  205 ++++--------
>  drivers/net/wireless/b43/phy.c                  |   13 +-
>  drivers/net/wireless/b43/phy.h                  |    2 +-
>  drivers/net/wireless/b43/rfkill.c               |  184 +++++++++++
>  drivers/net/wireless/b43/rfkill.h               |   58 ++++
>  drivers/net/wireless/hostap/hostap.h            |    2 +-
>  drivers/net/wireless/hostap/hostap_hw.c         |    2 +-
>  drivers/net/wireless/hostap/hostap_main.c       |   19 +-
>  drivers/net/wireless/iwlwifi/iwl3945-base.c     |    4 -
>  drivers/net/wireless/iwlwifi/iwl4965-base.c     |    4 -
>  drivers/net/wireless/p54common.c                |    4 +-
>  drivers/net/wireless/p54pci.c                   |    4 +-
>  drivers/net/wireless/rt2x00/rt2x00.h            |    2 +-
>  drivers/net/wireless/zd1211rw/Makefile          |    2 +-
>  drivers/net/wireless/zd1211rw/zd_chip.c         |    1 -
>  drivers/net/wireless/zd1211rw/zd_mac.c          |    4 +-
>  drivers/net/wireless/zd1211rw/zd_usb.c          |    1 -
>  drivers/net/wireless/zd1211rw/zd_util.c         |   82 -----
>  drivers/net/wireless/zd1211rw/zd_util.h         |   29 --
>  include/linux/rfkill.h                          |   24 ++
>  include/net/mac80211.h                          |   46 +++-
>  net/mac80211/cfg.c                              |   75 ++++-
>  net/mac80211/ieee80211.c                        |  189 +-----------
>  net/mac80211/ieee80211_i.h                      |   17 +-
>  net/mac80211/ieee80211_iface.c                  |   68 +----
>  net/mac80211/ieee80211_ioctl.c                  |   31 +-
>  net/mac80211/ieee80211_led.c                    |   67 +++-
>  net/mac80211/ieee80211_led.h                    |    6 +
>  net/mac80211/ieee80211_rate.c                   |    3 +-
>  net/mac80211/ieee80211_rate.h                   |    2 -
>  net/mac80211/ieee80211_sta.c                    |    7 +-
>  net/mac80211/key.c                              |    1 -
>  net/mac80211/rx.c                               |  122 +++-----
>  net/mac80211/sta_info.c                         |   13 +-
>  net/mac80211/tx.c                               |  211 ++++++------
>  net/mac80211/wme.c                              |   10 +-
>  net/rfkill/Kconfig                              |    7 +
>  net/rfkill/rfkill.c                             |   49 +++-
>  45 files changed, 1022 insertions(+), 1078 deletions(-)
>  create mode 100644 drivers/net/wireless/b43/rfkill.c
>  create mode 100644 drivers/net/wireless/b43/rfkill.h
>  delete mode 100644 drivers/net/wireless/zd1211rw/zd_util.c
>  delete mode 100644 drivers/net/wireless/zd1211rw/zd_util.h
>=20
> Omnibus patch attached as upstream-davem.patch.bz2

--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
