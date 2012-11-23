Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40019 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2KWUTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:19:07 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFCv2 00/13] mesh powersave - basics
Date: Fri, 23 Nov 2012 12:18:41 -0800
Message-Id: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_211913_448201_EDDB2126)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commits cover the basic subset of functions, that each mesh node
must support to communicate in the presence of power saving nodes.
The current patchset does not implement any actual power savings yet (no
hardware configuration, no doze state).

Mesh powersave is different from client mode powersave in the sense that
1) there is not just a singular power mode towards the access point, but a
   link-specific power mode towards each peer instead
2) peers also maintain a power mode towards us (the local STA)
3) each node has to buffer frames towards power saving neighbors

With that said the different commits cover the following main topics:
3:  maintaining a local power mode for each peer + one non-peer power mode
4:  indicate the power mode towards the respective neighbors
5:  track neighbors' power modes 
9: buffer frames towards power saving neighbors
13: release buffered frames in coordination with neighbor


v2:
-active voice commit logs
-beacon interval and DTIM period set during mesh join (no change during mesh
 runtime anymore)
-power mode "unknown" instead of "invalid"
-merged mesh power mode parameters and set/get commits
-"mesh" and "sta" in function names where useful
-sdata check in list_for_each_entry_rcu(sta, &sdata->local->sta_list, list)
-sta timer setup in sta_info_alloc
-BUG_ON -> WARN_ON + return
-clarify comments
-kernel-doc style
-clear separation {cfg,nl}80211 & mac80211
-removed debug strings
-ieee80211_has_qos_pm int -> bool
-#IFDEF CONFIG_MESH around use of sta->plid
-move skb_queue_purge to stop_mesh
-move counter cleanup to stop_mesh
-no use of sta_ps_transition anymore - own routines instead
-no use of ieee80211_sta_ps_deliver_response anymore, no use of ambiguous
 UAPSD enum anymore - own function instead
-concentrate PS stuff in ieee80211_mesh_ps_rx_bcn
-less exposed functions in mesh.h

not done:
range checks and FILL_IN_MESH_PARAM_IF_SET - follows later in one cleanup

Concerning the patch series ordering etc., everything *should* be safe.
1-7 just adds lots of overhead to maintain a power mode and track neighbors
without actually having any effects. Before any frames are buffered in 9,
8 adds all the neccessary data structures. In that snapshot state buffered
unicast frames would not be released, but would just time out. 10-12 add more
overhead until 13 allows unicast frame release. Of course for the patch
submission I can merge everything together, if that is helpful. The current
splitted state helps to understand the semantics, though.


Marco Porsch (13):
  {nl,cfg,mac}80211: set beacon interval and DTIM period on mesh join
  {cfg,nl}80211: mesh power mode config parameters
  mac80211: local link-specific mesh power mode logic
  mac80211: mesh power mode indication in transmitted frames
  mac80211: track neighbor STA power modes
  {cfg,nl}80211: allow userspace to set the local link-specific power
    mode
  {cfg,nl}80211: allow userspace to read the local and peer mesh power
    modes
  mac80211: add power save support structure to mesh interface
  mac80211: enable frame buffering for PS STA
  {cfg,nl}80211: add awake window to mesh config
  mac80211: add awake window IE to mesh beacons
  mac80211: add TIM IE to mesh beacons
  mac80211: mesh PS individually-addressed frame release

 include/linux/ieee80211.h     |   17 ++
 include/net/cfg80211.h        |   24 ++
 include/uapi/linux/nl80211.h  |   49 ++++
 net/mac80211/Kconfig          |   11 +
 net/mac80211/Makefile         |    3 +-
 net/mac80211/cfg.c            |   24 +-
 net/mac80211/debug.h          |   10 +
 net/mac80211/debugfs_netdev.c |    6 +
 net/mac80211/debugfs_sta.c    |    5 +-
 net/mac80211/ieee80211_i.h    |    7 +
 net/mac80211/mesh.c           |   36 ++-
 net/mac80211/mesh.h           |   22 +-
 net/mac80211/mesh_hwmp.c      |   10 +
 net/mac80211/mesh_pathtbl.c   |    1 +
 net/mac80211/mesh_plink.c     |   22 ++
 net/mac80211/mesh_ps.c        |  632 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c             |   24 ++
 net/mac80211/sta_info.c       |   19 +-
 net/mac80211/sta_info.h       |   14 +
 net/mac80211/status.c         |    5 +
 net/mac80211/tx.c             |   59 +++-
 net/mac80211/util.c           |    4 +
 net/mac80211/wme.c            |   13 +-
 net/wireless/mesh.c           |    8 +
 net/wireless/nl80211.c        |   56 +++-
 25 files changed, 1060 insertions(+), 21 deletions(-)
 create mode 100644 net/mac80211/mesh_ps.c

-- 
1.7.9.5

