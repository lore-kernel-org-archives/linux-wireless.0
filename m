Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45867 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1DECQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 22:16:05 -0400
Received: by iyb14 with SMTP id 14so6482252iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 19:16:05 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: ohannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v7 00/10] mesh security enhancements
Date: Mon,  4 Apr 2011 18:15:11 -0700
Message-Id: <1301966121-26019-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v7 changes:
- squash nl80211 _USERSPACE_AUTH and _MESH_AUTH capability reporting. (Johannes)
- refactor mesh capability reporting into separate nl and mac80211 patches. (Johannes)

Javier Cardona (9):
  nl80211: rename NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE
  nl80211: Add userspace authentication flag to mesh setup
  mac80211: ignore peers if security is enabled for this mesh
  nl80211: let userspace authenticate stations
  mac80211: Let user space receive and send mesh auth/deauth frames
  mac80211: ignore peer link requests from unauthenticated stations.
  mac80211: Perform PLINK_ACTION on new station
  nl80211: New notification to discover mesh peer candidates.
  mac80211: send notification on new peer candidate for our secure mesh

Thomas Pedersen (1):
  mac80211: Support userspace mesh authentication

 include/linux/nl80211.h    |   32 +++++++++++++++++++---
 include/net/cfg80211.h     |   29 +++++++++++++++++---
 net/mac80211/cfg.c         |   22 +++++++++-----
 net/mac80211/ieee80211_i.h |    5 ++-
 net/mac80211/main.c        |    8 +++++-
 net/mac80211/mesh.c        |   14 +++++----
 net/mac80211/mesh.h        |    3 +-
 net/mac80211/mesh_plink.c  |   35 +++++++++++++++++++-----
 net/mac80211/rx.c          |    3 +-
 net/mac80211/tx.c          |    2 +-
 net/wireless/mesh.c        |   23 ++++++++++++++-
 net/wireless/nl80211.c     |   64 +++++++++++++++++++++++++++++++++++++++----
 net/wireless/nl80211.h     |    4 +++
 13 files changed, 201 insertions(+), 43 deletions(-)

-- 
1.7.4.1

