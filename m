Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40433 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab3AHNEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 08:04:52 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 0/6] Add DFS master ability
Date: Tue,  8 Jan 2013 14:04:05 +0100
Message-Id: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130108_140456_234943_569332EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is patchs series no 6 of the DFS master ability, based on Victor
Goldenshteins original work. See changelog in the various patches for
details. The main changes to v5 are:

 * channel switch announcement patch has been dropped from this patchset.
   Although CSA is required for 802.11h, DFS can also be implemented
   by just disassociating all stations and open up AP on another channel
   later when a radar is detected (to meet ETSI/FCC requirements). 
   I've choosen this approach to reduce the patchset size, CSA can (and should)
   still be added later.
 * SINGLE_ONLY patch from last time was dropped as well
 * interface combination are now used to define and check DFS capabilities:
   * one AP only/single channel is supported for now, more can be added later
   * channel bandwidths are checked within a bitfield now
   * Johannes Berg helped me a lot here, thanks! :)
 * some more obsolete things have been removed (dfs_nlportid, cac_chantype, etc)
 * rebased on latest master, of course

Again, the implementation works for me[tm] with a dummy dfs-implementation
in ath9k and a patched hostapd - I'll provide the hostapd patchset later
after cleaning it up.
 
Any comment/review/etc are very much appreciated!

Thanks,
	Simon

Simon Wunderlich (4):
  nl80211: check if channel can be used in join_ibss
  cfg80211: check radar interface combinations
  mac80211: check radar interaction with scan and roc
  nl80211: allow DFS in start_ap

Victor Goldenshtein (2):
  nl80211/cfg80211: add radar detection command/event
  mac80211: add radar detection command/event

 include/net/cfg80211.h       |   26 +++++++++
 include/net/mac80211.h       |   19 +++++++
 include/uapi/linux/nl80211.h |   12 ++++
 net/mac80211/cfg.c           |   37 ++++++++++++-
 net/mac80211/driver-ops.h    |   15 +++++
 net/mac80211/ieee80211_i.h   |    3 +
 net/mac80211/iface.c         |    4 ++
 net/mac80211/mlme.c          |   11 ++++
 net/mac80211/scan.c          |    3 +
 net/mac80211/trace.h         |   76 +++++++++++++++++++++++++
 net/wireless/chan.c          |   14 +++--
 net/wireless/core.c          |   11 +++-
 net/wireless/core.h          |    7 ++-
 net/wireless/mlme.c          |   14 +++++
 net/wireless/nl80211.c       |  126 +++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h       |    6 ++
 net/wireless/util.c          |   32 ++++++++++-
 17 files changed, 400 insertions(+), 16 deletions(-)

-- 
1.7.10.4

