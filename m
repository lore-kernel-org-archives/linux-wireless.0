Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49168 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1JTSey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 14:34:54 -0400
Received: by gyb13 with SMTP id 13so3086542gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 11:34:53 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 0/6] HT support for mesh
Date: Thu, 20 Oct 2011 11:34:33 -0700
Message-Id: <1319135679-6740-1-git-send-email-thomas@cozybit.com> (sfid-20111020_203457_551126_927EB3A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds basic HT support for mesh nodes. We avoid the question of
how to negotiate channel types, by simply disallowing peering with mismatched
HT modes. Needs the mesh fixes posted earlier today for patch context.

Many thanks to Luis Rodriguez for his assistance, and Ashok Nagarajan for
co-authoring this patchset.

v2: 
	Remove outdated BA comments (Christian)

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
 net/mac80211/agg-tx.c      |   10 +--
 net/mac80211/ht.c          |    3 +-
 net/mac80211/ieee80211_i.h |    8 ++
 net/mac80211/mesh.c        |   75 ++++++++++++++--
 net/mac80211/mesh.h        |    4 +
 net/mac80211/mesh_plink.c  |   24 +++++-
 net/mac80211/rx.c          |    7 +--
 net/mac80211/tx.c          |    6 ++
 net/mac80211/util.c        |  208 ++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/work.c        |   29 +------
 13 files changed, 336 insertions(+), 71 deletions(-)

-- 
1.7.5.4

