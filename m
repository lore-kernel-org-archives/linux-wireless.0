Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58397 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424688Ab2LGWOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 17:14:37 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so648555pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 14:14:37 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>
Subject: [RFCv3 0/5] mesh power save - basics
Date: Fri,  7 Dec 2012 14:13:58 -0800
Message-Id: <1354918443-3076-1-git-send-email-marco@cozybit.com> (sfid-20121207_231442_909567_B1070FE3)
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

v3:
- default DTIM period of 1
- merged patches together
- common function name pattern
- else if in local_ps_update
- rcu_read_lock in local_ps_update
- re-order variables to reduce padding
- fix More Data flag setting
- minimum beacon interval of 10
- int for counting light and deep sleep peers
- all line breaks on strong indentation
- indentation fixes
- ieee80211_has_qos_pm -> ieee80211_has_qos_mesh_ps
- return 0 in mesh_nexthop_resolve
- fix typos
- typecasts to void
- reject settting local PS mode setting to unknown
- compare with NL80211_MESH_POWER_MAX
- moved purging of BC buffer after STA flush
- preferred use of ieee80211_vif_is_mesh
- range check of mesh config parameters

not done yet:
- authenticated mesh peering with nodes in PS mode

Marco Porsch (5):
  {nl,cfg,mac}80211: set beacon interval and DTIM period on mesh join
  cfg80211: mesh power mode primitives
  mac80211: move add_tim to subfunction
  mac80211: mesh power save basics
  nl80211: allow userspace to access mesh power mode parameters

 include/linux/ieee80211.h     |   17 ++
 include/net/cfg80211.h        |   25 ++
 include/uapi/linux/nl80211.h  |   47 +++
 net/mac80211/Kconfig          |   11 +
 net/mac80211/Makefile         |    3 +-
 net/mac80211/cfg.c            |   25 +-
 net/mac80211/debug.h          |   10 +
 net/mac80211/debugfs_netdev.c |    5 +
 net/mac80211/debugfs_sta.c    |    5 +-
 net/mac80211/ieee80211_i.h    |    7 +
 net/mac80211/mesh.c           |   37 ++-
 net/mac80211/mesh.h           |   23 +-
 net/mac80211/mesh_hwmp.c      |    7 +
 net/mac80211/mesh_pathtbl.c   |    1 +
 net/mac80211/mesh_plink.c     |   21 ++
 net/mac80211/mesh_ps.c        |  630 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c             |   22 ++
 net/mac80211/sta_info.c       |   18 +-
 net/mac80211/sta_info.h       |   17 ++
 net/mac80211/status.c         |    5 +
 net/mac80211/tx.c             |   81 ++++--
 net/mac80211/util.c           |    4 +
 net/mac80211/wme.c            |   13 +-
 net/wireless/mesh.c           |    8 +
 net/wireless/nl80211.c        |   57 +++-
 25 files changed, 1059 insertions(+), 40 deletions(-)
 create mode 100644 net/mac80211/mesh_ps.c

-- 
1.7.9.5

