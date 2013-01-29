Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:58614 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3A2MYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 07:24:14 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv7 0/3] Add DFS master ability
Date: Tue, 29 Jan 2013 13:21:57 +0100
Message-Id: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130129_132419_496284_5AB9407C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is patch series version 7 of the DFS master ability, based on Victor
Goldenshteins original work. See changelog in the various patches for
details. The main changes to v6 are:

 * change to channel state handling within cfg80211/mac80211. This moves
   the channel state management from hostapd to the kernel driver, as
   we discussed in previous mails - a change from the original concept.
   We can hopefully support scenarios like multiple interfaces, full DFS
   spectrum scans before enabling an AP, etc better. 
 * also add CAC/NOP handling
 * remove mac80211 start_radar_detection command, use hardware config
   flags instead. the nl80211/cfg80211 command will remain
 * add/change cfg80211 channel checking functions (set channel state,
   get info if radar is required, adapt reg_can_beacon())
 * add/fix tracing
 * more chandef usage
 * rebased on latest master, of course

Thanks again to Johannes and Zefir for the valuable input! I've verified
the implementation (again) with ath9k a patched hostapd (patches to be
released later). This patchset is more an RFC with a few open questions,
any comment/review/etc are very much appreciated. 

Questions:

Right now, channels at least on my machine have the NO IBSS and PASSIVE SCAN
flags set, which prevents reg_can_beacon from returning true, even if we do
have radar support. This is due to my reg database setting these flags for
country code 00, and this is still kept when changing the country code to
something else (DE in my case). How should we proceed with this? Shouldn't
these flags be removed when selecting a country code?

The channel states are now implemented in cfg80211. Shall we inform userspace
about channel changes? If yes, how should we do that? We could add channel states
to the channel list, and give "channel list changed" events to userspace as it
happens now, or define a new kind of event ("channel-available-again-event").
Suggestions welcome. :)

If you prefer, I can split off the channel state stuff from the radar detect
patches.

Cheers,
	Simon

Simon Wunderlich (1):
  nl80211: allow DFS in start_ap

Victor Goldenshtein (2):
  nl80211/cfg80211: add radar detection command/event
  mac80211: add radar detection command/event

 include/net/cfg80211.h       |   57 ++++++++++++++++++
 include/net/mac80211.h       |   18 +++++-
 include/uapi/linux/nl80211.h |   31 ++++++++++
 net/mac80211/cfg.c           |   43 +++++++++++++-
 net/mac80211/chan.c          |   31 ++++++++++
 net/mac80211/ieee80211_i.h   |   11 ++++
 net/mac80211/iface.c         |   12 ++++
 net/mac80211/mlme.c          |   32 +++++++++++
 net/mac80211/scan.c          |    3 +
 net/mac80211/trace.h         |   19 ++++++
 net/wireless/chan.c          |  130 +++++++++++++++++++++++++++++++++++++++++-
 net/wireless/core.c          |    3 +
 net/wireless/core.h          |    8 +++
 net/wireless/mlme.c          |  111 ++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |  119 +++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h       |    7 +++
 net/wireless/reg.c           |    3 +
 net/wireless/trace.h         |   33 +++++++++++
 18 files changed, 665 insertions(+), 6 deletions(-)

-- 
1.7.10.4

