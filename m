Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:47083 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab2LMN7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 08:59:05 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 0/8] Add DFS master ability
Date: Thu, 13 Dec 2012 14:58:25 +0100
Message-Id: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121213_145918_801467_DC7EFEC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm picking up and extending Victor Goldenshteins work on DFS
ability in AP mode. See changelog in the various patches for
details. The main changes are:

 * the freuency within start_radar_detection is now used for the
   channel, dependency on __nl80211_set_channel is removed
 * enable_tx command removed, respective checks are now in start_ap
 * ap channel switch implicitly stops AP when changing to a radar
   channel. Userspace must then restart radar detection and can
   start the AP again after that
 => both changes from above are done to have a clean state of
    channel - low level driver should not care about whether
    a channel is a radar channel and when to be quiet. This way, all
    the control over the channel state keeps in nl80211.
 * add new SINGLE_ONLY channel mode to prevent other MultiSSID/MultiVIF use
 * prevent scan/roc to run at the same time as the AP
 * move dfs capability checks into reg_can_beacon()
 * change most of the functions to use the new chandef instead of
   channel, channel_type ...
 * rebased on latest master, of course

I'm sending this as patch to keep the versioning, although it can be
considered as RFC, I would be suprised if all single channel/single
interface aspects were considered correctly. :)

The implementation works for me [tm] with a dummy dfs-implementation
in ath9k and a patched hostapd - the hostapd patches will be sent later
once this patchset is in shape (Victors patches plus some dirty
modifications, need to clean it up first).

Any comment/review/etc are very much appreciated!

Thanks,
	Simon


Simon Wunderlich (4):
  cfg80211: add CHAN_MODE_SINGLE_ONLY for DFS use
  cfg/mac80211: add dfs capability to cfg80211_reg_can_beacon()
  mac80211: check radar interaction with scan and roc
  nl80211: allow DFS in start_ap

Victor Goldenshtein (4):
  nl80211/cfg80211: add radar detection command/event
  mac80211: add radar detection command/event
  nl80211/cfg80211: add ap channel switch command
  mac80211: add ap channel switch command/event

 include/net/cfg80211.h       |   68 ++++++++++++++-
 include/net/mac80211.h       |   46 ++++++++++
 include/uapi/linux/nl80211.h |   39 +++++++++
 net/mac80211/cfg.c           |   65 +++++++++++++-
 net/mac80211/driver-ops.h    |   26 ++++++
 net/mac80211/ibss.c          |    2 +-
 net/mac80211/ieee80211_i.h   |    7 ++
 net/mac80211/iface.c         |    6 ++
 net/mac80211/main.c          |    2 +
 net/mac80211/mlme.c          |   77 +++++++++++++++++
 net/mac80211/scan.c          |    3 +
 net/mac80211/trace.h         |  121 ++++++++++++++++++++++++++
 net/wireless/chan.c          |   23 +++--
 net/wireless/core.h          |    1 +
 net/wireless/mesh.c          |    2 +-
 net/wireless/mlme.c          |   32 ++++++-
 net/wireless/nl80211.c       |  194 ++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.h       |    9 +-
 net/wireless/trace.h         |   11 ++-
 net/wireless/util.c          |   14 +++
 20 files changed, 723 insertions(+), 25 deletions(-)

-- 
1.7.10.4

