Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37571 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab1JTBDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 21:03:32 -0400
Received: by iaek3 with SMTP id k3so2770432iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 18:03:32 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: anagar6@uic.edu, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 0/6] HT support for mesh
Date: Wed, 19 Oct 2011 18:03:20 -0700
Message-Id: <1319072606-28291-1-git-send-email-thomas@cozybit.com> (sfid-20111020_030339_841685_6EDD5397)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds basic HT support for mesh nodes. We avoid the question of
how to negotiate channel types, by simply disallowing peering with mismatched
HT modes. Needs the mesh fixes posted earlier today for patch context.

Many thanks to Luis Rodriguez for his assistance, and Ashok Nagarajan for
co-authoring this patchset.

Alexander Simon (1):
  mac80211: Add HT helper functions

Thomas Pedersen (5):
  mac80211: add HT IEs to mesh frames
  mac80211: set HT capabilities for mesh peer
  mac80211: allow frame aggregation for mesh
  mac80211: add WMM IE to mesh frames
  mac80211: check mesh peer's WMM parameters

 include/linux/ieee80211.h  |   26 ++++++
 include/net/mac80211.h     |    4 +
 net/mac80211/agg-rx.c      |    3 +-
 net/mac80211/agg-tx.c      |    4 +-
 net/mac80211/ht.c          |    3 +-
 net/mac80211/ieee80211_i.h |    8 ++
 net/mac80211/mesh.c        |   75 ++++++++++++++--
 net/mac80211/mesh.h        |    4 +
 net/mac80211/mesh_plink.c  |   24 +++++-
 net/mac80211/rx.c          |    1 +
 net/mac80211/tx.c          |    6 ++
 net/mac80211/util.c        |  208 ++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/work.c        |   29 +------
 13 files changed, 336 insertions(+), 59 deletions(-)

-- 
1.7.5.4

