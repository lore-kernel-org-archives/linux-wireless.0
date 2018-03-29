Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38416 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbeC2NKM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 09:10:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-03-29
Date: Thu, 29 Mar 2018 15:10:02 +0200
Message-Id: <20180329131003.21687-1-johannes@sipsolutions.net> (sfid-20180329_151020_190956_1A06F803)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Last update for -next, I guess, but I wanted to get the ETSI adaptivity
requirements code and the eapol-over-nl80211 thing out - both have been
around for a while. A number of other smaller things are also there, of
course.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 0466080c751ec2de9efae3ac6305225cc4326047:

  Merge branch 'dsa-mv88e6xxx-some-fixes' (2018-03-20 12:29:58 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-03-29

for you to fetch changes up to c470bdc1aaf36669e04ba65faf1092b2d1c6cabe:

  mac80211: don't WARN on bad WMM parameters from buggy APs (2018-03-29 15:02:38 +0200)

----------------------------------------------------------------
We have a fair number of patches, but many of them are from the
first bullet here:
 * EAPoL-over-nl80211 from Denis - this will let us fix
   some long-standing issues with bridging, races with
   encryption and more
 * DFS offload support from the qtnfmac folks
 * regulatory database changes for the new ETSI adaptivity
   requirements
 * various other fixes and small enhancements

----------------------------------------------------------------
Benjamin Beichler (1):
      mac80211_hwsim: fix use-after-free bug in hwsim_exit_net

Denis Kenzior (11):
      cfg80211: Support all iftypes in autodisconnect_wk
      nl80211: Add SOCKET_OWNER support to JOIN_IBSS
      nl80211: Add SOCKET_OWNER support to JOIN_MESH
      nl80211: Add SOCKET_OWNER support to START_AP
      nl80211: Add CMD_CONTROL_PORT_FRAME API
      nl80211: Implement TX of control port frames
      nl80211: Add CONTROL_PORT_OVER_NL80211 attribute
      nl80211: Add control_port_over_nl80211 for ibss
      nl80211: Add control_port_over_nl80211 to mesh_setup
      mac80211: Add support for tx_control_port
      mac80211: Send control port frames over nl80211

Dmitry Lebed (4):
      cfg80211/nl80211: add CAC_STARTED event
      cfg80211/nl80211: add DFS offload flag
      cfg80211: fix CAC_STARTED event handling
      cfg80211: enable use of non-cleared DFS channels for DFS offload

Emmanuel Grumbach (1):
      mac80211: don't WARN on bad WMM parameters from buggy APs

Haim Dreyfuss (3):
      cfg80211: read wmm rules from regulatory database
      mac80211: limit wmm params to comply with ETSI requirements
      cfg80211: Add API to allow querying regdb for wmm_rule

Johannes Berg (4):
      mac80211_hwsim: fix secondary MAC address assignment
      cfg80211: don't require RTNL held for regdomain reads
      mac80211: remove shadowing duplicated variable
      Merge branch 'eapol-over-nl80211' into mac80211-next

Manikanta Pubbisetty (1):
      mac80211: allow AP_VLAN operation on crypto controlled devices

Pradeep Kumar Chitrapu (1):
      mac80211: notify driver for change in multicast rates

Tosoni (1):
      mac80211: inform wireless layer when frame RSSI is invalid

tamizhr@codeaurora.org (3):
      cfg80211: fix data type of sta_opmode_info parameter
      mac80211: Use proper smps_mode enum in sta opmode event
      mac80211: Use proper chan_width enum in sta opmode event

 drivers/net/wireless/mac80211_hwsim.c |  10 +-
 include/net/cfg80211.h                |  76 ++++++++++++-
 include/net/mac80211.h                |   3 +
 include/net/regulatory.h              |  28 +++++
 include/uapi/linux/nl80211.h          |  46 +++++++-
 net/mac80211/cfg.c                    |  12 ++
 net/mac80211/ht.c                     |  15 +++
 net/mac80211/ibss.c                   |   3 +-
 net/mac80211/ieee80211_i.h            |  12 ++
 net/mac80211/iface.c                  |   2 +
 net/mac80211/key.c                    |   8 +-
 net/mac80211/main.c                   |  10 +-
 net/mac80211/mesh.c                   |   3 +-
 net/mac80211/mlme.c                   | 168 ++++++++++++++-------------
 net/mac80211/rx.c                     |  45 ++++++--
 net/mac80211/scan.c                   |   4 +-
 net/mac80211/tx.c                     |  46 ++++++++
 net/mac80211/util.c                   |  47 +++++++-
 net/mac80211/vht.c                    |  32 +++++-
 net/wireless/ap.c                     |   1 +
 net/wireless/chan.c                   |   9 +-
 net/wireless/core.h                   |  12 +-
 net/wireless/ibss.c                   |  27 +----
 net/wireless/mesh.c                   |  16 +--
 net/wireless/mlme.c                   |   9 +-
 net/wireless/nl80211.c                | 205 +++++++++++++++++++++++++++++++--
 net/wireless/rdev-ops.h               |  15 +++
 net/wireless/reg.c                    | 206 ++++++++++++++++++++++++++++++++--
 net/wireless/sme.c                    |  43 +++++--
 net/wireless/trace.h                  |  47 ++++++++
 30 files changed, 979 insertions(+), 181 deletions(-)
