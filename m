Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55924 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1GZAAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 20:00:02 -0400
Received: by pzk37 with SMTP id 37so9320498pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 17:00:02 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 0/6] update mesh frame formats
Date: Mon, 25 Jul 2011 16:59:11 -0700
Message-Id: <1311638357-28740-1-git-send-email-thomas@cozybit.com> (sfid-20110726_020006_376874_EB505917)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset updates the existing mesh beacon, peering, and path selection
frames to use the frame formats specified in the recently ratified 802.11s
standard. These patches break compatibility with previous versions of the mesh
stack.

Previously submitted mesh beacon patches have been rolled into 'mac80211: fix
mesh beacon format', and the scope severely reduced. Changes from v1:
 - Don't fake PS support
 - Don't keep beacon in if_mesh for now
 - Don't call into cfg80211
 - Set privacy bit if security is on

Thomas Pedersen (6):
  mac80211: fix mesh beacon format
  ieee80211: introduce Self Protected Action codes
  mac80211: update mesh peering frame codes
  mac80211: update mesh peering frame format
  ieee80211: add mesh action codes
  mac80211: update mesh path selection frame format

 include/linux/ieee80211.h  |   46 +++++----
 net/mac80211/ieee80211_i.h |    4 +-
 net/mac80211/mesh.c        |  239 ++++++++++++++++++++++++++++++++------------
 net/mac80211/mesh.h        |   14 +++
 net/mac80211/mesh_hwmp.c   |   43 +++++---
 net/mac80211/mesh_plink.c  |  238 ++++++++++++++++++++++---------------------
 net/mac80211/rx.c          |   20 ++++-
 net/mac80211/tx.c          |   13 ++-
 net/mac80211/util.c        |    6 +-
 9 files changed, 398 insertions(+), 225 deletions(-)

-- 
1.7.6

