Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:56617 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab3BDMuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 07:50:11 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv8 0/3] Add DFS master ability
Date: Mon,  4 Feb 2013 13:49:55 +0100
Message-Id: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130204_135025_557972_123F232D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is patch series version 8 of the DFS master ability, based on Victor
Goldenshteins original work. See changelog in the various patches for
details. The main changes to v7 are:

 * export channel state to userspace
 * add event when NOP is over
 * use wdev->channel instead of wdev->preset_chandef.chan for CAC
 * remove NL80211_FEATURE_DFS
 * many small fixes
 * claim authorship for patches (but leave note for victors original patches
   - please mail me if you find this inappropriate)
 * rebased on latest master, of course

As always, thanks a lot to Johannes and Zefir for review and support. 
I've verified the implementation (again) with ath9k a patched hostapd (patches
to be released later). This patchset is more an RFC with a few open questions,
any comment/review/etc are very much appreciated. 

iw patches for interface combinations and DFS state handling are attached as well.

One open issue remains: On my system, DFS channels are flagged with NO_IBSS and
DISABLED, this is due to my country code setting to 00. I can manually circumvent
that, but should we find a proper solution for this? This regularity intersection
gives me quite a bit of a headache ...

Simon Wunderlich (3):
  nl80211/cfg80211: add radar detection command/event
  mac80211: add radar detection command/event
  nl80211: allow DFS in start_ap

 include/net/cfg80211.h       |   46 +++++++++++++++
 include/net/mac80211.h       |   16 ++++++
 include/uapi/linux/nl80211.h |   58 +++++++++++++++++++
 net/mac80211/cfg.c           |   36 +++++++++++-
 net/mac80211/chan.c          |   33 +++++++++++
 net/mac80211/ieee80211_i.h   |   11 ++++
 net/mac80211/iface.c         |   12 ++++
 net/mac80211/mlme.c          |   32 +++++++++++
 net/mac80211/scan.c          |    3 +
 net/mac80211/trace.h         |   19 ++++++
 net/wireless/chan.c          |  129 ++++++++++++++++++++++++++++++++++++++++-
 net/wireless/core.c          |    3 +
 net/wireless/core.h          |   18 ++++++
 net/wireless/mlme.c          |  127 +++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |  130 ++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.h       |    7 +++
 net/wireless/reg.c           |    3 +
 net/wireless/scan.c          |   10 ----
 net/wireless/trace.h         |   33 +++++++++++
 19 files changed, 708 insertions(+), 18 deletions(-)

-- 
1.7.10.4

