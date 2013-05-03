Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61899 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3ECCgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:09 -0400
Received: by mail-pb0-f41.google.com with SMTP id mc17so659910pbc.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:08 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [RFC 00/12] MBSS sharing across multiple interfaces
Date: Thu,  2 May 2013 19:33:50 -0700
Message-Id: <1367548442-8229-1-git-send-email-thomas@cozybit.com> (sfid-20130503_043613_810724_8516D851)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset enables multiple interfaces on the same host to share mesh path
selection and frame forwarding duties. The peering state machine remains
per-interface.

The user interface looks something like:

iw wlan0 mesh join foo shared on
iw wlan1 mesh join foo shared on

As long as wlan0 and wlan1 have a matching mesh setup profile, they will be
considered part of the same MBSS.

This approach is superior to simple 802.1d briding, since mac80211 can
dynamically pick the better link instead of simply disabling an entire port.
The added link knowledge also enables bonding and alternation in the future.

Bob Copeland (6):
  mac80211: track and share mesh BSSes among interfaces
  mac80211: mesh: add function to tx on all other mbss ifaces
  mac80211: use all MBSS interfaces for path selection
  mac80211: forward group frames on mbss-shared interfaces
  mac80211: add shared-mbss transmit path
  mac08211: add shared-mbss receive path handling

Thomas Pedersen (6):
  mac80211: assign outgoing interface with nexthop
  mac80211: forward frames on correct mbss-shared interface
  mac80211: notify bridge when leaving mesh
  mac80211: make RMC per-mbss
  {nl,mac}80211: specify MBSS sharing on/off
  {nl,mac}80211: allow mpath dump to span local MBSS

 include/net/cfg80211.h       |    8 +-
 include/uapi/linux/nl80211.h |   12 +-
 net/mac80211/cfg.c           |   17 +--
 net/mac80211/ieee80211_i.h   |   37 +++++-
 net/mac80211/iface.c         |    3 -
 net/mac80211/mesh.c          |  276 +++++++++++++++++++++++++++++++++++++++---
 net/mac80211/mesh.h          |   24 ++--
 net/mac80211/mesh_hwmp.c     |  133 ++++++++++++++------
 net/mac80211/mesh_pathtbl.c  |   68 +++++++----
 net/mac80211/rx.c            |  110 +++++++++++++----
 net/mac80211/tx.c            |    8 +-
 net/wireless/mesh.c          |    1 +
 net/wireless/nl80211.c       |   21 +++-
 net/wireless/rdev-ops.h      |   10 +-
 14 files changed, 599 insertions(+), 129 deletions(-)

-- 
1.7.10.4

