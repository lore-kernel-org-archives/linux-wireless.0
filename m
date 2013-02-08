Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52753 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946674Ab3BHRQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:16:46 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv10 0/2] Add DFS master ability
Date: Fri,  8 Feb 2013 18:16:18 +0100
Message-Id: <1360343782-32149-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130208_181831_174050_095794B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is patch series version 10 of the DFS master ability, based on Victor
Goldenshteins original work. See changelog in the various patches for
details. The main changes to v9 are:

 * based on Johannes patch "mac80211: explicitly copy channels to VLANs where needed",
   dropped my patch "mac80211: lock AP_VLAN list with iflist_mtx" in favor of
   this solution.
 * abort CAC when going in suspend
 * add and check wiphy flag for radar detect
 * disallow radar detect for channel context drivers (no support yet)
 * rebased on latest master, of course

As always, thanks a lot to Johannes for review and support. 
I've verified the implementation (again) with ath9k a patched hostapd (patches
to be released later).

iw patches for interface combinations and DFS state handling are attached as well.

One open issue (still) remains: On my system, DFS channels are flagged with NO_IBSS and
DISABLED, this is due to my country code setting to 00. I can manually circumvent
that, but should we find a proper solution for this? This regulatory intersection
gives me quite a bit of a headache ...

Simon Wunderlich (2):
  nl80211/cfg80211: add radar detection command/event
  mac80211: add radar detection command/event

 include/net/cfg80211.h       |   48 ++++++++++++++
 include/net/mac80211.h       |   14 +++++
 include/uapi/linux/nl80211.h |   61 ++++++++++++++++++
 net/mac80211/cfg.c           |   40 +++++++++++-
 net/mac80211/chan.c          |   33 ++++++++++
 net/mac80211/ieee80211_i.h   |   14 +++++
 net/mac80211/iface.c         |   12 ++++
 net/mac80211/main.c          |    7 +++
 net/mac80211/mlme.c          |   59 ++++++++++++++++++
 net/mac80211/pm.c            |    2 +
 net/mac80211/scan.c          |    3 +
 net/mac80211/trace.h         |   19 ++++++
 net/wireless/chan.c          |  129 +++++++++++++++++++++++++++++++++++++-
 net/wireless/core.c          |    3 +
 net/wireless/core.h          |   28 +++++++++
 net/wireless/mlme.c          |  121 ++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |  141 ++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.h       |    7 +++
 net/wireless/reg.c           |    3 +
 net/wireless/scan.c          |   10 ---
 net/wireless/trace.h         |   47 ++++++++++++++
 21 files changed, 783 insertions(+), 18 deletions(-)

-- 
1.7.10.4

