Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:48375 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3LPWBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 17:01:04 -0500
Received: by mail-ob0-f171.google.com with SMTP id wp18so5487930obc.30
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 14:01:03 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC/RFT] mac80211 powersave rework
Date: Mon, 16 Dec 2013 16:00:52 -0600
Message-Id: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230111_394682_2D743D3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

This is a set of patches that I've been working on on-and-off for
several months, in response to your feedback to some less ambitious
changes I submitted previously to fix off-channel problems with Broadcom
hardware [1] (though I haven't taken things so far as what you suggest
there). The patches fix the Broadcom problems and should also make
powersave capable of supporting multi-interface devices.

The patches add a new powersave sub-module which handles the direct
hardware control of PS. The managed mode code is changed to instead
control only the PS state of individual interfaces. The hardware PS
state of a device is changed only from the PS module by aggregating the
PS states of that device's interfaces.

The patches also add a new driver callback named change_ps to inform
drivers of changes to interface PS states. My expectation is that
multi-interface drivers will require something like this, but this is
one area in particular where I'd like to get some feedback. I have
already put this interface to use though in the Broadcom drivers to make
them aware of when the HWPS field should be enabled for transmitting
nullfuncs with the PM bit set.

Along with all of this I did a little bit of general clean-up of the
managed mode PS code as well as some necessary changes to the scan and
off-channel code.

So far I've tested this with iwlwifi, ath9k, b43, and brcmsmac, and
everything seems to be working well. I've also been using the code for a
couple of weeks on two machines with no sign of ill effects, so I think
the code is fairly stable, at least for managed mode. I do need to test
a few more specific code paths and double check that no additional
locking is needed. I also haven't done testing with anything other than
managed mode yet, though other modes should be largely unaffected by the
changes.

Please take a look and let me know what you think. I would also love to
receive testing feedback from anyone who'd like to try out these
changes.

Thanks,
Seth

[1] http://marc.info/?l=linux-wireless&m=135838252227053


Seth Forshee (8):
  mac80211: Move dynamic PS data out of common code
  mac80211: Add per-interface powersave states and parameters
  mac80211: Add powersave module
  mac80211: Use PS module for managed mode powersave
  mac80211: Don't start dynamic PS timer when leaving off-channel if
    still scanning
  brcmsmac: Set MCTL_HPS when PM should be set
  b43: Allow HWPS state to be changed
  b43: Set B43_MACCTL_HWPS when PM should be set

 drivers/net/wireless/b43/main.c                    |  24 ++-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   7 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  17 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |   1 +
 include/net/mac80211.h                             |  90 ++++++--
 net/mac80211/Makefile                              |   3 +-
 net/mac80211/cfg.c                                 |   9 +-
 net/mac80211/driver-ops.h                          |  13 ++
 net/mac80211/ieee80211_i.h                         |  29 +--
 net/mac80211/iface.c                               |  11 +-
 net/mac80211/main.c                                |   7 -
 net/mac80211/mlme.c                                | 240 ++++++++++-----------
 net/mac80211/offchannel.c                          |  61 ++----
 net/mac80211/pm.c                                  |  17 +-
 net/mac80211/ps.c                                  | 162 ++++++++++++++
 net/mac80211/rx.c                                  |  10 +-
 net/mac80211/scan.c                                |  14 ++
 net/mac80211/status.c                              |  15 +-
 net/mac80211/trace.h                               |  27 +++
 net/mac80211/tx.c                                  |  16 +-
 net/mac80211/util.c                                |  58 ++++-
 21 files changed, 562 insertions(+), 269 deletions(-)
 create mode 100644 net/mac80211/ps.c

