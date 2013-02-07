Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:52257 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817Ab3BGSik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 13:38:40 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv9 0/3] Add DFS master ability
Date: Thu,  7 Feb 2013 19:38:19 +0100
Message-Id: <1360262304-28362-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130207_193845_404770_69218A48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is patch series version 9 of the DFS master ability, based on Victor
Goldenshteins original work. See changelog in the various patches for
details. The main changes to v8 are:

 * checked and fixed locking - note the new patch 1 changing the locking
   for use/release_channel to remove rtnl dependency
 * report radar detected and NOP only once
 * fix gfp usage
 * merge "nl80211: allow DFS in start_ap" in the main nl80211 patch
 * various style changes
 * rebased on latest master, of course

As always, thanks a lot to Johannes for review and support. 
I've verified the implementation (again) with ath9k a patched hostapd (patches
to be released later). This time also lock verified (I used a tainted kernel
before, so locking was disabled ...).

iw patches for interface combinations and DFS state handling are attached as well.

One open issue (still) remains: On my system, DFS channels are flagged with NO_IBSS and
DISABLED, this is due to my country code setting to 00. I can manually circumvent
that, but should we find a proper solution for this? This regularity intersection
gives me quite a bit of a headache ...

Simon Wunderlich (3):
  mac80211: lock AP_VLAN list with iflist_mtx
  nl80211/cfg80211: add radar detection command/event
  mac80211: add radar detection command/event

 include/net/cfg80211.h       |   46 ++++++++++++++
 include/net/mac80211.h       |   14 +++++
 include/uapi/linux/nl80211.h |   61 +++++++++++++++++++
 net/mac80211/cfg.c           |   51 +++++++++++++++-
 net/mac80211/chan.c          |   37 +++++++++++-
 net/mac80211/ieee80211_i.h   |   15 +++++
 net/mac80211/iface.c         |   23 ++++++-
 net/mac80211/main.c          |    3 +
 net/mac80211/mlme.c          |   56 ++++++++++++++++++
 net/mac80211/scan.c          |    3 +
 net/mac80211/trace.h         |   19 ++++++
 net/wireless/chan.c          |  129 +++++++++++++++++++++++++++++++++++++++-
 net/wireless/core.c          |    3 +
 net/wireless/core.h          |   28 +++++++++
 net/wireless/mlme.c          |  121 +++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |  135 ++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.h       |    7 +++
 net/wireless/reg.c           |    3 +
 net/wireless/scan.c          |   10 ----
 net/wireless/trace.h         |   47 +++++++++++++++
 20 files changed, 790 insertions(+), 21 deletions(-)

-- 
1.7.10.4

