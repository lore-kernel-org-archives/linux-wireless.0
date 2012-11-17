Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48632 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2KQGsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:33 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC 00/14] mesh powersave - basics
Date: Fri, 16 Nov 2012 22:47:52 -0800
Message-Id: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074837_464743_440F4B6E)
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
4:  maintaining a local power mode for each peer + one non-peer power mode
5:  indicate the power mode towards the respective neighbors
6:  track neighbors' power modes 
10: buffer frames towards power saving neighbors
14: release buffered frames in coordination with neighbor

Marco Porsch (14):
  {nl,cfg,mac}80211: add beacon interval and DTIM period to mesh config
  {cfg,nl}80211: mesh power mode config parameters
  {cfg,nl}80211: set and get default mesh power mode
  mac80211: local link-specific mesh power mode logic
  mac80211: mesh power mode indication in transmitted frames
  mac80211: track neighbor STA power modes
  {cfg,nl}80211: set local link-specific power mode
  {cfg,nl}80211: get local and peer mesh power modes
  mac80211: add power save support structure to mesh interface
  mac80211: enable frame buffering for PS STA
  {cfg,nl}80211: add awake window to mesh config
  mac80211: add awake window IE to mesh beacons
  mac80211: add TIM IE to mesh beacons
  mac80211: mesh PS individually-addressed frame release

 include/linux/ieee80211.h     |   14 +
 include/net/cfg80211.h        |   24 ++
 include/uapi/linux/nl80211.h  |   55 ++++
 net/mac80211/Kconfig          |   11 +
 net/mac80211/Makefile         |    3 +-
 net/mac80211/cfg.c            |   33 ++-
 net/mac80211/debug.h          |   10 +
 net/mac80211/debugfs_netdev.c |    9 +
 net/mac80211/debugfs_sta.c    |    5 +-
 net/mac80211/ieee80211_i.h    |    7 +
 net/mac80211/iface.c          |    3 +
 net/mac80211/mesh.c           |   34 ++-
 net/mac80211/mesh.h           |   26 +-
 net/mac80211/mesh_hwmp.c      |   10 +
 net/mac80211/mesh_pathtbl.c   |    1 +
 net/mac80211/mesh_plink.c     |   39 +++
 net/mac80211/mesh_ps.c        |  578 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c             |   32 ++-
 net/mac80211/sta_info.c       |   28 +-
 net/mac80211/sta_info.h       |   18 ++
 net/mac80211/status.c         |    5 +
 net/mac80211/tx.c             |   62 ++++-
 net/mac80211/util.c           |    4 +
 net/mac80211/wme.c            |   15 +-
 net/wireless/mesh.c           |    8 +
 net/wireless/nl80211.c        |   46 +++-
 26 files changed, 1054 insertions(+), 26 deletions(-)
 create mode 100644 net/mac80211/mesh_ps.c

-- 
1.7.9.5

